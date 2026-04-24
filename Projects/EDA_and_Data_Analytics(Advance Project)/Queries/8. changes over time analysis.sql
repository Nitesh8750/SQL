/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- 1. Analyse sales performance over time
-- Quick Date Functions
select year(order_date) as year_wise_sale,
month(order_date) as month_wise_Sales,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity)as total_quantity
from fact_sales
group by year_wise_sale, month_wise_Sales
order by year_wise_sale, month_wise_Sales;


-- BY using date_format()
select date_format(order_date, "%Y") as order_year,
date_format(order_date, "%Y-%m") as order_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from fact_sales
group by order_year, order_month
order by order_year, order_month;
-- group by date_format(order_date, "%Y"), date_format(order_date, "%Y-%m")
-- order by date_format(order_date, "%Y"), date_format(order_date, "%Y-%m");


-- BY using Extract
select extract(year from order_date) as order_year,
extract(month from order_date) as order_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
count(quantity) as total_quantity
from fact_sales
group by order_year, order_month
order by order_year, order_month;

