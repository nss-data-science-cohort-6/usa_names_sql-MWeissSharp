-- 1. How many rows are in the names table?
SELECT COUNT(*)
FROM names;
-- 1,957,046 rows

-- 2. How many total registered people appear in the dataset?
SELECT SUM(num_registered)
FROM names;
-- 351,653,025 total people

-- 3. Which name had the most appearances in a single year in the dataset?
SELECT name,
		year,
		num_registered
FROM names
ORDER BY num_registered DESC
LIMIT 1;
-- Linda in 1947 with 99,689 registered

-- 4. What range of years are included?
SELECT MIN(year),
		MAX(year)
FROM names;
-- 1880 to 2018

-- 5. What year has the largest number of registrations?
SELECT year,
		SUM(num_registered) AS total
FROM names
GROUP BY year
ORDER BY total DESC
LIMIT 1;
--1957 with 4,200,022 registered

-- 6. How many different (distinct) names are contained in the dataset?
SELECT COUNT(DISTINCT name)
FROM names;
--98,400

-- 7. Are there more males or more females registered?
SELECT gender,
		SUM(num_registered)
FROM names
GROUP BY gender;
-- There are more males (177,573,793) that females (174,079,232)

-- 8. What are the most popular male and female names overall (i.e., the most total registrations)?
SELECT name,
		gender,
		SUM(num_registered) AS total
FROM names
GROUP BY name, gender
ORDER BY total DESC
LIMIT 5;
--James for males (5,164,280) an Mary for females (4,125,675)

-- 9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
SELECT name,
		gender,
		SUM(num_registered) AS total
FROM names
WHERE year BETWEEN 2000 AND 2009
GROUP BY name, gender
ORDER BY total DESC
LIMIT 5;
-- Jacob for males (273,844) and Emily for females (223,690)

-- 10. Which year had the most variety in names (i.e. had the most distinct names)?
SELECT year,
		COUNT(DISTINCT name) AS total_distinct
FROM names
GROUP BY year
ORDER BY total_distinct DESC
LIMIT 2;
--2008 with 32,518 distinct names

-- 11. What is the most popular name for a girl that starts with the letter X?
SELECT name,
		SUM(num_registered) AS total
FROM names
WHERE name LIKE 'X%'
	AND gender = 'F'
GROUP BY name
ORDER BY total DESC
LIMIT 12;
-- Ximena with 26,145 registered

-- 12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?
SELECT COUNT(DISTINCT name)
FROM names
WHERE name LIKE 'Q%'
	AND name NOT LIKE 'Qu%';
--46 distinct names start with Q but don't have u as the second letter

-- 13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.
SELECT name,
		SUM(num_registered)
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name;
-- Steven is more popular by about 50% (1,286,951) compared to Stephen (860,972)

-- 14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?
SELECT name,
		COUNT(DISTINCT gender) AS unisex_or_not
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2;
--10773/98400 or 10.95% of names are unisex

-- 15. How many names have made an appearance in every single year since 1880?
SELECT name,
		COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 139;
-- 921 names have appeared in every year of the data set

-- 16. How many names have only appeared in one year?
SELECT name,
		COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 1;
--21,123 names have only appeared in one year of the data set

-- 17. How many names only appeared in the 1950s?
SELECT name,
		MIN(year),
		MAX(year)
FROM names
GROUP BY name
HAVING MIN(year) BETWEEN 1950 AND 1959
	AND MAX(year) BETWEEN 1950 AND 1959;
--661 names only appeared in the 1950's

-- 18. How many names made their first appearance in the 2010s?
SELECT name,
		MIN(year) AS first_year
FROM names
GROUP BY name
HAVING MIN(year) >=2010;
--11,270 names were first used in the 2010's

-- 19. Find the names that have not be used in the longest.
SELECT name,
		MAX(year) AS last_used
FROM names
GROUP BY name
ORDER BY last_used;
LIMIT 2
--Roll and Zilpah haven't been used since 1881

-- 20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.
-- Question: What is the most used unisex name that is evenly split between female and males?
SELECT name,
	SUM(CASE WHEN gender = 'F' THEN num_registered END) AS total_f_use,
	SUM(CASE WHEN gender = 'M' THEN num_registered END) AS total_m_use,
	ABS(SUM(CASE WHEN gender = 'F' THEN num_registered END) - SUM(CASE WHEN gender = 'M' THEN num_registered END)) AS abs_difference
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2
ORDER BY abs_difference, total_f_use DESC;
--Daine, used 298 times by both males and females