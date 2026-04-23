/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
select min(order_date)as min_date,
max(order_date) as max_date,
abs(timestampdiff(month, max(order_date), min(order_date)) ) as total_duration
from fact_sales
where order_date > "0000-00-00";     -- This ignores the "blank" records

select * from fact_sales where order_date = "0000-00-00";


SELECT 
    MIN(NULLIF(order_date, '0000-00-00')) AS min_date,
    MAX(NULLIF(order_date, '0000-00-00')) AS max_date,
    TIMESTAMPDIFF(MONTH, 
        MIN(NULLIF(order_date, '0000-00-00')), 
        MAX(NULLIF(order_date, '0000-00-00'))
    ) AS total_months
FROM fact_sales;


-- Find the youngest and oldest customer based on birthdate
select
MIN(nullif(birthdate, "0000-00-00")) as oldest,
timestampdiff(year, MIN(nullif(birthdate, "0000-00-00")), Now()) as oldest_age,
max(nullif(birthdate, "0000-00-00"))as youngest,
timestampdiff(year, max(nullif(birthdate, "0000-00-00")), Now()) as youngest_age
from dim_customers;
