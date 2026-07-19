function tests = test_pipeline_helpers
tests = functiontests(localfunctions);
end

function testPatientIsolationAndClassCoverage(testCase)
subject = (1:20)';
label = repmat([0; 1], 10, 1);
fold = make_patient_folds(subject, label, 5, 42);
for id = unique(subject)'
    verifyEqual(testCase, numel(unique(fold(subject == id))), 1);
end
for id = 1:5
    verifyEqual(testCase, sort(unique(label(fold == id))), [0; 1]);
end
end

function testObservationWindow(testCase)
admit = datetime(2024, 1, 1, 8, 0, 0);
events = table(admit + hours([-1; 0; 12; 24; 24.1]), ...
    repmat(admit, 5, 1), (1:5)', "VariableNames", ...
    ["charttime", "admittime", "value"]);
filtered = filter_observation_window(events, 24);
verifyEqual(testCase, filtered.value, [2; 3; 4]);
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
verifyEqual(testCase, m.roc_auc, 1);
end

function testUndefinedPrecisionIsNaN(testCase)
truth = [0; 1]; prediction = [0; 0]; score = [0.1; 0.2];
m = compute_metrics(truth, prediction, score);
verifyTrue(testCase, isnan(m.precision));
verifyTrue(testCase, isnan(m.f1));
end
