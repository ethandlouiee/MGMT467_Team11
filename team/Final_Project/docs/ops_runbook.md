# Operations Runbook: Air Quality Pipeline

This guide details how to Deploy (Spin Up) and Teardown (Spin Down) the entire infrastructure.

## Prerequisites
*   Google Cloud SDK (`gcloud`) installed and authenticated.
*   Python 3.10+ installed.
*   Project ID: `(You must have your projectID available)`.

---

## Deployment (Spin Up)

### 1. Infrastructure Initialization
Run the setup script located in the `infra/` folder. This enables APIs, creates buckets, datasets, and tables.

```bash
chmod +x infra/setup.sh
./infra/setup.sh
```

### 2. Batch Ingestion (One-Time)
Run the Jupyter Notebook `final_project.ipynb` (Steps 1 & 4) OR execute the following commands manually to upload and load the historical data:

```bash
# Set your Project ID variable
export PROJECT_ID={projectID}

# 1. Upload Raw Data to GCS
gsutil cp data/AirQualityUCI.csv gs://air_quality_raw_$PROJECT_ID/

# 2. Load to BigQuery (Schema Auto-detect)
bq load --source_format=CSV --skip_leading_rows=1 \
  air_quality_dataset.sensor_data \
  gs://air_quality_raw_$PROJECT_ID/AirQualityUCI.csv
```

### 3. Deploy Streaming Producer
Navigate to the pipeline directory and deploy the Cloud Function (2nd Gen).

```bash
cd pipeline/function
gcloud functions deploy openaq-ingest \
    --gen2 \
    --runtime=python310 \
    --region=us-central1 \
    --source=. \
    --entry-point=fetch_openaq \
    --trigger-http \
    --allow-unauthenticated \
    --set-env-vars=GCP_PROJECT=$PROJECT_ID
```

### 4. Activate Automation
Ensure Cloud Scheduler is running to trigger the function every 15 minutes.

```bash
# Get the URL of the function you just deployed
FUNCTION_URL=$(gcloud functions describe openaq-ingest --gen2 --region=us-central1 --format="value(url)")

# Create the Cron Job
gcloud scheduler jobs create http openaq-ticker \
    --schedule="*/15 * * * *" \
    --uri="$FUNCTION_URL" \
    --http-method=GET \
    --location=us-central1
```

### 5. Deploy Analytics & Views
Execute the SQL scripts in `bq/sql/` to create the Model and Dashboard Views.

```bash
# Example: Create the Unit-Corrected Model
bq query --use_legacy_sql=false < bq/sql/1_train_model.sql

# Example: Create the Dashboard Views
bq query --use_legacy_sql=false < bq/sql/dashboard_views/1_current_status_view.sql
bq query --use_legacy_sql=false < bq/sql/dashboard_views/4_pollution_trend_view.sql
```

---

## Teardown (Spin Down)

To prevent ongoing costs, run the following commands to remove resources.

### 1. Stop Automation
```bash
gcloud scheduler jobs delete openaq-ticker --location=us-central1 --quiet
```

### 2. Remove Compute & Messaging
```bash
gcloud functions delete openaq-ingest --gen2 --region=us-central1 --quiet
gcloud pubsub subscriptions delete openaq-to-bq --quiet
gcloud pubsub topics delete openaq-topic --quiet
```

### 3. Remove Storage (Optional - Data Loss Warning)
*Warning: This will delete your historical data and ML models.*

```bash
# Remove Dataset (and all tables/models/views inside)
bq rm -r -f -d $PROJECT_ID:air_quality_dataset

# Remove GCS Bucket
gsutil rm -r gs://air_quality_raw_$PROJECT_ID
```

---

## Failure Handling & Troubleshooting

### API Rate Limiting (HTTP 429)
*   **Observation:** Cloud Function logs show "API Error: 429".
*   **Action:** No manual action required for transient errors. The Scheduler will retry in 15 minutes.
*   **Persistent:** If error persists > 1 hour, modify Scheduler to run less frequently (e.g., every 30 minutes).

```bash
gcloud scheduler jobs update http openaq-ticker --schedule="*/30 * * * *" --location=us-central1
```

### Data Drift / Model Inaccuracy
*   **Observation:** Dashboard shows massive discrepancy between "Live CO" and "Predicted CO".
*   **Action:** Check the Data Drift Analysis query.
*   **Fix:** Ensure the Unit Conversion multiplier in the training SQL matches the current API output (currently `* 1000` for mg -> µg).

```bash
# Check drift
bq query --use_legacy_sql=false < bq/sql/4_data_drift_analysis.sql
```
