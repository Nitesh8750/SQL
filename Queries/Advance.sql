Use questions;

CREATE TABLE Orders (
    Order_ID INT not null,
    Customer_Name VARCHAR(100) not null,
    Product VARCHAR(100) not null,
    Quantity INT,
    Order_Date DATE NOT NULL,
    Total_Amount DECIMAL(10, 2),
    CATEGORY VARCHAR(50),
    -- Composite PK to support partitioning
    PRIMARY KEY (Order_ID, Order_Date)
);

INSERT INTO Orders (Order_ID, Customer_Name, Product, Quantity, Order_Date, Total_Amount, CATEGORY) VALUES
(101, 'Ananya', 'Laptop', 1, '2023-06-15', 55000.00, 'Electronics'),
(102, 'Bharat', 'Mobile Phone', 2, '2023-06-18', 60000.00, 'Electronics'),
(103, 'Chitra', 'Office Chair', 4, '2023-07-01', 28000.00, 'Furniture'),
(104, 'Dev', 'Coffee Maker', 1, '2023-07-04', 4000.00, 'Furniture'),
(105, 'Esha', 'Dining Table', 1, '2023-07-10', 15000.00, 'Furniture'),
(106, 'Ananya', 'Headphones', 1, '2023-06-16', 2000.00, 'Electronics'),
(107, 'Bharat', 'Charger', 1, '2023-06-20', 500.00, 'Electronics'),
(108, 'Harsh', 'Headphones', 1, '2023-07-16', 2000.00, 'Electronics'),
(109, 'Ishita', 'Headphones', 2, '2023-07-17', 4000.00, 'Electronics'),
(110, 'Jai', 'Headphones', 2, '2023-07-18', 4000.00, 'Electronics'),
(111, 'Kavita', 'Headphones', 6, '2023-07-19', 12000.00, 'Electronics');

describe orders;
select * from orders;

# Question 1
# 1. Retrieve orders where the Total_Amount is greater than the average Total_Amount of all orders.
select * from orders where Total_Amount > (select avg(Total_Amount) as avg_amount from orders);


# Question 2
# 2. Display the total revenue generated for each product.
select product, sum(Total_Amount) as total_revenue from orders group by product;


# Question 3
# 3. Find the top 2 highest Total_Amount orders for each customer.
select * from 
(select *, row_number() over(partition by Customer_Name order by Total_Amount desc) as ranking from orders)  
as rank_ordersn where ranking <= 2;


# Question 4
# 4. List orders placed in the last 30 days of last order.
select * from orders order by Order_Date desc;
select * from orders where Order_Date > (select max(Order_Date) from orders) - interval 30 Day
 order by Order_Date desc; 
 
 
# Question 5
# 5. Retrieve orders for customers who placed more than one order.
select * from 
(select *,
count(Order_Id) over(partition by Customer_Name)  as count_order from orders) t
where count_order > 1;


# Question 6
# 6. Display orders where Quantity is greater than the average quantity ordered per product.
select * from
(select *, avg(Quantity) over(partition by Product) as avg_quantity from orders)t
where Quantity > avg_quantity;


# Question 7
# 7. Calculate the cumulative total amount for each order based on the order date.
select *, sum(Total_Amount) over(partition by Order_Date) as total_sum from orders;


# Question 8
# 8. Find the maximum Total_Amount within each month.
select *, max(Total_Amount) over(partition by month(Order_Date)) as monthwisesales from orders;


# QUestion 9
# 9. List customers who have ordered products totaling more than 40000 in a single order.
select * from (
select Customer_Name, sum(Total_Amount) over(partition by Order_ID) as customerwisesales from orders)t
where customerwisesales > 40000;

-- OR 
select Customer_Name, Total_Amount from orders where Total_Amount > 40000;


# Question 10
# 10. Show orders along with the rank of Total_Amount for each customer.
select *, rank() over(PARTITION BY Customer_Name order by Total_Amount desc) as rank_customers from orders;


# Question 11
# 11. Display the minimum and maximum Total_Amount for each product.
select Product, max(Total_Amount) as max_sales, min(Total_Amount) as min_sales from orders group by Product;

-- OR
select *, 
max(Total_Amount) over(partition by Product) as max_sales, 
min(Total_Amount) over(partition by Product) as min_sales
from orders;


# Question 12
# 12. Retrieve orders where Total_Amount is within 10% of the highest order amount.
select * from(
select *, max(Total_Amount) over()as highest_order_amount from orders)t
where Total_Amount <= highest_order_amount * 0.1;


