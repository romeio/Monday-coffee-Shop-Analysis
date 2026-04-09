-- =============================================================
--  Monday Coffee — Database Schema
--  Project  : Monday Coffee Data Analysis
--  Database : PostgreSQL
--  Author   : Ramy
-- =============================================================

-- Drop tables if they already exist (safe re-run)
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS city;

-- -------------------------------------------------------------
-- Table 1: city
-- -------------------------------------------------------------
CREATE TABLE city (
    city_id        SERIAL PRIMARY KEY,
    city_name      VARCHAR(50)  NOT NULL,
    population     BIGINT,
    estimated_rent NUMERIC(10,2),
    city_rank      INT
);

-- -------------------------------------------------------------
-- Table 2: products
-- -------------------------------------------------------------
CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price        NUMERIC(10,2)
);

-- -------------------------------------------------------------
-- Table 3: customers
-- -------------------------------------------------------------
CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city_id       INT REFERENCES city(city_id)
);

-- -------------------------------------------------------------
-- Table 4: sales
-- -------------------------------------------------------------
CREATE TABLE sales (
    sale_id     SERIAL PRIMARY KEY,
    sale_date   DATE         NOT NULL,
    product_id  INT REFERENCES products(product_id),
    customer_id INT REFERENCES customers(customer_id),
    total       NUMERIC(10,2)
);
