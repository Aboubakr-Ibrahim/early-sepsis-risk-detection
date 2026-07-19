# Source code

The refactored pipeline is organized into small, auditable MATLAB functions.

| File | Responsibility |
|---|---|
| `run_pipeline.m` | Validates inputs, orchestrates the experiment, and saves summaries |
| `prepare_cohort.m` | Creates independent diagnosis-based admission labels |
| `build_features.m` | Extracts and aggregates observed chart measurements |
| `make_patient_folds.m` | Creates stratified patient-level folds |
| `evaluate_models.m` | Fits fold-specific preprocessing and baseline models |
| `compute_metrics.m` | Computes binary classification and ranking metrics |

The original academic script is intentionally not published unchanged because it contains machine-specific paths, synthetic variables, circular labels, and evaluation leakage. Those issues are documented in [limitations](../docs/limitations.md).

## Entry point

```matlab
addpath("config", "src");
results = run_pipeline("data/mimiciii-demo/1.4");
```

## Design guarantees

- No synthetic clinical values
- No absolute personal paths
- Diagnosis labels are independent from input features
- Patient-level fold isolation
- Training-only imputation and scaling
- A new model is fitted inside every fold
- Raw datasets and generated outputs are excluded from Git
