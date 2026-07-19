# Early Sepsis Risk Detection

A reproducible MATLAB portfolio project exploring diagnosis-labelled sepsis-risk modelling with the MIMIC-III Clinical Database Demo.

> **Educational research only.** This repository is not a clinical diagnostic system and must not be used for patient-care decisions.

## Project overview

This work began as **Aboubakr Ibrahim's Biomedical Engineering graduation project at Işık University**. The original academic prototype explored structured ICU data, qSOFA-related variables, Logistic Regression with Lasso, Random Forest, neural networks, class imbalance, and model evaluation.

The portfolio version preserves that engineering story while correcting important methodological weaknesses.

## What was improved

- Replaced qSOFA-derived targets with diagnosis-based admission labels
- Removed randomly generated heart-rate and temperature values
- Uses only observed chart measurements
- Keeps every admission from a patient in one validation fold
- Fits median imputation and standardization on training data only
- Trains Logistic Regression and Random Forest separately inside every fold
- Adds balanced accuracy, sensitivity, specificity, precision, F1, ROC-AUC, and PR-AUC
- Protects datasets, credentials, generated exports, and local machine paths
- Documents limitations instead of promoting the original 100% result

## Repository structure

```text
├── config/
│   └── default_config.m
├── src/
│   ├── run_pipeline.m
│   ├── prepare_cohort.m
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

The refactored baseline does not require the Deep Learning Toolbox.

## Data setup

1. Obtain MIMIC-III Demo from [PhysioNet](https://physionet.org/content/mimiciii-demo/1.4/).
2. Keep the CSV files outside version control, for example:

```text
data/mimiciii-demo/1.4/
├── ADMISSIONS.csv
├── DIAGNOSES_ICD.csv
└── CHARTEVENTS.csv
```

The `data/` directory is ignored by Git. See [data-access.md](docs/data-access.md).

## Run the project

From the repository root in MATLAB:

```matlab
addpath("config", "src");
results = run_pipeline("data/mimiciii-demo/1.4");
```

The pipeline writes privacy-safe generated summaries to `outputs/`:

- `cohort_summary.csv`
- `fold_metrics.csv`
- `summary_metrics.csv`
- `experiment_results.mat`

Generated outputs remain ignored until they are reviewed and deliberately selected for publication.

## Run the tests

```matlab
addpath("src");
results = runtests("tests");
table(results)
```

Tests verify patient isolation across folds and core binary metrics.

## Model design

The current baselines are:

- L1-regularized Logistic Regression
- Random Forest with uniform class priors

Features are admission-level medians of observed respiratory rate, systolic blood pressure, total GCS, heart rate, and temperature after physiologic range checks.

See [methodology.md](docs/methodology.md) for the full experimental design.

## Honest limitations

MIMIC-III Demo is small and intended for education and software development. It cannot establish clinical generalizability. The repository has no external or prospective validation, and performance values are intentionally not published until the refactored pipeline is executed and reviewed.

See [limitations.md](docs/limitations.md) for the complete audit.

## Verification status

- Repository structure: complete
- Code refactor: complete
- Static privacy and path audit: complete
- Helper tests: included
- MATLAB runtime execution: pending on a MATLAB environment
- Clinical validation: not claimed

## Ethics and intended use

No identifiable patient data, restricted datasets, credentials, or client information are included. The software is provided for education, research demonstration, and professional portfolio review only.

## Author

**Aboubakr Ibrahim**  
Biomedical Engineer | Clinical Engineering | Medical Device Quality | Healthcare Data  
[LinkedIn](https://www.linkedin.com/in/aboubakr-ibrahim-45435a246)

## Licence and citation

The refactored source code is available under the MIT License. Citation metadata is provided in [CITATION.cff](CITATION.cff).
