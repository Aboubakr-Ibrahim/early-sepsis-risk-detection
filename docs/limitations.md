# Limitations and technical audit

This document separates the accomplishments of the original academic prototype from conclusions that the available implementation cannot support.

## Original prototype limitations

1. **Circular target construction**  
   The early workflow derived the target from qSOFA while also using qSOFA components as predictors. This evaluates reconstruction of a rule rather than independent sepsis prediction.

2. **Synthetic variables**  
   Heart rate and temperature were generated randomly for experimentation and are not observed clinical measurements.

3. **Preprocessing leakage**  
   Normalization and SMOTE were applied before cross-validation in the original implementation. Both should be fitted only on each training fold.

4. **Random Forest evaluation leakage**  
   The original Random Forest was fitted once on all resampled observations and then evaluated across cross-validation test partitions. A new model must be trained inside every fold.

5. **Temporal limitations**  
   Moving averages were calculated across table rows without demonstrating that rows represented correctly ordered measurements within an admission.

6. **Small demo cohort**  
   MIMIC-III Demo is suitable for learning and software development, not for estimating clinically generalizable model performance.

7. **No external validation**  
   The project has not been evaluated on a separate hospital, time period, or prospective cohort.

## Correct interpretation

The project demonstrates biomedical data handling, MATLAB development, feature engineering, machine-learning experimentation, evaluation metrics, documentation, and the ability to critically improve earlier work.

It does **not** establish a clinically validated sepsis-detection system.

## Refactoring goals

- Use diagnosis-based or explicitly defined outcome labels
- Preserve admission and patient identifiers during splitting
- Apply preprocessing only to training data
- Apply SMOTE only within training folds, when justified
- Train every model independently within each fold
- Remove synthetic variables from validated experiments
- Document feature provenance and observation windows
- Report uncertainty and class-specific metrics
