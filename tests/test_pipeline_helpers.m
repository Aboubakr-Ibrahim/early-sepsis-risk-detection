function tests = test_pipeline_helpers
tests = functiontests(localfunctions);
end

function testPatientIsolation(testCase)
subject = [1; 1; 2; 3; 3; 4; 5; 6];
label = [0; 0; 1; 0; 1; 1; 0; 1];
fold = make_patient_folds(subject, label, 3, 42);
for id = unique(subject)'
    verifyEqual(testCase, numel(unique(fold(subject == id))), 1);
end
end

function testPerfectMetrics(testCase)
truth = [0; 0; 1; 1];
prediction = truth;
score = [0.1; 0.2; 0.8; 0.9];
m = compute_metrics(truth, prediction, score);
verifyEqual(testCase, m.accuracy, 1);
verifyEqual(testCase, m.sensitivity, 1);
verifyEqual(testCase, m.specificity, 1);
verifyEqual(testCase, m.f1, 1);
end
