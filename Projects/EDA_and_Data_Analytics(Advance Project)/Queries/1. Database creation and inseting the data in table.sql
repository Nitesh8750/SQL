/*
=============================================================
Create Database and Analytics Tables
=============================================================
Script Purpose:
    This script creates the 'DataWarehouseAnalytics' database 
    and defines the Star Schema tables directly within it.
=============================================================
*/

-- 1. Create and Use the Database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

-- ------------------------------------------------
-- 2. Create Dimension: dim_customers
-- ------------------------------------------------
CREATE TABLE dim_customers (
    customer_key    INT PRIMARY KEY,
    customer_id     INT,
    customer_number VARCHAR(50),
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    country         VARCHAR(50),
    marital_status  VARCHAR(50),
    gender          VARCHAR(50),
    birthdate       DATE,
    create_date     DATE
);

describe dim_customers;

-- ------------------------------------------------
-- 3. Create Dimension: dim_products
-- ------------------------------------------------
CREATE TABLE dim_products (
    product_key     INT PRIMARY KEY,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(50),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(50),
    cost            INT,
    product_line    VARCHAR(50),
    start_date      DATE 
);

describe dim_products;

-- ------------------------------------------------
-- 4. Create Fact: fact_sales
-- ------------------------------------------------
CREATE TABLE fact_sales (
    order_number    VARCHAR(50),
    product_key     INT,
    customer_key    INT,
    order_date      DATE,
    shipping_date   DATE,
    due_date        DATE,
    sales_amount    INT,
    quantity        TINYINT,
    price           INT,
    -- Adding Foreign Keys to ensure data integrity
    CONSTRAINT fk_product FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
    CONSTRAINT fk_customer FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key)
);

describe fact_sales;

-- =============================================================
-- DATA LOADING (Importing CSVs)
-- =============================================================

-- Ensure your MySQL server has local_infile enabled
SET GLOBAL local_infile = 1;
SET SESSION sql_mode = '';

-- *** Disable Foreign Key checks so we can truncate the table
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Load dim_customers
TRUNCATE TABLE dim_customers;
LOAD DATA LOCAL INFILE "C:/sql_data/dim_customers.csv"
INTO TABLE dim_customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, @v_birthdate, @v_create_date)
SET 
    birthdate   = STR_TO_DATE(@v_birthdate, '%d-%m-%Y'),
    create_date = STR_TO_DATE(@v_create_date, '%d-%m-%Y');

select * from dim_customers;

--  2. Load dim_products
TRUNCATE TABLE dim_products;
LOAD DATA LOCAL INFILE "C:/sql_data/dim_products.csv"
INTO TABLE dim_products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(product_key, product_id, product_number, product_name, category_id, category, subcategory, maintenance, cost, product_line, @v_start_date)
SET 
    start_date = STR_TO_DATE(@v_start_date, '%d-%m-%Y');
    
select * from dim_products;

-- 3. Load fact_sales
TRUNCATE TABLE fact_sales;
LOAD DATA LOCAL INFILE "C:/sql_data/fact_sales.csv"
INTO TABLE fact_sales
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_number, product_key, customer_key, @v_order_date, @v_ship_date, @v_due_date, sales_amount, quantity, price)
SET 
    order_date    = STR_TO_DATE(@v_order_date, '%d-%m-%Y'),
    shipping_date = STR_TO_DATE(@v_ship_date, '%d-%m-%Y'),
    due_date      = STR_TO_DATE(@v_due_date, '%d-%m-%Y');
    
select * from fact_sales;

-- **** Re-enable Foreign Key after the truncate the table
SET FOREIGN_KEY_CHECKS = 1;