# U.S. Electric Vehicle Market Analysis

## Project Overview

This project analyzes U.S. vehicle registration data to evaluate electric vehicle (EV) adoption across states and jurisdictions and identify large vehicle markets that may warrant further investigation for EV market expansion.

The analysis combines **SQL, MySQL, DAX, and Power BI** to transform raw vehicle registration data into business-focused metrics and an interactive three-page dashboard.

Rather than evaluating EV registrations by volume alone, the project considers multiple dimensions of market performance, including:

- EV adoption rate
- Total vehicle market size
- EV registration volume
- Performance relative to the national EV adoption benchmark
- EV representation relative to overall vehicle market share
- Gasoline and alternative-fuel composition
- Hybrid and plug-in hybrid participation

The project follows a business-oriented analytical workflow:

**Business Problem → KPI → Comparison → Market Segmentation → Opportunity → Recommendation**

---

## Executive Summary

- Fully electric vehicles make up **1.24%** of the **287.1 million** light-duty vehicles registered in the U.S. in 2023 (3.56 million EVs).
- EVs are highly concentrated. **California holds 35.3% of all U.S. EVs** with only 12.8% of vehicles, and the top 5 states hold 57% of EVs.
- Of the 23 jurisdictions with at least 5 million vehicles, **15 are below the national EV adoption rate**. Together they would need about **645,000 more EVs** just to match the national rate.
- **Texas** is the largest of these markets (25.8M vehicles, 0.89% EV) and has the largest absolute gap, about 89,000 EVs below the national rate.
- **E85 flex-fuel vehicles (7.05%)** are by far the largest alternative-fuel group and reach at least 1% of vehicles in all 51 jurisdictions. CNG, hydrogen, propane, and methanol are each under 0.01% nationally.

---

## Business Problem

Electric vehicle registrations are not distributed evenly across the United States. Some jurisdictions have relatively high EV penetration, while others have large vehicle markets but comparatively low EV adoption.

Looking only at EV registration counts can be misleading because large states naturally tend to have more vehicles. Similarly, looking only at EV adoption rates can overlook the business importance of overall market size.

This project therefore investigates the following stakeholder question:

> **Which U.S. jurisdictions present stronger opportunities for further EV market investigation based on vehicle market size, EV adoption, and fuel composition?**

The analysis is designed for stakeholders such as:

- Transportation planners
- EV market strategists
- Infrastructure analysts
- Automotive market analysts
- Business intelligence teams

---

## Data Source

**U.S. Department of Energy, Alternative Fuels Data Center (AFDC): Vehicle Registration Counts by State, 2023.**
AFDC publishes these counts using data from Experian, rounded to the nearest 100.

The totals in this project match the AFDC 2023 figures (for example, 3,555,900 EVs nationally and 1,256,600 in California).

- **Scope:** light-duty vehicles only. "Total registered vehicles" in this project means light-duty vehicles, not all vehicles.
- **Coverage:** 51 jurisdictions (50 states and the District of Columbia).
- **Fuel types:** EV, PHEV, HEV, gasoline, diesel, E85, biodiesel, CNG, propane, hydrogen, methanol, and unknown fuel.

---

## Business Questions

1. What is the national EV adoption rate?
2. Which jurisdictions have the highest and lowest EV adoption rates?
3. Which jurisdictions have the largest overall vehicle markets and EV populations?
4. Which large vehicle markets have EV adoption below the national benchmark?
5. Which jurisdictions have relatively high HEV/PHEV participation but lower EV adoption?
6. Which markets combine large gasoline populations with relatively low EV penetration?
7. How significant are alternative fuels such as E85, biodiesel, CNG, propane, hydrogen, and methanol?
8. Which jurisdictions account for the largest share of U.S. EV registrations?
9. Which jurisdictions have disproportionately high or low EV representation relative to their overall vehicle market size?
10. What market characteristics can be used to identify jurisdictions that warrant deeper EV expansion analysis?

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL** | Data cleaning, transformation, aggregation, and exploratory analysis |
| **DBeaver** | SQL development and database management |
| **Power BI** | Data modeling, DAX calculations, dashboard development, and visualization |
| **DAX** | Dynamic KPIs, benchmarks, market segmentation, and comparative metrics |
| **Power Query** | Unpivoting alternative-fuel columns into a long table |
| **Git/GitHub** | Version control and project documentation |

---

## Data Preparation

The raw import contained **102 rows for 51 jurisdictions**: every jurisdiction appeared twice, once with `Methanol` as `NULL` and once with `0`.

A layered workflow preserves the original data while producing a clean analytical dataset.

