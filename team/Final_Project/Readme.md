# Hybrid Air Quality Monitoring Pipeline

### Big Data & Cloud Computing Final Project | Team [11]

## Executive Summary
This project implements a production-grade Hybrid Data Pipeline that bridges a 20-year gap in environmental data. By integrating historical sensor data (2004) with real-time API streaming data (2025), we have built a system capable of analyzing long-term pollution trends and predicting current Carbon Monoxide levels using BigQuery Machine Learning (BQML) and **advanced feature engineering.**

**Key Business Problem:** Calibrating predictive models using reliable historical baselines to score live, disparate data sources while handling data drift (unit mismatches) and behavioral variances.

---

## Repository Structure

```text
TermProject_TeamX/
├── notebooks/          # Individual Analysis & DIVE Journals
│   ├── Final_Alice_analysis.ipynb
│   ├── Final_Bob_analysis.ipynb
│   └── ...
├── pipeline/           # Ingestion Logic
│   ├── function/       # Cloud Function (Producer) Code
│   ├── dataflow/       # Pipeline Configs
│   └── infra/          # Infrastructure Setup Scripts
├── bq/                 # Analytics & Data Warehouse
│   └── sql/            # BQML Training, Eval, and Dashboard View queries
├── dashboards/         # Visualization Documentation
│   └── kpis.md         # KPI Definitions & Link to Looker Studio
├── docs/               # Architecture & Operations
│   ├── blueprint.pdf     # Architecture Diagram & Design Patterns
│   ├── governance.pdf    # Data Ethics, Privacy, & Assumptions
│   └── ops_runbook.md    # Deployment & Teardown Instructions
└── README.md           # Project Root
```

---

## Key Features (Requirements Met)

### 1. Batch Ingestion (ETL)
*   **Source:** UCI/Kaggle Air Quality Dataset (2004-2005).
*   **Architecture:** Local CSV -> GCS Bucket -> BigQuery.
*   **Optimization:** Tables are Time-Partitioned by Day to optimize query costs.
*   **Quality Check:** SQL logic filters invalid sensor codes (-200) before analysis.

### 2. Streaming Ingestion (Real-Time)
*   **Source:** Open-Meteo Air Quality API (Rome, Italy).
*   **Producer:** Serverless Cloud Function (2nd Gen) triggered every 15 minutes via Cloud Scheduler.
*   **Pipeline:** API -> Cloud Function -> Pub/Sub -> BigQuery Subscription -> Streaming Table.
*   **Validation:** Normalized JSON payloads ensure schema consistency between producer and warehouse.

### 3. Hybrid Analytics & BQML (with Feature Engineering)
*   **Model:** Linear Regression Model trained on historical Batch data to predict CO levels based on NO2 concentrations.
*   **Unit Harmonization:** Solved critical Data Drift (mg/m3 vs ug/m3) by applying unit conversion logic during training.
*   **Advanced Feature Engineering (Extra Credit):**
    *   **Temporal Logic:** Engineered `is_rush_hour` (07:00-09:00 & 17:00-19:00) and `is_weekend` features to capture human behavioral patterns in traffic pollution.
    *   **Dynamic Inference:** These features are calculated **on-the-fly** during streaming ingestion, allowing the model to instantly adjust predictions based on the current time of day.
    *   **Model Validation:** Implemented a side-by-side "Model Showdown" (Base vs. Engineered) using `ML.EVALUATE` to statistically prove predictive lift.

### 4. Executive Dashboard
*   **Tool:** Looker Studio.
*   **KPIs:** Live CO Levels, Forecast Accuracy, Historical Reliability, and Correlation Scatter Plots.
*   **Time-Series:** Interactive trend lines comparing "Live Conditions" vs "2004 Baseline".

---

## Quick Start (Deployment)

For detailed step-by-step instructions, commands, and failure handling, please refer to the **[Operations Runbook](docs/ops_runbook.md)**.

### High-Level Deployment Steps:
1.  **Infrastructure:** Run `infra/setup.sh` to enable APIs and create BQ datasets.
2.  **Batch Load:** Upload historical CSVs to the created GCS bucket.
3.  **Stream:** Deploy the Cloud Function in `pipeline/function/` and enable the Scheduler.
4.  **Analyze:** Run the SQL scripts in `bq/sql/` to train the models and create dashboard views.

---

## Dashboard & Deliverables

*   **Live Dashboard:** [Looker Studio Link](https://lookerstudio.google.com/u/0/reporting/2fc71b11-3a55-45b6-8a01-d77ad5878b63/page/p_ol08d80uyd/edit)
*   **Architecture Blueprint:** [View PDF](docs/blueprint.pdf)
*   **Governance & Ethics:** [View PDF](docs/governance.pdf)
*   **Ops Runbook:** [View Markdown](docs/ops_runbook.md)
*   **Medium Article** [Medium Link](https://medium.com/@njhiatt04/bridging-a-20-year-data-gap-building-a-hybrid-air-quality-pipeline-on-google-cloud-c2ab0fedd4f5)

---

## Contributors & Roles

*   **[Ethan Louie, Nathaniel Hiatt]:** Pipeline Architecture & Cloud Functions.
*   **[Nathaniel Hiatt]:** BQML Modeling & Feature Engineering.
*   **[Iris Zhang, Qianyue Wang, Ethan Louie, Nathaniel Hiatt]:** Dashboarding & Data Visualization.

---

*Project developed for [MGMT467], Fall 2025.*
