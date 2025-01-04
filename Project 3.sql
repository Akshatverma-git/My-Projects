
create database chinook

--project question 
/* 
Part 1
1. I will look for employees named Nancy.
2. I will look for employees named Nancy or Andrew.
3. I will look for employees born after 1970.
4. I will count the total number of employees.
5. I will print the tracks from the album with an ID of 65.

Part 2
1. I want to find out what is the total number of customers by employee.
2. I want to know who are the top customers according to their invoices
3. I want to find out what are the albums with the highest number of tracks.
4. Show the artists with the most albums on catalogue
5. Show the countries with the most customers

Part 3
1. Let's find out who are the top listeners of Pop music
2. Find out what is the top selling genre by country*/

use chinook
--1
select * from Employee 
where FirstName = 'Nancy'
--2
select * from Employee 
where FirstName = 'Nancy' or FirstName = 'Andrew'
--3
select * from Employee 
where year(BirthDate) > 1970
--4
select count(distinct Employeeid) as count_of_employee
from Employee
--5
select * from Track 
where AlbumId = 65
order by Milliseconds desc

/*Part 2
1. I want to find out what is the total number of customers by employee.
2. I want to know who are the top customers according to their invoices
3. I want to find out what are the albums with the highest number of tracks.
4. Show the artists with the most albums on catalogue
5. Show the countries with the most customers*/

use chinook 

select concat(e.FirstName, ' ', e.LastName) as EmployeeName, count(c.CustomerId) 
as CustomerCount from Employee e join Customer c on e.EmployeeId = c.SupportRepId
group by concat(e.FirstName, ' ', e.LastName)

select * from Album
select * from Artist

select c.CustomerId,concat(c.FirstName, ' ', c.LastName) as CustomerName, sum(i.Quantity*i.UnitPrice)  as sum_of_amount from Customer c join InvoiceLine i on i.TrackId = c.CustomerId
group by concat(c.FirstName, ' ', c.LastName), c.CustomerId
order by sum_of_amount desc

SELECT top 10 a.Title, ar.Name AS 'Artist_Name', COUNT(t.TrackId) AS 'No_of_Tracks' 
            FROM Album a
            JOIN Track As t ON t.AlbumId = a.AlbumId
            JOIN Artist AS ar ON a.ArtistId = ar.ArtistId
            GROUP BY a.Title, ar.Name
            ORDER BY 3 DESC

select ar.ArtistId, ar.Name, count(an.AlbumId) from Artist ar 
join Album an on ar.ArtistId = an.ArtistId
group by ar.ArtistId,ar.Name
order by count(an.AlbumId) desc

select top 5 country, count(CustomerId) from Customer 
group by Country
order by count(CustomerId) desc

/*Part 3
1. Let's find out who are the top listeners of Pop music
2. Find out what is the top selling genre by country*/

use chinook

select * from Album
select * from Artist
select * from Customer
select * from Employee
select * from Genre
select * from InvoiceLine
select * from MediaType
select * from Playlist
select * from PlaylistTrack

select * from Track
select * from Genre
select * from InvoiceLine

SELECT c.FirstName || ' ' || c.LastName AS 'Customer_Name', g.Name AS 'Genre', 
                             COUNT(il.TrackId) AS 'Number_of_Tracks'
                             FROM Customer c
                             JOIN InvoiceLine AS il ON i.InvoiceId = il.InvoiceId
                             JOIN Track AS t ON il.TrackId = t.TrackId
                             JOIN Genre AS g ON t.GenreId = g.GenreId
                             WHERE g.Name = 'Pop'
                             GROUP BY 1                   
                             ORDER BY 3 DESC
                             LIMIT 10
