/*
  Dashboard View 4: Pollution Trend Comparison
  Used for: Time Series Chart (Live Trend vs 2004 Baseline)
  Logic: 
  - Smooths live data to 1-minute intervals to prevent Looker rendering errors.
  - Cross-Joins with the calculated 2004 Average Baseline.
  - Unit Conversion: Multiplies Historical CO by 1000 to match Live units (µg).
*/

CREATE OR REPLACE VIEW `{{PROJECT_ID}}.air_quality_dataset.pollution_trend_view` AS

WITH live_data_smoothed AS (
    SELECT 
        -- Truncate to Minute for cleaner plotting
        TIMESTAMP_TRUNC(timestamp, MINUTE) as timestamp_minute,
        AVG(CASE WHEN parameter = 'co' THEN value END) as live_co_ug,
        AVG(CASE WHEN parameter = 'no2' THEN value END) as live_no2_ug
    FROM `{{PROJECT_ID}}.air_quality_dataset.streaming_air_quality`
    GROUP BY 1
),

historical_baseline AS (
    SELECT 
        AVG(CO_GT_) * 1000 as avg_historical_co, -- Convert mg to µg
        AVG(NO2_GT_) as avg_historical_no2
    FROM `{{PROJECT_ID}}.air_quality_dataset.sensor_data`
    WHERE CO_GT_ > -200 AND NO2_GT_ > -200
)

SELECT 
    l.timestamp_minute as timestamp,
    l.live_co_ug,
    l.live_no2_ug,
    h.avg_historical_co as baseline_co_2004,
    h.avg_historical_no2 as baseline_no2_2004
FROM live_data_smoothed l
CROSS JOIN historical_baseline h
ORDER BY l.timestamp_minute DESC;
