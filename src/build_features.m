function dataset = build_features(cfg, cohort)
%BUILD_FEATURES Aggregate observed chart values by hospital admission.
% No synthetic clinical variables are created.

opts = detectImportOptions(fullfile(cfg.dataPath, "CHARTEVENTS.csv"), ...
    "VariableNamingRule", "preserve");
opts.VariableNames = lower(opts.VariableNames);
required = ["subject_id", "hadm_id", "itemid", "valuenum"];
assert(all(ismember(required, string(opts.VariableNames))), ...
    "CHARTEVENTS.csv is missing required columns.");
opts.SelectedVariableNames = cellstr(required);
chart = readtable(fullfile(cfg.dataPath, "CHARTEVENTS.csv"), opts);

chart = chart(~ismissing(chart.hadm_id) & ~ismissing(chart.valuenum), :);
chart = chart(ismember(chart.hadm_id, cohort.hadm_id), :);

features = cohort;
features = addFeature(features, chart, cfg.itemIds.respiratoryRate, ...
    cfg.validRange.respiratoryRate, "respiratory_rate", false);
features = addFeature(features, chart, cfg.itemIds.systolicBP, ...
    cfg.validRange.systolicBP, "systolic_bp", false);
features = addFeature(features, chart, cfg.itemIds.gcsTotal, ...
    cfg.validRange.gcsTotal, "gcs_total", false);
features = addFeature(features, chart, cfg.itemIds.heartRate, ...
    cfg.validRange.heartRate, "heart_rate", false);
features = addFeature(features, chart, cfg.itemIds.temperatureC, ...
    cfg.validRange.temperatureC, "temperature_c", false);

% Convert observed Fahrenheit measurements and combine with Celsius.
tempF = aggregateFeature(chart, cfg.itemIds.temperatureF, [70, 115]);
if ~isempty(tempF)
    tempF.temperature_f = (tempF.temperature_f - 32) .* (5/9);
    tempF.Properties.VariableNames{"temperature_f"} = "temperature_c_f_source";
    features = outerjoin(features, tempF, "Keys", ["subject_id", "hadm_id"], ...
        "MergeKeys", true, "Type", "left");
    fillFromF = ismissing(features.temperature_c) & ...
        ~ismissing(features.temperature_c_f_source);
    features.temperature_c(fillFromF) = features.temperature_c_f_source(fillFromF);
    features.temperature_c_f_source = [];
end

featureMatrix = features{:, cellstr(cfg.featureNames)};
hasObservedFeature = any(~isnan(featureMatrix), 2);
dataset = features(hasObservedFeature, :);
dataset = sortrows(dataset, ["subject_id", "hadm_id"]);
end

function output = addFeature(base, chart, itemIds, validRange, featureName, required)
aggregated = aggregateFeature(chart, itemIds, validRange, featureName);
output = outerjoin(base, aggregated, "Keys", ["subject_id", "hadm_id"], ...
    "MergeKeys", true, "Type", "left");
if required
    output = output(~ismissing(output.(featureName)), :);
end
end

function aggregated = aggregateFeature(chart, itemIds, validRange, featureName)
if nargin < 4
    featureName = "temperature_f";
end
rows = ismember(chart.itemid, itemIds) & chart.valuenum >= validRange(1) & ...
    chart.valuenum <= validRange(2);
subset = chart(rows, {"subject_id", "hadm_id", "valuenum"});
if isempty(subset)
    aggregated = table([], [], [], "VariableNames", ...
        {"subject_id", "hadm_id", char(featureName)});
    return;
end
aggregated = groupsummary(subset, ["subject_id", "hadm_id"], "median", "valuenum");
aggregated.GroupCount = [];
aggregated.Properties.VariableNames{"median_valuenum"} = char(featureName);
end
