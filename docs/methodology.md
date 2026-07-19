# Methodology

## Original academic workflow

The graduation prototype followed this general sequence:

1. Load selected MIMIC-III Demo tables.
2. Identify diagnosis records related to sepsis ICD-9 codes.
3. Extract qSOFA-related chart variables.
4. Aggregate values by subject and hospital admission.
5. Create engineered and exploratory features.
6. Compare Logistic Regression with Lasso, Random Forest, and a neural-network prototype.
7. Calculate accuracy, precision, recall, F1 score, confusion matrices, and feature importance.

## Refactored workflow design

The portfolio version is being redesigned around a safer experimental structure:

1. Define the prediction target independently from the input features.
2. Define a clinically meaningful index time and observation window.
3. Create one row per prediction unit while preserving patient and admission IDs.
4. Split by patient before fitting preprocessing steps.
5. Fit imputation and scaling using training data only.
6. Handle class imbalance inside training folds only.
7. Train models separately inside each fold.
8. Evaluate on untouched fold data.
9. Report sensitivity, specificity, precision, recall, F1 score, ROC-AUC, PR-AUC, and confusion matrices where appropriate.
10. Describe uncertainty, cohort size, missingness, and limitations.

## Reproducibility principles

- No machine-specific absolute paths
- No raw clinical data in version control
- Fixed random seeds for experiments
- Modular source files
- Explicit feature provenance
- Saved configuration and result summaries
- Clear separation of exploratory and validated analyses
