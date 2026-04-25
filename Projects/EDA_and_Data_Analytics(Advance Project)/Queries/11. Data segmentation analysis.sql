/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/* 1. Segment products into cost ranges and 
count how many products fall into each segment*/

use datawarehouseanalytics;
with product_segemnt as (
	select product_key,
	product_name,
	cost,
	case
		when cost < 100 then 'Below 100'
		when cost between 100 and 500 then '100-500'
		else 'Above 500'
	end as cost_ranges
	from dim_products
)

select 
cost_ranges,
count(product_key) as total_products
from product_segemnt
group by cost_ranges
order by total_products desc;


/* 2. Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

with customer_spending as (
	select
	c.customer_key,
	sum(f.sales_amount) as total_spending,
	min(f.order_date) as first_date,
	max(f.order_date) as last_date,
	timestampdiff(month, min(f.order_date), max(f.order_date)) as lifespan
	from fact_sales as f
	inner join dim_customers as c on
	c.customer_key = f.customer_key
	where order_date is not null and order_date != 0
	group by c.customer_key
),

customer_segementation as(
select 
customer_key, 
case
	when lifespan >= 12 and total_spending > 5000 then 'VIP'
    when lifespan >= 12 and total_spending <= 5000 then 'Regular'
    else 'New'
end as customer_segement
from customer_spending
)

select customer_segement,
count(customer_key) as total_customers
from customer_segementation
group by customer_segement;