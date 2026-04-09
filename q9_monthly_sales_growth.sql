-- =============================================================
--  Q9 — Monthly Sales Growth Rate
--  Calculate the percentage growth (or decline) in sales
--  over different months by each city.
-- =============================================================

WITH monthly_sales AS (
    SELECT
        ci.city_name,
        EXTRACT(YEAR  FROM s.sale_date)  AS sale_year,
        EXTRACT(MONTH FROM s.sale_date)  AS sale_month,
        SUM(s.total)                     AS total_revenue
    FROM sales AS s
    JOIN customers AS c
        ON s.customer_id = c.customer_id
    JOIN city AS ci
        ON ci.city_id = c.city_id
    GROUP BY ci.city_name, sale_year, sale_month
),

sales_with_lag AS (
    SELECT
        city_name,
        sale_year,
        sale_month,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY city_name
            ORDER BY sale_year, sale_month
        ) AS prev_month_revenue
    FROM monthly_sales
)

SELECT
    city_name,
    sale_year,
    sale_month,
    total_revenue,
    prev_month_revenue,
    CASE
        WHEN prev_month_revenue IS NULL THEN NULL
        ELSE ROUND(
            (total_revenue - prev_month_revenue)::NUMERIC
            / prev_month_revenue * 100, 2
        )
    END AS growth_rate_pct
FROM sales_with_lag
ORDER BY city_name, sale_year, sale_month;
