# Methodology

## Research question

Can a small set of observed vital-sign summaries from the first 24 hours after hospital admission distinguish admissions with and without selected sepsis-related ICD-9 diagnosis codes in the MIMIC-III Demo dataset?

This is an educational admission-level classification experiment. It is not an onset-time model or clinical diagnostic system.

## Outcome definition

An admission is labelled positive when `DIAGNOSES_ICD.csv` contains a code beginning with:

- `038` — septicemia family
- `99591` — sepsis
- `99592` — severe sepsis

The label is independent from the qSOFA-related input variables. Because diagnosis codes do not establish exact onset time, results must be interpreted as association with an admission-level coded diagnosis.

## Observation window and features

Only `CHARTEVENTS` measurements recorded from admission time through 24 hours after admission are eligible. Pre-admission measurements and events after the cutoff are excluded.

The current baseline features are admission-level medians of observed:

- Respiratory rate
- Systolic blood pressure
- Total Glasgow Coma Scale
- Heart rate
- Temperature in degrees Celsius

Fahrenheit observations are converted to Celsius and used only when a Celsius value is unavailable. Physiologic range checks are applied before aggregation. No synthetic clinical variables are created.

## Validation design

1. Create one row per eligible hospital admission.
2. Assign all admissions from one patient to the same fold.
3. Stratify folds using each patient's maximum admission label.
4. Verify that training and test data contain both admission classes.
5. Fit median imputation using the training fold only.
6. Fit standardization using the imputed training fold only.
7. Train every model independently within its fold.
8. Evaluate on untouched fold observations.

## Baseline models

- L1-regularized Logistic Regression with class-dependent error costs
- Random Forest with uniform class priors

No headline performance result is published until the current MATLAB pipeline is executed and its outputs are reviewed.

## Outputs

The pipeline saves:

- Cohort and class counts
- Feature missingness
- Fold-specific metrics
- Mean and standard deviation across folds
- Patient/admission-level predictions and scores
- MATLAB experiment structure and configuration

Metrics include accuracy, sensitivity, specificity, precision, F1, balanced accuracy, ROC-AUC, and PR-AUC.

## Reproducibility principles

- No raw clinical data in version control
- No machine-specific absolute paths
- Fixed random seed
- Modular source files and tests
- Explicit feature provenance and time window
- Training-only preprocessing
- Patient-grouped validation
- Honest residual limitations
