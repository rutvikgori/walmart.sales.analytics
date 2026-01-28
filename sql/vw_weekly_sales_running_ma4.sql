CREATE OR REPLACE VIEW bi.vw_weekly_sales_running_ma4 AS
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
  SUM(total_sales) OVER (ORDER BY date) AS running_total_sales,
  AVG(total_sales) OVER (
    ORDER BY date
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
  ) AS moving_avg_4wk
FROM weekly;