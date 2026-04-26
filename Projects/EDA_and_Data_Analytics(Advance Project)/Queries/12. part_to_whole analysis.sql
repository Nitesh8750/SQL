/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

use datawarehouseanalytics;

-- 1. Which categories contribute the most to overall sales?

with category_sales as
(
	select 
	p.category as category,
	sum(f.sales_amount) total_sales
	from dim_products as p
	inner join fact_sales as f
	group by p.category
)

select 
category,
total_sales,
sum(total_sales) over() as overall_sales,
round((total_sales / sum(total_sales) over()) * 100, 2) as percentage_sale
from category_sales
order by totaal_sales desc;

