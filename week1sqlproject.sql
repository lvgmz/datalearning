-- Week 1 SQL Project
-- Dataset imdb top 1000 (Kaggle)
-- Date: 2026-02-22

-- columns: Poster_Link, Series_Title, Released_Year, Certificate, Runtime, Genre, IMDB_Rating, Overview, Meta_score, Director, Star1, Star2, Star3, Star4, No_of_Votes, Gross


-- Query 1: How many movies?
SELECT COUNT(*) FROM movies;

-- Query 2: Earliest and latest release years?
SELECT MIN(Released_Year) as earliest, MAX(Released_Year) as latest FROM movies;

-- Query 3: Top 10 highest rated movies
SELECT Series_Title, IMDB_Rating FROM movies 
ORDER BY IMDB_Rating DESC LIMIT 10;

-- Query 4: Movies longer than 2 hours
SELECT Series_Title, Runtime, Released_Year FROM movies 
WHERE CAST(REPLACE(Runtime, ' min', '') AS INTEGER) > 120 
ORDER BY CAST(REPLACE(Runtime, ' min', '') AS INTEGER) DESC;

-- Query 5: Movies from 2010s
SELECT Series_Title, Released_Year FROM movies
WHERE Released_Year BETWEEN 2010 AND 2019;

-- Query 6: Find movies with "The" in the title
SELECT Series_Title FROM movies
WHERE Series_Title LIKE '%The%';

-- Query 7: Find R-rated movies only
SELECT Series_Title FROM movies
WHERE Certificate = 'R'
ORDER BY IMDB_Rating Desc LIMIT 20;

-- Query 8: Count movies by decade
SELECT
  CASE
    WHEN Released_Year < 1980 THEN '<= 70s'
    WHEN Released_Year < 1990 THEN '80s'
    WHEN Released_Year < 2000 THEN '90s'
    WHEN Released_Year < 2010 THEN '00s'
    WHEN Released_Year < 2020 THEN '10s'
    ELSE '20s'
  END as decade, 
  COUNT(*) as movie_count FROM movies
GROUP BY decade
ORDER BY decade;

-- Query 9: Average rating by certification
SELECT Certificate, COUNT(*) as movie_count, AVG(IMDB_Rating) as avg_rating FROM movies
WHERE Certificate IS NOT NULL
GROUP BY Certificate;

-- Query 10: Directors with most movies
SELECT Director, COUNT(*) as movie_count FROM movies
WHERE Director IS NOT NULL
GROUP BY Director HAVING COUNT(*) > 3
ORDER BY movie_COUNT DESC LIMIT 10;

-- Query 11: Movies with above average rating
SELECT Series_Title, IMDB_Rating FROM movies
WHERE IMDB_Rating > (SELECT AVG(IMDB_Rating) FROM movies)
ORDER BY IMDB_Rating DESC;

-- Query 12: Categorize by length
SELECT Series_Title, Runtime, CASE
  WHEN CAST(REPLACE(Runtime, ' min', '') AS INTEGER) < 90 THEN 'Short'
  WHEN CAST(REPLACE(Runtime, ' min', '') AS INTEGER) < 120 THEN 'Standard'
  WHEN CAST(REPLACE(Runtime, ' min', '') AS INTEGER) < 150 THEN 'Long'
  ELSE 'Epic' END as length_category FROM movies
WHERE Runtime IS NOT NULL
ORDER BY CAST(REPLACE(Runtime, ' min', '') AS INTEGER) DESC;

-- Query 13: Rating comparison
SELECT
  CASE
    WHEN IMDB_Rating >= 8.0 THEN 'Highly Rated'
    WHEN IMDB_Rating >= 6.0 THEN 'Average'
    ELSE 'Low Rated' 
  END as rating_category,
  COUNT(*) as count, AVG(CAST(REPLACE(Runtime, ' min', '') AS INTEGER)) as avg_runtime, AVG(Gross) as avg_gross FROM movies
WHERE IMDB_Rating IS NOT NULL
GROUP BY rating_category;

-- Query 14: Top 5 Directors by avg rating
SELECT Director, COUNT(*) as movies_directed, AVG(IMDB_Rating) as avg_rating, MIN(IMDB_Rating) as worst_rating, MAX(IMDB_Rating) as best_rated FROM movies
WHERE Director IS NOT NULL
GROUP BY Director
ORDER BY avg_rating DESC
LIMIT 5;

-- Query 15: kitchen sink query!!
SELECT
  CASE
    WHEN Released_Year < 2000 THEN 'Classic'
    ELSE 'Modern' END as era,
  Certificate,
  COUNT(*) as movie_count,
  AVG(IMDB_Rating) as avg_rating,
  AVG(CAST(REPLACE(Runtime, ' min', '') AS INTEGER)) as avg_runtime_mins,
  SUM(CASE WHEN IMDB_Rating >= 8.0 THEN 1 ELSE 0 END) as highly_rated_count,
  CASE
    WHEN AVG(IMDB_Rating) > (SELECT AVG(IMDB_Rating) FROM movies)
    THEN 'Above Average Era' ELSE 'Below Average Era' 
  END as performance
FROM movies
WHERE Certificate IS NOT NULL AND Runtime IS NOT NULL
GROUP BY era, Certificate
HAVING COUNT(*) > 10
ORDER BY avg_rating DESC;
