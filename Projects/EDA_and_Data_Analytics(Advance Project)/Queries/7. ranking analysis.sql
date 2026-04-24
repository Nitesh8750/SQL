/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- 1. Which 5 products Generating the Highest Revenue?
-- Simple Ranking
select p.product_name, sum(f.sales_amount) as revenue 
from dim_products as p
inner join fact_sales as f on
p.product_key = f.product_key
group by p.product_name
order by revenue desc limit 5;


-- Complex but Flexible Ranking Using Window Functions
select * from
(
	select p.product_name, 
	sum(f.sales_amount) as revenue,
	row_number() over(order by sum(f.sales_amount) desc) as rank_revenue
	from dim_products as p 
	inner join fact_sales as f on 
	p.product_key = f.product_key
	group by p.product_name
) as rank_revenue
where rank_revenue <= 5;


-- 2. What are the 5 worst-performing products in terms of sales?
select p.product_name,
sum(f.sales_amount) as revenue
from dim_products as p
inner join fact_sales as f on
p.product_key = f.product_key
group by p.product_name
order by revenue limit 5;


-- 3. Find the top 10 customers who have generated the highest revenue
select c.customer_key, c.first_name, c.last_name,
sum(f.sales_amount) as revenue
from dim_customers as c
inner join fact_sales as f on
c.customer_key = f.customer_key
group by c.customer_key,
c.first_name,
c.last_name
order by revenue desc limit 10;


-- 4. The 3 customers with the fewest(minimum) orders placed
select c.customer_key, c.first_name, c.last_name,
count(distinct f.order_number) as total_orders
from dim_customers as c
inner join fact_sales as f on
c.customer_key = f.customer_key
group by c.customer_key, c.first_name, c.last_name
order by total_orders asc limit 3;


