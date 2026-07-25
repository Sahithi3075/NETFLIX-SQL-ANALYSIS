--BUSINESS QUESTIONS AND ANALYSIS

-- COUNT NUMBER OF MOVIES V/S SHOWS
select * from netflix_titles

select 
   type,
   COUNT(*) as total_content
from netflix_titles
group by type

--FIND MOST COMMON RATING FOR MOVIES AND TV SHOWS
select 
   type,
   MAX(rating)[most common rating]
from netflix_titles
group by type


select 
type,
rating
from (
select 
    type,
    rating,
    COUNT(*)[number of times it was rated],
    dense_RANK() over(partition by type order by count(*) desc) [rank]
from netflix_titles
group by type,rating
) as t1
where rank=1


--LIST ALL MOVIES IN SPECIFIC YEAR EG., 2020
select * from netflix_titles

select * from netflix_titles
   where type='movie' and release_year=2020

--TOP 5 COUNTRIES WITH MOST CONTENT ON NETFLIX 
SELECT * FROM netflix_titles

SELECT 
 TOP 5 COUNTRY ,
 COUNT(SHOW_ID) [TOTAL CONTENT],
 RANK() OVER(ORDER BY COUNT(SHOW_ID) DESC) [RANK]
FROM netflix_titles
WHERE COUNTRY IS NOT NULL
GROUP BY COUNTRY


--IDENTIFY THE LONGEST MOVIE

SELECT * FROM netflix_titles

SELECT 
*
from netflix_titles
where type='movie' 
      and 
      duration= (select MAX(duration) from netflix_titles)  --used sub query

--FIND CONTENT ADDED IN THE LAST 5 YEARS

SELECT *
FROM netflix_titles
where date_added>= DATEADD(year,-5, GETDATE())


--FIND ALL MOVIES/TV-SHOWS OF DIRECTOR 'RAJIV CHILAKA'
SELECT TYPE,TITLE[MOVIES],director FROM netflix_titles
WHERE director='RAJIV CHILAKA'                                   --RETURNED 19 VALUES
--OR 
SELECT * FROM netflix_titles WHERE director LIKE '%RAJIV CHILAKA%' --RETURNED 22 VALUES

--ALL TV-SHOWS WITH MORE THAN 5 SEASONS
SELECT * FROM netflix_titles
WHERE type='TV SHOW' AND duration>='5 SEASONS'

--COUNT NUMBER OF CONTENT ITEMS IN EACH GENRE

SELECT 
    TRIM(value) AS genre,
    COUNT(*) AS content_count
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value)
ORDER BY content_count DESC; --OPTIONAL 

--FIND EACH YEAR AND THE AVERAGE NUMBERS OF CONTENT RELEASE BY INDIA ON NETFLIX
--RETURN TOP 5 YEAR WITH HIGHEST AVG CONTENT RELEASE

SELECT * FROM netflix_titles

SELECT 
  RELEASE_YEAR,
  COUNT(SHOW_ID) AS TOTAL_RELEASE,
  
round(count(show_id)*1.0 / (select COUNT(show_id) from netflix_titles where country='india'),3)* 100

FROM netflix_titles
where country='india'
group by release_year 
order by TOTAL_RELEASE desc

--avg:
--ROUND(COUNT(show_id) * 1.0 / (SELECT COUNT(show_id) FROM netflix_titles WHERE country = 'India'),3) * 100 AS avg_release
--total relase that year / all indian movies * 100 rounding off to 3 decimal places 
-- 1st ans: (31/392)*100  =3.189 will be rounded off to 3.2

--now top 5:
select 
top 5 release_year,
COUNT(show_id) [total relase],
round(COUNT(show_id)*1.0 / (select COUNT(show_id) from netflix_titles where country='india'),3) *100  [avg release]
from netflix_titles
where country='india'
group by release_year
order by [total relase] desc

--LIST OF ALL MOVIES THAT ARE DOCUMENTARIES
SELECT * FROM netflix_titles
WHERE listed_in LIKE '%DOCUMENTARIES%'

--FIND ALL CONTENT WITHOUT A DIRECTOR
SELECT * FROM netflix_titles
WHERE director IS NULL

--FIND HOW MANY MOVIES ACTOR SALMAN KHAN HAS APPEARED IN LAST 10 YEARS
SELECT show_id,type,CAST,date_added FROM netflix_titles
WHERE CAST LIKE '%SALMAN KHAN%'
--THAT OR THIS BOTH RETURNS SAME ANS AS THERES NO MUCH OF DATA LIKE LAST 10 YEARS
SELECT show_id,type,CAST,date_added FROM netflix_titles
WHERE CAST LIKE '%SALMAN KHAN%' AND date_added>= DATEADD(YEAR,-10,GETDATE())

--FIND TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA
SELECT * FROM netflix_titles

SELECT TOP 10
    TRIM(value) AS actor,
    COUNT(*) AS movie_count
FROM netflix_titles
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India' AND type = 'Movie'
GROUP BY TRIM(value)
ORDER BY movie_count DESC;

--CATEGORIZE THE CONTENT BASED ON  PRESENCE OF KEYWORDS 'KILL' AND 'VOILENCE' IN DESCRIPTION FIELD 
--LABEL THE CONTENT CONTAINING KEYWORDS AS BAD AND ALL OTHER CONTENT AS GOOD.
--COUNT HOW MANY ITEMS FALL INTO EACH CATEGORY

SELECT * FROM netflix_titles

SELECT 
*,CASE
    WHEN  description LIKE '%KILL%' OR description LIKE '%VOILENCE%' THEN 'BAD' 
    ELSE 'GOOD'
    END [REMARK]
FROM netflix_titles

--HOW MNAY TIMES THE REMARKS GOOD AND BAD OCCURRED:


SELECT 
       CATEGORY,
       COUNT(*) AS[CONTENT COUNT]
       FROM(
SELECT 
    *,
    CASE
       WHEN DESCRIPTION LIKE '%KILL%' OR DESCRIPTION LIKE '%VOILENCE%' THEN 'BAD'
       ELSE 'GOOD'
       END AS CATEGORY
FROM netflix_titles)AS T
GROUP BY CATEGORY
