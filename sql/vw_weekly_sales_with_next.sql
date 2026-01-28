CREATE OR REPLACE VIEW bi.vw_weekly_sales_with_next AS
WITH weekly AS (
  SELECT
    walmart_sales.date,
    SUM(walmart_sales.weekly_sales) AS total_sales
  FROM walmart_sales
  GROUP BY walmart_sales.date
)
SELECT
  date,
  total_sales,
  LEAD(total_sales) OVER (ORDER BY date) AS next_week_sales
FROM weekly;
