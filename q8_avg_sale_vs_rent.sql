-- =============================================================
--  Q8 — Average Sale vs Rent per Customer
--  Find each city's average sale per customer
--  and average rent per customer.
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
        estimated_rent
    FROM city
)

SELECT
    cr.city_name,
    cr.estimated_rent,
    cs.total_customers,
    cs.avg_sale_per_customer,
    ROUND(cr.estimated_rent::NUMERIC / cs.total_customers::NUMERIC, 2) AS avg_rent_per_customer
FROM city_rent AS cr
JOIN city_sales AS cs
    ON cr.city_name = cs.city_name
ORDER BY avg_rent_per_customer DESC;
