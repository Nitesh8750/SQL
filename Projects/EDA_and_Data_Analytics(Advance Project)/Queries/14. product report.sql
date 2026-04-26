/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

-- =============================================================================
-- Create Report: report_products
-- =============================================================================


/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/

with base_query as (
select 
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost,
f.order_number,
f.customer_key,
f.order_date,
f.quantity,
f.sales_amount
from dim_products as p
join fact_sales as f on
p.product_key = f.product_key
where f.order_date is not null and f.order_date != 0
),

/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/

product_aggregation as 
(
select 
product_key,
product_name,
category,
subcategory,
cost,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity_sold,
count(distinct customer_key) as total_customers,
max(order_date) as last_order_date,
timestampdiff(month, min(order_date), max(order_date)) as lifespan,
round(avg(sales_amount / nullif(quantity, 0)),2) as average_selling_price
from base_query
group by 
product_key,
product_name,
category,
subcategory,
cost
),

/*--------------------------------------------------------------------------------------------------------------
3) Product Segmentation: Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
----------------------------------------------------------------------------------------------------------------*/

product_segmentation as 
(
select 
product_key,
product_name,
category,
subcategory,
cost,
last_order_date,
lifespan,
total_customers,
total_orders,
total_sales,
total_quantity_sold,
average_selling_price,
case
	when total_sales > 50000 then 'High Performance'
    when total_sales >= 100000 then 'Mid-range'
    else 'Low Performance'
end as revenue_type
from product_aggregation
)

/*---------------------------------------------------------------------------
4) Calculates valuable KPIs:
							- recency (months since last order)
							- average order value
							- average monthly spend
---------------------------------------------------------------------------*/


select * ,
-- recency (years since last order)
timestampdiff(year, last_order_date, now()) as recency,

-- average order value
case
	when total_sales = 0 then 0
    else round(total_sales / total_orders, 2)
end as avg_orders_revenue,

-- average monthly spend
case
	when total_sales = 0 then 0
    else round(total_Sales / lifespan, 2)
end as avg_monthly_spend

from product_segmentation;