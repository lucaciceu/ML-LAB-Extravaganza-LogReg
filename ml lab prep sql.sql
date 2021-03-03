-- ML Lab Extravaganza
-- We will be trying to predict if a customer will be renting a film this month based on their previous activity and other details. We will first construct a table with:
/*Customer ID - customer
City - city
Most rented film category - film_category
Total films rented - rental_id from rental
Total money spent - amount from payment
How many films rented last month (MAY/2005) - monthdate(rental.rental_date) from rental
If the customer rented a movie this month (JUNE/2005) - rental
Once you extract that information, and any other that seems fit, predict which customers will be renting this month.
customer c
city_id a
city ci
film_category fc
rental r
inventory i
payment p*/

select distinct customer_id from customer;
select * from rental
where customer_id = 130;

select * from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on c.customer_id = p.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id;


 -- c.category_id as 'most_rented_categ'
select c.customer_id, ci.city, sum(p.amount) as "total_amount_paid", count_movies, max(count_movies) over (partition by customer_id order by 'count_movies'), count(r.rental_id) as 'times_renting', june_rentals, coalesce(may_rentals, 0) as 'may_rentals' from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on r.rental_id= p.rental_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
-- where category_id = select * from (count(film_id) from film_category group by category_id)
left join (select rental_id, count(rental_id) as 'may_rentals'
from rental
where monthname(rental_date) = 'May' 
group by customer_id) mr on r.rental_id = mr.rental_id
join (select *, case when (count(rental_id) > 1 and monthname(rental_date) = 'June') then 1 else 0
end as 'june_rentals'
from rental
group by customer_id) jr on r.rental_id = jr.rental_id
left join (select c.customer_id, count(cat.category_id), cat.category_id as 'count_movies'from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id, cat.category_id) tm on c.customer_id = tm.customer_id
group by c.customer_id;

select c.customer_id, ci.city, sum(p.amount) from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on c.customer_id = p.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
-- where category_id = select * from (count(film_id) from film_category group by category_id)
-- where r.rental_id in (select r.rental_id where monthname(r.rental_date) = 'May')
group by c.customer_id;

select count(rental_id) from rental where monthname(rental_date) = 'May';
select count(rental_date) from rental where monthname(rental_date) = 'May';

select film_id, category_id from film_category
group by category_id;
-- WHERE category_id_count = (SELECT distinct category_id FROM category);

select category_id, count(film_id) from film_category
group by category_id;

select count(rental_id) as 'may_rentals'
from rental
where monthname(rental_date) >= 'May';
-- group by customer_id

select sum(total) from (select *, case when (count(rental_id) >= 1 and monthname(rental_date) = 'May') then count(rental_id) else 0 end as total
from rental group by customer_id) as SUM;


select * from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on c.customer_id = p.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
join (select *, case when (count(rental_id) > 1 and monthname(rental_date) = 'June') then 1 else 0
end as 'june_rentals'
from rental
group by customer_id) jr on r.rental_id = jr.rental_id
group by c.customer_id;


select c.customer_id, count(cat.category_id) as 'count_movies', cat.category_id, rank() over (partition by customer_id order by 'count_movies') from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id, cat.category_id;

select c.customer_id, count(cat.category_id), cat.category_id from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id, cat.category_id
order by c.customer_id, count(cat.category_id) desc;

select c.customer_id, ci.city, sum(p.amount) as "total_amount_paid", favorite_categ, count(r.rental_id) as 'times_renting', june_rentals, coalesce(may_rentals, 0) as 'may_rentals' from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on r.rental_id= p.rental_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
-- where category_id = select * from (count(film_id) from film_category group by category_id)
left join (select rental_id, count(rental_id) as 'may_rentals'
from rental
where monthname(rental_date) = 'May' 
group by customer_id) mr on r.rental_id = mr.rental_id
join (select *, case when (count(rental_id) > 1 and monthname(rental_date) = 'June') then 1 else 0
end as 'june_rentals'
from rental
group by customer_id) jr on r.rental_id = jr.rental_id
left join (select c.customer_id, count(cat.category_id), cat.category_id as 'favorite_categ' from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id, cat.category_id
order by c.customer_id, count(cat.category_id) desc) tm on c.customer_id = tm.customer_id
group by c.customer_id;