# Question 13
# 13. Identify customers who ordered every available product at least once.
select Customer_Name from orders group by Customer_Name having count(distinct Product) = (select count( distinct product) from orders);


# Question 14
# 14. List orders where the Total_Amount exceeds the average order amount for that customer.
select * from (
select *, avg(Total_Amount) over(partition by Customer_Name) as avg_sales from orders)t
where Total_Amount > avg_sales;


# Question 15
# 15. Display customers whose orders cover all products in the Electronics category.
select Customer_Name from orders where CATEGORY = 'Electornics' group by Customer_Name having
count(distinct Product) = (select count(distinct Product) from orders where CATEGORY = 'Electornics');


# Question 16
# 16. Show the 3 most recent orders for each product.
select * from orders order by Order_Date desc limit 3;


# Question 17
# 17. Calculate the difference in Total_Amount between consecutive orders for each customer.
select *, 
lag(Total_Amount) over(partition by Customer_Name order by Order_Date) as previous_amount,
Total_Amount - lag(Total_Amount) over (partition by Customer_Name order by Order_Date) as difference
from orders;


# Question 18
# 18. Retrieve the average Total_Amount for each customer, only including orders with more than 1 quantity.
select Customer_Name, avg(Total_Amount) from orders where Quantity > 1 group by Customer_Name;


# Question 19
# 19. Find customers who made consecutive orders within 3 days of each other.
select * from (
select *, lag(Order_Date) over(partition by Customer_Name) as previous_order,
Order_Date - lag(Order_Date) over(partition by Customer_Name) as difference
from orders)t
where difference <= 3;


# Question 20
# 20. Display customers with a running total of the Total_Amount across all their orders.
select *, sum(Total_Amount) over(partition by Customer_Name order by Order_Date) as running_total from orders;


# Question 21
# 21. Show orders where the Total_Amount is within the top 25% of all orders.
select * from(
select *, percent_rank() over(order by Total_Amount desc) as percent_ranking from orders)t
where percent_ranking <= 0.25;


# Question 22
# 22. Retrieve the percentage contribution of each order to the total revenue.
select *,  (Total_Amount/ (select sum(Total_Amount) from orders)) *100 as percentile from orders;


# Question 23
# 23. Identify orders that generated more revenue than the average revenue for their respective product.
select * from (
select *, avg(Total_Amount) over(partition by Product) as avg_product_sales from orders) t
where Total_Amount > avg_product_sales;


# Question 24
# 24. List orders that were placed on a Monday.
select * from orders where weekday(Order_Date) = 'Monday';


# Question 25
# 25. Find orders where the Total_Amount is at least twice the median Total_Amount.
select * from orders
where Total_Amount >= 2*(
	select Total_Amount from(
							select Total_Amount,
                            row_number() over(partition by Total_Amount) as row_num,
                            count(*) over() as total_count 
                            from orders) as sub
	where row_num = floor(total_count/2) + 1
);


# Question 26
# 26. Calculate the average gap in days between consecutive orders for each customer.
select Customer_Name, avg(diff) from (
select *, lag(Order_Date) over(partition by Customer_Name order by Order_Date)as previous_order,
Order_Date - lag(Order_Date) over(partition by Customer_Name order by Order_Date) as diff from orders)sunb
group by Customer_Name;



# Question 27
# 27. Show the highest single order Total_Amount for each month.
select month(Order_Date), max(Total_Amount) from orders group by month(Order_Date);
    
    

# Question 28
# 28. Identify customers who have a minimum order quantity across all their orders greater than 2.
SELECT Customer_Name FROM Orders GROUP BY Customer_Name HAVING MIN(Quantity) > 2;


# Question 29
# 29. Display orders where the Quantity is greater than 2 times the median quantity ordered for that product.

select * from orders
where Quantity >= 2*(
	select Quantity from(
							select Quantity,
                            row_number() over(partition by Quantity) as row_num,
                            count(*) over() as total_count 
                            from orders) as sub
	where row_num = floor(total_count/2) + 1
);


# Question 30
# 30. Retrieve customers who placed orders totaling in the top 10% of all customers' cumulative totals.
WITH CustomerTotals AS ( 
SELECT Customer_Name, SUM(Total_Amount) AS Total, 
PERCENT_RANK() OVER (ORDER BY SUM(Total_Amount) DESC) AS rank_percent FROM Orders GROUP BY Customer_Name ) 
SELECT Customer_Name, Total FROM CustomerTotals WHERE rank_percent <= 0.1;




