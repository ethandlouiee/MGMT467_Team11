/* 
   Side-by-side comparison of Base Model vs FE Model 
   using the same dataset (engineered_training_data).
*/
SELECT
    'Base Model' as model_version,
    r2_score,
    mean_absolute_error,
    mean_squared_error
FROM
    ML.EVALUATE(MODEL `YOUR_PROJECT_ID.air_quality_dataset.air_quality_model_v2`,
    (SELECT (CO_GT_ * 1000) as label, NO2_GT_ as no2 FROM `YOUR_PROJECT_ID.air_quality_dataset.sensor_data` WHERE CO_GT_ > -200 AND NO2_GT_ > -200))

UNION ALL

SELECT
    'Feature Engineered Model' as model_version,
    r2_score,
    mean_absolute_error,
    mean_squared_error
FROM
    ML.EVALUATE(MODEL `YOUR_PROJECT_ID.air_quality_dataset.air_quality_model_fe`,
    (SELECT label, no2, is_rush_hour, is_weekend FROM `YOUR_PROJECT_ID.air_quality_dataset.engineered_training_data`))
ORDER BY r2_score DESC
