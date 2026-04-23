/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
select sum(sales_amount) as total_sales from fact_sales;

-- Find how many items are sold
select sum(quantity) total_item_sold from fact_sales;

-- Find the average selling price
select round(avg(price),2) as avg_selling_price from fact_sales;

-- Find the Total number of Orders
select count(order_number) as total_orders from fact_sales;
select count(distinct order_number) as total_orders from fact_sales;

-- Find the total number of products
select count(distinct product_id) as total_products from dim_products;
select count(distinct product_number) as total_products from dim_products;

-- Find the total number of customers
select count(customer_id) as total_customers from dim_customers;
select count(customer_key) as total_customers from dim_customers;
select count(customer_number) as total_customers from dim_customers;

-- Find the total number of customers that has placed an order
select count(distinct customer_key) as total_customers from fact_sales;

-- Generate a Report that shows all key metrics of the business
select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from fact_sales
Union
select 'Total Quantity' , sum(quantity) from fact_sales
union
select 'Average Price', round(avg(price),2) from fact_sales
union
select 'Total Orders', count(distinct order_number) from fact_sales
union
select 'Total Products', count(distinct product_key) from fact_sales
union
select 'Total Customers', count(distinct customer_key) from fact_sales;
