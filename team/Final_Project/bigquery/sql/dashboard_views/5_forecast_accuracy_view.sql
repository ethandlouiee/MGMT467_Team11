/*
  Dashboard View 5: Forecast Accuracy
  Used for: Scorecard (Avg Error %) and Line Chart (Pred vs Actual)
  Logic: Runs ML.PREDICT on live data (Last 24h) and calculates % Error.
*/

CREATE OR REPLACE VIEW `{{PROJECT_ID}}.air_quality_dataset.forecast_accuracy_view` AS

WITH live_features AS (
    SELECT 
        TIMESTAMP_TRUNC(timestamp, MINUTE) as timestamp,
        AVG(CASE WHEN parameter = 'no2' THEN value END) as no2,
        AVG(CASE WHEN parameter = 'co' THEN value END) as actual_co
    FROM `{{PROJECT_ID}}.air_quality_dataset.streaming_air_quality`
    WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
    GROUP BY 1
    HAVING no2 IS NOT NULL AND actual_co IS NOT NULL
),

predictions AS (
    SELECT
        timestamp,
        predicted_label as predicted_co,
        actual_co
    FROM
        ML.PREDICT(MODEL `{{PROJECT_ID}}.air_quality_dataset.air_quality_model_v2`, 
        (SELECT * FROM live_features))
)

SELECT
    timestamp,
    ROUND(predicted_co, 2) as predicted_co,
    ROUND(actual_co, 2) as actual_co,
    -- Calculate Error Percentage: ABS(Pred - Actual) / Actual
    ROUND(ABS(predicted_co - actual_co) / NULLIF(actual_co, 0) * 100, 2) as error_pct
FROM predictions
ORDER BY timestamp ASC;
