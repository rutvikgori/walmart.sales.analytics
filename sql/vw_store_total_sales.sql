CREATE OR REPLACE VIEW bi.vw_store_total_sales AS
SELECT
  store,
  SUM(weekly_sales) AS total_sales
FROM walmart_sales
GROUP BY store;