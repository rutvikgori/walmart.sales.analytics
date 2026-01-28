CREATE OR REPLACE VIEW bi.vw_store_global_top3_frequency AS
WITH ranked AS (
  SELECT
    store,
    date,
    weekly_sales,
    DENSE_RANK() OVER (ORDER BY weekly_sales DESC) AS global_rank
  FROM walmart_sales
)
SELECT
  store,
  COUNT(*) AS times_in_global_top3
FROM ranked
WHERE global_rank <= 3
GROUP BY store;
