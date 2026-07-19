# Early Sepsis Risk Detection

A MATLAB-based academic prototype exploring early sepsis-risk modelling with the MIMIC-III Clinical Database Demo.

> **Portfolio status:** The original graduation-project workflow is being refactored for reproducibility, leakage-safe evaluation, and a clear separation between observed and synthetic variables. This repository documents both the engineering work and its limitations. It is not a clinical diagnostic system.

## Project overview

This project was developed by **Aboubakr Ibrahim** as a Biomedical Engineering graduation project at Işık University. It explored how structured ICU information and qSOFA-related variables could support an early sepsis-risk modelling workflow in MATLAB.

The original prototype included:

- MIMIC-III demo data preparation
- ICD-9-based sepsis cohort exploration
- Respiratory rate, systolic blood pressure, and Glasgow Coma Scale processing
- qSOFA-related feature engineering
- Logistic Regression with Lasso, Random Forest, and a neural-network prototype
- Class-imbalance handling
- Confusion matrices and classification metrics
- Feature-importance analysis

## What this repository demonstrates

- Biomedical data preparation in MATLAB
- Clinical feature engineering
- Machine-learning experimentation
- Model evaluation and visualization
- Critical review of methodological limitations
- Reproducible research practices

## Repository structure

```text
early-sepsis-risk-detection/
├── README.md
├── src/
│   └── README.md
├── docs/
│   ├── methodology.md
│   ├── limitations.md
│   └── data-access.md
├── results/
│   └── README.md
└── .gitignore
```

## Data

The project uses the public **MIMIC-III Clinical Database Demo** distributed by PhysioNet. Dataset files are not included here. Obtain data directly from the official source and follow its terms of use.

## Important limitations

The original academic prototype requires careful interpretation:

- Some additional variables were synthetically generated for experimentation.
- Preprocessing occurred before cross-validation in parts of the original workflow.
- The first Random Forest implementation was not retrained independently inside every validation fold.
- qSOFA-derived labels and qSOFA-related predictors create a risk of circular evaluation.
- Original performance values must not be interpreted as evidence of clinical validity.

The refactored version will use fold-specific training, training-only preprocessing, explicit feature provenance, safer evaluation, and cautious reporting.

## Tools

- MATLAB
- Statistics and Machine Learning Toolbox
- Deep Learning Toolbox
- MIMIC-III Clinical Database Demo

## Ethics and intended use

This repository is for education, research demonstration, and professional portfolio purposes only. It must not be used for diagnosis, treatment decisions, or clinical deployment.

No identifiable patient information, restricted clinical data, passwords, or access credentials are included.

## Author

**Aboubakr Ibrahim**  
Biomedical Engineer | Clinical Engineering | Medical Device Quality | Healthcare Data  
[LinkedIn](https://www.linkedin.com/in/aboubakr-ibrahim-45435a246)

## Status

Repository foundation created. The original MATLAB prototype is under technical review; a cleaned modular version will be added after validation.
