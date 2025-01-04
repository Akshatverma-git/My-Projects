use PaintingData

select * from artist
select * from work
select work_id, count(work_id) from work
group by work_id
having count(work_id) > 1

select * from work
where work_id = 181491


select * from museum
select * from canvas_size

--Project
--1) Fetch all the paintings which are not displayed on any museaums?
SELECT 
    w.name AS "PAINTING NAME", 
    a.full_name AS "ARTIST NAME"
FROM 
    work w
LEFT JOIN 
    artist a ON w.artist_id = a.artist_id
WHERE 
    w.museum_id IS NULL;

--2) Are there museuems without any paintings?
select m.museum_id, w.name, m.address, m.city, m.state, m.postal, m.country, m.phone, m.url 
from museum m join work w on w.museum_id = m.museum_id
where m.museum_id is null;

--3) How many paintings have an asking price of more than their regular price?
select * from product_size
where sale_price > regular_price;

--4) How many paintings have an selling price of less than their regular price?
select * from product_size
where sale_price < regular_price;

--5) Identify the paintings whose asking price is less than 50% of its regular price?
select * from product_size 
where sale_price < (0.5*regular_price)

--6) Which canvas size costs the most?

SELECT top 1 c.height, c.width, c.label, p.sale_price
FROM canvas_size c
INNER JOIN product_size p ON cast(c.size_id as bigint) = p.size_id
ORDER BY p.sale_price DESC;

--7) Identify the museums with invalid city information in the given dataset
use PaintingData

select * from museum

select museum_id, city, name, address, ISNUMERIC(city) from museum
where ISNUMERIC(city) >=1

--8) Fetch the top 10 most famous painting subject

select top 10 subject, COUNT(subject) 
from subject
group by subject
order by COUNT(subject) desc

--9) Identify the museums which are open on Sunday or Monday or both. Display museum name, city.
select distinct t.museum_id as id, t.name from (SELECT mh.museum_id, mn.name
FROM museum_hours mh
INNER JOIN museum mn ON mh.museum_id = mn.museum_id
WHERE mh.day IN ('Monday', 'Sunday') AND mh.opens IS NOT NULL) t

--10) How many museums are open every single day?
select t.id, t.name from (select h.museum_id as id, m.name as name, count(h.day) as 'no. of days open' from museum_hours h join museum m on m.museum_id = h.museum_id
group by h.museum_id, m.name
having count(h.day) =7) t

--11) Which museum is open for the longest during a day. Display museum name, state?
select * from museum
where state = 'FL'

select * from museum_hours
where museum_id = 70


select t.museum_id, cast(CONCAT(t.open_hour, ':', t.open_min) as time) as times  from (select museum_id, 
cast(SUBSTRING(opens,1,2) as int)  as 'open_hour', 
cast(SUBSTRING(opens, 4, 2) as int) as 'open_min', 
SUBSTRING(opens, 7, 2) as 'Open_AM_PM',
cast(substring(closee, 1, 2) as int) as 'close_hour',
cast(SUBSTRING(opens, 4, 2) as int) as 'close_min',
SUBSTRING(opens, 7, 2) as 'Close_AM_PM'
from museum_hours) t 

UPDATE museum_hours
SET closee = '08:00:PM'
WHERE museum_id = 73 and day = 'Thusday';

select 
t.museum_id,
case
when t.Open_AM_PM = 'PM' and t.opening_time > 12 then t.opening_time + cast('12:00:00' as time)
else t.opening_time
end as 'In_12_format'
from (select museum_id,
 cast(substring(opens, 1,5 ) as time) as 'opening_time',
 SUBSTRING(opens, 7, 2) as 'Open_AM_PM',
 cast(substring(closee, 1,5 ) as time) as 'closing_time',
 SUBSTRING(closee, 7, 2) as 'close_AM_PM'
from museum_hours) as t


select t.museum_id, cast(CONCAT(t.open_hour, ':', t.open_min, ' ', T.Open_AM_PM) as time) as time  from (select museum_id, 
cast(SUBSTRING(opens,1,2) as int)  as 'open_hour', 
cast(SUBSTRING(opens, 4, 2) as int) as 'open_min', 
SUBSTRING(opens, 7, 2) as 'Open_AM_PM',
cast(substring(closee, 1, 2) as int) as 'close_hour',
cast(SUBSTRING(opens, 4, 2) as int) as 'close_min',
SUBSTRING(opens, 7, 2) as 'Close_AM_PM'
from museum_hours) t 



select top 1 t.museum_id, max(DateDiff(MINUTE, t.open_TIME,t.close_time)) as maxx from (select museum_id, 
CAST(CONCAT(SUBSTRING(opens,1,2), ':',SUBSTRING(opens, 4, 2), ' ', SUBSTRING(opens, 7, 2)) AS TIME)  as 'open_TIME',
CAST(CONCAT(SUBSTRING(closee,1,2), ':',SUBSTRING(closee, 4, 2), ' ', SUBSTRING(closee, 7, 2)) AS TIME)  as 'close_time'
from museum_hours) t
group by t.museum_id
order by maxx desc;

--final ans
select top 1 t.name_of_mu, t.state_of_mu, avg(DateDiff(MINUTE, t.open_TIME,t.close_time)) as maxx from (select mh.museum_id, m.name as name_of_mu, m.state as state_of_mu,
CAST(CONCAT(SUBSTRING(opens,1,2), ':',SUBSTRING(opens, 4, 2), ' ', SUBSTRING(opens, 7, 2)) AS TIME)  as 'open_TIME',
CAST(CONCAT(SUBSTRING(closee,1,2), ':',SUBSTRING(closee, 4, 2), ' ', SUBSTRING(closee, 7, 2)) AS TIME)  as 'close_time'
from museum_hours mh join museum m on m.museum_id = mh.museum_id) t
 group by  t.name_of_mu, t.state_of_mu
 order by maxx desc

