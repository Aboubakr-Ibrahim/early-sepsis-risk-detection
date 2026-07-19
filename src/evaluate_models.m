function results = evaluate_models(dataset, foldId, cfg)
%EVALUATE_MODELS Leakage-aware cross-validation for two baseline models.

X = dataset{:, cellstr(cfg.featureNames)};
y = double(dataset.sepsis_label);
k = cfg.numFolds;
models = ["LassoLogistic", "RandomForest"];
metricNames = ["accuracy", "sensitivity", "specificity", "precision", ...
    "f1", "balanced_accuracy", "roc_auc", "pr_auc"];
metricRows = [];
predictions = table();

for fold = 1:k
    trainMask = foldId ~= fold;
    testMask = foldId == fold;
    assert(any(trainMask) && any(testMask), "Fold %d is empty.", fold);

    XTrain = X(trainMask, :); yTrain = y(trainMask);
    XTest = X(testMask, :); yTest = y(testMask);
    assert(numel(unique(yTrain)) == 2, "Training fold %d has one class.", fold);
    assert(numel(unique(yTest)) == 2, "Test fold %d has one class.", fold);

    [XTrain, XTest] = fitPreprocessing(XTrain, XTest);
    cost = classCost(yTrain);

    logistic = fitclinear(XTrain, yTrain, "Learner", "logistic", ...
        "Regularization", "lasso", "Solver", "sparsa", ...
        "ClassNames", [0; 1], "Cost", cost);
    [predLogistic, scoreLogistic] = predict(logistic, XTest);
    positiveLogistic = positiveScore(scoreLogistic, logistic.ClassNames);
    metricRows = [metricRows; metricRow(fold, models(1), yTest, ...
        predLogistic, positiveLogistic)]; %#ok<AGROW>
    predictions = [predictions; predictionRows(dataset(testMask, :), ...
        fold, models(1), yTest, predLogistic, positiveLogistic)]; %#ok<AGROW>

    forest = TreeBagger(cfg.numTrees, XTrain, categorical(yTrain), ...
        "Method", "classification", "OOBPrediction", "on", ...
        "MinLeafSize", 3, "Prior", "uniform");
    [predForestText, scoreForest] = predict(forest, XTest);
    predForest = double(string(predForestText) == "1");
    positiveColumn = find(string(forest.ClassNames) == "1", 1);
    positiveForest = scoreForest(:, positiveColumn);
    metricRows = [metricRows; metricRow(fold, models(2), yTest, ...
        predForest, positiveForest)]; %#ok<AGROW>
    predictions = [predictions; predictionRows(dataset(testMask, :), ...
        fold, models(2), yTest, predForest, positiveForest)]; %#ok<AGROW>
end

foldMetrics = struct2table(metricRows);
summary = groupsummary(foldMetrics, "model", ["mean", "std"], ...
    cellstr(metricNames));
cohortSummary = table(height(dataset), numel(unique(dataset.subject_id)), ...
    sum(dataset.sepsis_label == 1), sum(dataset.sepsis_label == 0), ...
    cfg.observationHours, "VariableNames", ["admissions", "patients", ...
    "sepsis_admissions", "nonsepsis_admissions", "observation_hours"]);

missingCount = sum(isnan(X), 1)';
missingness = table(cfg.featureNames', missingCount, ...
    100 .* missingCount ./ height(dataset), ...
    "VariableNames", ["feature", "missing_n", "missing_percent"]);

results = struct("foldMetrics", foldMetrics, "summary", summary, ...
    "cohortSummary", cohortSummary, "missingness", missingness, ...
    "predictions", predictions, "featureNames", cfg.featureNames);
end

function [trainOut, testOut] = fitPreprocessing(trainIn, testIn)
medians = median(trainIn, 1, "omitnan");
medians(isnan(medians)) = 0;
trainOut = fillWith(trainIn, medians);
testOut = fillWith(testIn, medians);
mu = mean(trainOut, 1);
sigma = std(trainOut, 0, 1);
sigma(sigma == 0 | isnan(sigma)) = 1;
trainOut = (trainOut - mu) ./ sigma;
testOut = (testOut - mu) ./ sigma;
end

function X = fillWith(X, values)
for column = 1:size(X, 2)
    missing = isnan(X(:, column));
    X(missing, column) = values(column);
end
end

function cost = classCost(y)
n0 = sum(y == 0); n1 = sum(y == 1);
cost = [0, numel(y)/(2*n0); numel(y)/(2*n1), 0];
end

function score = positiveScore(scores, classNames)
column = find(double(classNames) == 1, 1);
score = scores(:, column);
end

function row = metricRow(fold, model, truth, prediction, score)
m = compute_metrics(truth, double(prediction), score);
row = struct("fold", fold, "model", model, "n_test", numel(truth), ...
    "n_positive", sum(truth == 1), "accuracy", m.accuracy, ...
    "sensitivity", m.sensitivity, "specificity", m.specificity, ...
    "precision", m.precision, "f1", m.f1, ...
    "balanced_accuracy", m.balanced_accuracy, "roc_auc", m.roc_auc, ...
    "pr_auc", m.pr_auc);
end

function rows = predictionRows(testData, fold, model, truth, prediction, score)
n = height(testData);
rows = table(testData.subject_id, testData.hadm_id, ...
    repmat(fold, n, 1), repmat(model, n, 1), double(truth), ...
    double(prediction), double(score), "VariableNames", ...
    ["subject_id", "hadm_id", "fold", "model", "truth", ...
    "prediction", "positive_score"]);
end
