function foldId = make_patient_folds(subjectId, labels, numFolds, seed)
%MAKE_PATIENT_FOLDS Assign every admission from a patient to one fold.

arguments
    subjectId (:,1) double
    labels (:,1) double
    numFolds (1,1) double {mustBeInteger, mustBeGreaterThan(numFolds,1)}
    seed (1,1) double = 42
end

[patients, ~, patientIndex] = unique(subjectId, "stable");
patientLabel = accumarray(patientIndex, labels, [], @max);
assert(numel(patients) >= numFolds, "Fewer patients than folds.");
for classValue = [0, 1]
    assert(sum(patientLabel == classValue) >= numFolds, ...
        "Fewer than %d patient groups are available for class %d.", ...
        numFolds, classValue);
end

rng(seed, "twister");
patientFold = zeros(numel(patients), 1);
for classValue = [0, 1]
    indices = find(patientLabel == classValue);
    indices = indices(randperm(numel(indices)));
    patientFold(indices) = mod((0:numel(indices)-1)', numFolds) + 1;
end
foldId = patientFold(patientIndex);

for patient = 1:numel(patients)
    assert(numel(unique(foldId(patientIndex == patient))) == 1, ...
        "Patient leakage detected during fold creation.");
end
for fold = 1:numFolds
    assert(numel(unique(labels(foldId == fold))) == 2, ...
        "Fold %d has only one admission-level class. Reduce numFolds.", fold);
end
end
