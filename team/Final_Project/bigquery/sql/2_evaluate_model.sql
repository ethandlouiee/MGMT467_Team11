/*
  Step 2: Evaluate Model Performance
  Returns metrics: r2_score, mean_absolute_error, mean_squared_error
*/

SELECT *
FROM ML.EVALUATE(MODEL `{{PROJECT_ID}}.air_quality_dataset.air_quality_model_v2`, (
    SELECT
        (CO_GT_ * 1000) as label,
        NO2_GT_ as no2
    FROM
        `{{PROJECT_ID}}.air_quality_dataset.sensor_data`
    WHERE
        CO_GT_ > -200 AND NO2_GT_ > -200
));
