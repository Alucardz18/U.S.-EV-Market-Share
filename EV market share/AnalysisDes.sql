USE evmarketshare;

SELECT DATABASE();

SHOW full TABLES;

-- check null values
SELECT
    SUM(CASE WHEN `Electric (EV)` IS NULL THEN 1 ELSE 0 END) AS ev_nulls,
    SUM(CASE WHEN `Plug-In Hybrid Electric (PHEV)` IS NULL THEN 1 ELSE 0 END) AS phev_nulls,
    SUM(CASE WHEN `Hybrid Electric (HEV)` IS NULL THEN 1 ELSE 0 END) AS hev_nulls,
    SUM(CASE WHEN Biodiesel IS NULL THEN 1 ELSE 0 END) AS biodiesel_nulls,
    SUM(CASE WHEN `Ethanol/Flex (E85)` IS NULL THEN 1 ELSE 0 END) AS e85_nulls,
    SUM(CASE WHEN `Compressed Natural Gas (CNG)` IS NULL THEN 1 ELSE 0 END) AS cng_nulls,
    SUM(CASE WHEN Propane IS NULL THEN 1 ELSE 0 END) AS propane_nulls,
    SUM(CASE WHEN Hydrogen IS NULL THEN 1 ELSE 0 END) AS hydrogen_nulls,
    SUM(CASE WHEN Gasoline IS NULL THEN 1 ELSE 0 END) AS gasoline_nulls,
    SUM(CASE WHEN Diesel IS NULL THEN 1 ELSE 0 END) AS diesel_nulls,
    SUM(CASE WHEN `Unknown Fuel` IS NULL THEN 1 ELSE 0 END) AS unknown_fuel_nulls,
    SUM(CASE WHEN Methanol IS NULL THEN 1 ELSE 0 END) AS methanol_nulls
FROM vehicle_data_clean;

-- check impossible negative values
SELECT *
FROM vehicle_data_clean
WHERE
    `Electric (EV)` < 0
    OR `Plug-In Hybrid Electric (PHEV)` < 0
    OR `Hybrid Electric (HEV)` < 0
    OR Biodiesel < 0
    OR `Ethanol/Flex (E85)` < 0
    OR `Compressed Natural Gas (CNG)` < 0
    OR Propane < 0
    OR Hydrogen < 0
    OR Gasoline < 0
    OR Diesel < 0
    OR `Unknown Fuel` < 0
    OR Methanol < 0;

-- what are the ranges
SELECT
    MIN(`Electric (EV)`) AS min_ev,
    MAX(`Electric (EV)`) AS max_ev,
    MIN(Gasoline) AS min_gasoline,
    MAX(Gasoline) AS max_gasoline,
    MIN(Diesel) AS min_diesel,
    MAX(Diesel) AS max_diesel
FROM vehicle_data_clean;

-- create view for better analysis
CREATE OR REPLACE VIEW state_vehicle_metrics AS
SELECT
    State,
    `Electric (EV)` AS ev_count,
    `Plug-In Hybrid Electric (PHEV)` AS phev_count,
    `Hybrid Electric (HEV)` AS hev_count,
    Biodiesel AS biodiesel_count,
    `Ethanol/Flex (E85)` AS e85_count,
    `Compressed Natural Gas (CNG)` AS cng_count,
    Propane AS propane_count,
    Hydrogen AS hydrogen_count,
    Gasoline AS gasoline_count,
    Diesel AS diesel_count,
    `Unknown Fuel` AS unknown_fuel_count,
    Methanol AS methanol_count,
    (`Electric (EV)`
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
    + Methanol) AS total_vehicles
FROM vehicle_data_clean;

-- #1 What is the national EV adoption rate?
select  round((SUM(ev_count) / sum(total_vehicles)) * 100.0, 2 ) as ev_adoption_rate
from state_vehicle_metrics
;

-- #2 
-- a)Which jurisdictions have the highest EV adoption rates?
select state, ev_count as EV_num, total_vehicles as MarketSize, round((ev_count / total_vehicles) * 100.0, 2 ) as ev_adoption_rate
from state_vehicle_metrics
order by ev_adoption_rate desc
limit 5
;

-- b)Which jurisdictions have the lowest EV adoption rates?
select state, ev_count as EV_num, total_vehicles as MarketSize, round((ev_count / total_vehicles) * 100.0, 2 ) as ev_adoption_rate
from state_vehicle_metrics
order by ev_adoption_rate asc
limit 5
;

-- #3 a) Which jurisdictions have the largest overall vehicle markets ?
select state, total_vehicles as vehicleMarket, ev_count as evPop
from state_vehicle_metrics
order by vehiclemarket desc
limit 10
;

-- b) Which jurisdictions have the largest  EV populations?
select state, total_vehicles as vehicleMarket, ev_count as evPop
from state_vehicle_metrics
order by evpop desc
limit 10
;

-- why does Texas has more total vehicles than Florida?
select state, ev_count as EV_num, total_vehicles as MarketSize, round((ev_count / total_vehicles) * 100.0, 2 ) as ev_adoption_rate
from state_vehicle_metrics
where state in ("Florida", "Texas")
order by ev_adoption_rate desc
;

-- #4 Which large vehicle markets have EV adoption below the 1.24% national benchmark? 
-- (Lets say large vehicle market = states with 5 million or more registered vehicles.)
-- Which jurisdictions with at least 5 million registered vehicles have an EV adoption rate below the national benchmark of 1.24%?
with national_evRate as (
	select  (SUM(ev_count) / sum(total_vehicles)) * 100.0 as nation_bench
	from state_vehicle_metrics
)
select 
	State, total_vehicles as MarketSize, 
	round((ev_count / total_vehicles) * 100.0, 2 ) as ev_adoption_rate, 
	round(((ev_count / total_vehicles) * 100.0 - nation_bench ), 2 ) as adoption_gap
