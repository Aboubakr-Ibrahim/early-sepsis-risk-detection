function metrics = compute_metrics(truth, prediction, positiveScore)
%COMPUTE_METRICS Binary classification metrics with safe division.

truth = double(truth(:)); prediction = double(prediction(:));
positiveScore = double(positiveScore(:));
tp = sum(truth == 1 & prediction == 1);
tn = sum(truth == 0 & prediction == 0);
fp = sum(truth == 0 & prediction == 1);
fn = sum(truth == 1 & prediction == 0);

metrics.accuracy = safeDivide(tp + tn, tp + tn + fp + fn);
metrics.sensitivity = safeDivide(tp, tp + fn);
metrics.specificity = safeDivide(tn, tn + fp);
metrics.precision = safeDivide(tp, tp + fp);
metrics.f1 = safeDivide(2 * metrics.precision * metrics.sensitivity, ...
    metrics.precision + metrics.sensitivity);
metrics.balanced_accuracy = mean([metrics.sensitivity, metrics.specificity], ...
    "omitnan");

if numel(unique(truth)) == 2
    [~, ~, ~, metrics.roc_auc] = perfcurve(truth, positiveScore, 1);
    [~, ~, ~, metrics.pr_auc] = perfcurve(truth, positiveScore, 1, ...
        "XCrit", "reca", "YCrit", "prec");
else
    metrics.roc_auc = NaN;
    metrics.pr_auc = NaN;
end
end

function value = safeDivide(numerator, denominator)
if denominator == 0
    value = NaN;
else
    value = numerator / denominator;
end
end