```text
Vehicle Data.csv
       ↓
vehicle_data_raw          (original import, untouched)
       ↓
vehicle_data_clean        (DataCleaning.sql)
       ↓
state_vehicle_metrics     (view in AnalysisDes.sql)
       ↓
Power BI data model and DAX measures
       ↓
Interactive dashboard
```

### Cleaning Process

`DataCleaning.sql`:

- Counts rows and distinct jurisdictions in the raw import
- Lists the duplicated jurisdictions
- Compares `NULL` and `0` Methanol values
- Builds `vehicle_data_clean` with `COALESCE(Methanol, 0)` and `SELECT DISTINCT`, which collapses each duplicate pair into one row
- Confirms **51 rows and 51 distinct jurisdictions**

`AnalysisDes.sql` then:

- Checks for nulls and negative values
- Creates the `state_vehicle_metrics` view with clean aliases and `total_vehicles`
- Answers the business questions with CTEs, cross joins to national benchmarks, and conditional aggregation

---

## Key Metrics

| Metric | Definition |
|---|---|
| **EV Adoption Rate** | Battery-electric registrations ÷ total registered vehicles. EVs only; hybrids are not included. |
| **National EV Adoption Rate** | Total U.S. EVs ÷ total U.S. vehicles. A weighted rate, not an average of state rates. **1.24%** |
| **EV Adoption Gap** | Jurisdiction EV rate minus the national rate. Negative means below the benchmark. |
| **EV Representation Index** | Share of U.S. EVs ÷ share of U.S. vehicles (equal to state rate ÷ national rate). Above 1.00 means over-represented. |
| **HEV/PHEV Rate** | (Hybrid + plug-in hybrid registrations) ÷ total vehicles. National rate **3.03%** |
| **Large Market** | At least 5,000,000 registered vehicles. This is an analyst-chosen threshold, not an industry standard. |
| **EV Gap to National Rate** | EVs a market would need to add to reach the national rate: (national rate × vehicles) − current EVs. |

### Count vs. Rate vs. Share

- **Count:** how many EVs are registered?
- **Adoption Rate:** what percentage of a jurisdiction's vehicles are electric?
- **National EV Share:** what percentage of all U.S. EVs come from this jurisdiction?
- **Representation Index:** does the jurisdiction have more or fewer EVs than its market size would predict?

Using these together gives a more complete picture than EV counts alone.

---

## Key Findings

### National EV Adoption

Fully electric vehicles represent **1.24%** of registered light-duty vehicles nationally.

| Highest EV adoption | Rate | | Lowest EV adoption | Rate |
|---|---:|---|---|---:|
| California | 3.41% | | North Dakota | 0.13% |
| District of Columbia | 2.60% | | Mississippi | 0.13% |
| Hawaii | 2.37% | | Wyoming | 0.17% |
| Washington | 2.23% | | | |
| Nevada | 1.85% | | | |

High adoption does not always mean a big EV market. D.C. ranks second in adoption but has only 8,100 EVs.

### EV Volume vs. EV Penetration

- California leads both EV registrations (1.26M) and EV adoption.
- Florida has **254,900 EVs** at a **1.37%** adoption rate.
- Texas has **230,100 EVs** but a much larger vehicle market (25.8M vs. 18.6M) and a lower adoption rate (**0.89%**).

Texas holds 9.0% of U.S. vehicles but only 6.5% of U.S. EVs.

### Large Markets Below the National Benchmark

Of the **23** jurisdictions with at least 5 million vehicles, **15 have EV adoption below 1.24%**. Texas is the largest of them.

| Market | Vehicles | EV rate | Gap | Rep. index | EV gap to national rate |
|---|---:|---:|---:|---:|---:|
| Texas | 25.8M | 0.89% | -0.35 pts | 0.72 | ~89,400 |
| Ohio | 10.3M | 0.49% | -0.75 pts | 0.39 | ~77,400 |
| Pennsylvania | 10.2M | 0.69% | -0.55 pts | 0.56 | ~56,300 |
| Michigan | 8.5M | 0.59% | -0.65 pts | 0.48 | ~55,300 |
| Indiana | 6.2M | 0.42% | -0.82 pts | 0.34 | ~50,300 |
| Tennessee | 6.5M | 0.51% | -0.73 pts | 0.41 | ~47,800 |
| Wisconsin | 5.5M | 0.45% | -0.79 pts | 0.36 | ~43,600 |
| Missouri | 5.6M | 0.48% | -0.76 pts | 0.39 | ~42,800 |
| North Carolina | 9.1M | 0.77% | -0.47 pts | 0.62 | ~42,300 |
| South Carolina | 5.0M | 0.41% | -0.82 pts | 0.33 | ~41,600 |
| Georgia | 9.6M | 0.96% | -0.28 pts | 0.77 | ~27,000 |
| Minnesota | 5.1M | 0.72% | -0.51 pts | 0.59 | ~26,300 |
| Illinois | 10.0M | 0.99% | -0.25 pts | 0.80 | ~24,800 |
| Virginia | 7.7M | 1.10% | -0.14 pts | 0.89 | ~10,800 |
| New York | 11.3M | 1.16% | -0.08 pts | 0.94 | ~8,900 |

