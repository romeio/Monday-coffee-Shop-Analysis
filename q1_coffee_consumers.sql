-- =============================================================
--  Q1 — Coffee Consumers Count
--  How many people in each city are estimated to consume coffee,
--  given that 25% of the population does?
-- =============================================================

SELECT
    city_name,
    ROUND((population * 0.25) / 1000000, 2) AS coffee_consumers_in_millions,
    city_rank
FROM city
ORDER BY population DESC;
