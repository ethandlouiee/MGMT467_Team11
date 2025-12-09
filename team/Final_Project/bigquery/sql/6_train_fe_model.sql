/* 
   Trains the Advanced Model using the View created in Step 5.
*/
CREATE OR REPLACE MODEL `YOUR_PROJECT_ID.air_quality_dataset.air_quality_model_fe`
OPTIONS(model_type='LINEAR_REG') AS
SELECT
    label,
    no2,
    is_rush_hour,
    is_weekend
FROM
    `YOUR_PROJECT_ID.air_quality_dataset.engineered_training_data`
