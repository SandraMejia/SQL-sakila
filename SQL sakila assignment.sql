-- SQL Assignment
-- Sandra Mejia Avendaño

USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor; 

-- 1b. Display the first and last name of each actor in a single column in 
-- upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor_Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would 
-- you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, 
-- order the rows by last name and first name, in that order:
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the 
-- following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you 
-- will be performing queries on a description, so create a column in the 
-- table actor named description and use the data type BLOB (Make sure to 
-- research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is 
-- too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS 'Count'
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS 'Count'
FROM actor
GROUP BY last_name
HAVING Count >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
-- GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that 
-- GROUCHO was the correct name after all! In a single query, if the first name of 
-- the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name = 'GROUCHO' WHERE first_NAME = 'HARPO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, 
-- of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff AS s
LEFT JOIN address AS a
ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in 
-- August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff AS s
LEFT JOIN payment AS p
ON s.staff_id = p.staff_id
WHERE YEAR(p.payment_date) = '2005'
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(a.film_id) AS 'Actor Count'
FROM film AS f
INNER JOIN film_actor AS a
ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(i.film_id)
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total 
-- paid by each customer. List the customers alphabetically by last name:
SELECT c.last_name, c.first_name, SUM(p.amount) AS 'Total paid'
FROM customer AS c
JOIN payment as p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also 
-- soared in popularity. Use subqueries to display the titles of movies starting with 
-- the letters K and Q whose language is English.
SELECT f.title 
	FROM film AS f
	WHERE f.title LIKE 'k%' OR f.title LIKE 'q%'
	AND f.language_id IN 
		(SELECT l.language_id 
        FROM language AS l 
        WHERE l.language_id = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name, a.last_name
	FROM actor AS a
    WHERE a.actor_id IN 
		(SELECT fa.actor_id
			FROM film_actor AS fa
            WHERE fa.film_id IN
				(SELECT f.film_id 
                FROM film AS f
                WHERE f.title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the 
-- names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, country.country
	FROM customer
	JOIN address
	ON customer.address_id = address.address_id
	JOIN city
	ON address.city_id = city.city_id
	JOIN country
	ON city.country_id = country.country_id
	WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family 
-- movies for a promotion. Identify all movies categorized as family films.
SELECT film.title, category.name
	FROM film
	JOIN film_category
	ON film.film_id = film_category.film_id
	JOIN category
	ON film_category.category_id = category.category_id
	WHERE category.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS 'Rental_count'
	FROM rental AS r
	JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	JOIN film as f
	ON f.film_id = i.film_id
	GROUP BY f.title
	ORDER BY Rental_count DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS 'total'
	FROM payment AS p
	JOIN rental AS r
	ON p.rental_id = r.rental_id
	JOIN inventory i
	ON i.inventory_id = r.inventory_id
	JOIN store s
	ON s.store_id= i.store_id 
	GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
	FROM store
	JOIN address
	ON store.address_id = address.address_id
	JOIN city
	ON address.address_id = city.city_id
	JOIN country
	ON city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name AS 'Category', SUM(payment.amount) AS 'Total'
	FROM category
	JOIN film_category
	ON film_category.category_id = category.category_id
	JOIN inventory
	ON film_category.film_id = inventory.film_id
	JOIN rental
	ON inventory.inventory_id = rental.inventory_id
	JOIN payment
	ON rental.rental_id = payment.rental_id
	GROUP BY category.name
	ORDER BY Total DESC
	LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. Use the solution from the problem above to 
-- create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW total_per_genre AS
	SELECT category.name AS 'Category', SUM(payment.amount) AS 'Total'
	FROM category
	JOIN film_category
	ON film_category.category_id = category.category_id
	JOIN inventory
	ON film_category.film_id = inventory.film_id
	JOIN rental
	ON inventory.inventory_id = rental.inventory_id
	JOIN payment
	ON rental.rental_id = payment.rental_id
	GROUP BY category.name
	ORDER BY Total DESC
	LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM total_per_genre;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW total_per_genre;