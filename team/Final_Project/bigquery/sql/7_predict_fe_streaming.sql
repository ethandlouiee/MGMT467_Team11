/* 
   Applies the Advanced FE Model to streaming data.
   CRITICAL: Calculates 'is_rush_hour' and 'is_weekend' dynamically 
   from the live timestamp during prediction.
*/
WITH live_features AS (
    SELECT
        timestamp,
        MAX(CASE WHEN parameter = 'no2' THEN value END) as no2,
        MAX(CASE WHEN parameter = 'co' THEN value END) as actual_co_live,

        -- Dynamic Feature Engineering
        CASE
            WHEN EXTRACT(HOUR FROM timestamp) BETWEEN 7 AND 9 THEN 1
            WHEN EXTRACT(HOUR FROM timestamp) BETWEEN 17 AND 19 THEN 1
            ELSE 0
        END as is_rush_hour,
        
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM timestamp) IN (1, 7) THEN 1
            ELSE 0
        END as is_weekend

    FROM `YOUR_PROJECT_ID.air_quality_dataset.streaming_air_quality`
    GROUP BY timestamp
    HAVING no2 IS NOT NULL
)

SELECT
    timestamp,
    ROUND(predicted_label, 2) as predicted_co_ug,
    actual_co_live as actual_co,
    no2 as input_no2,
    is_rush_hour,
    is_weekend
FROM
    ML.PREDICT(MODEL `YOUR_PROJECT_ID.air_quality_dataset.air_quality_model_fe`,
    (SELECT * FROM live_features))
ORDER BY timestamp DESC
LIMIT 15
