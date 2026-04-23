/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

use datawarehouseanalytics;

-- Retrieve a list of unique countries from which customers originate
select distinct country from dim_customers;
select * from dim_customers where country = "n/a";

-- Retrieve a list of unique categories, subcategories, and products
select distinct
category,
subcategory,
product_name
from dim_products
order by category, subcategory, product_name;