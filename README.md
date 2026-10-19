# U.S. Electric Vehicle Market Analysis

## Project Overview

This project analyzes U.S. vehicle registration data to evaluate electric vehicle (EV) adoption across states and jurisdictions and identify large vehicle markets that may warrant further investigation for EV market expansion.

The analysis combines **SQL, MySQL, DAX, and Power BI** to transform raw vehicle registration data into business-focused metrics and interactive dashboards.

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

> **Project Status:** In Progress  
> Additional fuel composition analysis, dashboard development, documentation, and final recommendations are currently being completed.

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

## Business Questions

The analysis focuses on the following questions:

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
| **Git/GitHub** | Version control and project documentation |

---

## Data Preparation

The raw vehicle registration dataset contained duplicate jurisdiction records caused by inconsistent `Methanol` values, where one version of each record contained `NULL` and another contained `0`.

A layered data workflow was created to preserve the original data while producing a clean analytical dataset.

```text
Raw Vehicle Data
       ↓
vehicle_data_raw
       ↓
vehicle_data_clean
       ↓
state_vehicle_metrics
       ↓
Power BI Data Model
       ↓
DAX Measures
       ↓
Interactive Dashboard
```

### Cleaning Process

Key data preparation steps included:

- Preserving the original dataset in a raw table
- Investigating duplicate jurisdiction records
- Identifying `NULL` versus `0` inconsistencies in the Methanol field
- Standardizing missing Methanol values
- Removing duplicate jurisdiction records
- Validating one record per jurisdiction
- Creating a reusable analytical SQL view
- Creating standardized aliases for fuel-count variables
- Calculating total registered vehicles for each jurisdiction

The resulting analytical dataset contains **51 jurisdictions**, representing the 50 U.S. states and the District of Columbia.

---

## Key Metrics

### National EV Adoption Rate

EV adoption is calculated as:

```text
EV Adoption Rate = Electric Vehicle Registrations / Total Registered Vehicles
```

The analysis uses a **weighted national adoption rate**, rather than averaging individual jurisdiction adoption rates.

**National EV Adoption Rate: 1.24%**

This metric serves as the primary benchmark for comparing EV penetration across jurisdictions.

---

### EV Adoption Gap

The EV Adoption Gap measures how far each jurisdiction's EV adoption rate is above or below the national benchmark.

```text
EV Adoption Gap =
Jurisdiction EV Adoption Rate - National EV Adoption Rate
```

A negative value indicates that EV penetration is below the national benchmark.

---

### EV Representation Index

The EV Representation Index compares a jurisdiction's share of U.S. EV registrations with its share of the overall U.S. vehicle market.

```text
EV Representation Index =
Jurisdiction Share of U.S. EVs
/
Jurisdiction Share of U.S. Vehicles
```

Interpretation:

- **Above 1.00** → EVs are overrepresented relative to the jurisdiction's vehicle market size
- **1.00** → EV representation is proportional to vehicle market size
- **Below 1.00** → EVs are underrepresented relative to vehicle market size

This provides additional context beyond EV registration counts or adoption rates alone.

---

## Key Findings

### National EV Adoption

Fully electric vehicles represent approximately **1.24% of registered vehicles nationally** in the dataset.

EV adoption varies substantially across jurisdictions.

Among the highest EV adoption rates identified were:

- California — **3.41%**
- District of Columbia — **2.60%**
- Hawaii — **2.37%**
- Washington — **2.23%**
- Nevada — **1.85%**

This demonstrates that high EV penetration is not necessarily associated with the largest overall vehicle markets.

---

### EV Volume vs. EV Penetration

The jurisdictions with the largest vehicle markets are not identical to those with the largest EV populations.

For example:

- California leads both overall EV registrations and EV adoption among large markets.
- Florida has approximately **254,900 EV registrations** with an EV adoption rate of approximately **1.37%**.
- Texas has approximately **230,100 EV registrations** but a substantially larger overall vehicle market and an EV adoption rate of approximately **0.89%**.

This illustrates why EV registration volume should be evaluated alongside market size and penetration.

