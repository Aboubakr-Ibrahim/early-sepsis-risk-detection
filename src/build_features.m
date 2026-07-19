function dataset = build_features(cfg, cohort)
%BUILD_FEATURES Aggregate observed values inside the admission-time window.
% No synthetic clinical variables are created.

opts = detectImportOptions(fullfile(cfg.dataPath, "CHARTEVENTS.csv"), ...
    "VariableNamingRule", "preserve");
opts.VariableNames = lower(opts.VariableNames);
required = ["subject_id", "hadm_id", "itemid", "charttime", "valuenum"];
assert(all(ismember(required, string(opts.VariableNames))), ...
    "CHARTEVENTS.csv is missing required columns.");
opts.SelectedVariableNames = cellstr(required);
chart = readtable(fullfile(cfg.dataPath, "CHARTEVENTS.csv"), opts);

chart = chart(~ismissing(chart.hadm_id) & ~ismissing(chart.valuenum), :);
chart.hadm_id = double(chart.hadm_id);
if ~isdatetime(chart.charttime)
    chart.charttime = datetime(string(chart.charttime), ...
        "InputFormat", "yyyy-MM-dd HH:mm:ss");
end
assert(~any(isnat(chart.charttime)), "Unable to parse CHARTEVENTS charttime.");

chart = innerjoin(chart, cohort(:, {"subject_id", "hadm_id", "admittime"}), ...
    "Keys", ["subject_id", "hadm_id"]);
chart = filter_observation_window(chart, cfg.observationHours);

features = cohort;
features = addFeature(features, chart, cfg.itemIds.respiratoryRate, ...
    cfg.validRange.respiratoryRate, "respiratory_rate");
features = addFeature(features, chart, cfg.itemIds.systolicBP, ...
    cfg.validRange.systolicBP, "systolic_bp");
features = addFeature(features, chart, cfg.itemIds.gcsTotal, ...
    cfg.validRange.gcsTotal, "gcs_total");
features = addFeature(features, chart, cfg.itemIds.heartRate, ...
    cfg.validRange.heartRate, "heart_rate");
features = addFeature(features, chart, cfg.itemIds.temperatureC, ...
    cfg.validRange.temperatureC, "temperature_c");

% Convert observed Fahrenheit measurements and use them only when the
% corresponding admission has no observed Celsius value.
tempF = aggregateFeature(chart, cfg.itemIds.temperatureF, [70, 115], ...
    "temperature_f");
if ~isempty(tempF)
    tempF.temperature_f = (tempF.temperature_f - 32) .* (5/9);
    tempF.Properties.VariableNames{"temperature_f"} = ...
        "temperature_c_f_source";
    features = outerjoin(features, tempF, ...
        "Keys", ["subject_id", "hadm_id"], "MergeKeys", true, ...
        "Type", "left");
    fillFromF = ismissing(features.temperature_c) & ...
        ~ismissing(features.temperature_c_f_source);
    features.temperature_c(fillFromF) = ...
        features.temperature_c_f_source(fillFromF);
    features.temperature_c_f_source = [];
end

featureMatrix = features{:, cellstr(cfg.featureNames)};
hasObservedFeature = any(~isnan(featureMatrix), 2);
dataset = features(hasObservedFeature, :);
dataset = sortrows(dataset, ["subject_id", "hadm_id"]);
end

function output = addFeature(base, chart, itemIds, validRange, featureName)
aggregated = aggregateFeature(chart, itemIds, validRange, featureName);
output = outerjoin(base, aggregated, ...
    "Keys", ["subject_id", "hadm_id"], "MergeKeys", true, "Type", "left");
end

function aggregated = aggregateFeature(chart, itemIds, validRange, featureName)
rows = ismember(chart.itemid, itemIds) & ...
    chart.valuenum >= validRange(1) & chart.valuenum <= validRange(2);
subset = chart(rows, {"subject_id", "hadm_id", "valuenum"});
if isempty(subset)
    aggregated = table([], [], [], "VariableNames", ...
        {"subject_id", "hadm_id", char(featureName)});
    return;
end
aggregated = groupsummary(subset, ["subject_id", "hadm_id"], ...
    "median", "valuenum");
aggregated.GroupCount = [];
aggregated.Properties.VariableNames{"median_valuenum"} = char(featureName);
end
