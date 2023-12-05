/*
Challenge 1
You need to use SQL built-in functions to gain insights relating to the duration of movies:

1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
1.2. Express the average movie duration in hours and minutes. Don't use decimals.
Hint: Look for floor and round functions.

You need to gain insights related to rental dates:
2.1 Calculate the number of days that the company has been operating.
Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
Hint: use a conditional expression.
You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
Hint: Look for the IFNULL() function.
Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.

Challenge 2
Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
1.1 The total number of films that have been released.
1.2 The number of films for each rating.
1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
Using the film table, determine:
2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
Bonus: determine which last names are not repeated in the table actor.

*/

use sakila;

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.

SELECT min(length) as min_duration, max(length) as max_duration
FROM sakila.film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions.

SELECT CONCAT(floor(AVG(length) / 60), ':', FLOOR(AVG(length) % 60)) as average_duration
FROM sakila.film;


-- You need to gain insights related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.

SELECT DATEDIFF(max(rental_date), min(rental_date)) as number_operating_days
FROM sakila.rental; -- 266 days

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.


SELECT *, DAYNAME(rental_date) as rental_day, MONTHNAME(rental_date) as rental_month
FROM sakila.rental
LIMIT 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.

SELECT *, DAYNAME(rental_date) as RENTAL_DAY, MONTHNAME(rental_date) as RENTAL_MONTH, 
CASE
WHEN DAYNAME(rental_date) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'workday'
WHEN DAYNAME(rental_date) IN ('Saturday', 'Sunday') THEN 'weekend'
END as DAY_TYPE
FROM sakila.rental
WHERE DAYNAME(rental_date) NOT IN ('Saturday','Sunday')
LIMIT 20;

-- You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. 
-- If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

SELECT title as film_title, IFNULL(rental_duration, "Not Available") as rental_duration
FROM sakila.film
ORDER BY title ASC;


-- Challenge 2
-- Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

SELECT COUNT(DISTINCT(title)) as total_number_of_movies
FROM sakila.film; -- 1000 total movies released

-- 1.2 The number of films for each rating.
SELECT COUNT(title) as num_movies, rating
FROM sakila.film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

SELECT COUNT(title) as num_movies, rating
FROM sakila.film
GROUP BY rating
ORDER BY 1 DESC;


-- Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.

SELECT ROUND(AVG(length), 2) as average_movie_duration, rating
FROM sakila.film
GROUP BY 2
ORDER BY 1 DESC;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
SELECT ROUND(AVG(length), 2) as average_movie_duration, rating
FROM sakila.film
GROUP BY 2
HAVING average_movie_duration > 120
ORDER BY 1 DESC;

-- Bonus: determine which last names are not repeated in the table actor.
SELECT last_name, COUNT(1) as total_count
FROM sakila.actor
GROUP BY 1
HAVING total_count = 1;