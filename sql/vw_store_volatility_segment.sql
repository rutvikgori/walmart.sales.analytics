 WITH base AS (
         SELECT walmart_sales.store,
            avg(walmart_sales.weekly_sales) AS avg_weekly_sales,
            stddev_pop(walmart_sales.weekly_sales) AS stddev_weekly_sales,
            stddev_pop(walmart_sales.weekly_sales) / NULLIF(avg(walmart_sales.weekly_sales), 0::numeric) AS volatility_score
           FROM walmart_sales
          GROUP BY walmart_sales.store
        ), ranked AS (
         SELECT base.store,
            base.avg_weekly_sales,
            base.stddev_weekly_sales,
            base.volatility_score,
            ntile(3) OVER (ORDER BY base.volatility_score DESC) AS volatility_bucket
           FROM base
        )
 SELECT store,
    avg_weekly_sales,
    stddev_weekly_sales,
    volatility_score,
        CASE
            WHEN volatility_bucket = 1 THEN 'High Volatility'::text
            WHEN volatility_bucket = 2 THEN 'Medium Volatility'::text
            ELSE 'Low Volatility'::text
        END AS volatility_segment
   FROM ranked;