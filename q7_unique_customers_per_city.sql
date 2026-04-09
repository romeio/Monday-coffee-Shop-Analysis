-- =============================================================
--  Q7 — Customer Segmentation by City
--  How many unique customers are there in each city
--  who have purchased coffee products?
-- =============================================================

SELECT
    ci.city_name,
    COUNT(DISTINCT c.customer_id) AS unique_customers
FROM city AS ci
LEFT JOIN customers AS c
    ON c.city_id = ci.city_id
JOIN sales AS s
    ON s.customer_id = c.customer_id
WHERE s.product_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
GROUP BY ci.city_name
ORDER BY unique_customers DESC;
