-- HR Attrition Insights — SQL Analysis
-- Database: any ANSI SQL (tested syntax for PostgreSQL / MySQL / SQL Server)
-- Source table: hr_employees (load from data/hr_employees.csv)

-- =========================================================
-- 0. CREATE TABLE
-- =========================================================
CREATE TABLE hr_employees (
    EmployeeID              VARCHAR(10) PRIMARY KEY,
    Age                     INT,
    Gender                  VARCHAR(10),
    MaritalStatus           VARCHAR(15),
    Education               VARCHAR(20),
    Department              VARCHAR(20),
    JobRole                 VARCHAR(40),
    JobLevel                INT,
    YearsAtCompany          INT,
    YearsSinceLastPromotion INT,
    MonthlyIncome           INT,
    OverTime                VARCHAR(3),
    BusinessTravel          VARCHAR(20),
    DistanceFromHome        INT,
    JobSatisfaction         INT,
    EnvironmentSatisfaction INT,
    WorkLifeBalance         INT,
    PerformanceRating       INT,
    Attrition               VARCHAR(3)
);

-- =========================================================
-- 1. HEADLINE KPIs
-- =========================================================
SELECT
    COUNT(*)                                              AS total_employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)      AS leavers,
    ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 0)                          AS avg_monthly_income,
    ROUND(AVG(YearsAtCompany), 2)                         AS avg_tenure_years
FROM hr_employees;

-- =========================================================
-- 2. ATTRITION BY DEPARTMENT
-- =========================================================
SELECT Department,
       COUNT(*) AS headcount,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- =========================================================
-- 3. ATTRITION BY JOB ROLE (TOP 10 RISKIEST)
-- =========================================================
SELECT JobRole,
       COUNT(*) AS headcount,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS leavers,
       ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employees
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- =========================================================
-- 4. ATTRITION BY TENURE BUCKET
-- =========================================================
SELECT
    CASE
        WHEN YearsAtCompany < 2  THEN '0-1 yrs'
        WHEN YearsAtCompany < 5  THEN '2-4 yrs'
        WHEN YearsAtCompany < 10 THEN '5-9 yrs'
        ELSE '10+ yrs'
    END AS tenure_bucket,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS leavers,
    ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employees
GROUP BY 1
ORDER BY MIN(YearsAtCompany);

-- =========================================================
-- 5. ATTRITION BY COMPENSATION BAND
-- =========================================================
SELECT
    CASE
        WHEN MonthlyIncome < 3000  THEN 'Band 1 (<3K)'
        WHEN MonthlyIncome < 5000  THEN 'Band 2 (3-5K)'
        WHEN MonthlyIncome < 8000  THEN 'Band 3 (5-8K)'
        WHEN MonthlyIncome < 12000 THEN 'Band 4 (8-12K)'
        ELSE 'Band 5 (12K+)'
    END AS comp_band,
    COUNT(*) AS headcount,
    ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employees
GROUP BY 1
ORDER BY MIN(MonthlyIncome);

-- =========================================================
-- 6. OVERTIME IMPACT
-- =========================================================
SELECT OverTime,
       COUNT(*) AS headcount,
       ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employees
GROUP BY OverTime;

-- =========================================================
-- 7. SATISFACTION & WORK-LIFE BALANCE DRIVERS
-- =========================================================
SELECT JobSatisfaction,
       WorkLifeBalance,
       COUNT(*) AS headcount,
       ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employees
GROUP BY JobSatisfaction, WorkLifeBalance
ORDER BY attrition_rate_pct DESC;

-- =========================================================
-- 8. HIGH-RISK COHORT (window function)
-- Flag employees in the top 25% income gap vs role average who also work overtime
-- =========================================================
WITH role_avg AS (
    SELECT EmployeeID, JobRole, MonthlyIncome, OverTime, Attrition,
           AVG(MonthlyIncome) OVER (PARTITION BY JobRole) AS role_avg_income
    FROM hr_employees
)
SELECT JobRole,
       COUNT(*) AS at_risk_headcount,
       ROUND(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM role_avg
WHERE OverTime = 'Yes'
  AND MonthlyIncome < 0.85 * role_avg_income
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;
