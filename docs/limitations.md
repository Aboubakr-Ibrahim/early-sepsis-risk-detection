# Limitations and technical audit

## Original June 2024 prototype

The original academic implementation is preserved as project history. Its performance values cannot be treated as independent sepsis-prediction evidence because it included:

1. A qSOFA-derived target constructed from variables also used as predictors
2. Randomly generated heart-rate and temperature variables
3. Normalization and SMOTE before cross-validation
4. A Random Forest trained on the full resampled dataset before fold evaluation
5. Row-level moving averages without a valid within-patient temporal sequence
6. Test data reused as neural-network validation data
7. A small educational demo cohort and no external validation

## Version 2 corrections

- Diagnosis-derived admission labels are independent from the input features
- Only observed clinical variables are used
- Measurements are restricted to the first 24 hours after admission
- Patient groups remain isolated between folds
- Imputation and scaling are fitted on training data only
- Every model is trained separately inside each fold
- Prediction-level outputs and missingness are retained for review

## Residual Version 2 limitations

1. **Diagnosis-code target** — ICD-9 codes are administrative admission labels and do not provide exact sepsis onset time.
2. **Not a true early-warning evaluation** — the experiment uses a fixed admission window and does not test prospective alarms before a documented onset.
3. **Small demo cohort** — MIMIC-III Demo is intended for education and software development, not clinically generalizable performance estimation.
4. **Feature missingness** — some variables, particularly total GCS, may be frequently missing and require transparent reporting.
5. **Admission-level aggregation** — medians simplify longitudinal physiology and may hide trends or interventions.
6. **Limited covariates** — demographics, laboratories, infection evidence, treatment timing, comorbidity, and care context are not modelled.
7. **No external or prospective validation** — no separate hospital, later time period, or real-time cohort has been evaluated.
8. **Runtime verification pending** — source code has been statically reviewed, but current MATLAB execution must be completed before results are published.

## Correct interpretation

The project demonstrates biomedical data handling, MATLAB development, patient-grouped evaluation, model comparison, documentation, and the ability to audit and improve earlier work.

It does not establish a clinically validated sepsis-detection system.
