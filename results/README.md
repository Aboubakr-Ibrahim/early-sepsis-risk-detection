# Results

Validated outputs will be added only after the Version 2 MATLAB pipeline and tests run successfully and the generated files are reviewed.

## Pre-execution data audit

An independent read-only audit of the supplied MIMIC-III Demo tables confirmed that a first-24-hour cohort with both outcome classes and sufficient patient groups for five-fold patient-level validation is feasible. This is a data-feasibility finding, not a model-performance result.

## Planned reviewed outputs

- Cohort and class counts
- Feature missingness
- Fold class distribution
- Fold-specific model metrics
- Mean and variability across folds
- Prediction-level scores
- Confusion matrices
- ROC and precision-recall curves
- Explicit limitations and verification environment

The original prototype's 94.545% and 100% headline values are not repeated as Version 2 performance because the original experimental design contained target and evaluation leakage.
