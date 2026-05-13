# HR Attrition Insights & Process Improvement

End-to-end mini analytics project: synthetic HR dataset, SQL driver analysis, Python EDA,
Excel dashboard, and a Power BI build guide with DAX measures.

**Tech**: SQL · Python (pandas, matplotlib) · Microsoft Excel · Microsoft Power BI · DAX

## What is in here
```
hr_attrition_project/
├── data/         hr_employees.csv  (1,500 employees, 19 columns)
├── sql/          attrition_analysis.sql  (8 driver queries)
├── python/       eda.py + eda_charts.pdf
├── excel/        HR_Attrition_Dashboard.xlsx  (Data, KPIs, breakdown sheets with charts)
├── powerbi/      measures.dax + README.md  (build guide)
└── docs/         Requirements_and_KPI_Catalog.pdf
```

## Headline numbers (from synthetic data)
- Total employees: 1,500
- Leavers: 399
- Attrition rate: 26.60%
- Avg monthly income: $6,482
- Avg tenure: 3.66 years

## Key findings
- **Overtime** is the single largest lift in attrition rate.
- Employees in **tenure 0–1 yrs** leave at 2–3x the rate of 5–9 yr cohort.
- **Compensation Band 1 (<3K)** has the highest attrition; Band 5 the lowest.
- Combination of low **JobSatisfaction (1–2)** + low **WorkLifeBalance (1–2)** identifies
  the highest-risk cohort.

## Recommended actions
1. Stay-interview program for tenure < 18 months in top-3 attrition roles.
2. Compensation review for anyone earning < 85% of role average.
3. Cap OT at 8 hrs/week in departments with > 20-pt OT attrition lift.
4. Quarterly Pulse survey feeding satisfaction + WLB scores back into the dashboard.

## How to reproduce
```bash
# Python EDA
cd python && python eda.py ../data/hr_employees.csv

# SQL — load CSV into your DB then run
psql -f sql/attrition_analysis.sql
```

Author: **Simarjeet Singh** · Data Analyst
