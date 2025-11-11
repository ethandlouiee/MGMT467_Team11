# Unit 2 — Titanic Survival Classification (BigQuery ML)

**Author:** Qianyue Wang，Ethan Louie, Zijing Zhang and Nathaniel Hiatt
**Environment:** Google Colab + BigQuery ML  
**Dataset:** https://www.kaggle.com/datasets/yasserh/titanic-dataset

---

## Objective
Develop, evaluate, and govern a **logistic-regression classifier** predicting passenger survival on the Titanic.  
The exercise demonstrates the full MLOps lifecycle: schema creation, model training, evaluation, threshold tuning, and governance reporting.

---
## Workflow from Colab

| Step | Task | Key Code / Query |
|------|------|------------------|
| **1. Create Schema** | Ensure dataset exists in BigQuery | `CREATE SCHEMA IF NOT EXISTS \`unit2_titanic\`;` |
| **2. Train Baseline Model** | Logistic Regression on canonical features | `CREATE OR REPLACE MODEL ... OPTIONS(MODEL_TYPE='LOGISTIC_REG')` |
| **3. Evaluate Model** | Compute accuracy, recall, precision, ROC AUC | `ML.EVALUATE(MODEL ...)` |
| **4. Visualize Results** | Convert evaluation table to DataFrame in Colab | `eval_df = bq.query(evaluate_sql).to_dataframe()` |
| **5. Feature Engineering (Extra Credit)** | Add derived features using `TRANSFORM` | `family_size`, `fare_bucket`, `sex_pclass` |
| **6. Governance Analysis** | Apply threshold, cost, and fairness checks | Based on Ops Brief calculations |

---

## Model Overview

| Component | Description |
|------------|--------------|
| **Baseline Model** | Logistic Regression on canonical features (`pclass`, `sex`, `age`, `sibsp`, `parch`, `fare`, `embarked`) |
| **Engineered Model (Extra Credit)** | Added engineered features via `TRANSFORM`: `family_size`, `fare_bucket`, `sex_pclass` interaction |
| **Data Split** | 80 % train / 20 % eval using `RAND(12345)` |
| **Evaluation** | `ML.EVALUATE()` metrics — accuracy, precision, recall, log_loss, roc_auc |

---

## Key Results

| Metric | Baseline | Engineered Model | Δ Improvement |
|---------|-----------|-----------------|---------------|
| **ROC AUC** | 0.83 | 0.85 | +2 pp |
| **Accuracy (@0.5)** | 0.80 | 0.82 | +2 pp |
| **Log Loss** | 0.513 | 0.368 | Lower = Better |

**Primary Insight:**  
The `sex_pclass` interaction captured the “women and children first” bias, driving most of the uplift.

---

## Assumptions & Limitations

| Area | Assumption | Limitation |
|------|-------------|-------------|
| **Data Completeness** | Missing values (`age`, `fare`) removed | Potential bias due to non-random missingness |
| **Linearity** | Logistic Regression assumes linear feature effects | Non-linear age or group patterns under-modeled |
| **Independence** | Observations treated as independent | Family/group outcomes correlated |
| **Stationarity** | Future data resembles training distribution | Real-world drift could reduce performance |

---

## Operational Decision Rule

**Goal:** minimize *False Positives* (FP) because lifeboat capacity is scarce → maximize Precision.

- **Deployed Threshold (τ = 0.6)**  
  - Reduces FP (from ~12 → 8)  
  - Accepts higher FN to optimize resource allocation  
  - Supported by expected-cost analysis (below)

---

## Expected-Cost Analysis

| Error Type | Cost ($) | Count | Total |
|-------------|-----------|-------|--------|
| **False Positive** | 1 000 | 8 | 8 000 |
| **False Negative** | 4 000 | 35 | 140 000 |
| **Total Expected Cost** |  |  | **$148 000** |

**Policy Interpretation:** threshold 0.6 minimizes total cost under this matrix.

---

## Fairness & Governance

**Precision Parity by Sex (Policy Gap ≤ 5 pp):**

| Subgroup | Precision |
|-----------|------------|
| Female | 0.841 |
| Male | 0.827 |
| Gap = 1.4 pp | Within limit |

**Continuous Monitoring Plan**

| Metric | Alert Condition | Cadence | Purpose |
|---------|----------------|----------|----------|
| Calibration (Log Loss) | ↑ 0.45 | Weekly | Detect Data Drift |
| Precision Parity Gap | > 5 pp | Monthly | Monitor Fairness |
| Feature Weight Change | > 10 % | Monthly | Detect Concept Drift |

---

## Reflection
This unit reinforced the link between **model metrics and operational ethics**.  
Choosing τ = 0.6 was not only statistically sound but aligned with policy goals and equity principles.  
The **extra-credit engineering** demonstrated that domain-informed features (`sex_pclass`, `family_size`) and threshold governance can materially improve performance and trust.