-- 12) find the particular longest day ,museum and city,open and close

select top 2 t.name_of_mu as 'Name', t.state_of_mu as 'state', t.day as 'day', t.open_TIME as 'open_time', t.close_time as 'close_time' ,max(DateDiff(MINUTE, t.open_TIME,t.close_time)) as 'duration' from (select mh.day, mh.museum_id, m.name as name_of_mu, m.state as state_of_mu,
CAST(CONCAT(SUBSTRING(opens,1,2), ':',SUBSTRING(opens, 4, 2), ' ', SUBSTRING(opens, 7, 2)) AS TIME)  as 'open_TIME',
CAST(CONCAT(SUBSTRING(closee,1,2), ':',SUBSTRING(closee, 4, 2), ' ', SUBSTRING(closee, 7, 2)) AS TIME)  as 'close_time'
from museum_hours mh join museum m on m.museum_id = mh.museum_id) t
 group by t.name_of_mu,  t.state_of_mu, t.day, t.open_TIME, t.close_time
 order by duration desc

 -- 13) Identify the artists whose paintings are displayed in multiple countries

 select * from artist;
 select * from work;
  select * from museum;

SELECT 
    a.id, 
    a.name, 
    COUNT(DISTINCT a.country) AS country_count
FROM 
    (
    SELECT 
        a.artist_id AS 'id', 
        a.full_name AS 'name',
        m.country AS 'country'
    FROM work w 
    LEFT JOIN artist a 
        ON w.artist_id = a.artist_id
    LEFT JOIN museum m 
        ON w.museum_id = m.museum_id
    ) a
GROUP BY a.id, a.name
having COUNT(DISTINCT a.country) > 1
ORDER BY a.id desc


SELECT 
    a.artist_id, 
    a.full_name, 
    COUNT(DISTINCT m.country) AS country_count
FROM 
    work w
LEFT JOIN artist a 
    ON w.artist_id = a.artist_id
INNER JOIN museum m 
    ON w.museum_id = m.museum_id
GROUP BY 
    a.artist_id, a.full_name
ORDER BY 
    a.artist_id desc; 

--14) Display the country and the city with most no of museums.
select country, city, count(museum_id) as 'no_of_museum' from museum 
group by country, city
order by country desc, count(museum_id)  desc


--15) Identify the artist and the museum where the most expensive and least expensive painting is placed.

--product_size-------- work_id or size_id
--work-----------------  museum_id, artist_id,work_id
--artist------------------artist_id

select t.museum_id, t.artist_id, max(t.sales_price) from (select w.artist_id, a.full_name,  m.museum_id as 'museum_id', max(p.sale_price) as 'sales_price'
from work w
inner join museum m 
			on w.museum_id = m.museum_id
inner join artist a 
			on w.artist_id = a.artist_id
inner join product_size p
			on w.work_id = p.work_id
group by w.artist_id, a.full_name, m.museum_id) t
group by t.museum_id, t.artist_id
order by t.museum_id;
----------------------------------------------------------------------------------------------------------------------------------------------------------
select t.museum_id, t.artist_id, min(t.sales_price) from (select w.artist_id, a.full_name,  m.museum_id as 'museum_id', min(p.sale_price) as 'sales_price'
from work w
inner join museum m 
			on w.museum_id = m.museum_id
inner join artist a 
			on w.artist_id = a.artist_id
inner join product_size p
			on w.work_id = p.work_id
group by w.artist_id, a.full_name, m.museum_id) t
group by t.museum_id, t.artist_id
order by t.museum_id

-- 16) Display the artist name, sale_price, painting name, museum name, museum city and canvas label
select a.full_name as 'name_of_artist', p.sale_price, w.name as 'painting_name' , m.name as 'museum_name', m.city, c.label
from work w 
join artist a 
		on w.artist_id = a.artist_id
join product_size p
        on w.work_id = p.work_id
join museum m
		on w.museum_id = m.museum_id
join canvas_size c 
		on p.size_id = cast(c.size_id as varchar)

--17) Which country has the 5th highest no of paintings
select top 5 * from (SELECT 
    m.country AS Country,
    count(m.country) as count_of_painting,
    row_number() OVER (ORDER BY COUNT(w.work_id) DESC) AS 'ranks'
FROM 
    museum m
JOIN 
    work w ON m.museum_id = w.museum_id
GROUP BY 
    m.country) t
order by t.count_of_painting desc

-- 18) Which are the 3 most popular and 3 least popular painting styles
--top 3 least 
select top 4 w.style, count(w.style) from work w
group by  w.style
order by count(w.style) asc

--top 
select top 3 w.style, count(w.style) from work w
group by  w.style
order by count(w.style) desc

--19) Which artist has the most no of Portraits paintings outside USA?. 
--Display artist name, no of paintings and the artist nationality.
select a.artist_id, a.full_name, count(w.work_id) as 'no_of_painting', a.nationality
from work w 
 inner join artist a 
	on w.artist_id = a.artist_id
 inner join subject s 
	on w.work_id = s.work_id
 inner join museum m on  w.museum_id = m.museum_id
where m.country <> 'USA'  and s.subject  = 'Portraits'
group by a.artist_id, a.full_name, a.nationality
order by artist_id desc 

--20) MOST EARNED BY Museum
select a.artist_id, full_name, sum(sale_price) as total_sale from product_size p join work w on w.work_id = p.work_id
join artist a on w.artist_id = a.artist_id
group by  a.artist_id, full_name
order by sum(sale_price) desc