/*
  Step 4: Data Drift / Scale Analysis
  Compares average values between Historical Training Data and Live Streaming Data
  to identify unit mismatches (mg/m³ vs µg/m³).
*/

SELECT 
    'Training Data (2004)' as dataset_source,
    AVG(CO_GT_) as avg_co_raw,
    'mg/m^3' as apparent_unit
FROM `{{PROJECT_ID}}.air_quality_dataset.sensor_data`
WHERE CO_GT_ > -200

UNION ALL

SELECT 
    'Live Data (2025)' as dataset_source,
    AVG(value) as avg_co_raw,
    'µg/m^3' as apparent_unit
FROM `{{PROJECT_ID}}.air_quality_dataset.streaming_air_quality`
WHERE parameter = 'co';
