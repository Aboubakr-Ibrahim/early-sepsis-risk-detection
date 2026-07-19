function cohort = prepare_cohort(cfg)
%PREPARE_COHORT Create one diagnosis-labelled row per hospital admission.

admissions = readtable(fullfile(cfg.dataPath, "ADMISSIONS.csv"), ...
    "VariableNamingRule", "preserve");
diagnoses = readtable(fullfile(cfg.dataPath, "DIAGNOSES_ICD.csv"), ...
    "VariableNamingRule", "preserve", "TextType", "string");
admissions.Properties.VariableNames = lower(admissions.Properties.VariableNames);
diagnoses.Properties.VariableNames = lower(diagnoses.Properties.VariableNames);

assert(all(ismember(["subject_id", "hadm_id"], string(admissions.Properties.VariableNames))), ...
    "ADMISSIONS.csv is missing subject_id or hadm_id.");
assert(all(ismember(["subject_id", "hadm_id", "icd9_code"], ...
    string(diagnoses.Properties.VariableNames))), ...
    "DIAGNOSES_ICD.csv is missing required columns.");

codes = upper(strip(string(diagnoses.icd9_code)));
codes = erase(codes, ".");
isSepsisDiagnosis = false(height(diagnoses), 1);
for prefix = cfg.sepsisPrefixes
    isSepsisDiagnosis = isSepsisDiagnosis | startsWith(codes, erase(prefix, "."));
end

positiveAdmissions = unique(diagnoses.hadm_id(isSepsisDiagnosis));
cohort = admissions(:, {"subject_id", "hadm_id"});
cohort.sepsis_label = double(ismember(cohort.hadm_id, positiveAdmissions));
cohort = unique(cohort, "rows", "stable");

assert(numel(unique(cohort.sepsis_label)) == 2, ...
    "The demo cohort must contain both positive and negative admissions.");
end
