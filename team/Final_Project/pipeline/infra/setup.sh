#!/bin/bash

# ==============================================================================
# INFRASTRUCTURE SETUP SCRIPT
# Project: Air Quality Monitoring Pipeline
# ==============================================================================

# 1. Configuration Variables
# Replace these with your actual Project ID and preferences
PROJECT_ID="[Insert Your Project ID]"
REGION="us-central1"
BUCKET_NAME="air_quality_raw_${PROJECT_ID}"
DATASET_NAME="air_quality_dataset"
STREAMING_TABLE="streaming_air_quality"
TOPIC_ID="openaq-topic"
SUBSCRIPTION_ID="openaq-to-bq"
JOB_NAME="openaq-ticker"

# Set Project Context
gcloud config set project $PROJECT_ID

echo "Starting Infrastructure Setup for Project: $PROJECT_ID..."

# ==============================================================================
# STEP 1: Enable APIs
# ==============================================================================
echo "Enabling required APIs..."
gcloud services enable \
    cloudfunctions.googleapis.com \
    run.googleapis.com \
    pubsub.googleapis.com \
    cloudbuild.googleapis.com \
    cloudscheduler.googleapis.com \
    artifactregistry.googleapis.com

# ==============================================================================
# STEP 2: Create Storage & BigQuery Resources
# ==============================================================================
echo "Creating GCS Bucket..."
gsutil mb -l $REGION gs://$BUCKET_NAME/ || echo "Bucket already exists"

echo "Creating BigQuery Dataset..."
bq --location=US mk -d --description "Air Quality Data" ${PROJECT_ID}:${DATASET_NAME} || echo "Dataset exists"

echo "Creating Streaming Fact Table..."
# Schema: timestamp, city, parameter, value, unit
bq mk --table \
   ${PROJECT_ID}:${DATASET_NAME}.${STREAMING_TABLE} \
   timestamp:TIMESTAMP,city:STRING,parameter:STRING,value:FLOAT,unit:STRING \
   || echo "Table exists"

# ==============================================================================
# STEP 3: Pub/Sub & IAM Setup
# ==============================================================================
echo "Creating Pub/Sub Topic..."
gcloud pubsub topics create $TOPIC_ID || echo "Topic exists"

echo "Granting IAM Roles..."
# Retrieve the Google-managed Pub/Sub Service Account
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format="value(projectNumber)")
PUBSUB_SA="service-${PROJECT_NUMBER}@gcp-sa-pubsub.iam.gserviceaccount.com"

# Allow Pub/Sub to write directly to BigQuery
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PUBSUB_SA" \
    --role="roles/bigquery.dataEditor"

# ==============================================================================
# STEP 4: Create Pipeline (BigQuery Subscription)
# ==============================================================================
echo "Creating Pipeline (Pub/Sub -> BigQuery)..."
gcloud pubsub subscriptions create $SUBSCRIPTION_ID \
    --topic=$TOPIC_ID \
    --bigquery-table="${PROJECT_ID}:${DATASET_NAME}.${STREAMING_TABLE}" \
    --use-table-schema \
    || echo "Subscription exists"

# ==============================================================================
# STEP 5: Cloud Scheduler (The Trigger)
# ==============================================================================
# Note: This assumes the Cloud Function is already deployed and we have its URL.
# You would manually replace FUNCTION_URL below after deployment.
# FUNCTION_URL=$(gcloud functions describe openaq-ingest --gen2 --region=$REGION --format="value(url)")

# echo "Creating Scheduler Job..."
# gcloud scheduler jobs create http $JOB_NAME \
#    --schedule="*/15 * * * *" \
#    --uri="$FUNCTION_URL" \
#    --http-method=GET \
#    --location=$REGION \
#    --quiet

echo "Infrastructure Setup Complete."
