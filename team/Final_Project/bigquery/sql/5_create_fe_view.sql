/* 
   Creates a view with Feature Engineering.
   1. Parses "Rush Hour" from the 'Time' column.
   2. Parses "Weekend" from the 'Date' column.
*/
CREATE OR REPLACE VIEW `YOUR_PROJECT_ID.air_quality_dataset.engineered_training_data` AS
SELECT
    -- TARGET
    (CO_GT_ * 1000) as label,

    -- ORIGINAL FEATURES
    NO2_GT_ as no2,

    -- NEW ENGINEERED FEATURE 1: Rush Hour (07-09 and 17-19)
    -- Parses string format HH.MM.SS
    CASE
        WHEN EXTRACT(HOUR FROM PARSE_TIME('%H.%M.%S', Time)) BETWEEN 7 AND 9 THEN 1
        WHEN EXTRACT(HOUR FROM PARSE_TIME('%H.%M.%S', Time)) BETWEEN 17 AND 19 THEN 1
        ELSE 0
    END as is_rush_hour,

    -- NEW ENGINEERED FEATURE 2: Weekend (1=Sun, 7=Sat)
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM Date) IN (1, 7) THEN 1
        ELSE 0
    END as is_weekend

FROM
    `YOUR_PROJECT_ID.air_quality_dataset.sensor_data`
WHERE
    CO_GT_ > -200
    AND NO2_GT_ > -200