Being on this list does not make a market the best investment. It means the combination of a large market and below-benchmark EV adoption makes it a candidate for further investigation.

### EV Representation Relative to Market Size

| Jurisdiction | Representation Index |
|---|---:|
| California | 2.75 |
| Washington | 1.80 |
| New Jersey | 1.49 |
| Florida | 1.11 |
| New York | 0.94 |
| Texas | 0.72 |
| Ohio | 0.39 |

California has 2.75 times the EVs its market size would predict. Texas and Ohio have fewer EVs than their share of the vehicle market would suggest.

### Gasoline Dependence

Gasoline vehicles make up **84.6%** of registered vehicles nationally.

California has the largest gasoline fleet overall (about 31.2M). Among jurisdictions **below the national EV benchmark**, Texas has the largest gasoline fleet (about 21.4M). The two rankings differ only because of that filter.

Across jurisdictions, gasoline share has only a weak relationship with EV adoption (correlation of about 0.33), so on its own it does not separate high-EV from low-EV markets. It works as context, not as a predictor.

### Hybrid Participation

The national HEV/PHEV rate is **3.03%**. Seven jurisdictions have above-average hybrid participation but below-average EV adoption: New York, Maine, Virginia, Connecticut, Illinois, New Hampshire, and Rhode Island.

Across all jurisdictions, hybrid rates and EV rates rise together (correlation of about 0.88). This is an association only. The data cannot show that hybrid owners will switch to EVs.

### Alternative Fuel Landscape

| Fuel Type | National Share | Jurisdictions with ≥1% Local Share |
|---|---:|---:|
| E85 | 7.0501% | 51 |
| Biodiesel | 0.9765% | 27 |
| CNG | 0.0086% | 0 |
| Hydrogen | 0.0059% | 0 |
| Propane | 0.0021% | 0 |
| Methanol | 0.0000% | 0 |

E85 is the most common alternative fuel and the only one above 1% everywhere. Biodiesel is measurable but regional. CNG, hydrogen, and propane are present but niche. Zero jurisdictions at the 1% threshold does not mean a fuel is absent; for example, CNG is registered in 41 jurisdictions. Methanol has no recorded registrations in this dataset.

---

## Power BI Dashboard

The report has three pages. Each page answers a different question, and each page has its own State slicer.

### Page 1: U.S. EV Market Overview

*How big is the U.S. EV market, and where is adoption highest?*

![U.S. EV Market Overview](EV%20market%20share/U.S.%20Electric%20Vehicle%20Market%20Share/MarketOverview.png)

- KPIs: total vehicles, total EVs, national EV adoption rate, and the leading jurisdiction (California, 3.41%)
- Map of EV adoption by jurisdiction
- Top 5 jurisdictions by adoption rate and by EV count, side by side, to separate penetration from volume
- National EV % and Leading Market always show the national values; vehicle and EV totals follow the State slicer

### Page 2: EV Market Opportunity

*Which large markets have low EV penetration?*

![EV Market Opportunity](EV%20market%20share/U.S.%20Electric%20Vehicle%20Market%20Share/MarketOpportunity.png)

- KPIs: national benchmark (1.24%), large markets below benchmark (15), largest below-benchmark market (Texas). The benchmark always stays national; the other two cards narrow to the selected state when the State slicer is used.
- EV Adoption Gap for the 15 below-benchmark large markets
- EV Representation Index for all 23 large markets, with a 1.00 reference line
- Market size vs. EV adoption scatter plot, with bubble size for EV count and a dashed national benchmark line

### Page 3: Fuel Transition & Market Composition

*How do gasoline, hybrids, and alternative fuels fit in?*

![Fuel Transition & Market Composition](EV%20market%20share/U.S.%20Electric%20Vehicle%20Market%20Share/FuelTransition.png)

- Gasoline share vs. EV adoption, and HEV/PHEV rate vs. EV adoption, both with national benchmark lines
- National alternative-fuel shares, a separate niche-fuel chart on its own scale, and geographic reach (jurisdictions at 1% or more)
- With no state selected, every chart shows national values. The key insights text always describes the national results

### Data model

