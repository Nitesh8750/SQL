/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per year 
-- and the running total of sales over time 
-- and the moving average of price over time

select 	orders_date,
total_sales,
avg_price,
sum(total_sales) over(order by orders_date) as running_total_Sales,
round(avg(avg_price) over(order by orders_date),2) as moving_average_price
from
(
    select year(order_date) as orders_date,
	sum(sales_amount) as total_sales,
	round(avg(price),2) as avg_price
	from fact_sales
	where order_date is not null and order_date !=0
	group by orders_date
	order by orders_date
)t;


-- Calculate the total sales per month
-- and the running total of sales over time 
-- and the moving average of price over time

select *,
sum(total_sales) over(order by Years, Months) as running_total_Sales,
round(avg(avg_price) over(order by Years, Months),2) as moving_average_price
from
(
	select year(order_date) as Years,
	month(order_date) as Months,
	sum(sales_amount) as total_sales,
	round(avg(price),2) as avg_price
	from fact_sales
	where order_date is not null and order_date != 0
	group by Years, Months
	order by Years, Months
)t;