---

### Large Markets Below the National Benchmark

For this analysis, a **large vehicle market** is defined as a jurisdiction with at least **5 million registered vehicles**.

Using this threshold:

**15 large vehicle markets have EV adoption below the 1.24% national benchmark.**

These include markets such as:

- Texas
- New York
- Virginia
- Illinois
- Georgia
- North Carolina
- Pennsylvania
- Michigan
- Tennessee
- Ohio
- Missouri
- Wisconsin
- Indiana
- South Carolina
- Minnesota

Texas is the **largest vehicle market among the below-benchmark jurisdictions** identified by the analysis.

This does not by itself establish Texas—or any other jurisdiction—as the best market for EV expansion. Instead, the combination of large market size and below-benchmark EV penetration identifies these jurisdictions as candidates for further investigation.

---

### EV Representation Relative to Market Size

The EV Representation Index provides another way to evaluate market performance.

Examples include:

- California — approximately **2.75**
- Washington — approximately **1.80**
- New Jersey — approximately **1.49**
- Florida — approximately **1.11**
- New York — approximately **0.94**
- Texas — approximately **0.72**
- Ohio — approximately **0.39**

California therefore accounts for a substantially larger share of U.S. EV registrations than its share of the overall vehicle market would suggest.

Texas, despite its large vehicle market and EV population, has EV representation below its proportional share of the national vehicle market.

---

### Alternative Fuel Landscape

The analysis also examines fuel types beyond fully electric vehicles.

Among the alternative fuels evaluated:

| Fuel Type | National Share | Jurisdictions with ≥1% Local Share |
|---|---:|---:|
| E85 | 7.05% | 51 |
| Biodiesel | 0.98% | 27 |
| CNG | <0.01% | 0 |
| Hydrogen | <0.01% | 0 |
| Propane | <0.01% | 0 |
| Methanol | 0.00% | 0 |

E85 is the most prominent alternative fuel examined in the dataset and has the broadest geographic presence.

Biodiesel represents a smaller but still measurable portion of registrations, while CNG, hydrogen, propane, and methanol remain niche within this dataset.

---

## Power BI Dashboard

The Power BI report is being developed as a multi-page analytical dashboard.

### Page 1 — U.S. EV Market Overview

The executive overview provides a high-level view of the U.S. EV market, including:

- Total registered vehicles
- Total EV registrations
- National EV adoption rate
- Leading jurisdiction by EV adoption
- Geographic EV adoption patterns
- Top jurisdictions by EV adoption rate
- Top jurisdictions by EV registration volume

![U.S. EV Market Overview](U.S.%20Electric%20Vehicle%20Share/MarketOverview.png)

The overview is designed to distinguish between **market size, EV volume, and EV penetration**, allowing stakeholders to quickly understand the national EV landscape.

---

### Page 2 — EV Market Opportunity

The second dashboard page focuses on identifying large markets that warrant further analysis.

Current components include:

- National EV adoption benchmark
- Count of large markets below the national benchmark
- Largest below-benchmark vehicle market
- Market Size vs. EV Adoption scatter plot
- EV Adoption Gap analysis
- EV Representation Index

The market opportunity analysis uses multiple indicators rather than relying on a single ranking or score.

This helps distinguish between:

- Large markets with high EV penetration
- Large markets with low EV penetration
- Smaller markets with high EV penetration
- Smaller markets with low EV penetration

---

### Page 3 — Fuel Transition & Market Composition

**Status: In Development**

This page will examine the broader vehicle fuel landscape, including:

- Gasoline dependence
- Hybrid Electric Vehicle (HEV) registrations
- Plug-In Hybrid Electric Vehicle (PHEV) registrations
- HEV/PHEV participation relative to EV adoption
- Alternative-fuel market share
- Geographic reach of alternative fuels

The purpose of this analysis is to provide additional market context rather than assume that hybrid or alternative-fuel adoption directly causes future EV adoption.

---

## Analytical Approach

A major focus of this project is separating several metrics that can easily be confused.

### Count vs. Rate vs. Share

