--Project 2
/*Beginner SQL Questions 
Q1 List all products: Write a query to retrieve all product names and their corresponding brand names.
Q2 Find active staff: Write a query to find all active staff members and their store names.
Q3 Customer details: Write a query to list all customers with their full names, email, and phone number.
Q4 Product categories: Write a query to count the number of products in each category.
Q5 Orders by customer: Write a query to list the total number of orders placed by each customer.*/
use BikeStores

--Q1 List all products: Write a query to retrieve all product names and their corresponding brand names.

select distinct product_name, pb.brand_name 
from production_brands pb 
join production_products pp 
on pp.brand_id = pb.brand_id

--Q2 Find active staff: Write a query to find all active staff members and their store names.
select concat(ss.first_name, ss.last_name) as Full_name, ss.active 
as active_status, s.store_name as store_name from sales_staffs ss 
join sales_stores s on ss.store_id = s.store_id
where ss.active = 1

select * from sales_staffs

--Q3 Customer details: Write a query to list all customers with their full names, email, and phone number.
select * from sales_customers

select concat(sc.first_name,' ', sc.last_name) as 'Full_name', sc.email as email, sc.phone as phone from sales_customers sc

--Q4 Product categories: Write a query to count the number of products in each category.

select c.category_name as 'Name', count(p.product_id) as 'Count of Product' 
from production_categories c 
join production_products p 
	on p.category_id = c.category_id
group by c.category_name

--Q5 Orders by customer: Write a query to list the total number of orders placed by each customer.

select c.customer_id, 
concat(c.first_name,' ', c.last_name) as 'Customer_Name', 
count(o.order_id ) as order_count
from sales_customers c 
join sales_orders o 
	on c.customer_id = o.customer_id
group by c.customer_id, concat(c.first_name,' ', c.last_name)
order by concat(c.first_name,' ', c.last_name)


/*Intermediate SQL Questions¶
Total sales per product: Write a query to calculate the total sales amount for each product (considering quantity, list price, and discount).
Orders by status: Write a query to count the number of orders for each order status.
Customer orders: Write a query to list all customers who have placed at least one order, including their full name and total number of orders.
Stock availability: Write a query to find the total quantity of each product available in all stores.
Revenue by store: Write a query to calculate the total revenue generated by each store.*/

--Ques 1 Total sales per product: Write a query to calculate the total sales amount for each product (considering quantity, list price, and discount).
select 
oi.product_id as Product_id, 
p.product_name as Product_name, 
oi.quantity as Unit_sold, 
oi.list_price as List_price, 
oi.discount as Discount,
oi.list_price*(1 - oi.discount) as Discounted_price,
sum(sum(oi.list_price*(1 - oi.discount)) * oi.quantity) over(Partition By oi.product_id) as Total_Sales
from sales_order_items oi join production_products p 
on oi.product_id = p.product_id
group by oi.product_id, p.product_name, oi.quantity, oi.list_price, oi.discount, oi.list_price*(1 - oi.discount)
order by oi.product_id asc

--Ques 2 Orders by status: Write a query to count the number of orders for each order status.
select o.order_status, count(o.order_id) as No_od_Order from sales_orders o
group by o.order_status
order by order_status

--Ques 3 Customer orders: Write a query to list all customers who have 
--placed at least one order, including their full name and total number of orders.
select c.customer_id as 'Id', concat(c.first_name, ' ', c.last_name) as Name_of_customer, COUNT(o.order_id) as number_of_order  from sales_customers c join sales_orders o on c.customer_id = o.customer_id
group by c.customer_id, concat(c.first_name, ' ', c.last_name)
having COUNT(o.order_id) >= 1
order by c.customer_id


--Ques 4 Stock availability: Write a query to find the total quantity of each product available in all stores.

select * from sales_stores
select ps.product_id, pp.product_name, sum(ps.quantity) from production_stocks ps
join production_products pp on pp.product_id = ps.product_id 
group by ps.product_id, pp.product_name

--ques 5 Revenue by store: Write a query to calculate the total revenue generated by each store.
select o.store_id, sum((oi.list_price * (1 - oi.discount)) * OI.quantity) as total_income
from sales_order_items oi inner join sales_orders o on oi.order_id = o.order_id
group by o.store_id
order by o.store_id

--Advanced Question
/*
Ques 1 Monthly sales analysis: Write a query to calculate the total sales amount for each month.
Ques 2 Top customers: Write a query to find the top 5 customers who have spent the most money.
Ques 3 Employee hierarchy: Write a query to list all staff members along with their managers' names.
Ques 4 Product performance: Write a query to determine which products have the highest sales volume in the current year.
Ques 5 Customer location analysis: Write a query to count the number of customers in each city and state.*/

-- Ques 1 Monthly sales analysis: Write a query to calculate the total sales amount for each month.
select year(o.order_date) as Year, MONTH(o.order_date) as Month, sum((oi.list_price * (1 - oi.discount)) * OI.quantity) as Month_total_sale  
from sales_orders o inner join sales_order_items oi on o.order_id = oi.order_id
group by year(o.order_date), MONTH(o.order_date)
order by Year(o.order_date), MONTH(o.order_date)

--Ques 2 Top customers: Write a query to find the top 5 customers who have spent the most money.
select top 5 * from (select c.customer_id as customer_id,
concat(c.first_name , ' ', c.last_name) as Name_of_customer,
sum(sum((oi.list_price * (1 - oi.discount)) * OI.quantity)) over(partition by c.customer_id) as total_spending
from sales_customers c inner join sales_orders o on c.customer_id = o.customer_id
inner join sales_order_items oi on oi.order_id = o.order_id
group by c.customer_id,
concat(c.first_name , ' ', c.last_name)) t
order by t.total_spending desc

-- Ques 3 Employee hierarchy: Write a query to list all staff members along with their managers' names. 

select * from sales_staffs
select s1.staff_id as Staff_id,
concat(s1.first_name, ' ', s1.last_name) as Employee_name, 
concat(s2.first_name, ' ', s2.last_name) as Manager_name,
s1.manager_id as manager_id from sales_staffs s1
left Join sales_staffs s2 on s1.manager_id = s2.staff_id

--Ques 4 Write a query to determine which products have the highest sales volume in 2018.
select oi.product_id ,Year(o.order_date) as order_year, p.product_name, sum(oi.quantity) 
from sales_order_items oi 
join production_products p on p.product_id = oi.product_id
join sales_orders o on oi.order_id = o.order_id
WHERE YEAR(o.order_date) = 2018 
group by oi.product_id ,Year(o.order_date), p.product_name 
order by sum(oi.quantity) desc 

-- Ques 5 Customer location analysis: Write a query to count the number of customers in each city and state.*/
select c.City, c.state,
count(c.customer_id) as Total_customer, 
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales,
Max(oi.quantity * oi.list_price * (1 - oi.discount)) AS Max_sale, 
Avg(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_sales
from sales_customers c join sales_orders o on c.customer_id = o.customer_id
join sales_order_items oi on o.order_id = oi.order_id
group by city, state
order by total_sales desc

