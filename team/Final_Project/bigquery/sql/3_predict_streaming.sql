/*
  Step 3: Hybrid Prediction on Live Streaming Data
  1. Pivots streaming data (Long format) into Wide format (columns for NO2, CO).
  2. Feeds NO2 into the model to predict CO.
  3. Compares Predicted CO vs Actual Live CO.
*/

WITH live_features AS (
    SELECT 
        timestamp,
        -- Pivot parameters to columns
        AVG(CASE WHEN parameter = 'no2' THEN value END) as no2,
        AVG(CASE WHEN parameter = 'co' THEN value END) as actual_co_live
    FROM `{{PROJECT_ID}}.air_quality_dataset.streaming_air_quality`
    GROUP BY timestamp
    HAVING no2 IS NOT NULL
)

SELECT
    timestamp,
    ROUND(predicted_label, 2) as predicted_co_ug, -- Model Prediction
    actual_co_live,                               -- Actual API Value
    no2 as input_no2
FROM
    ML.PREDICT(MODEL `{{PROJECT_ID}}.air_quality_dataset.air_quality_model_v2`, 
    (SELECT * FROM live_features))
ORDER BY timestamp DESC;
