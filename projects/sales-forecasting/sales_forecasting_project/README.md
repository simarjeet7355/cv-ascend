# Sales Performance & Forecasting Solution

End-to-end BA + analytics project: requirements docs, SQL KPI library, Python EDA + forecast,
Excel dashboard, and a Power BI build guide with DAX measures.

**Tech**: SQL · Python (pandas, matplotlib) · Microsoft Excel · Microsoft Power BI · DAX

## Layout
```
sales_forecasting_project/
├── data/      sales_transactions.csv  (100,000 rows, 12 columns, 2022–2025)
├── sql/       kpi_queries.sql         (8 KPI / forecast queries)
├── python/    eda_forecast.py + eda_forecast.pdf
├── excel/     Sales_Forecasting_Dashboard.xlsx  (KPIs, Monthly, ByRegion, Data)
├── powerbi/   measures.dax + README.md (build guide, DAX, page layout)
└── docs/      BRD.pdf · FRD.pdf · KPI_Catalog.pdf
```

## Headline numbers (synthetic data)
- Transactions: 100,000
- Revenue: $41,223,152
- Profit: $13,806,900
- Margin: 33.5%
- Period: 2022-01-01 → 2025-12-31

## Key deliverables
1. **BRD / FRD** — stakeholders, scope, process flow, acceptance criteria.
2. **KPI catalog** — definitions, formulas, owners, targets.
3. **Power BI dashboard** — 5 pages, slicers (Year, Region, Channel, Segment, Category), drill-through, 6-month forecast.
4. **SQL KPI library** — reusable queries powering the same KPIs outside Power BI.
5. **Excel back-up** — KPI sheet + monthly trend chart + region breakdown.

## Reproduce
```bash
cd python && python eda_forecast.py ../data/sales_transactions.csv
```

Author: **Simarjeet Singh** · Business / Data Analyst
