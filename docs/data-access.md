# Data access

## Dataset

This project was developed using the **MIMIC-III Clinical Database Demo, version 1.4**, distributed by PhysioNet.

Dataset files are intentionally excluded from this repository.

## Obtain the data

Download the dataset directly from the official PhysioNet page:

- https://physionet.org/content/mimiciii-demo/1.4/

Place locally obtained files in a directory named `data/`. That directory is excluded by `.gitignore`.

## Expected source tables

The original prototype used:

- `ADMISSIONS.csv`
- `DIAGNOSES_ICD.csv`
- `PATIENTS.csv`
- `CHARTEVENTS.csv`

## Data responsibility

Users are responsible for following the dataset licence, citation requirements, and all applicable PhysioNet terms. Do not commit raw medical datasets, credentials, access tokens, or identifiable information.
