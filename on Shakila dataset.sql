use Shakila
--Ques 1 How many total customers are there, and how many stores does Sakila DVD Rental operate?
select count(distinct customer_id ) as Customr_count from customer
union all
select count(distinct store_id) as Store_count from store

-- Ques 2 find films whoch are recently rented?
select top 5 t3.title as movie, count(t3.title) as rented_count 
from inventory t1 
left join rental t2 on t1.inventory_id = t2.inventory_id
left join film t3 on t1.film_id = t3.film_id
group by t3.title
order by count(t3.title) desc

--Ques 3 how many films are available in each rating category (G, PG, PG-13, etc.)
select rating, count(film_id) from film
group by rating
order by count(film_id) desc

--Ques 4 Which actors appear in the most films?
select concat(a.first_name, ' ', a.last_name) as actor_name, count(fa.actor_id) as No_of_film 
from film_actor fa
 join film f on f.film_id = fa.film_id
inner join actor a on a.actor_id = fa.actor_id
group by concat(a.first_name, ' ', a.last_name)
order by count(fa.actor_id) desc

--Ques 5 What is the distribution of film rental rates in the inventory?
select * from inventory
select * from film

SELECT 
    rental_rate AS rates, 
   COUNT(film_id) AS total_film_count 
FROM 
    film
GROUP BY 
    rental_rate;
--------------------------------------------------------
SELECT 
    rental_rate AS rates, 
    concat((CAST(COUNT(film_id) * 100.0 / (SELECT COUNT(*) FROM film) AS FLOAT)), '%') AS percentage_of_film
FROM 
    film
GROUP BY 
    rental_rate;

-- Ques 6 What is the average rental duration, average length of movies and amount spent per customer?
select r.customer_id, 
round(AVG(f.rental_duration),2), 
round(avg(f.length), 2), 
round(avg(p.amount),2) 
from film f
left join inventory i on i.film_id = f.film_id
left join rental r on f.film_id = r.rental_id
left join payment p on p.customer_id = r.rental_id
where r.customer_id = 187
group by r.customer_id

--Ques 7 Which cities and countries generate the most revenue?

select top 1 ci.city, sum(p.amount) from address a
join customer c on c.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join rental r on r.customer_id = c.customer_id
join payment p on p.customer_id = c.customer_id
group by ci.city;


select top 1 co.country, sum(p.amount) from address a
join customer c on c.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id
join rental r on r.customer_id = c.customer_id
join payment p on p.customer_id = c.customer_id
group by co.country;


--Ques 8 What is the monthly revenue trend throughout the available time period?
select concat(year(r.rental_date), '-', month(r.rental_date)) as month, sum(p.amount) as amount_trend from rental r 
join payment p on p.customer_id = r.customer_id
group by concat(year(r.rental_date), '-', month(r.rental_date))
order by concat(year(r.rental_date), '-', month(r.rental_date)) asc

--Ques 9 How many rentals do customers make on average, and what's the distribution?
select CONCAT(YEAR(rental_date),'-', MONTH(rental_date)),
        round(count(distinct rental_id)*1.0/count(distinct customer_id), 2) as avg_rental
from rental
group by CONCAT(YEAR(rental_date),'-', MONTH(rental_date))
order by CONCAT(YEAR(rental_date),'-', MONTH(rental_date)) asc

--Ques 10 Which customers are most valuable based on their rental frequency and total spending?
SELECT
top 5
c.customer_id as cus_id,
concat(c.first_name, ' ', c.last_name) as name, 
count(r.rental_id) as rental_freq, 
sum(p.amount) as total_spending
FROM customer C 
JOIN payment p on p.customer_id = c.customer_id
join rental r on r.customer_id = c.customer_id
group by c.customer_id, concat(c.first_name, ' ', c.last_name)
order by count(r.rental_id) desc

--Ques 11 What are the peak rental periods (time of day, month) that might indicate seasonal patterns?

select concat(year(rental_date),':',month(rental_date)) as period, 
count(rental_id) as count_id
from rental
group by concat(year(rental_date),':',month(rental_date))

select * from rental

--hour

SELECT FORMAT(rental_date, 'HH') AS hour, 
       COUNT(*) AS count_id
FROM rental
GROUP BY FORMAT(rental_date, 'HH')
order by COUNT(*) desc









