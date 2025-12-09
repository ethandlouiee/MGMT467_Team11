/*
  Step 1: Train BQML Linear Regression Model
  Target: CO_GT_ (Carbon Monoxide)
  Features: NO2_GT_ (Nitrogen Dioxide)
  
  Feature Engineering:
  - Multiplies CO_GT_ by 1000 to convert mg/m³ to µg/m³
  - Filters out error codes (-200)
*/

CREATE OR REPLACE MODEL `{{PROJECT_ID}}.air_quality_dataset.air_quality_model_v2`
OPTIONS(model_type='LINEAR_REG') AS
SELECT
    (CO_GT_ * 1000) as label,   -- Convert Target to Micrograms to match API units
    NO2_GT_ as no2              -- Correlated Feature
FROM
    `{{PROJECT_ID}}.air_quality_dataset.sensor_data`
WHERE
    CO_GT_ > -200 
    AND NO2_GT_ > -200;
