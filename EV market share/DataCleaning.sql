USE evmarketshare;

-- row count and distinct jurisdictions in the raw import
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT State) AS distinct_states
FROM vehicle_data_raw;

-- jurisdictions that appear more than once
SELECT State, COUNT(*) AS copies
FROM vehicle_data_raw
GROUP BY State
HAVING COUNT(*) > 1
ORDER BY State;

-- how Methanol differs between duplicate rows
SELECT
    SUM(CASE WHEN Methanol IS NULL THEN 1 ELSE 0 END) AS methanol_nulls,
    SUM(CASE WHEN Methanol = 0 THEN 1 ELSE 0 END) AS methanol_zeros
FROM vehicle_data_raw;

-- clean table: Methanol NULL set to 0, duplicate rows removed
CREATE TABLE vehicle_data_clean AS
SELECT DISTINCT
    State,
    `Electric (EV)`,
    `Plug-In Hybrid Electric (PHEV)`,
    `Hybrid Electric (HEV)`,
    Biodiesel,
    `Ethanol/Flex (E85)`,
    `Compressed Natural Gas (CNG)`,
    Propane,
    Hydrogen,
    COALESCE(Methanol, 0) AS Methanol,
    Gasoline,
    Diesel,
    `Unknown Fuel`
FROM vehicle_data_raw;

-- confirms one row per jurisdiction (expected 51 and 51)
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT State) AS distinct_states
FROM vehicle_data_clean;
