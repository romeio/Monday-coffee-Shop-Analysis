-- =============================================================
--  Q3 — Sales Count for Each Product
--  How many units of each coffee product have been sold?
-- =============================================================

SELECT
    p.product_name,
    COUNT(s.sale_id) AS total_orders
FROM products AS p
LEFT JOIN sales AS s
    ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC;
