CREATE TABLE Netflix1(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(125),
description VARCHAR(250)
 

)

SELECT * FROM netflix1;

SELECT 
   COUNT(*) as total_content
FROM netflix1;

SELECT 
   DISTINCT type
FROM netflix1;

-- 15 Business Probelms

--1. Count the number of movies vs TV shows

SELECT 
   type,
   COUNT(*) as total_content
FROM netflix1
GROUP BY type


--2. Find the most common rating for movies and TV shows
SELECT 
      type,
	  rating
FROM	  
( SELECT 
      type,
	  rating, 
	  COUNT(*),
	  RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	  
FROM netflix1
GROUP BY 1,2
) as t1
WHERE 
   ranking = 1


-- 3.List all movies released in a specific year(eg. 2019)
-- filter for the specific year
-- movies

SELECT * FROM netflix1
WHERE 
   type = 'Movie'
   AND
   release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix

SELECT
    UNNEST(STRING_TO_ARRAY(country, ' ,')) as new_country,
	COUNT(show_id) as total_content
FROM netflix1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--5.Identify the longest movie?
SELECT title,  SUBSTRING(duration, 1,POSITION ('m' in duration)-1)::int duration
FROM netflix1
WHERE type = 'Movie' and duration is not null
order by 2 desc
limit 1


--6.Find content added in the last 5 years
SELECT 
    *, 
    TO_DATE(date_added, 'Month DD, YYYY') AS added_date
FROM 
    netflix1
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
	

--7.Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * FROM netflix1
WHERE director ILIKE '%Rajiv Chilaka%'

--8.List all TV shows with more than 5 seasons
SELECT 
    *
FROM 
    netflix1
WHERE 
    type = 'TV Show'
    AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;

--9.Count the number of content items in each genre
SELECT 
  TRIM(genre) AS genre,
  COUNT(*) AS total_content
FROM 
  netflix1,
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP BY 
  genre
ORDER BY 
  total_content DESC;

--10.Find each year and the avg number of content release by India on netflix, return top 5 year with highest avg ontent release :
SELECT 
    release_year,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT title), 2) AS avg_content_per_title
FROM (
    SELECT 
        title,
        country,
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS release_year
    FROM 
        netflix1
    WHERE 
        country ILIKE '%India%' 
        AND date_added IS NOT NULL
) AS subquery
GROUP BY 
    release_year
ORDER BY 
    total_content DESC
LIMIT 5;

--11.List all the movies that are documentaries
SELECT *
FROM netflix1
WHERE 
  type = 'Movie'
  AND listed_in ILIKE '%Documentaries%';

--12.Find all content without a director
	
SELECT *
FROM netflix1
WHERE director IS NULL OR director = '';


--13.Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT COUNT(*) AS salman_khan_movies_last_10_years
FROM netflix1
WHERE 
    type = 'Movie'
    AND "casts" ILIKE '%Salman Khan%'
    AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years';


--14.Find the top 10 actors who have appeared in the highest number of movies produced in india
SELECT 
  TRIM(actor) AS actor_name,
  COUNT(*) AS movie_count
FROM 
  netflix1,
  UNNEST(STRING_TO_ARRAY("casts", ',')) AS actor
WHERE 
  type = 'Movie'
  AND country ILIKE '%India%'
  AND "casts" IS NOT NULL
GROUP BY 
  actor_name
ORDER BY 
  movie_count DESC
LIMIT 10;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT 
  *,  -- selects all original columns
  CASE 
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
    ELSE 'Good_Content'
  END AS category
FROM 
  netflix1;  -- use the correct table name (e.g., netflix1)






 


