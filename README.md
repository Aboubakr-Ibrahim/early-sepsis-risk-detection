# Early Sepsis Risk Detection

A reproducible MATLAB portfolio project exploring **first-24-hour vital-sign modelling of an admission-level sepsis diagnosis label** with the MIMIC-III Clinical Database Demo.

> **Educational research only.** This repository is not a clinical diagnostic system and must not be used for patient-care decisions.

## Project history

This work began as **Aboubakr Ibrahim's Biomedical Engineering graduation project at Işık University**. The original June 2024 prototype explored qSOFA-related variables, Logistic Regression with Lasso, Random Forest, a neural-network experiment, class imbalance, and model evaluation.

The original academic package is preserved as project history. Its headline results are not presented as clinical evidence because a later audit found circular labels, synthetic variables, preprocessing leakage, and model-evaluation leakage.

## Portfolio Version 2

The public pipeline now:

- Uses admission-level diagnosis labels instead of qSOFA-derived targets
- Uses only observed chart measurements
- Restricts features to the first 24 hours after recorded hospital admission
- Excludes pre-admission and later-admission measurements
- Keeps every admission from a patient in one validation fold
- Fits median imputation and standardization on training data only
- Trains Logistic Regression and Random Forest separately inside every fold
- Saves fold metrics, prediction-level outputs, cohort counts, and missingness
- Protects datasets, credentials, generated exports, and local paths
- Documents residual limitations instead of promoting the original 100% result

## Repository structure

```text
├── config/
│   └── default_config.m
├── src/
│   ├── run_pipeline.m
│   ├── prepare_cohort.m
│   ├── filter_observation_window.m
│   ├── build_features.m
│   ├── make_patient_folds.m
│   ├── evaluate_models.m
│   └── compute_metrics.m
├── tests/
│   └── test_pipeline_helpers.m
├── docs/
│   ├── methodology.md
│   ├── limitations.md
│   └── data-access.md
├── results/
│   └── README.md
├── CITATION.cff
├── LICENSE
└── .gitignore
```

## Requirements

- MATLAB with support for arguments blocks and string arrays
- Statistics and Machine Learning Toolbox
- MIMIC-III Clinical Database Demo 1.4

The Version 2 baselines do not require the Deep Learning Toolbox.

## Data setup

Obtain MIMIC-III Demo 1.4 from [PhysioNet](https://physionet.org/content/mimiciii-demo/1.4/) and keep the CSV files outside version control. See [data-access.md](docs/data-access.md).

## Run the project

From the repository root in MATLAB:

```matlab
addpath("config", "src");
results = run_pipeline("data/mimiciii-demo/1.4");
```

The pipeline writes generated summaries to `outputs/`:

- `cohort_summary.csv`
- `missingness_summary.csv`
- `fold_metrics.csv`
- `summary_metrics.csv`
- `fold_predictions.csv`
- `experiment_results.mat`

Generated outputs remain ignored until they are reviewed and deliberately selected for publication.

## Run the tests

```matlab
addpath("src");
results = runtests("tests");
table(results)
```

Tests cover patient isolation, fold class coverage, observation-window boundaries, and core binary metrics.

## Interpretation

The target is an admission-level ICD-9 diagnosis label and does not provide an exact time of sepsis onset. The project therefore evaluates association between first-24-hour observed measurements and a diagnosis recorded for the admission. It does not establish real-time onset prediction or clinical generalizability.

## Verification status

- Dataset feasibility audit: complete
- First-24-hour cohort logic: independently checked against the supplied MIMIC-III Demo tables
- Source refactor and static review: complete
- Privacy and path audit: complete
- MATLAB runtime execution: pending
- Clinical validation: not claimed

## Author

**Aboubakr Ibrahim**  
Biomedical Engineer | Clinical Engineering | Medical Device Quality | Healthcare Data  
[LinkedIn](https://www.linkedin.com/in/aboubakr-ibrahim-45435a246)

## Licence and citation

The refactored source code is available under the MIT License. Citation metadata is provided in [CITATION.cff](CITATION.cff).
