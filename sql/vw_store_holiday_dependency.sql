 WITH base AS (
         SELECT walmart_sales.store,
                CASE
                    WHEN walmart_sales.holiday_flag = 1 THEN 'Holiday'::text
                    ELSE 'Non-Holiday'::text
                END AS period_type,
            walmart_sales.weekly_sales
           FROM walmart_sales
        ), agg AS (
         SELECT base.store,
            base.period_type,
            avg(base.weekly_sales) AS avg_weekly_sales
           FROM base
          GROUP BY base.store, base.period_type
        )
 SELECT store,
    max(
        CASE
            WHEN period_type = 'Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END) AS holiday_avg_weekly_sales,
    max(
        CASE
            WHEN period_type = 'Non-Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END) AS non_holiday_avg_weekly_sales,
    max(
        CASE
            WHEN period_type = 'Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END) - max(
        CASE
            WHEN period_type = 'Non-Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END) AS abs_lift,
    (max(
        CASE
            WHEN period_type = 'Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END) - max(
        CASE
            WHEN period_type = 'Non-Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END)) / NULLIF(max(
        CASE
            WHEN period_type = 'Non-Holiday'::text THEN avg_weekly_sales
            ELSE NULL::numeric
        END), 0::numeric) AS pct_lift
   FROM agg
  GROUP BY store;