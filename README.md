# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

🗃️ Database Schema
sql
Copy code
CREATE TABLE netflix1 (
    show_id      VARCHAR(10),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
📌 Business Problems Solved
1. 🎬 Count the number of Movies vs TV Shows
sql
Copy code
SELECT type, COUNT(*) AS total_content
FROM netflix1
GROUP BY type;
2. 🎯 Most Common Rating for Movies and TV Shows
sql
Copy code
SELECT type, rating
FROM (
   SELECT type, rating, COUNT(*),
          RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
   FROM netflix1
   GROUP BY 1,2
) AS t1
WHERE ranking = 1;
3. 🎞️ All Movies Released in 2020
sql
Copy code
SELECT * FROM netflix1
WHERE type = 'Movie' AND release_year = 2020;
4. 🌍 Top 5 Countries with the Most Content
sql
Copy code
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
       COUNT(show_id) AS total_content
FROM netflix1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
5. 🕒 Longest Movie on Netflix
sql
Copy code
SELECT title, SUBSTRING(duration, 1, POSITION('m' IN duration)-1)::INT AS duration
FROM netflix1
WHERE type = 'Movie'
ORDER BY duration DESC
LIMIT 1;
6. ⏳ Content Added in the Last 5 Years
sql
Copy code
SELECT * FROM netflix1
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
7. 🎥 All Content by Director 'Rajiv Chilaka'
sql
Copy code
SELECT * FROM netflix1
WHERE director ILIKE '%Rajiv Chilaka%';
8. 📺 TV Shows with More Than 5 Seasons
sql
Copy code
SELECT * FROM netflix1
WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;
9. 🎭 Count of Content per Genre
sql
Copy code
SELECT TRIM(genre) AS genre, COUNT(*) AS total_content
FROM netflix1,
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP BY genre
ORDER BY total_content DESC;
10. 🇮🇳 Top 5 Years with Highest Average Indian Content Release
sql
Copy code
SELECT release_year, COUNT(*) AS total_content,
       ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT title), 2) AS avg_content_per_title
FROM (
   SELECT title, country,
          EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS release_year
   FROM netflix1
   WHERE country ILIKE '%India%' AND date_added IS NOT NULL
) AS subquery
GROUP BY release_year
ORDER BY total_content DESC
LIMIT 5;
11. 📚 List All Movies That Are Documentaries
sql
Copy code
SELECT * FROM netflix1
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';
12. ❌ Content Without a Director
sql
Copy code
SELECT * FROM netflix1
WHERE director IS NULL OR director = '';
13. 🌟 Movies Featuring Salman Khan in the Last 10 Years
sql
Copy code
SELECT COUNT(*) AS salman_khan_movies_last_10_years
FROM netflix1
WHERE type = 'Movie'
  AND "casts" ILIKE '%Salman Khan%'
  AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years';
14. 👨‍🎤 Top 10 Indian Movie Actors on Netflix
sql
Copy code
SELECT TRIM(actor) AS actor_name, COUNT(*) AS movie_count
FROM netflix1,
     UNNEST(STRING_TO_ARRAY("casts", ',')) AS actor
WHERE type = 'Movie' AND country ILIKE '%India%' AND "casts" IS NOT NULL
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 10;
15. 🔪 Categorize Content Based on Violent Keywords
sql
Copy code
SELECT category, COUNT(*) AS content_count
FROM (
   SELECT CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
            ELSE 'Good_Content'
         END AS category
   FROM netflix1
) AS categorized
GROUP BY category;
✅ Key Findings
Content Type: Movies outnumber TV Shows

Top Countries: US, India, and the UK dominate in volume

Indian Content: Rising consistently over recent years

Genre Popularity: Documentaries and Dramas are top performers

Actor Insights: Frequent appearances by key Bollywood names like Salman Khan



## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

