# Source code

The Version 2 pipeline is organized into small, auditable MATLAB functions.

| File | Responsibility |
|---|---|
| `run_pipeline.m` | Validates inputs, orchestrates the experiment, and saves reviewed output types |
| `prepare_cohort.m` | Creates independent diagnosis-based admission labels and parses admission time |
| `filter_observation_window.m` | Retains measurements from admission through the configured 24-hour cutoff |
| `build_features.m` | Extracts and aggregates observed chart measurements inside the time window |
| `make_patient_folds.m` | Creates stratified patient-level folds and verifies class coverage |
| `evaluate_models.m` | Fits fold-specific preprocessing/models and returns metrics, missingness, and predictions |
| `compute_metrics.m` | Computes binary classification and ranking metrics |

The original academic script is preserved privately as project history. It is not published as the professional pipeline because it contains machine-specific paths, synthetic variables, circular labels, and evaluation leakage. Those issues are documented in [limitations](../docs/limitations.md).

## Entry point

```matlab
addpath("config", "src");
results = run_pipeline("data/mimiciii-demo/1.4");
```

## Design guarantees

- First-24-hour observation window
- No synthetic clinical values
- No absolute personal paths
- Diagnosis labels are independent from input features
- Patient-level fold isolation
- Training-only imputation and scaling
- A new model is fitted inside every fold
- Prediction-level and missingness outputs are generated for review
- Raw datasets and generated outputs are excluded from Git by default

## Runtime status

The source and supplied MIMIC-III Demo data have passed a static and independent data-feasibility audit. MATLAB runtime verification remains separate and is complete only after the current tests and pipeline execute successfully.