**Count** answers:

> How many EVs are registered?

**Adoption Rate** answers:

> What percentage of a jurisdiction's vehicle market is electric?

**National EV Share** answers:

> What percentage of all U.S. EV registrations comes from this jurisdiction?

**Representation Index** answers:

> Is the jurisdiction contributing more or fewer EV registrations than expected based on its overall vehicle market size?

Using these metrics together provides a more complete picture than relying on EV registration counts alone.

---

## Business Interpretation

The analysis indicates that stronger candidates for further EV market investigation are characterized by a combination of:

- Large overall vehicle market size
- EV penetration below the national benchmark
- EV underrepresentation relative to overall market size
- Large conventional gasoline vehicle populations
- Potential participation in hybrid and plug-in hybrid vehicle segments

No single metric is treated as sufficient evidence for an expansion decision.

Instead, the dashboard uses multiple indicators to identify jurisdictions where additional market research may be valuable.

---

## Limitations

The dataset represents a **snapshot of vehicle registrations** and does not contain a visible historical date or year field.

As a result, this project does **not** make claims regarding:

- EV market growth rates
- Increasing or declining EV adoption
- Year-over-year market momentum
- Future EV demand
- Causal relationships between fuel types and EV adoption

Additional variables would be required before making investment or infrastructure recommendations, including:

- EV charging station and charging-port availability
- Population and household demographics
- Income
- Urbanization
- Electricity prices
- Gasoline prices
- Vehicle purchase incentives
- Historical EV registration data

These variables would allow future analysis to investigate why EV adoption differs between markets and whether identified market gaps represent actionable opportunities.

---

## Preliminary Business Takeaway

The analysis shows that **vehicle market size and EV adoption should be evaluated together** when examining EV market opportunities.

Large markets such as Texas can contribute substantial EV registration volume while still exhibiting EV penetration below the national benchmark. Conversely, some smaller jurisdictions demonstrate relatively high EV adoption but contribute a smaller portion of total national EV registrations.

The current findings therefore support using **market size, adoption gap, EV representation, and fuel composition together as screening indicators** for deeper market analysis rather than using a single metric to determine expansion priorities.

---

## Future Development

Planned next steps include:

- Complete the Fuel Transition & Market Composition dashboard
- Analyze gasoline dependence relative to EV adoption
- Compare HEV/PHEV participation with EV penetration
- Expand alternative-fuel analysis
- Finalize dashboard interactions and visual formatting
- Add dashboard screenshots
- Document final business insights and recommendations
- Investigate additional external datasets for charging infrastructure and demographic analysis

---

## Skills Demonstrated

- SQL
- MySQL
- DBeaver
- Data Cleaning
- Data Validation
- Common Table Expressions (CTEs)
- SQL Views
- Conditional Aggregation
- Business Intelligence
- Power BI
- DAX
- Filter Context
- KPI Development
- Data Visualization
- Market Segmentation
- Exploratory Data Analysis
- Data Storytelling
- Business Analysis
- Git/GitHub

---

## Repository Structure

```text
U.S.-EV-Market-Share/
│
├── EV market share/
│   ├── U.S. Electric Vehicle Share/
│   │   ├── MarketOverview.png
│   │   └── ...
│   ├── Vehicle Data.csv
│   ├── dashboard.pbix
│   ├── ev analysis.sql
│   └── ...
│
└── README.md
```

> Repository organization will continue to be refined as the project is completed.

---

## Conclusion

This project demonstrates an end-to-end analytical workflow that moves beyond simply visualizing EV registration counts.

Raw vehicle registration data was cleaned and transformed in MySQL, validated through SQL analysis, modeled in Power BI, and extended using DAX to create dynamic benchmarks and market-level KPIs.

The analysis currently identifies substantial differences in EV penetration and representation across U.S. jurisdictions. In particular, several large vehicle markets remain below the national EV adoption benchmark, providing a useful starting point for deeper market investigation.

The next phase of the project expands the analysis into gasoline dependence, hybrid participation, and alternative-fuel composition before developing final business recommendations.