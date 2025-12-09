/*
  Dashboard View 3: Historical Data Reliability
  Used for: Gauge Chart (Data Quality Score)
  Logic: Calculates % of rows where sensor values were valid (> -200).
*/

CREATE OR REPLACE VIEW `{{PROJECT_ID}}.air_quality_dataset.historical_reliability_view` AS
SELECT 
    COUNT(*) as total_records,
    ROUND((COUNTIF(CO_GT_ > -200) / COUNT(*)) * 100, 2) as co_reliability_pct,
    ROUND((COUNTIF(NO2_GT_ > -200) / COUNT(*)) * 100, 2) as no2_reliability_pct,
    ROUND(
        (
            (COUNTIF(CO_GT_ > -200) + COUNTIF(NO2_GT_ > -200)) 
            / (COUNT(*) * 2)
        ) * 100, 
    2) as overall_reliability_pct
FROM `{{PROJECT_ID}}.air_quality_dataset.sensor_data`;
