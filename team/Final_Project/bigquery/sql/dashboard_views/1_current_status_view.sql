/*
  Dashboard View 1: Current Air Quality Status
  Used for: Scorecard KPI (Live CO Level)
  Logic: Returns the single most recent record, pivoted for easy visualization.
*/

CREATE OR REPLACE VIEW `{{PROJECT_ID}}.air_quality_dataset.current_air_quality_view` AS
SELECT 
    timestamp,
    MAX(CASE WHEN parameter = 'co' THEN value END) as co_level,
    MAX(CASE WHEN parameter = 'no2' THEN value END) as no2_level,
    MAX(CASE WHEN parameter = 'o3' THEN value END) as o3_level,
    MAX(CASE WHEN parameter = 'co' THEN unit END) as unit
FROM `{{PROJECT_ID}}.air_quality_dataset.streaming_air_quality`
GROUP BY timestamp
ORDER BY timestamp DESC
LIMIT 1;
