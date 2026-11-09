# Validation: SQL vs. Power BI

Every key number was recalculated independently from `Vehicle Data.csv`, then compared with the SQL query results and the Power BI dashboard (checked in Power BI Desktop, November 2026).

## Data quality

| Check | Expected | Actual | Status |
|---|---|---|---|
| Rows in clean data | 51 | 51 | Pass |
| Distinct jurisdictions | 51 | 51 | Pass |
| Null values in clean data | 0 | 0 | Pass |
| Negative counts | 0 | 0 | Pass |
| Cleaning script on a 102-row duplicated import | 51 rows, 51 jurisdictions | 51 rows, 51 jurisdictions | Pass |
| Source totals match AFDC 2023 | 3,555,900 EVs | 3,555,900 EVs | Pass |

## National metrics

| Metric | Expected | Recalculated | Power BI | Status |
|---|---:|---:|---:|---|
| Total registered vehicles | ~287.10M | 287,096,500 | 287.10M | Pass |
| Total EVs | ~3.56M | 3,555,900 | 3.56M | Pass |
| National EV adoption rate | 1.24% | 1.2386% | 1.24% | Pass |
| National HEV/PHEV rate | 3.03% | 3.0302% | 3.03% | Pass |
| Leading EV market | California, 3.41% | California, 3.41% | California, 3.41% | Pass |

## Rankings and segmentation

| Check | Expected | Actual | Status |
|---|---|---|---|
| Top 5 EV adoption | CA 3.41, DC 2.60, HI 2.37, WA 2.23, NV 1.85 | Same | Pass |
| Top 5 EV count | CA, FL, TX, WA, NJ | Same | Pass |
| Jurisdictions with 5M+ vehicles | n/a | 23 | Info |
| Large markets below benchmark | 15 | 15 | Pass |
| Largest below-benchmark market | Texas | Texas (25.8M) | Pass |
| Largest adoption gap | n/a | Indiana and South Carolina, -0.82 pts | Info |

## EV Representation Index

| Jurisdiction | Expected | Actual | Status |
|---|---:|---:|---|
| California | 2.75 | 2.75 | Pass |
| Washington | 1.80 | 1.80 | Pass |
| New Jersey | 1.49 | 1.49 | Pass |
| Florida | 1.11 | 1.11 | Pass |
| New York | 0.94 | 0.94 | Pass |
| Texas | 0.72 | 0.72 | Pass |
| Ohio | 0.39 | 0.39 | Pass |

## Gasoline

| Check | Expected | Actual | Status |
|---|---|---|---|
| Largest gasoline fleet, all jurisdictions | California, ~31M | California, 31,191,900 | Pass |
| Largest gasoline fleet, below EV benchmark | Texas, ~21.39M | Texas, 21,392,800 | Pass |
| National gasoline share | n/a | 84.60% | Info |

## Alternative fuels

| Fuel | Expected share | Actual share | Expected reach | Actual reach | Status |
|---|---:|---:|---:|---:|---|
| E85 | 7.0501% | 7.0501% | 51 | 51 | Pass |
| Biodiesel | 0.9765% | 0.9765% | 27 | 27 | Pass |
| CNG | 0.0086% | 0.0086% | 0 | 0 | Pass |
| Hydrogen | 0.0059% | 0.0059% | 0 | 0 | Pass |
| Propane | 0.0021% | 0.0021% | 0 | 0 | Pass |
| Methanol | 0.0000% | 0.0000% | 0 | 0 | Pass |
| Unpivoted table rows | 306 | 51 jurisdictions × 6 fuel types | | | Pass |

## Dashboard behavior

| Check | Result | Status |
|---|---|---|
| National EV rate stays 1.24% when a state is selected | Uses `REMOVEFILTERS(State)` | Pass |
| Leading Market stays California, 3.41% when a state is selected | Uses `ALL(State)` | Pass |
| Relationship between tables | Many-to-one on State, single direction, no double counting | Pass |
| Page 2 KPI cards with a state selected | Count and largest market narrow to the selected state (for example, California shows 0) | Note |
| Page 3 alternative-fuel charts with a state selected | Charts narrow to the selected state | Note |
| Geographic Reach for fuels below 1% | Shown as empty bars rather than 0 | Note |

The notes above describe how the current report behaves. With no state selected, every value on every page matches the national results in this file.

## Changes made during validation

| Area | Change | Why |
|---|---|---|
| SQL | Added `DataCleaning.sql` | The cleaning steps were described but not in the repo |
| README | Rewritten as one version with data source, findings, recommendations and limitations | The old file had two versions stacked and no source |
| Screenshots | Retaken for all three pages | Old screenshots were out of date; page 3 was missing |
