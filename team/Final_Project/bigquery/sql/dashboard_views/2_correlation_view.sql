/*
  Dashboard View 2: Recent Correlation Analysis
  Used for: Scatter Plot (NO2 vs O3)
  Logic: Gets last 24 hours of data, ensures both sensors were active.
*/

CREATE OR REPLACE VIEW `{{PROJECT_ID}}.air_quality_dataset.recent_24h_correlation_view` AS
SELECT 
    timestamp,
    MAX(CASE WHEN parameter = 'no2' THEN value END) as no2_level,
    MAX(CASE WHEN parameter = 'o3' THEN value END) as o3_level
FROM `{{PROJECT_ID}}.air_quality_dataset.streaming_air_quality`
WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
GROUP BY timestamp
HAVING no2_level IS NOT NULL AND o3_level IS NOT NULL;
