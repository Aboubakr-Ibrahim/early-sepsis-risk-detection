function results = run_pipeline(dataPath)
%RUN_PIPELINE Execute the leakage-aware MIMIC-III Demo experiment.
%
% Example:
%   addpath("config", "src");
%   results = run_pipeline("data/mimiciii-demo/1.4");

arguments
    dataPath (1,1) string
end

root = fileparts(fileparts(mfilename("fullpath")));
addpath(fullfile(root, "config"), fullfile(root, "src"));
cfg = default_config(dataPath);
rng(cfg.randomSeed, "twister");

required = ["ADMISSIONS.csv", "DIAGNOSES_ICD.csv", "CHARTEVENTS.csv"];
for name = required
    assert(isfile(fullfile(cfg.dataPath, name)), ...
        "Missing required dataset file: %s", fullfile(cfg.dataPath, name));
end

fprintf("Preparing diagnosis-labelled admission cohort...\n");
cohort = prepare_cohort(cfg);

fprintf("Building observed features from the first %g hours...\n", ...
    cfg.observationHours);
dataset = build_features(cfg, cohort);
assert(height(dataset) >= cfg.numFolds, ...
    "Too few eligible admissions (%d) for %d folds.", ...
    height(dataset), cfg.numFolds);

fprintf("Creating patient-level folds...\n");
foldId = make_patient_folds(dataset.subject_id, dataset.sepsis_label, ...
    cfg.numFolds, cfg.randomSeed);

fprintf("Training and evaluating fold-specific models...\n");
results = evaluate_models(dataset, foldId, cfg);

if ~isfolder(cfg.outputPath)
    mkdir(cfg.outputPath);
end
writetable(results.foldMetrics, fullfile(cfg.outputPath, "fold_metrics.csv"));
writetable(results.summary, fullfile(cfg.outputPath, "summary_metrics.csv"));
writetable(results.cohortSummary, fullfile(cfg.outputPath, "cohort_summary.csv"));
writetable(results.missingness, fullfile(cfg.outputPath, "missingness_summary.csv"));
writetable(results.predictions, fullfile(cfg.outputPath, "fold_predictions.csv"));
save(fullfile(cfg.outputPath, "experiment_results.mat"), "results", "cfg");

disp(results.cohortSummary);
disp(results.missingness);
disp(results.summary);
fprintf("Outputs saved to %s\n", cfg.outputPath);
end
