/*
===============================================================================
Script: Load Bronze Layer (Source -> Bronze)
===============================================================================
Note: In MySQL, 'LOAD DATA' cannot be used inside a Stored Procedure. 
This script acts as the automated batch loader for the Bronze Layer.
===============================================================================
*/

-- Enable local loading
SET GLOBAL local_infile = 1;

-- Initialize Batch Timer
SET @batch_start = NOW();

SELECT '================================================' AS ' ';
SELECT 'Loading Bronze Layer' AS ' ';
SELECT '================================================' AS ' ';

-- ------------------------------------------------
-- LOADING CRM TABLES
-- ------------------------------------------------
SELECT '------------------------------------------------' AS ' ';
SELECT 'Loading CRM Tables' AS ' ';
SELECT '------------------------------------------------' AS ' ';

-- 1. crm_cust_info
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.crm_cust_info' AS ' ';
TRUNCATE TABLE bronze.crm_cust_info;

SELECT '>> Inserting Data Into: bronze.crm_cust_info' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/Admin/Desktop/SQL/topic_wise by data with Baraa/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT 'crm_cust_info' AS Table_Name, COUNT(*) AS Rows_Loaded FROM bronze.crm_cust_info;

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> -------------' AS ' ';


-- 2. crm_prd_info
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.crm_prd_info' AS ' ';
TRUNCATE TABLE bronze.crm_prd_info;

SELECT '>> Inserting Data Into: bronze.crm_prd_info' AS ' ';
LOAD DATA LOCAL INFILE "C:/Users/Admin/Desktop/sql_data/source_crm/prd_info.csv"
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT 'crm_prd_info' AS Table_Name, COUNT(*) AS Rows_Loaded FROM bronze.crm_prd_info;

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> -------------' AS ' ';

-- 3. crm_sales_details
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.crm_sales_details' AS ' ';
TRUNCATE TABLE bronze.crm_sales_details;

SELECT '>> Inserting Data Into: bronze.crm_sales_details' AS ' ';
LOAD DATA LOCAL INFILE "C:/Users/Admin/Desktop/sql_data/source_crm/sales_details.csv"
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT 'crm_sales_details' AS Table_Name, COUNT(*) AS Rows_Loaded FROM bronze.crm_sales_details;

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> -------------' AS ' ';


-- ------------------------------------------------
-- LOADING ERP TABLES
-- ------------------------------------------------
SELECT '------------------------------------------------' AS ' ';
SELECT 'Loading ERP Tables' AS ' ';
SELECT '------------------------------------------------' AS ' ';

-- 1. erp_loc_a101
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.erp_loc_a101' AS ' ';
TRUNCATE TABLE bronze.erp_loc_a101;

SELECT '>> Inserting Data Into: bronze.erp_loc_a101' AS ' ';
LOAD DATA LOCAL INFILE "C:/Users/Admin/Desktop/sql_data/source_erp/LOC_A101.csv"
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT 'erp_loc_a101' AS Table_Name, COUNT(*) AS Rows_Loaded FROM bronze.erp_loc_a101;
select * from bronze.erp_loc_a101;


SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> -------------' AS ' ';

-- 2. erp_cust_az12
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.erp_cust_az12' AS ' ';
TRUNCATE TABLE bronze.erp_cust_az12;

SELECT '>> Inserting Data Into: bronze.erp_cust_az12' AS ' ';
LOAD DATA LOCAL INFILE  'C:/Users/Admin/Desktop/sql_data/source_erp/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
-- List columns, but use a variable (@v_bdate) for the date field
(cid, @v_bdate, gen) 
SET bdate = STR_TO_DATE(NULLIF(TRIM(@v_bdate),''), '%d-%m-%Y'); -- Adjust ''%d-%m-%Y' to match your CSV format

SELECT 'erp_cust_az12' AS Table_Name, COUNT(*) AS Rows_Loaded FROM bronze.erp_cust_az12;
select * from bronze.erp_cust_az12;

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> -------------' AS ' ';

-- 3. erp_px_cat_g1v2
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.erp_px_cat_g1v2' AS ' ';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

SELECT '>> Inserting Data Into: bronze.erp_px_cat_g1v2' AS ' ';
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT 'erp_px_cat_g1v2' AS Table_Name, COUNT(*) AS Rows_Loaded FROM bronze.erp_px_cat_g1v2;

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> -------------' AS ' ';

-- Final Summary
SET @batch_end = NOW();
SELECT '==========================================' AS ' ';
SELECT 'Loading Bronze Layer is Completed' AS ' ';
SELECT CONCAT('   - Total Load Duration: ', TIMESTAMPDIFF(SECOND, @batch_start, @batch_end), ' seconds') AS ' ';
SELECT '==========================================' AS ' ';