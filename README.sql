#This is my HomeWork for SQL with all my queries below created:

HW10 -  README.md
==============================================================================================================

1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
FROM sakila.actor;



1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, '  ', last_name)) AS Actor_Name FROM sakila.actor;



2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM sakila.actor WHERE first_name = "Joe"




2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM sakila.actor
WHERE last_name LIKE '%GEN%';




2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT *   
FROM sakila.actor 
WHERE last_name LIKE '%LI%' 
ORDER BY last_name ASC, first_name




2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM sakila.country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');




3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
USE sakila;
ALTER TABLE actor ADD middle_name VARCHAR(45) NOT NULL FIRST;
SELECT middle_name, first_name, last_name FROM sakila.actor;




3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
SELECT middle_name, first_name, last_name FROM sakila.actor;
ALTER TABLE actor MODIFY COLUMN middle_name Blob;



3c. Now delete the middle_name column.
USE sakila;
SELECT middle_name, first_name, last_name FROM sakila.actor;
ALTER TABLE actor DROP COLUMN middle_name;
SELECT * FROM sakila.actor;



4a. List the last names of actors, as well as how many actors have that last name.
USE sakila;
SELECT last_name, COUNT(last_name) as "Count of Last Names"
FROM sakila.actor
GROUP BY last_name;



4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) as "Count of Last Names"
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2 
ORDER BY COUNT(last_name) ASC;



4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
—First I am making sure this is the correct record, I need to update
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name = 'GROUCHO'
and  last_name = 'WILLIAMS';

— now updating the record with correct info
UPDATE sakila.actor
SET first_name = 'HARPO'
WHERE actor_id = 172;

— Making sure it is updated correctly
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id = 172; 




4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE sakila.actor
SET first_name = CASE 
                    WHEN first_name = 'HARPO' THEN 'GROUCHO'
        	    ELSE 'MUCHO GROUCHO'
		 END
WHERE actor_id = 172;


SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id = 172; 




5a. You cannot locate the schema of the address table. Which query would you use to re-create it? HINT: CHECK THIS OUT
USE sakila;

DESC sakila.address; — to check all the datatypes

SHOW CREATE TABLE sakila.address;

 -- CREATE TABLE `address` (
--   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--   `address` varchar(50) NOT NULL,
--   `address2` varchar(50) DEFAULT NULL,
--   `district` varchar(20) NOT NULL,
--   `city_id` smallint(5) unsigned NOT NULL,
--   `postal_code` varchar(10) DEFAULT NULL,
--   `phone` varchar(20) NOT NULL,
--   `location` geometry NOT NULL,
--   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   PRIMARY KEY (`address_id`),
--   KEY `idx_fk_city_id` (`city_id`),
--   SPATIAL KEY `idx_location` (`location`),
--   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8





6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name,  s.last_name, a.address
FROM address a 
INNER JOIN staff s
WHERE  a.address_id = s.address_id



6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT  SUM(p.amount) as "Total Amount"
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY p.payment_date LIKE '2005-08-%_%_';

SELECT  first_name, last_name, SUM(amount) as "Total Amount"
FROM staff s
INNER JOIN payment p  USING (staff_id) -- equivalent to where s.staff_id = p.staff_id
GROUP BY p.staff_id
ORDER by last_name ASC




6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 — List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 
 SELECT title, COUNT(a.actor_id) as "Number of actors"
 FROM film f
 INNER JOIN film_actor a
 ON f.film_id = a.film_id
 GROUP BY title;



6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id) as "Number of film"
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible"




6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
    ![Total amount paid](Images/total_payment.png)


SELECT last_name, first_name, SUM(amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;



7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select title
from film 
where language_id IN
(  
 select language_id
 from  language 
 where name = 'English')
 and (title like 'k%')
 or (title like 'q%');




7b. Use subqueries to display all actors who appear in the film Alone Trip.

select f.title, a.first_name, a.last_name
from film f, actor a, film_actor fa
where f.film_id = fa.film_id
and fa.actor_id = a.actor_id
and f.title = "Alone Trip";


select first_name, last_name
from actor
where actor_id in
( 
 select actor_id
 from film_actor
 where film_id in
 (
  select film_id
  from  film
  where title = "Alone Trip"
  )
); 




7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select cu.first_name, cu.last_name, cu.email, a.address, ci.city, co.country
 from customer cu
 inner join  address a
 on cu.address_id = a.address_id
 inner join  city ci
 on a.city_id = ci.city_id
 inner join  country co
 on ci.country_id = co.country_id
 where country in ('canada');

select cu.first_name, cu.last_name, cu.email, a.address, ci.city, co.country
 from customer cu
 right join  address a
 on cu.address_id = a.address_id
 right join  city ci
 on a.city_id = ci.city_id
 right join  country co
 on ci.country_id = co.country_id
 where country = 'Canada';

select cu.first_name, cu.last_name, cu.email, a.address, ci.city, co.country
 from customer cu
 left join  address a
 on cu.address_id = a.address_id
 left join  city ci
 on a.city_id = ci.city_id
 left join  country co
 on ci.country_id = co.country_id
 where country = 'Canada';

select first_name, last_name, email, address, city, country
 from customer cu, country co, address a, city ci
 WHERE cu.address_id = a.address_id
 and a.city_id = ci.city_id
 and ci.country_id = co.country_id
 and country = 'Canada' ;



7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

select title, name
from film ,film_category, category
where film.film_id = film_category.film_id
and film_category.category_id = category.category_id
and category.name = 'Family'
order by name DESC;

SELECT title, category
FROM film_list
WHERE category = 'Family';




7e. Display the most frequently rented movies in descending order.

SELECT i.film_id, f.title, COUNT(r.inventory_id)
FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f 
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;




7f. Write a query to display how much business, in dollars, each store brought in.
select st.store_id, concat('$',format(sum(amount),2)) as total_business
from store st
join customer c
using (store_id)
join payment  p
on (c.customer_id = p.customer_id)
group by (st.store_id);  



7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, st.first_name as "Manager_first_name", st.last_name as "Manager_last_name" , ci.city, co.country
FROM store s
INNER JOIN customer cu
ON s.store_id = cu.store_id
INNER JOIN staff st
ON s.store_id = st.store_id
INNER JOIN address a
ON cu.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id




7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select ca.name, concat('$',format(sum(amount),2))  as "Revenue-Top_5_genres"
from category ca
inner join film_category fc
on ca.category_id = fc.category_id
inner join inventory i
on fc.film_id = i.film_id
inner join rental r
on r.inventory_id = i.inventory_id
inner join payment p
on p.rental_id = r.rental_id
group by ca.name
order by SUM(p.amount) DESC
LIMIT 5;




8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW View_Revenue_Top_5_genres AS
select ca.name, concat('$',format(sum(amount),2)) as  "Revenue-Top_5_genres"
from category ca
inner join film_category fc
on ca.category_id = fc.category_id
inner join inventory i
on fc.film_id = i.film_id
inner join rental r
on r.inventory_id = i.inventory_id
inner join payment p
on p.rental_id = r.rental_id
group by ca.name
order by SUM(p.amount) DESC
LIMIT 5;



8b. How would you display the view that you created in 8a?

SELECT * FROM View_Revenue_Top_5_genres



8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW  View_Revenue_Top_5_genres
SELECT * FROM View_Revenue_Top_5_genres


 11:28:29	SELECT * FROM View_Revenue_Top_5_genres LIMIT 0, 50000	Error Code: 1146. Table 'sakila.view_revenue_top_5_genres' doesn't exist	0.00033 sec


===========================================================================================================





