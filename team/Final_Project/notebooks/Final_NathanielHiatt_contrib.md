# Individual Contribution Report
**Name:** Nathaniel Hiatt

**Project:** Hybrid Air Quality Pipeline

## Specific Contributions

### 1. Data Ingestion Infrastructure (Batch and Streaming)
*   **Batch Ingestion:** Implemented the Extract-Load-Transform (ELT) pipeline for historical data. This involved extracting the 2004 Air Quality dataset from Kaggle, staging the raw CSVs in Google Cloud Storage (GCS) buckets, and loading them into BigQuery.
*   **Optimization:** Configured Time-Partitioning on the BigQuery `sensor_data` table to optimize query performance and reduce long-term storage costs.
*   **Streaming Ingestion:** Designed the serverless ingestion architecture using Google Cloud Functions (2nd Gen) and Open-Meteo. I implemented the JSON normalization logic to ensure the payload matched the BigQuery schema (timestamp, city, parameter, value, unit) and configured the Pub/Sub to BigQuery subscription.

### 2. Analytics and Machine Learning Modeling
*   **Model Creation:** Developed the initial Linear Regression model using BigQuery ML (BQML). I wrote the SQL syntax (`CREATE MODEL ... OPTIONS(model_type='LINEAR_REG')`) to predict Carbon Monoxide levels based on Nitrogen Dioxide and Ozone inputs.
*   **Data Drift Diagnosis:** Debugged the model's initial poor performance on live data. I identified a critical unit mismatch between the 2004 sensors (mg/m3) and the 2025 API data (ug/m3).
*   **Feature Engineering:** Implemented the SQL transformation logic (`CO_GT_ * 1000`) within the training query to normalize units, reducing the prediction error from >90% to approximately 2.1%.

### 3. Visualization and Dashboarding
*   **Task:** Developed the Executive Dashboard in Looker Studio to visualize the model's performance.
*   **Implementation:** Created specific SQL Views (`pollution_trend_view`, `forecast_accuracy_view`) to handle time-series smoothing (1-minute buckets), resolving rendering errors caused by high-frequency streaming data.
*   **Output:** Built the interactive Plotly figure in the analysis notebook to prototype the "Predicted vs Actual" visualization before deploying it to the final dashboard.

---

## Code and Artifact Links
*   **Cloud Function Code:** [pipeline/function/main.py](../pipeline/function/main.py)
*   **ML Training Query:** [bq/sql/1_train_model.sql](../bq/sql/1_train_model.sql)
*   **Individual Analysis Notebook:** [notebooks/Final_Analysis.ipynb](../notebooks/Final_Analysis.ipynb)

---

## Lessons Learned

**1. The "Firehose" Fallacy**
I initially attempted to stream data for "All of Italy" using OpenAQ. I learned that modern APIs often separate metadata (Locations) from data (Measurements) to save bandwidth. This forced a pivot to a "Virtual IoT" strategy, where we simulate a single high-quality sensor (Rome) rather than trying to ingest a fragmented national dataset.

**2. Data Definitions versus Data Types**
Technically, both the historical and live data were FLOAT types. However, semantically, they were incompatible due to the unit mismatch. I learned that "Schema Validation" is not enough; one needs "Semantic Validation" (checking means/averages) to safely deploy ML models.

**3. Serverless Cost Management**
Using Cloud Scheduler to trigger the function every 15 minutes was a key architectural decision. It prevented us from hitting API rate limits (HTTP 429) and kept our Cloud Function invocations well within the free tier, ensuring the project remains sustainable.