select *, count(rental_id), case when (count(rental_id) >= 1 and monthname(rental_date) = 'June') then 1 else 0
end as 'june_rentals' from rental
where monthname(rental_date) = 'June'
group by customer_id;

select distinct customer_id from customer;

select * from rental where monthname(rental_date) = 'June' group by customer_id;
select *, count(rental_id) from rental where monthname(rental_date) = 'June' group by customer_id;
select * from rental where customer_id = 4;

select customer_id, count(*) rental_date
from rental
where monthname(rental_date) = 'June'
group by customer_id
;


explain with cte as (select customer_id, count(*) rental_date
from rental
group by customer_id)
select customer_id,
case rental_date
	when monthname(rental_date) = 'June' then 'bought'
    else 'did not'
    end june_rentals
from cte
order by customer_id;

select *, 
case 
	when sum(monthname(rental_date) = 'June') > 0 then 1 
    else 0
end as 'june_rentals'
from rental
group by customer_id;

select customer_id, sum(case when monthname(rental_date) = 'June' then 1 else 0 end) as june_transactions
from rental
group by customer_id;

select customer_id, rental_id, sum(case when monthname(rental_date) = 'June' then 1 else 0 end) as june_rentals
from rental
group by customer_id;

explain select c.customer_id, ci.city, sum(p.amount) as "total_amount_paid", favorite_categ, count(r.rental_id) as 'times_renting', coalesce(june_rentals, 0), coalesce(may_rentals, 0) as 'may_rentals' from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on r.rental_id= p.rental_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
-- where category_id = select * from (count(film_id) from film_category group by category_id)
left join (select customer_id, rental_id, count(rental_id) as 'may_rentals'
from rental
where monthname(rental_date) = 'May' 
group by customer_id) mr on r.rental_id = mr.rental_id
join (select *, count(rental_id), case when (count(rental_id) >= 1 and monthname(rental_date) = 'June') then 1 else 0
end as 'june_rentals' from rental
where monthname(rental_date) = 'June'
group by customer_id) jr on r.rental_id = jr.rental_id
left join (select c.customer_id, count(cat.category_id), cat.category_id as 'favorite_categ' from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id, cat.category_id
order by c.customer_id, count(cat.category_id) desc) tm on c.customer_id = tm.customer_id
group by c.customer_id;

select c.customer_id, ci.city, sum(p.amount) as "total_amount_paid", favorite_categ, count(r.rental_id) as 'times_renting', june_rentals, coalesce(may_rentals, 0) as 'may_rentals' from customer c -- c.customer_id, ci.city, max(count(fc.film_category)), sum(p.amount), count(rental_id) from rentals_june where monthname(rental_date) = 'May' as 'May_rentals', case (when monthname(rental_date) as'June' then 1 else 0 from customer)) end as 'June_rentals' from customer c
left join rental r on c.customer_id = r.customer_id
left join address a on c.address_id = a.address_id
left join city ci on a.city_id = ci.city_id
left join payment p on r.rental_id= p.rental_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
-- where category_id = select * from (count(film_id) from film_category group by category_id)
join (select *, 
case 
	when sum(monthname(rental_date) = 'June') > 0 then 1 
    else 0
end as 'june_rentals'
from rental
group by customer_id) jr on r.customer_id = jr.customer_id
left join (select customer_id, rental_id, count(rental_id) as 'may_rentals'
from rental
where monthname(rental_date) = 'May' 
group by customer_id) mr on r.rental_id = mr.rental_id
left join (select c.customer_id, count(cat.category_id), cat.category_id as 'favorite_categ' from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category cat on fc.category_id = cat.category_id
group by c.customer_id, cat.category_id
order by c.customer_id, count(cat.category_id) desc) tm on c.customer_id = tm.customer_id
group by c.customer_id;