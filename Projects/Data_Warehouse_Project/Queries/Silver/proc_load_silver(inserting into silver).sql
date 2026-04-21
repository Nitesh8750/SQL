/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL process to populate the 'silver' 
    schema tables from the 'bronze' schema using cleaned and transformed data.
    
Usage Example:
    CALL silver.load_silver();
===============================================================================
*/

-- Set the session to use the correct database
USE silver;


DELIMITER $$

DROP PROCEDURE IF EXISTS silver.load_silver $$

CREATE PROCEDURE silver.load_silver()
BEGIN
    -- Declare timing variables
    DECLARE v_batch_start, v_batch_end, v_start, v_end DATETIME;
    
    -- Error Handling: Log details if the procedure fails
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
        SELECT 'ERROR OCCURRED' AS Status, @p1 AS SQL_State, @p2 AS Message;
    END;

    -- Set the session to allow flexible date handling (important for 0000-00-00 fixes)
    SET SESSION sql_mode = '';

    SET v_batch_start = NOW();
    SELECT '================================================' AS ' ';
    SELECT 'Starting Silver Layer Load' AS ' ';
    SELECT '================================================' AS ' ';

    -- ===========================================================================
    -- CRM TABLES
    -- ===========================================================================
    SELECT '------------------------------------------------' AS ' ';
    SELECT 'Loading CRM Tables' AS ' ';
    SELECT '------------------------------------------------' AS ' ';

    -- 1. Loading silver.crm_cust_info (Deduplication & Formatting)
    SET v_start = NOW();
    SELECT '>> Truncating & Loading: silver.crm_cust_info' AS ' ';
    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname, 
        cst_marital_status, cst_gndr, cst_create_date
    )
    SELECT cst_id, cst_key, TRIM(cst_firstname), TRIM(cst_lastname),
           CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a' END,
           CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a' END,
           NULLIF(cst_create_date, '0000-00-00')
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL AND cst_id != 0
    ) t WHERE flag_last = 1;
    
    SET v_end = NOW();
    SELECT CONCAT('>> Duration: ', TIMESTAMPDIFF(SECOND, v_start, v_end), 's') AS ' ';

    -- 2. Loading silver.crm_prd_info (String Splitting & SCD logic)
    SET v_start = NOW();
    SELECT '>> Truncating & Loading: silver.crm_prd_info' AS ' ';
    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm, 
        prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT prd_id,
           REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
           SUBSTRING(prd_key, 7),
           prd_nm,
           IFNULL(prd_cost, 0),
           CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a' END,
           CAST(prd_start_dt AS DATE),
           DATE_SUB(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY)
    FROM bronze.crm_prd_info;

    SET v_end = NOW();
    SELECT CONCAT('>> Duration: ', TIMESTAMPDIFF(SECOND, v_start, v_end), 's') AS ' ';

    -- 3. Loading silver.crm_sales_details (Data Quality & Date Fixes)
    SET v_start = NOW();
    SELECT '>> Truncating & Loading: silver.crm_sales_details' AS ' ';
    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, 
        sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
    )
    SELECT sls_ord_num, sls_prd_key, sls_cust_id,
           CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL 
                ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d') END,
           CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL 
                ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d') END,
           CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL 
                ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d') END,
           CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) 
                THEN sls_quantity * ABS(sls_price) ELSE sls_sales END,
           sls_quantity,
           CASE WHEN sls_price <= 0 OR sls_price IS NULL 
                THEN sls_sales / NULLIF(sls_quantity, 0) ELSE sls_price END
    FROM bronze.crm_sales_details;

    SET v_end = NOW();
    SELECT CONCAT('>> Duration: ', TIMESTAMPDIFF(SECOND, v_start, v_end), 's') AS ' ';

    -- ===========================================================================
    -- ERP TABLES
    -- ===========================================================================
    SELECT '------------------------------------------------' AS ' ';
    SELECT 'Loading ERP Tables' AS ' ';
    SELECT '------------------------------------------------' AS ' ';

    -- 4. Loading erp_cust_az12
    SET v_start = NOW();
    TRUNCATE TABLE silver.erp_cust_az12;
    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4) ELSE cid END,
           CASE WHEN bdate > NOW() OR bdate = '0000-00-00' THEN NULL ELSE bdate END,
           CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a' END
    FROM bronze.erp_cust_az12;
    SET v_end = NOW();
    SELECT CONCAT('>> erp_cust_az12 Duration: ', TIMESTAMPDIFF(SECOND, v_start, v_end), 's') AS ' ';

    -- 5. Loading erp_loc_a101
    SET v_start = NOW();
    TRUNCATE TABLE silver.erp_loc_a101;
    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT REPLACE(cid, '-', ''),
           CASE WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry) END
    FROM bronze.erp_loc_a101;
    SET v_end = NOW();
    SELECT CONCAT('>> erp_loc_a101 Duration: ', TIMESTAMPDIFF(SECOND, v_start, v_end), 's') AS ' ';

    -- 6. Loading erp_px_cat_g1v2
    SET v_start = NOW();
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT TRIM(id), TRIM(cat), TRIM(subcat), TRIM(maintenance) 
    FROM bronze.erp_px_cat_g1v2;
    SET v_end = NOW();
    SELECT CONCAT('>> erp_px_cat_g1v2 Duration: ', TIMESTAMPDIFF(SECOND, v_start, v_end), 's') AS ' ';

    SET v_batch_end = NOW();
    SELECT '==========================================' AS ' ';
    SELECT CONCAT('Silver Layer Completed! Total: ', TIMESTAMPDIFF(SECOND, v_batch_start, v_batch_end), 's') AS ' ';
    SELECT '==========================================' AS ' ';
END $$

DELIMITER ;