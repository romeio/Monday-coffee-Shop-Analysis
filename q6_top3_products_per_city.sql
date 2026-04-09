-- =============================================================
--  Q6 — Top 3 Selling Products by City
--  What are the top 3 selling products in each city
--  based on sales volume?
-- =============================================================

SELECT *
FROM (
    SELECT
        ci.city_name,
        p.product_name,
        COUNT(s.sale_id)                                               AS total_orders,
        DENSE_RANK() OVER (
            PARTITION BY ci.city_name
            ORDER BY COUNT(s.sale_id) DESC
        )                                                              AS rank
    FROM sales AS s
    JOIN products AS p
        ON s.product_id = p.product_id
    JOIN customers AS c
        ON c.customer_id = s.customer_id
    JOIN city AS ci
        ON ci.city_id = c.city_id
    GROUP BY ci.city_name, p.product_name
) AS ranked
WHERE rank <= 3
ORDER BY city_name, rank;
