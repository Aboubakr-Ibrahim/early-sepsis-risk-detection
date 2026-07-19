# Data access

## Dataset

This project uses the **MIMIC-III Clinical Database Demo, version 1.4**, distributed by PhysioNet. Dataset files are intentionally excluded from this repository.

## Obtain the data

Download the dataset from the official PhysioNet page:

- https://physionet.org/content/mimiciii-demo/1.4/

Place locally obtained files under `data/mimiciii-demo/1.4/`. The entire `data/` directory is excluded by `.gitignore`.

## Required tables for Version 2

- `ADMISSIONS.csv` — patient/admission identifiers and admission time
- `DIAGNOSES_ICD.csv` — admission-level ICD-9 diagnosis codes
- `CHARTEVENTS.csv` — observed vital measurements and chart times

Other MIMIC-III Demo tables are not required by the baseline pipeline.

## Data responsibility

Users are responsible for following the dataset licence, citation requirements, and all applicable PhysioNet terms. Do not commit raw medical datasets, credentials, access tokens, private paths, or identifiable information.
