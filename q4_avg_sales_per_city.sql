-- =============================================================
--  Q4 — Average Sales Amount per City
--  What is the average sales amount per customer in each city?
-- =============================================================

SELECT
    ci.city_name,
    SUM(s.total)                                                        AS total_revenue,
    COUNT(DISTINCT s.customer_id)                                       AS total_customers,
    ROUND(SUM(s.total)::NUMERIC / COUNT(DISTINCT s.customer_id), 2)    AS avg_sale_per_customer
FROM sales AS s
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN city AS ci
    ON ci.city_id = c.city_id
GROUP BY ci.city_name
ORDER BY total_revenue DESC;
