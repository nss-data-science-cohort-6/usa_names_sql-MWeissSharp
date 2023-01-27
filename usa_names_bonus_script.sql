-- 1. Find the longest name contained in this dataset. What do you notice about the long names?
SELECT DISTINCT(name),
	CHAR_LENGTH(name) AS name_length
FROM names
WHERE CHAR_LENGTH(name) = 15;
-- There are 36 names with 15 characters and they all appear to be double names

-- 2. How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
SELECT DISTINCT(name)
FROM names
WHERE LOWER(name) = REVERSE(LOWER(name));
--137 names are palindromes

-- 	3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). (Hint: you might find this page helpful: https://www.postgresql.org/docs/8.3/functions-matching.html)
SELECT DISTINCT(name)
FROM names
WHERE LOWER(name) !~'[aeiouy]';
--There are 43 such names, all but 1 of which are 2 letters long

-- 	4. How many double-letter names show up in the dataset? Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. Are there any triple-letter names?
SELECT DISTINCT(name)
FROM names
WHERE LOWER(name) ~'(.)\1';
--22,537 double letter names
SELECT DISTINCT(name)
FROM names
WHERE LOWER(name) ~'(.)\1\1';
--12 triple letter names

-- 	5. On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. Now, find all names that did not appear in the 1950s but were used both before and after the 1950s. We'll answer this question in two steps.
-- 	a. First, write a query that returns all names that appeared during the 1950s.
SELECT DISTINCT(name)
FROM names
WHERE year BETWEEN 1950 AND 1959;

-- 	b. Now, make use of this query along with the IN keyword in order the find all names that did not appear in the 1950s but which were used both before and after the 1950s. See the example "A subquery with the IN operator." on this page: https://www.dofactory.com/sql/subquery.
SELECT DISTINCT(name),
		MIN(year),
		MAX(year)
FROM names
WHERE name NOT IN (SELECT DISTINCT(name)
					FROM names
					WHERE year BETWEEN 1950 AND 1959)
GROUP BY name
HAVING MIN(year) < 1950
	AND MAX(year) >1959;
--2525 names were not used in the 1950's but were used before and after

-- 	6. In question 16, you found how many names appeared in only one year. Which year had the highest number of names that only appeared once?
SELECT year,
		COUNT(name) AS total_names
FROM names
WHERE name IN (SELECT name
					FROM names
					GROUP BY name
					HAVING COUNT(DISTINCT year) = 1)
GROUP BY year
ORDER BY total_names DESC
LIMIT 2;
--In 2018 there were 1,060 names that had only been used that year

-- 	7. Which year had the most new names (names that hadn't appeared in any years before that year)? For this question, you might find it useful to write a subquery and then select from this subquery. 
SELECT first_year AS year,
		COUNT(first_year) AS num_new_names
FROM (SELECT name,
			MIN(year) AS first_year
		FROM names
		GROUP BY name) AS it
GROUP BY first_year
ORDER BY num_new_names DESC
LIMIT 1;
-- 2007 had the most new names with 2,027

-- 	8. Is there more variety (more distinct names) for females or for males? Is this true for all years or are their any years where this is reversed? Hint: you may need to make use of multiple subqueries and JOIN them in order to answer this question.
SELECT gender,
	COUNT(DISTINCT name)
FROM names
GROUP BY gender;
--Overall there are more distinct names for females (61,698) than males (41,475)
SELECT year,
		COUNT(CASE WHEN gender = 'F' THEN name END) AS female_names,
		COUNT(CASE WHEN gender = 'M' THEN name END) As male_names
FROM names
GROUP BY year
HAVING COUNT(CASE WHEN gender = 'M' THEN name END) > COUNT(CASE WHEN gender = 'F' THEN name END);
--There were more distinct male names than female names in 1880, 1881, and 1882

-- 	9. Which names are closest to being evenly split between male and female usage? For this question, consider only names that have been used at least 10000 times in total.
SELECT name,
	SUM(CASE WHEN gender = 'F' THEN num_registered END) AS total_f_use,
	SUM(CASE WHEN gender = 'M' THEN num_registered END) AS total_m_use,
	ABS(SUM(CASE WHEN gender = 'F' THEN num_registered END) - SUM(CASE WHEN gender = 'M' THEN num_registered END)) AS abs_difference
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2
	AND SUM(num_registered) >= 10000
ORDER BY abs_difference;
--Santana is the closest to evenly split with just 93 more female uses than male

-- 	10. Which names have been among the top 25 most popular names for their gender in every single year contained in the names table? Hint: you may have to combine a window function and a subquery to answer this question.

-- 	11. Find the name that had the biggest gap between years that it was used. 

-- 	12. Have there been any names that were not used in the first year of the dataset (1880) but which made it to be the most-used name for its gender in some year? Difficult follow-up: What is the shortest amount of time that a name has gone from not being used at all to being the number one used name for its gender in a year?