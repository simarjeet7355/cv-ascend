# Power BI Build Guide — Sales Performance & Forecasting

## Model
1. Get Data → Text/CSV → `data/sales_transactions.csv`
2. Mark `Date` as Date type; create a **Date table**:
   `Date = CALENDAR ( DATE(2022,1,1), DATE(2026,12,31) )`
   then add Year, Quarter, Month, MonthName, YearMonth columns.
3. Relate `Sales[Date]` → `Date[Date]` (single, many-to-one).

## Measures
Paste from `measures.dax` into a `_Measures` table.

## Pages
1. **Executive Summary** — KPI cards (Revenue, Profit, Margin %, Orders, AOV), Revenue YoY %.
2. **Trend & Forecast** — line chart (Revenue, 3M MA, Forecast) with Analytics-pane forecast (6 months, 95% CI).
3. **Region & Channel** — matrix (Region × Channel) + map.
4. **Product Mix** — treemap by Category, table with Margin %.
5. **Discount Impact** — scatter Discount vs Margin %, decomposition tree.

## Slicers
Year, Region, Channel, Segment, Category. Sync slicers across pages.

## Drill-throughs
Right-click Region → drill to Region detail page filtered by selection.
