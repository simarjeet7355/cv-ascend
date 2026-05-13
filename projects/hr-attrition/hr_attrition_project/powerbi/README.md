# Power BI Build Guide — HR Attrition

## 1. Get Data
- Home -> Get Data -> Text/CSV -> select `data/hr_employees.csv`.
- Confirm types: Age, JobLevel, YearsAtCompany, YearsSinceLastPromotion, MonthlyIncome,
  DistanceFromHome, JobSatisfaction, EnvironmentSatisfaction, WorkLifeBalance,
  PerformanceRating -> Whole Number. All others -> Text.

## 2. Add Calculated Columns
```
Tenure Bucket =
SWITCH ( TRUE (),
    Employees[YearsAtCompany] < 2,  "0-1 yrs",
    Employees[YearsAtCompany] < 5,  "2-4 yrs",
    Employees[YearsAtCompany] < 10, "5-9 yrs",
    "10+ yrs"
)

Comp Band =
SWITCH ( TRUE (),
    Employees[MonthlyIncome] < 3000,  "Band 1 (<3K)",
    Employees[MonthlyIncome] < 5000,  "Band 2 (3-5K)",
    Employees[MonthlyIncome] < 8000,  "Band 3 (5-8K)",
    Employees[MonthlyIncome] < 12000, "Band 4 (8-12K)",
    "Band 5 (12K+)"
)
```

## 3. Add Measures
Paste the contents of `measures.dax` into the model (one measure per New Measure).

## 4. Pages
- **Executive Summary**: KPI cards (Headcount, Leavers, Attrition Rate %, Replacement Cost).
  Donut by Department, line by Tenure Bucket.
- **Driver Deep Dive**: Bar charts of Attrition Rate % by JobRole, OverTime, WorkLifeBalance,
  JobSatisfaction. Slicers for Department and Comp Band.
- **Flight-Risk Cohort**: Table visual filtered by `Flight Risk Count` measure, columns:
  EmployeeID (masked), JobRole, MonthlyIncome, Role Avg Income, OverTime, JobSatisfaction.
- **Cost Impact**: Replacement Cost card + bar by Department + waterfall by quarter.

## 5. Theme
- Use the corporate color palette. Reserve red ONLY for high attrition (> org average).
- All visuals get descriptive titles ending in the metric unit, e.g. "Attrition Rate (%)".

## 6. Row-Level Security
- Create role `HRBP` with DAX: `[Department] = USERPRINCIPALNAME()` mapped via a `UserDept` table.
- Create role `CHRO` with no filter.
