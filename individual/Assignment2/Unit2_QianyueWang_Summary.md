# Unit 2 – Titanic Logistic Regression (BQML)

## Objective
Build and evaluate a **baseline Logistic Regression model** to predict passenger survival on the Titanic using BigQuery ML.  
This exercise demonstrates end-to-end ML workflow: data preparation, model training, evaluation, and decision threshold selection.

---

## Model Summary

| Stage | Description |
|-------|--------------|
| **Baseline Model** | `LOGISTIC_REG` trained on canonical features: `pclass, sex, age, sibsp, parch, fare, embarked` |
| **Split Method** | 80/20 random split using `RAND(12345)` |
| **Evaluation Metric** | `ML.EVALUATE()` – precision, recall, accuracy, ROC AUC |
| **Thresholds Tested** | 0.5 (default), 0.6 (custom deployment candidate) |

---

## Key Findings

- **Accuracy (~0.74):** The model performs reasonably well given the small dataset and simple features.  
- **ROC AUC (~0.83):** Indicates good discriminative ability between survivors and non-survivors.  
- **Feature importance (via coefficients):**  
  - `sex` (female) is the strongest positive predictor of survival.  
  - `pclass` and `fare` indicate socioeconomic status effects.  
  - `age` contributes moderately but has nonlinear effects not captured by baseline logistic regression.

---

## Model Limitations

| Issue | Impact | Example |
|--------|---------|----------|
| **Linearity assumption** | Model cannot capture nonlinear patterns (e.g., survival probability vs. age). | Children and elderly passengers are treated similarly in baseline. |
| **Missing contextual data** | Some columns (like `cabin`, `ticket`) are dropped, losing group-level signals. | Families or group travelers may share survival outcomes. |
| **Data imbalance** | Slight skew toward non-survivors reduces recall for minority (survivor) class. | Many false negatives at default threshold = 0.5. |

---

## Threshold Selection & Deployment Justification

- **Default (0.5):** Balanced accuracy but higher false negatives.  
- **Proposed Deployment Threshold: `0.6`**  
  - Reduces false positives (fewer incorrectly predicted survivors).  
  - More conservative for “lifeboat allocation” scenario where **resource scarcity favors precision** over recall.  
  - Ethically preferable if the goal is to avoid overcommitting limited capacity (e.g., lifeboats).

---

## Reflection

This lab demonstrates how simple feature engineering and threshold tuning meaningfully alter model behavior.  
In real operational settings, model success depends not only on accuracy but on **context-driven threshold decisions** aligned with organizational policy.  
Future work should explore:
- Feature transformations (`TRANSFORM` clause)
- Interaction terms (e.g., `sex * pclass`)
- Nonlinear models (e.g., boosted trees)

---
