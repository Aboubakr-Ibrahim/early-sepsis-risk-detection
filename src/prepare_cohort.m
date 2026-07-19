function cohort = prepare_cohort(cfg)
%PREPARE_COHORT Create one diagnosis-labelled row per hospital admission.

admissions = readtable(fullfile(cfg.dataPath, "ADMISSIONS.csv"), ...
    "VariableNamingRule", "preserve", "TextType", "string");
diagnoses = readtable(fullfile(cfg.dataPath, "DIAGNOSES_ICD.csv"), ...
    "VariableNamingRule", "preserve", "TextType", "string");
admissions.Properties.VariableNames = lower(admissions.Properties.VariableNames);
diagnoses.Properties.VariableNames = lower(diagnoses.Properties.VariableNames);

assert(all(ismember(["subject_id", "hadm_id", "admittime"], ...
    string(admissions.Properties.VariableNames))), ...
    "ADMISSIONS.csv is missing subject_id, hadm_id, or admittime.");
assert(all(ismember(["subject_id", "hadm_id", "icd9_code"], ...
    string(diagnoses.Properties.VariableNames))), ...
    "DIAGNOSES_ICD.csv is missing required columns.");

admissions.admittime = parseMimicDatetime(admissions.admittime, "admittime");
codes = upper(strip(string(diagnoses.icd9_code)));
codes = erase(codes, ".");
isSepsisDiagnosis = false(height(diagnoses), 1);
for prefix = cfg.sepsisPrefixes
    isSepsisDiagnosis = isSepsisDiagnosis | startsWith(codes, erase(prefix, "."));
end

positiveAdmissions = unique(diagnoses.hadm_id(isSepsisDiagnosis));
cohort = admissions(:, {"subject_id", "hadm_id", "admittime"});
cohort.sepsis_label = double(ismember(cohort.hadm_id, positiveAdmissions));
cohort = unique(cohort, "rows", "stable");

assert(numel(unique(cohort.sepsis_label)) == 2, ...
    "The demo cohort must contain both positive and negative admissions.");
end

function values = parseMimicDatetime(values, variableName)
if ~isdatetime(values)
    values = datetime(string(values), "InputFormat", "yyyy-MM-dd HH:mm:ss");
end
assert(~any(isnat(values)), "Unable to parse %s timestamps.", variableName);
end
