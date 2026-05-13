-- Sales Performance & Forecasting — KPI Queries
-- Assumes table sales(order_id, date, region, channel, segment, category, quantity, unit_price, discount, revenue, cost, profit)

-- 1. Headline KPIs
SELECT COUNT(*) AS orders, SUM(revenue) AS revenue, SUM(profit) AS profit,
       SUM(profit)*1.0/NULLIF(SUM(revenue),0) AS margin_pct
FROM sales;

-- 2. Monthly revenue trend
SELECT date_trunc('month', date) AS month, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM sales GROUP BY 1 ORDER BY 1;

-- 3. Region x Channel matrix
SELECT region, channel, SUM(revenue) AS revenue, SUM(profit) AS profit
FROM sales GROUP BY region, channel ORDER BY revenue DESC;

-- 4. Top categories
SELECT category, SUM(revenue) AS revenue, SUM(quantity) AS units,
       SUM(profit)*1.0/NULLIF(SUM(revenue),0) AS margin_pct
FROM sales GROUP BY category ORDER BY revenue DESC;

-- 5. YoY growth
WITH yr AS (SELECT EXTRACT(YEAR FROM date) y, SUM(revenue) r FROM sales GROUP BY 1)
SELECT y, r, r/LAG(r) OVER(ORDER BY y) - 1 AS yoy_growth FROM yr;

-- 6. Discount impact on margin
SELECT CASE WHEN discount=0 THEN '0%' WHEN discount<=0.1 THEN '<=10%' ELSE '>10%' END AS disc_band,
       SUM(revenue) AS revenue, SUM(profit)*1.0/NULLIF(SUM(revenue),0) AS margin_pct
FROM sales GROUP BY 1;

-- 7. 3-month moving average forecast input
SELECT date_trunc('month', date) AS month, SUM(revenue) AS revenue,
       AVG(SUM(revenue)) OVER(ORDER BY date_trunc('month', date) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS ma3
FROM sales GROUP BY 1 ORDER BY 1;

-- 8. Customer segment mix
SELECT segment, SUM(revenue) AS revenue,
       SUM(revenue)*1.0/SUM(SUM(revenue)) OVER() AS revenue_share
FROM sales GROUP BY segment;
