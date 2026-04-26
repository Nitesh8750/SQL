/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: report_customers
-- =============================================================================

DROP VIEW IF EXISTS datawarehouseanalytics.view_customer_report;

CREATE VIEW datawarehouseanalytics.view_customer_report AS


/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
with base_query as (
select c.customer_key,
c.customer_number,
concat(first_name, " ", last_name) as customer_name,
timestampdiff(year, c.birthdate, now()) as age,
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity
from dim_customers as c
join fact_sales as f on
c.customer_key = f.customer_key
where f.order_date is not null and f.order_date != 0
),

/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/

customer_aggregation as 
(
select customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
min(order_date) as first_order_date,
max(order_date) as last_order_date,
timestampdiff(month, min(order_date), max(order_date)) as lifespan
from base_query
group by 
customer_key,
customer_number,
customer_name,
age
),

/*----------------------------------------------------------------------------------------------
3) Customer Segmentation: Segments customers into categories (VIP, Regular, New) and age groups.
------------------------------------------------------------------------------------------------*/

customer_segmentation as (
select 
customer_key,
customer_number,
customer_name,
age,
lifespan,
total_orders,
total_sales,
total_quantity,
total_products,
last_order_date,
case
	when age < 20 then 'under 20'
    when age between 20 and 29 then '20-29'
    when age between 30 and 39 then '30-39'
    when age between 40 and 49 then '40-49'
    else '50 and above'
end as age_group,
case
	when lifespan >= 12 and total_sales > 5000 then 'VIP'
    when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New'
end as customer_type
from customer_aggregation
)

/*---------------------------------------------------------------------------
4) Calculates valuable KPIs:
							- recency (months since last order)
							- average order value
							- average monthly spend
---------------------------------------------------------------------------*/

select 
customer_key,
customer_number,
customer_name,
age,
lifespan,
total_orders,
total_sales,
total_quantity,
total_products,
age_group,
customer_type,
-- recency (years since last order)
timestampdiff(year, last_order_date, now()) as recency,

-- average order value
case 
	when total_sales = 0 then 0
    else round(total_sales / total_orders, 2)
end as avg_order_value,

-- average monthly spend
case
	when total_sales = 0 then 0
    else round(total_sales / lifespan, 2)
end as avg_monthly_spend
from customer_segmentation;


SHOW FULL TABLES IN datawarehouseanalytics WHERE TABLE_TYPE = 'VIEW';
