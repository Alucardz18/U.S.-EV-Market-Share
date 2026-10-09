# ⚡ U.S. Electric Vehicle Market Share Analysis
**Tools Used:** MySQL · Power BI · Excel

![U.S. EV Market Overview dashboard](EV%20market%20share/U.S.%20Electric%20Vehicle%20Market%20Share/MarketOverview.png)

## 📘 Overview
Electric vehicles get a lot of headlines, but how big is their share of the road in each state, and where is the gap between market size and EV adoption the widest?

This project analyzes registered vehicle counts by fuel type for all 50 states plus Washington, D.C. (**287.1 million vehicles** in total). Using MySQL, I built a reusable metrics view, set a national EV benchmark, and answered 10 business questions about EV penetration, market concentration, and where EV expansion deserves a closer look. The results feed a Power BI dashboard.

## 📈 Key Insights

| Metric | Value | Insight |
|---|---|---|
| **National EV adoption rate** | **1.24%** | About 1 in 80 registered vehicles is fully electric. Used as the benchmark for every state. |
| **Highest adoption** | **California, 3.41%** | 2.75x the national rate, while also being the largest vehicle market. |
| **Lowest adoption** | **North Dakota and Mississippi, 0.13%** | Roughly one tenth of the national rate. |
| **EV concentration** | **California holds 35.3% of all U.S. EVs** | With only 12.8% of all vehicles. The top 5 states hold 57% of EVs. |
| **Biggest under-penetrated market** | **Texas: 25.8M vehicles, 0.89% EV** | 9.0% of U.S. vehicles but only 6.5% of U.S. EVs. |
| **Large markets below benchmark** | **15 of the states with 5M+ vehicles** | Includes Texas, New York, Ohio, Pennsylvania, Illinois, Georgia, and North Carolina. |
| **Most common alternative fuel** | **E85 (flex fuel), 7.05% of vehicles** | At least 1% of vehicles in all 51 jurisdictions. CNG, propane, and hydrogen are under 0.01% nationally. |

### Findings worth highlighting
- **Market size and EV count are different stories.** Texas has a much larger vehicle market than Florida (25.8M vs. 18.6M), yet Florida has more EVs (254.9K vs. 230.1K) because its adoption rate is higher (1.37% vs. 0.89%).
- **High adoption does not always mean a big EV market.** D.C. ranks second in adoption (2.60%) but has only 8,100 EVs.
- **Hybrid-friendly, EV-lagging states.** Seven states, led by New York (3.59% hybrid/plug-in hybrid vs. 1.16% EV), have above-average hybrid adoption but below-average EV adoption. That pattern is worth investigating, though the data alone does not show that hybrid owners will switch to EVs.
- **An EV Representation Index** (a state's share of U.S. EVs divided by its share of U.S. vehicles) separates over-represented markets like California (2.75) from under-represented ones like Texas (0.72). North Carolina sits at 0.62.

## ❓ Business Questions Answered
1. What is the national EV adoption rate?
2. Which states have the highest and lowest EV adoption rates?
3. Which states have the largest vehicle markets and EV populations?
4. Which large markets (5M+ vehicles) fall below the national EV benchmark, and by how much?
5. Which states have high hybrid adoption but low EV adoption?
6. Which states have large gasoline fleets alongside low EV adoption?
7. Which alternative fuels are nationally meaningful, and how widespread are they?
8. Which states account for the largest share of U.S. EV registrations?
9. Which states have EVs over- or under-represented relative to their market size?
10. Which market characteristics point to stronger EV expansion opportunities?

Full answers with interpretation are in the [project write-up](EV%20market%20share/U.S.%20Electric%20Vehicle%20Market%20Share/Documenting.docx).

## 🧰 Approach

### Data quality checks (MySQL)
- Checked every fuel column for nulls and for impossible negative values
- Checked for duplicate states (none found)
- Reviewed min/max ranges for EV, gasoline, and diesel counts

### Modeling
- Built a `state_vehicle_metrics` view that standardizes column names and calculates total vehicles per state, so every question runs off one consistent definition
- Exported summary views (`state_fuel_market_share`, `ev_adoption_by_state`, `alt_fuel_meaningful_vs_niche`) to CSV for the dashboard

### SQL techniques used
CTEs, views, `CROSS JOIN` against national benchmarks, `UNION ALL` to unpivot fuel types, conditional aggregation with `CASE WHEN`, and ratio and index calculations.

### Dashboard (Power BI)
KPI cards (total vehicles, total EVs, national EV %, leading market), a filled map of EV adoption by state, and top 5 rankings by adoption rate and by EV count, with a state slicer.

## ⚠️ Limitations
- **This is a single snapshot, not a time series.** It describes the current market structure and cannot show growth, decline, or future adoption.
- The data shows *where* adoption is low, not *why*. Charging infrastructure, income, vehicle and fuel prices, population density, and state policy would be needed for a full market-opportunity assessment.
- The 5M-vehicle "large market" cutoff and the 1% "meaningful presence" threshold are analyst-defined.

## 📁 Project Files
```
EV market share/
├── Vehicle Data.csv                  ← raw state registration counts by fuel type
├── AnalysisDes.sql                   ← main analysis: data checks + 10 business questions
├── ev analysis.sql                   ← initial exploration and dashboard export views
├── dashboard.pbix                    ← Power BI dashboard
└── U.S. Electric Vehicle Market Share/
    ├── Documenting.docx              ← full write-up with interpretation
    ├── MarketOverview.png            ← dashboard screenshot
    ├── ev_adoption_by_state.csv      ← exported view
    ├── state_fuel_market_share.csv   ← exported view
    ├── alt_fuel_meaningful_vs_niche.csv ← exported view
    └── tableau.twb                   ← Tableau workbook (in progress)
```

## 📬 Contact
- GitHub: [Alucardz18](https://github.com/Alucardz18)
- LinkedIn: [Nii-Oye Kpakpo](https://www.linkedin.com/in/nii-oye-kpakpo-5b9997248/)
- Email: nhyirakpakpo@gmail.com