from 
	state_vehicle_metrics
cross join national_evRate
where 
	total_vehicles >= 5000000 
	and (ev_count / total_vehicles) * 100.0 < nation_bench 
order by ev_adoption_rate desc
;

-- #5 Which jurisdictions have high HEV/PHEV adoption but relatively low EV adoption?
-- High HEV/PHEV adoption rate
select (sum(phev_count) + sum(hev_count)) / sum(total_vehicles) * 100.0 as hevPevRate
from state_vehicle_metrics;

with national_benchmarks as (
	select (sum(phev_count) + sum(hev_count)) / sum(total_vehicles) * 100.0 as national_hev_phev_rate, 
		(SUM(ev_count) / sum(total_vehicles)) * 100.0 as national_ev_rate
	from state_vehicle_metrics
)	
select State, 
	round((ev_count / total_vehicles) * 100.0, 2) as state_ev_rate, 
	round(((phev_count + hev_count) / total_vehicles) * 100.0, 2) as state_hev_phev_rate, 
	round(national_hev_phev_rate, 2) national_hev_phev_rate , round(national_ev_rate , 2) as national_ev_rate
from state_vehicle_metrics
cross join national_benchmarks 
where ((phev_count + hev_count) / total_vehicles) * 100.0 > national_hev_phev_rate
	and (ev_count / total_vehicles) * 100.0 < national_ev_rate
order by state_hev_phev_rate desc  
;

-- #6 Which jurisdictions have large gasoline populations alongside low EV adoption?
with national_ev_benchmark as (
	select (sum(ev_count) / sum(total_vehicles)) * 100.0 as national_ev_rate
	from state_vehicle_metrics
)
select
	State,
	gasoline_count as `Gasoline_Count`,
	round((gasoline_count / total_vehicles) * 100.0, 2) as `Gasoline_Share`,
	round((ev_count / total_vehicles) * 100.0, 2) as `EV_Adoption_Rate`
from state_vehicle_metrics
cross join national_ev_benchmark
where (ev_count / total_vehicles) * 100.0 < national_ev_rate
order by gasoline_count desc
;

-- #7 Which alternative fuels are nationally meaningful, and are they geographically widespread?
with national_total as (
	select sum(total_vehicles) as total_registered_vehicles
	from state_vehicle_metrics
),
alternative_fuels as (
	select 1 as sort_order, 'E85' as Fuel, e85_count as fuel_count, total_vehicles
	from state_vehicle_metrics

	union all

	select 2 as sort_order, 'Biodiesel' as Fuel, biodiesel_count as fuel_count, total_vehicles
	from state_vehicle_metrics

	union all

	select 3 as sort_order, 'CNG' as Fuel, cng_count as fuel_count, total_vehicles
	from state_vehicle_metrics

	union all

	select 4 as sort_order, 'Propane' as Fuel, propane_count as fuel_count, total_vehicles
	from state_vehicle_metrics

	union all

	select 5 as sort_order, 'Hydrogen' as Fuel, hydrogen_count as fuel_count, total_vehicles
	from state_vehicle_metrics

	union all

	select 6 as sort_order, 'Methanol' as Fuel, methanol_count as fuel_count, total_vehicles
	from state_vehicle_metrics
),
fuel_summary as (
	select
		sort_order,
		Fuel,
		sum(fuel_count) as national_count,
		round((sum(fuel_count) / max(total_registered_vehicles)) * 100.0, 4) as national_share,
		sum(case when (fuel_count / total_vehicles) * 100.0 >= 1 then 1 else 0 end) as jurisdictions_at_least_1pct
	from alternative_fuels
	cross join national_total
	group by sort_order, Fuel
)
select
	Fuel,
	national_count as `National_Count`,
	national_share as `National_Share`,
	jurisdictions_at_least_1pct as `Jurisdictions >= 1%`
from fuel_summary
order by sort_order
;

-- #8 Which jurisdictions account for the largest share of U.S. EV registrations?
WITH national_ev_total AS (
    SELECT
        SUM(ev_count) as total_ev
    FROM state_vehicle_metrics
)
SELECT
    State,
    ev_count,
    round((ev_count / total_ev) * 100.0, 2) as ev_national_share
FROM state_vehicle_metrics
CROSS JOIN national_ev_total
ORDER BY ev_national_share desc 
;

-- #9 Which jurisdictions have disproportionately high or low EV representation relative to their overall vehicle market?
with national_totals as (
	select
		sum(ev_count) as total_us_evs,
		sum(total_vehicles) as total_us_vehicles
	from state_vehicle_metrics
),
state_representation as (
	select
		State,
		ev_count,
		total_vehicles,
		(ev_count / total_us_evs) * 100.0 as state_share_of_us_evs,
		(total_vehicles / total_us_vehicles) * 100.0 as state_share_of_us_total_vehicles
	from state_vehicle_metrics
	cross join national_totals
)
select
	State,
	ev_count as `EV_Count`,
	total_vehicles as `Total_Vehicles`,
	round(state_share_of_us_evs, 2) as `State_Share_of_US_EVs`,
	round(state_share_of_us_total_vehicles, 2) as `State_Share_of_US_Total_Vehicles`,
	round(state_share_of_us_evs / state_share_of_us_total_vehicles, 2) as `EV_Representation_Index`
from state_representation
order by `EV_Representation_Index` desc
;


