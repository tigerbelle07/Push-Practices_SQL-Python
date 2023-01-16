--1. What range of years for baseball games played does the provided database cover?
-- SELECT
-- MIN(span_first) as first_game,
-- MAX(span_last) as last_game

-- FROM homegames
--Answer: First game: 5-4-1871; Last game: 10-02-2016

--2.Find the name and height of the shortest player in the database. 
--How many games did he play in? What is the name of the team for which he played?
--Notes: 
--Part A. Find the name and height of the shortest player --what tbl is this information located?
       --people tbl --I need columns 'namegiven' & 'height'-MIN funtion
--Part B. How many games did he play in --what tbl?
       --appearences tbl --I need column 'G_all'(total games played)
--Paet C. What team did he play for --what tbl
       --teams tbl -- I need columns 'name'(full team name), 'G'(games played)
--Part A
-- SELECT
-- p.namegiven AS full_name,
-- t.name AS team_name,
-- --a.teamid,
-- a.g_all AS total_games,
-- MIN(p.height) AS shortest_height

-- FROM people p
-- LEFT JOIN appearances a 
-- ON p.playerid = a.playerid
-- LEFT JOIN teams t
-- ON a.teamid = t.teamid

-- GROUP BY 1,2,3
-- ORDER BY shortest_height asc
-- LIMIT 10
--Edward Carl at 43 inches played 1 game.

-- 3.Find all players in the database who played at Vanderbilt University. 
-- Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
-- Sort this list in descending order by the total salary earned. 
-- Which Vanderbilt player earned the most money in the majors?

--A. Find all players that played at Vanderbilt? Need tbls--collegeplaying, schools, people 

-- SELECT DISTINCT
-- p.namefirst AS first_name,
-- p.namelast AS last_name,
-- s.schoolname

-- FROM people p
-- LEFT JOIN collegeplaying cp
-- ON p.playerid = cp.playerid
-- LEFT JOIN schools s
-- ON cp.schoolid = s.schoolid

-- WHERE 
-- s.schoolname = 'Vanderbilt University'
-- --24 Vanderbilt University Players.

--B. Find tbl that contains salary earned in major leagues --tbl salaries & appearances to get the
--let's look at salaries, people and collegeplaying tbls
-- SELECT 
-- s.playerid,
-- MONEY(CAST(SUM(s.salary)AS Numeric)) AS total_sal

-- FROM salaries s
-- LEFT JOIN collegeplaying cp
-- ON s.playerid = cp.playerid

-- WHERE 
-- cp.schoolid = 'vandy'
-- GROUP BY 1
-- ORDER BY total_sal DESC
--15 players from vandy appeared to have earned a salary from the majors.

--C. Lets put it all together

SELECT DISTINCT
p.namefirst AS first_name,
p.namelast AS last_name,
b.total_sal

FROM people p
LEFT JOIN collegeplaying cp
ON p.playerid = cp.playerid

INNER JOIN --changed from LEFT JOIN to INNER becuase the total_sal column was null. When changed to INNER I got my results
(
SELECT 
s.playerid,
MONEY(CAST(SUM(s.salary)AS Numeric)) AS total_sal

FROM salaries s
LEFT JOIN collegeplaying cp
ON s.playerid = cp.playerid

WHERE 
cp.schoolid = 'vandy'
GROUP BY 1    
) b
ON p.playerid = b.playerid

ORDER BY b.total_sal DESC
--15 players from Vanderbilt 


