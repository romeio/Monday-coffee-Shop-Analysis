-- =============================================================
--  Q2 — Total Revenue from Coffee Sales (Q4 2023)
--  What is the total revenue generated from coffee sales
--  across all cities in the last quarter of 2023?
-- =============================================================

SELECT
    ci.city_name,
    SUM(s.total) AS total_revenue
FROM sales AS s
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN city AS ci
    ON ci.city_id = c.city_id
WHERE
    EXTRACT(YEAR    FROM s.sale_date) = 2023
    AND EXTRACT(QUARTER FROM s.sale_date) = 4
GROUP BY ci.city_name
ORDER BY total_revenue DESC;
