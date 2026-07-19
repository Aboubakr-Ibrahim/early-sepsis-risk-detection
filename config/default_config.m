function cfg = default_config(dataPath)
%DEFAULT_CONFIG Configuration for the MIMIC-III Demo sepsis pipeline.

arguments
    dataPath (1,1) string
end

cfg.dataPath = dataPath;
cfg.outputPath = fullfile(pwd, "outputs");
cfg.randomSeed = 42;
cfg.numFolds = 5;
cfg.numTrees = 200;
cfg.observationHours = 24;

% Admission-level diagnosis label. Prefix 038 captures 038.xx codes.
cfg.sepsisPrefixes = ["038", "99591", "99592"];

% Common CareVue and MetaVision ITEMIDs. Verify against D_ITEMS before
% adapting this configuration to another MIMIC version.
cfg.itemIds.respiratoryRate = [618, 220210];
cfg.itemIds.systolicBP = [51, 442, 455, 6701, 220179];
cfg.itemIds.gcsTotal = [198, 226755];
cfg.itemIds.heartRate = [211, 220045];
cfg.itemIds.temperatureC = [676, 223762];
cfg.itemIds.temperatureF = [678, 223761];

cfg.validRange.respiratoryRate = [2, 80];
cfg.validRange.systolicBP = [20, 300];
cfg.validRange.gcsTotal = [3, 15];
cfg.validRange.heartRate = [20, 250];
cfg.validRange.temperatureC = [25, 45];

cfg.featureNames = ["respiratory_rate", "systolic_bp", "gcs_total", ...
    "heart_rate", "temperature_c"];
end
