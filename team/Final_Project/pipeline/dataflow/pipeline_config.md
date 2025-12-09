# Pipeline Configuration: Pub/Sub to BigQuery

## Architecture Type
**Direct BigQuery Subscription** (No-Ops Streaming)

This pipeline utilizes a Google Cloud Pub/Sub BigQuery Subscription. This architecture bypasses the need for a classic Dataflow/Beam intermediate worker pool, reducing latency and cost.

## Pipeline Parameters

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Source Topic** | `projects/[PROJECT_ID]/topics/openaq-topic` | The Pub/Sub topic receiving JSON payloads from the Cloud Function. |
| **Sink Table** | `[PROJECT_ID]:air_quality_dataset.streaming_air_quality` | The BigQuery Streaming Fact Table. |
| **Schema Enforcement** | `True` (`--use-table-schema`) | Messages are matched to BigQuery columns by JSON key names. |
| **Dead Letter Policy** | *None / Drop* | Invalid messages that do not match the schema are dropped. |

## Schema Definition
The pipeline expects JSON messages matching the following BigQuery table schema:

*   **timestamp** (TIMESTAMP)
*   **city** (STRING)
*   **parameter** (STRING)
*   **value** (FLOAT)
*   **unit** (STRING)

## Delivery Guarantee
*   **At-least-once delivery:** Pub/Sub ensures messages are delivered to BigQuery.
*   **Deduplication:** Handled downstream in BigQuery Views if necessary (though strictly time-series data naturally handles duplicates via timestamp grouping).
