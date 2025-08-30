-- Basic

--List all Product names along with their List Prices.
use AdventureWorksLT2022
select name, listPrice from SalesLT.Product

--Retrieve the full names and and id of all Customers.
select concat(FirstName, MiddleName, LastName) as name_of_customer, CustomerID from SalesLT.Customer

--Show all customers living in the state of Washington.

select * from SalesLT.CustomerAddress c left Join SalesLT.Address a on c.AddressID = a.AddressID
where a.StateProvince = 'Washington'

--Display the names and email addresses of all customer
select concat(FirstName, MiddleName, LastName) as name_of_customer, EmailAddress from SalesLT.Customer

--Retrieve the top 10 most expensive products.

select Top 10 Name as 'Product Name', sum(ListPrice) as 'Cost of a Product'
from SalesLT.Product
group by Name
order by 'Cost of a Product' desc

--List all number of customer in particular postal code
select a.PostalCode, count(c.customerid) as 'No. of customer' 
from SalesLT.Address a 
left join SalesLT.Customer c on a.AddressID = c.CustomerID
group by a.PostalCode
having count(c.customerid) != 0
order by count(c.customerid) desc

--Show the first 20 records from the SalesOrderHeader table.
select Top 20 * 
from SalesLT.SalesOrderHeader

--extract number of cities in a particular state and sort it in desc order
select StateProvince, count(city) 
from SalesLT.Address
group by StateProvince
order by count(city) desc

--Get a list of sales from SalesOrderHeader
select * from SalesLT.SalesOrderHeader


-- Intermediate 
--List all products along with their category names.
select p.name as product_name, po.name as category_name
from SalesLT.Product p 
left join SalesLT.ProductCategory po 
	on p.ProductCategoryID = po.ProductCategoryID

--Count how many products are there in each subcategory.

select po.name, count(p.ProductCategoryID) as number_of_product
from SalesLT.Product p 
left join SalesLT.ProductCategory po 
	on p.ProductCategoryID = po.ProductCategoryID
group by po.name

--Get the total number of orders placed by each customer.
SELECT 
c.CustomerID AS Customer_id,
CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
COUNT(s.SalesOrderID) AS Number_of_Orders
FROM SalesLT.Customer c
LEFT JOIN SalesLT.SalesOrderHeader s 
  ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY Number_of_Orders DESC;

--Show the average list price of products by category.
select pc.ProductCategoryID as Product_id, pc.Name as Name, AVG(ListPrice) as average_list_price
from SalesLT.Product p inner join SalesLT.ProductCategory pc
ON P.ProductCategoryID = PC.ProductCategoryID
GROUP BY pc.ProductCategoryID, pc.Name
ORDER BY AVG(ListPrice) desc

--Find the top 5 customers by total sales amount.
select top 5 c.CustomerID as Customer_Id, concat(c.FirstName,c.MiddleName,c.LastName) as name_of_customer, sum(sd.OrderQty*sd.UnitPrice) as total_sales_amount 
from SalesLT.SalesOrderHeader oh 
join SalesLT.Customer c 
	ON oh.CustomerID = c.CustomerID
left join SalesLT.SalesOrderDetail sd 
	on sd.SalesOrderID = oh.SalesOrderID
group by c.CustomerID, concat(c.FirstName,c.MiddleName,c.LastName)
order by total_sales_amount desc

--Show the total sales made by each employee.
select c.SalesPerson as name_of_sales_person, sum(sd.OrderQty*sd.UnitPrice) as total_sales_amount 
from SalesLT.SalesOrderHeader oh 
join SalesLT.Customer c 
	ON oh.CustomerID = c.CustomerID
left join SalesLT.SalesOrderDetail sd 
	ON sd.SalesOrderID = oh.SalesOrderID
group by c.SalesPerson
order by total_sales_amount desc

--List the product name, sales order ID, and quantity sold.
select p.Name, sod.SalesOrderID, OrderQty from SalesLT.Product p 
left join SalesLT.SalesOrderDetail sod 
on p.ProductID = sod.ProductID
where sod.SalesOrderID is not null and OrderQty is not null


--Find all customers who have not placed any orders.
select CustomerID, concat(FirstName, ' ', MiddleName, ' ', LastName) as name_of_customer  from SalesLT.Customer
where CustomerID not in (select CustomerID from saleslt.SalesOrderHeader)

/*Absolutely! Here's a simplified version of each query's purpose, written in easy-to-understand language:*/

--Show how much total money we made from sales each year.
select year(orderdate) as Year_of_Purchase, sum(OrderQty*UnitPrice) as total_profit
from SalesLT.SalesOrderDetail sod 
left join SalesLT.SalesOrderHeader soh 
on sod.SalesOrderID = soh.SalesOrderID
group by year(orderdate)

--Find the product that was sold in the highest quantity overall.
use AdventureWorksLT2022
select top 1  productid, sum(orderqty) as number_of_quantity_sold
from SalesLT.salesorderDetail
group by productid
order by number_of_quantity_sold desc

--Show which salesperson helped make the most money from sales.
SELECT top 1
c.SalesPerson AS Salesperson,
SUM(soh.TotalDue) AS TotalSales
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE c.SalesPerson IS NOT NULL
GROUP BY c.SalesPerson
ORDER BY TotalSales DESC

--Show the latest 5 orders from customers who live in California.
SELECT TOP 5 soh.SalesOrderID,soh.OrderDate,c.CustomerID,a.City,a.StateProvince
FROM SalesLT.SalesOrderHeader soh
JOIN SalesLT.Customer c ON soh.CustomerID = c.CustomerID
JOIN SalesLT.CustomerAddress ca ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address a ON ca.AddressID = a.AddressID
WHERE a.StateProvince = 'California'
ORDER BY soh.OrderDate DESC;
--Show how much money we made in sales each month over the past month.
SELECT Month(OrderDate) AS Month, SUM(TotalDue) AS MonthlySales
FROM SalesLT.SalesOrderHeader
GROUP BY Month(OrderDate)
ORDER BY Month;

--List the products that were never included in any customer order.
SELECT p.ProductID, p.Name
FROM SalesLT.Product p
LEFT JOIN SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

--Find if there are any product names that are repeated in the product list.

SELECT Name, COUNT(*) AS NameCount
FROM SalesLT.Product
GROUP BY Name
HAVING COUNT(*) > 1;

--Show the top 3 product categories that earned the most money from sales.

SELECT TOP 3 pc.Name AS CategoryName, SUM(sod.OrderQty * sod.UnitPrice) AS TotalRevenue
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
JOIN SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY pc.Name
ORDER BY TotalRevenue DESC;

--For each product, show its name and the description connected to it.
SELECT p.Name AS ProductName,pd.Description
FROM SalesLT.Product p 
JOIN SalesLT.ProductModel pm ON p.ProductModelID = pm.ProductModelID
JOIN SalesLT.ProductModelProductDescription pm_pd ON pm.ProductModelID = pm_pd.ProductModelID
JOIN SalesLT.ProductDescription pd ON pm_pd.ProductDescriptionID = pd.ProductDescriptionID;

--Show full customer names, order IDs, and order amounts for orders worth more than \$5,000.
SELECT concat(c.FirstName,' ',c.LastName) AS CustomerName,soh.SalesOrderID,soh.TotalDue
FROM SalesLT.SalesOrderHeader soh
JOIN SalesLT.Customer c ON soh.CustomerID = c.CustomerID
WHERE soh.TotalDue > 5000
ORDER BY soh.TotalDue DESC;