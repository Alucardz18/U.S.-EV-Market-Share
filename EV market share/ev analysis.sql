select *
from `vehicle_data`;

/* change column name 
-- alter table vehicle_data
-- change column ï»¿State State Varchar(20);
*/

-- check for duplicates
select State ,count(*)
from vehicle_data
GROUP BY 1
having count(*) > 1 ;

-- MARKET SHARE ANALYSIS
--  percentage of EVs, PHEVs, HEVs, and Gasoline vehicles for each state
WITH totals AS (
    SELECT
        State,
        `Electric (EV)`,
        `Plug-In Hybrid Electric (PHEV)`,
        `Hybrid Electric (HEV)`,
        Gasoline,
        (
            `Electric (EV)`
          + `Plug-In Hybrid Electric (PHEV)`
          + `Hybrid Electric (HEV)`
          + Gasoline
          + Diesel
          + Biodiesel
          + `Ethanol/Flex (E85)`
          + `Compressed Natural Gas (CNG)`
          + Propane
          + Hydrogen
          + `Unknown Fuel`
        ) AS total_vehicles
    FROM vehicle_data
)
SELECT
    State,
    ROUND(100.0 * `Electric (EV)` / total_vehicles, 2) AS EV_share_state,
    ROUND(100.0 * `Plug-In Hybrid Electric (PHEV)` / total_vehicles, 2) AS PHEV_share_state,
    ROUND(100.0 * `Hybrid Electric (HEV)` / total_vehicles, 2) AS HEV_share_state,
    ROUND(100.0 * Gasoline / total_vehicles, 2) AS Gasoline_share_state
FROM totals;

-- EV adoption rate
SELECT 
    State,
    `Electric (EV)`,
    ROUND(`Electric (EV)` / (`Electric (EV)` 
		+ `Plug-In Hybrid Electric (PHEV)` 
        + `Hybrid Electric (HEV)` 
        + Biodiesel + `Ethanol/Flex (E85)` 
        + `Compressed Natural Gas (CNG)` 
        + Propane + Hydrogen + Gasoline + Diesel + `Unknown Fuel`) * 100,
            2) AS EV_adoption_rate
FROM
    vehicle_data
ORDER BY EV_adoption_rate DESC;

-- EV adoption in California vs. other large states (large by land area)
SELECT 
    State,
    `Electric (EV)`,
    ROUND(`Electric (EV)` / (`Electric (EV)` 
		+ `Plug-In Hybrid Electric (PHEV)` 
        + `Hybrid Electric (HEV)` 
        + Biodiesel + `Ethanol/Flex (E85)` 
        + `Compressed Natural Gas (CNG)` 
        + Propane + Hydrogen + Gasoline + Diesel + `Unknown Fuel`) * 100,
            2) AS EV_adoption_rate
FROM
    vehicle_data
WHERE State IN ('California', 'Texas', 'Alaska', 'Montana', 'New Mexico', 'Arizona')
ORDER BY EV_adoption_rate DESC;