- `evmarketshare state_vehicle_metrics`: one row per jurisdiction, loaded from the MySQL view
- `Alternative_fuel_data`: six alternative-fuel columns unpivoted in Power Query (51 × 6 = 306 rows)
- Many-to-one relationship on `State`, single filter direction, so the State slicer filters both tables without double counting
- National benchmarks use `CALCULATE(..., REMOVEFILTERS(State))`, so they stay at the national value under any state selection

---

## Recommendations

1. **Investigate the largest absolute gaps first.** Texas, Ohio, Pennsylvania, Michigan, and Indiana have the largest EV gaps to the national rate (about 50,000 to 89,000 EVs each). They are large markets with low representation (index 0.34 to 0.72). Start here when gathering charging, price, and incentive data.
2. **Treat New York, Virginia, and Illinois as a separate group.** They are close to the benchmark (gap under 0.3 points) and have above-average hybrid participation. The question here is what keeps hybrid-friendly buyers from choosing EVs, not whether demand exists.
3. **Use California, Washington, and New Jersey as reference markets.** Their representation indexes (1.49 to 2.75) make them useful comparisons for what a high-adoption market looks like.
4. **Keep E85 and biodiesel separate from niche fuels** in any alternative-fuel planning. The niche fuels are too small in this data to support market conclusions.

### KPIs to track with future data

- EV adoption rate by jurisdiction, year over year
- EV gap to national rate for the 15 below-benchmark markets
- EV Representation Index for the shortlisted markets
- HEV/PHEV rate alongside EV rate in the hybrid-heavy group
- Public charging ports per 1,000 EVs (requires charging data)

---

## Limitations

- **One year only.** The data is a 2023 snapshot, so the project makes no claims about growth, trends, or future demand.
- **Light-duty vehicles only.** Medium and heavy-duty vehicles are not included.
- **Rounded counts.** AFDC rounds to the nearest 100, which matters for very small categories such as hydrogen.
- **Thresholds are choices.** The 5M large-market cutoff and the 1% geographic-reach cutoff are analyst-defined. Moving them changes which jurisdictions qualify (for example, Alabama has 4.8M vehicles).
- **No causal claims.** Relationships between gasoline share, hybrid share, and EV adoption are associations only.
- **Missing context.** A real expansion decision would also need charging infrastructure, population and income, urbanization, electricity and gasoline prices, incentives, and multi-year registration history.

---

## How to Reproduce

1. Create a MySQL database named `evmarketshare`.
2. Import `EV market share/Vehicle Data.csv` into a table named `vehicle_data_raw` (DBeaver CSV import).
3. Run `EV market share/DataCleaning.sql` to build `vehicle_data_clean`.
4. Run `EV market share/AnalysisDes.sql` to create the `state_vehicle_metrics` view and answer the business questions.
5. Open `EV market share/dashboard.pbix` in Power BI Desktop. It connects to MySQL at `localhost:3306`, so click Refresh after steps 1 to 4.

---

## Repository Structure

```text
U.S.-EV-Market-Share/
├── EV market share/
│   ├── U.S. Electric Vehicle Market Share/
│   │   ├── MarketOverview.png            dashboard page 1
│   │   ├── MarketOpportunity.png         dashboard page 2
│   │   ├── FuelTransition.png            dashboard page 3
│   │   ├── ev_adoption_by_state.csv      exported query results
│   │   ├── state_fuel_market_share.csv   exported query results
│   │   └── alt_fuel_meaningful_vs_niche.csv
│   ├── Vehicle Data.csv                  source data (AFDC 2023)
│   ├── DataCleaning.sql                  raw to clean table
│   ├── AnalysisDes.sql                   metrics view and business questions
│   └── dashboard.pbix                    Power BI report
├── VALIDATION.md                         SQL vs. Power BI checks
└── README.md
```

---

## Skills Demonstrated

SQL · MySQL · DBeaver · Data Cleaning · Data Validation · CTEs · SQL Views · Conditional Aggregation · Power BI · DAX · Filter Context · Power Query · KPI Development · Data Visualization · Market Segmentation · Data Storytelling · Git/GitHub

---

## Conclusion

Raw vehicle registration data was cleaned and transformed in MySQL, validated through SQL analysis, modeled in Power BI, and extended with DAX to create fixed national benchmarks and market-level KPIs.

The analysis shows that market size and EV adoption have to be read together. Fifteen large markets sit below the national EV rate, led in scale by Texas. Ohio, Pennsylvania, Michigan, and Indiana show the lowest representation among the largest gaps. These markets are the clearest starting points for deeper investigation, once infrastructure, demographic, and multi-year data are added.
