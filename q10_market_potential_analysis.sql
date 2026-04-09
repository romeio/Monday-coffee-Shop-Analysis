-- =============================================================
--  Q10 — Market Potential Analysis
--  Identify the top 3 cities based on highest sales.
--  Return: city name, total sales, total rent, total customers,
--          avg sale per customer, avg rent per customer,
--          estimated coffee consumers.
-- =============================================================

WITH city_sales AS (
    SELECT
        ci.city_name,
        SUM(s.total)                                                       AS total_revenue,
        COUNT(DISTINCT s.customer_id)                                      AS total_customers,
        ROUND(SUM(s.total)::NUMERIC / COUNT(DISTINCT s.customer_id), 2)   AS avg_sale_per_customer
    FROM city AS ci
    LEFT JOIN customers AS c
        ON c.city_id = ci.city_id
    JOIN sales AS s
        ON s.customer_id = c.customer_id
    GROUP BY ci.city_name
),

city_rent AS (
    SELECT
        city_name,
        estimated_rent,
        ROUND((population * 0.25) / 1000000, 2) AS estimated_coffee_consumers_millions
    FROM city
)

SELECT
    cr.city_name,
    cs.total_revenue,
    cr.estimated_rent                                                       AS total_rent,
    cs.total_customers,
    cs.avg_sale_per_customer,
    ROUND(cr.estimated_rent::NUMERIC / cs.total_customers::NUMERIC, 2)    AS avg_rent_per_customer,
    cr.estimated_coffee_consumers_millions
FROM city_rent AS cr
JOIN city_sales AS cs
    ON cr.city_name = cs.city_name
ORDER BY avg_rent_per_customer ASC;

/*
================================================
  RECOMMENDATION SUMMARY
================================================

  City 1 — Jaipur
  - Lowest avg rent per customer (very affordable)
  - High avg sale per customer (~11.6K)
  - Strong customer base (69 unique customers)
  Verdict: Best ROI for a new branch

  City 2 — Delhi
  - Highest estimated coffee consumers
  - Largest customer base (68 unique customers)
  - Avg rent per customer ~330 (still under 500)
  Verdict: Highest growth potential

  City 3 — Pune
  - Strong revenue performance
  - Healthy revenue-to-rent ratio
  - Consistent sales growth
  Verdict: Stable market, lower risk

================================================
*/