-- which alternative fuels are meaningful vs. niche
WITH total AS (
    SELECT
        State,
        Biodiesel,
        `Ethanol/Flex (E85)`,
        `Compressed Natural Gas (CNG)`,
        Propane,
        Hydrogen,
        (
            `Electric (EV)` +
            `Plug-In Hybrid Electric (PHEV)` +
            `Hybrid Electric (HEV)` +
            Biodiesel +
            `Ethanol/Flex (E85)` +
            `Compressed Natural Gas (CNG)` +
            Propane +
            Hydrogen +
            Gasoline +
            Diesel +
            `Unknown Fuel`
        ) AS total_vehicles
    FROM vehicle_data
),
shares AS (
    SELECT
        State,
        100.0 * Biodiesel / total_vehicles AS biodiesel_share,
        100.0 * `Ethanol/Flex (E85)` / total_vehicles AS e85_share,
        100.0 * `Compressed Natural Gas (CNG)` / total_vehicles AS cng_share,
        100.0 * Propane / total_vehicles AS propane_share,
        100.0 * Hydrogen / total_vehicles AS hydrogen_share
    FROM total
),
fuel_summary AS (
    SELECT
        'Biodiesel' AS fuel_type,
        AVG(biodiesel_share) AS avg_share,
        MAX(biodiesel_share) AS max_share,
        SUM(CASE WHEN biodiesel_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Ethanol/Flex (E85)' AS fuel_type,
        AVG(e85_share) AS avg_share,
        MAX(e85_share) AS max_share,
        SUM(CASE WHEN e85_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Compressed Natural Gas (CNG)' AS fuel_type,
        AVG(cng_share) AS avg_share,
        MAX(cng_share) AS max_share,
        SUM(CASE WHEN cng_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Propane' AS fuel_type,
        AVG(propane_share) AS avg_share,
        MAX(propane_share) AS max_share,
        SUM(CASE WHEN propane_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Hydrogen' AS fuel_type,
        AVG(hydrogen_share) AS avg_share,
        MAX(hydrogen_share) AS max_share,
        SUM(CASE WHEN hydrogen_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares
)
SELECT
    fuel_type,
    ROUND(avg_share, 4) AS avg_share_pct,
    ROUND(max_share, 4) AS max_share_pct,
    states_above_1pct,
    CASE 
        WHEN max_share >= 1 THEN 'Meaningful'
        ELSE 'Niche'
    END AS category
FROM fuel_summary
ORDER BY avg_share_pct DESC;


/* CREATING VIEWS FOR IMPORT */

-- View: State fuel market share (within-state %)
CREATE OR REPLACE VIEW state_fuel_market_share AS
WITH totals AS (
    SELECT
        State,
        `Electric (EV)`,
        `Plug-In Hybrid Electric (PHEV)`,
        `Hybrid Electric (HEV)`,
        Gasoline,
        Diesel,
        Biodiesel,
        `Ethanol/Flex (E85)`,
        `Compressed Natural Gas (CNG)`,
        Propane,
        Hydrogen,
        `Unknown Fuel`,
        (
            `Electric (EV)`
          + `Plug-In Hybrid Electric (PHEV)`
          + `Hybrid Electric (HEV)`
          + Gasoline
          + Diesel
          + Biodiesel
          + `Ethanol/Flex (E85)`
          + `Compressed Natural Gas (CNG)`
          + Propane
          + Hydrogen
          + `Unknown Fuel`
        ) AS total_vehicles
    FROM vehicle_data
)
SELECT
    State,
    total_vehicles,
    ROUND(100.0 * `Electric (EV)` / total_vehicles, 2) AS EV_share_state,
    ROUND(100.0 * `Plug-In Hybrid Electric (PHEV)` / total_vehicles, 2) AS PHEV_share_state,
    ROUND(100.0 * `Hybrid Electric (HEV)` / total_vehicles, 2) AS HEV_share_state,
    ROUND(100.0 * Gasoline / total_vehicles, 2) AS Gasoline_share_state
FROM totals;

-- View: EV adoption by state
CREATE OR REPLACE VIEW ev_adoption_by_state AS
SELECT 
    State,
    `Electric (EV)`,
    (
        `Electric (EV)` 
      + `Plug-In Hybrid Electric (PHEV)` 
      + `Hybrid Electric (HEV)` 
      + Biodiesel 
      + `Ethanol/Flex (E85)` 
      + `Compressed Natural Gas (CNG)` 
      + Propane 
      + Hydrogen 
      + Gasoline 
      + Diesel 
      + `Unknown Fuel`
    ) AS total_vehicles,
    ROUND(
        100.0 * `Electric (EV)` / (
            `Electric (EV)` 
          + `Plug-In Hybrid Electric (PHEV)` 
          + `Hybrid Electric (HEV)` 
          + Biodiesel 
          + `Ethanol/Flex (E85)` 
          + `Compressed Natural Gas (CNG)` 
          + Propane 
          + Hydrogen 
          + Gasoline 
          + Diesel 
          + `Unknown Fuel`
        ),
        2
    ) AS EV_adoption_rate
FROM vehicle_data;


-- View: Alternative fuels – meaningful vs niche
CREATE OR REPLACE VIEW alt_fuel_meaningful_vs_niche AS
WITH total AS (
    SELECT
        State,
        Biodiesel,
        `Ethanol/Flex (E85)`,
        `Compressed Natural Gas (CNG)`,
        Propane,
        Hydrogen,
        (
            `Electric (EV)` +
            `Plug-In Hybrid Electric (PHEV)` +
            `Hybrid Electric (HEV)` +
            Biodiesel +
            `Ethanol/Flex (E85)` +
            `Compressed Natural Gas (CNG)` +
            Propane +
            Hydrogen +
            Gasoline +
            Diesel +
            `Unknown Fuel`
        ) AS total_vehicles
    FROM vehicle_data
),
shares AS (
    SELECT
        State,
        100.0 * Biodiesel / total_vehicles AS biodiesel_share,
        100.0 * `Ethanol/Flex (E85)` / total_vehicles AS e85_share,
        100.0 * `Compressed Natural Gas (CNG)` / total_vehicles AS cng_share,
        100.0 * Propane / total_vehicles AS propane_share,
        100.0 * Hydrogen / total_vehicles AS hydrogen_share
    FROM total
),
fuel_summary AS (
    SELECT
        'Biodiesel' AS fuel_type,
        AVG(biodiesel_share) AS avg_share,
        MAX(biodiesel_share) AS max_share,
        SUM(CASE WHEN biodiesel_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Ethanol/Flex (E85)' AS fuel_type,
        AVG(e85_share) AS avg_share,
        MAX(e85_share) AS max_share,
        SUM(CASE WHEN e85_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Compressed Natural Gas (CNG)' AS fuel_type,
        AVG(cng_share) AS avg_share,
        MAX(cng_share) AS max_share,
        SUM(CASE WHEN cng_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Propane' AS fuel_type,
        AVG(propane_share) AS avg_share,
        MAX(propane_share) AS max_share,
        SUM(CASE WHEN propane_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares

    UNION ALL

    SELECT
        'Hydrogen' AS fuel_type,
        AVG(hydrogen_share) AS avg_share,
        MAX(hydrogen_share) AS max_share,
        SUM(CASE WHEN hydrogen_share >= 1 THEN 1 ELSE 0 END) AS states_above_1pct
    FROM shares
)
SELECT
    fuel_type,
    ROUND(avg_share, 4) AS avg_share_pct,
    ROUND(max_share, 4) AS max_share_pct,
    states_above_1pct,
    CASE 
        WHEN max_share >= 1 THEN 'Meaningful'
        ELSE 'Niche'
    END AS category
FROM fuel_summary;

