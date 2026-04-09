-- =============================================================
--  Q5 — City Population and Coffee Consumers
--  Provide a list of cities along with their populations
--  and estimated coffee consumers vs actual unique customers.
-- =============================================================

WITH city_table AS (
    SELECT
        city_name,
        ROUND((population * 0.25) / 1000000, 2) AS coffee_consumers_in_millions
    FROM city
),

customers_table AS (
    SELECT
        ci.city_name,
        COUNT(DISTINCT c.customer_id) AS unique_customers
    FROM sales AS s
    JOIN customers AS c
        ON c.customer_id = s.customer_id
    JOIN city AS ci
        ON ci.city_id = c.city_id
    GROUP BY ci.city_name
)

SELECT
    ct.city_name,
    cit.coffee_consumers_in_millions,
    ct.unique_customers
FROM customers_table AS ct
JOIN city_table AS cit
    ON cit.city_name = ct.city_name
ORDER BY cit.coffee_consumers_in_millions DESC;
