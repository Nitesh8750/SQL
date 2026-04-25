/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/


/* 1. Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

use datawarehouseanalytics;

with yearly_product_performance as
(
select year(f.order_date) as order_date,
p.product_number as product,
sum(f.sales_amount) as current_sales
from fact_sales as f
inner join dim_products as p on
p.product_key = f.product_key
where order_date is not null and order_date != 0
group by order_date, product
)

select order_date, product, current_sales,
avg(current_sales) over(partition by product) as avg_sales,
current_sales - avg(current_sales) over(partition by product) as diff_sales,
case
	when current_sales - avg(current_sales) over(partition by product) < 0 then 'Below average'
    when current_sales - avg(current_sales) over(partition by product) > 0 then 'Above average'
    else 'Average'
end as avg_change,

-- Year-over-Year Analysis
lag(current_sales) over(partition by product order by order_date) as py_sales,
current_sales - lag(current_sales) over(partition by product order by order_date) as diff_py,
case
	when current_sales - lag(current_sales) over(partition by product order by order_date) > 0 then 'Increase'
    when current_sales - lag(current_sales) over(partition by product order by order_date) < 0 then 'Decrease'
    else 'No Change'
end as py_change
from yearly_product_performance
order by product, order_date;

