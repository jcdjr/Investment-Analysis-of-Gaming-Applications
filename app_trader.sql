SELECT COUNT(*)
FROM app_store_apps

SELECT COUNT(*)
FROM play_store_apps

SELECT *
FROM app_store_apps
LIMIT 5;

SELECT *
FROM play_store_apps
ORDER BY name

SELECT DISTINCT(app_store_apps.name)
FROM app_store_apps INNER JOIN play_store_apps
USING(name)

SELECT DISTINCT(app_store_apps.name)
FROM app_store_apps FULL JOIN play_store_apps
USING(name)
ORDER BY name;

SELECT COUNT(a.name)
FROM play_store_apps AS p INNER JOIN app_store_apps AS a
ON p.name = a.name;

-- WORKING LIST (328)
SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
FROM app_store_apps AS a INNER JOIN play_store_apps AS p
ON a.name = p.name
ORDER BY genre;

--WHERE rating >=4.0
SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
FROM app_store_apps AS a INNER JOIN play_store_apps AS p
ON a.name = p.name
WHERE a.rating >= 4.0
ORDER BY a.rating, genre;

--WHERE review_count >=?

WITH best_aps AS (SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
	FROM app_store_apps AS a INNER JOIN play_store_apps AS p
	ON a.name = p.name
	WHERE a.rating >= 3.0
	ORDER BY a.rating, genre)
SELECT *
FROM best_aps
WHERE review_count >= 10000
ORDER BY review_count DESC;

WITH best_aps AS (SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
	FROM app_store_apps AS a INNER JOIN play_store_apps AS p
	ON a.name = p.name
	WHERE a.rating >= 3.0
	ORDER BY a.rating, genre)
SELECT *
FROM best_aps
WHERE review_count >= 10000
GROUP BY best_aps.name, genre;

--BINS or SERIES

--Summary Stats by Genre
WITH working_list AS( SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
					FROM app_store_apps AS a INNER JOIN play_store_apps AS p
					ON a.name = p.name
					ORDER BY genre)
SELECT genre, ROUND(AVG(rating),1) AS avg_rating, ROUND(AVG(review_count)) AS avg_review_count, ROUND(AVG(price),1) AS avg_price
FROM working_list
GROUP BY genre
ORDER BY avg_review_count DESC;
				


-- What groups are you computing statistics by?
SELECT sector,
       -- Select the mean of assets with the avg function
       avg(assets) AS mean,
       -- Select the median
       percentile_disc(.5) WITHIN GROUP (ORDER BY assets) AS median
  FROM fortune500
 -- Computing statistics for each what?
 GROUP BY sector
 -- Order results by a value of interest
 ORDER BY mean;
 
 
-- SUBqueries on WORKING LIST
(SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
FROM app_store_apps AS a INNER JOIN play_store_apps AS p
ON a.name = p.name
ORDER BY rating, review_count DESC)

--Sarah Beth 

SELECT name, (lifespan*4000*12 - purchase_price) AS total_rev
FROM
(SELECT a.name, a.rating, MAX(a.review_count) AS review_count_max, a.price,
	CASE
		WHEN a.price <1 THEN 10000
		WHEN a.price >1 THEN 10000 * a.price
	END purchase_price,
	CASE
		WHEN a.rating BETWEEN 0 AND 1 THEN 3
		WHEN a.rating BETWEEN 1 AND 1.5 THEN 4
		WHEN a.rating BETWEEN 1.5 AND 2 THEN 5
		WHEN a.rating BETWEEN 2 AND 2.5 THEN 6
		WHEN a.rating BETWEEN 2.5 AND 3 THEN 7
		WHEN a.rating BETWEEN 3 AND 3.5 THEN 8
		WHEN a.rating BETWEEN 3.5 AND 4 THEN 9
		WHEN a.rating BETWEEN 4 AND 4.5 THEN 10
		WHEN a.rating BETWEEN 4.5 AND 5 THEN 11
	END lifespan
FROM play_store_apps AS p INNER JOIN app_store_apps AS a
	ON p.name = a.name
WHERE a.rating IS NOT NULL
GROUP BY a.name, a.rating, a.price, lifespan) AS first_query
GROUP BY name, lifespan, purchase_price
ORDER BY total_rev DESC;


--AVG Review COunt
WITH best_aps AS (SELECT DISTINCT(a.name), a.price, CAST (a.review_count AS INTEGER), a.rating, primary_genre AS genre
	FROM app_store_apps AS a INNER JOIN play_store_apps AS p
	ON a.name = p.name
	WHERE a.rating >= 3.0
	ORDER BY a.rating, genre)
SELECT AVG(review_count)
FROM best_aps
WHERE review_count >= 10000





