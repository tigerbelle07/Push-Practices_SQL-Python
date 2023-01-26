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

-- SELECT DISTINCT
-- p.namefirst AS first_name,
-- p.namelast AS last_name,
-- b.total_sal

-- FROM people p
-- LEFT JOIN collegeplaying cp
-- ON p.playerid = cp.playerid

-- INNER JOIN --changed from LEFT JOIN to INNER becuase the total_sal column was null. When changed to INNER I got my results
-- (
-- SELECT 
-- s.playerid,
-- MONEY(CAST(SUM(s.salary)AS Numeric)) AS total_sal

-- FROM salaries s
-- LEFT JOIN collegeplaying cp
-- ON s.playerid = cp.playerid

-- WHERE 
-- cp.schoolid = 'vandy'
-- GROUP BY 1    
-- ) b
-- ON p.playerid = b.playerid

-- ORDER BY b.total_sal DESC
--15 players from Vanderbilt 

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", 
-- those with position "SS", "1B", "2B", and "3B" as "Infield", 
-- and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

-- SELECT 
-- CASE WHEN pos = 'OF' THEN 'Outfield'
        
--     WHEN pos = 'SS' OR
--          pos = '1B' OR
--          pos = '2B' OR
--          pos = '3B' THEN 'Infield'
   
--  WHEN pos = 'P' OR 
--       pos = 'C' THEN 'Battery'
--  END AS Position,
     
-- SUM (po)
      
-- FROM fielding  
-- WHERE yearid = '2016'
-- Group BY position

-- 5.Find the average number of strikeouts per game by decade since 1920. 
-- Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
--Note: Need Batting Tbl, maybe Pitching tbl or BattingPost Tbl
--homegames tbl to filter games after 1920
--A.First use a CASE WHEN Statment to categorized the years into decades --use Teams tbl
--B. Next do the calculations - SO/games played gives you avg strikeouts per game. Do the same for homeruns
-- SELECT 

-- CASE WHEN yearID BETWEEN 1920 AND 1929 THEN '1920s'
--      WHEN yearID BETWEEN 1930 AND 1939 THEN '1930s'
--      WHEN yearID BETWEEN 1940 AND 1949 THEN '1940s'
--      WHEN yearID BETWEEN 1950 AND 1959 THEN '1950s'
--      WHEN yearID BETWEEN 1960 AND 1969 THEN '1960s'
--      WHEN yearID BETWEEN 1970 AND 1979 THEN '1970s'
--      WHEN yearID BETWEEN 1980 AND 1989 THEN '1980s'
--      WHEN yearID BETWEEN 1990 AND 1999 THEN '1990s'
--      WHEN yearID BETWEEN 2000 AND 2009 THEN '2000s'
--      WHEN yearID BETWEEN 2010 AND 2020 THEN '2010s'
--      END AS decade,
     
-- ROUND(CAST(SUM(SO) AS numeric)/CAST(SUM(g/2) AS numeric), 2) AS avg_so_per_game,
-- ROUND(CAST(SUM(HR) AS numeric)/CAST(SUM(g/2) AS numeric), 2) AS avg_hr_per_game

-- FROM teams
-- GROUP BY 1
-- ORDER BY decade 
     
-- 6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. 
-- (A stolen base attempt results either in a stolen base or being caught stealing.) 
-- Consider only players who attempted at least 20 stolen bases.  
--note: adding CAST and Numeric helps with the calculations w/in SQL.
SELECT 
p.namegiven,
ROUND(CAST(SUM(b.sb) AS numeric)/CAST(SUM(b.sb) + SUM(b.cs) AS numeric), 3) AS pct_sb,
SUM(b.sb) AS steal_bases,
SUM(b.cs) AS caught_stealing
--ROUND(CAST(SUM(b.sb) AS numeric)/CAST((SUM(b.sb) + SUM(b.cs)) AS numeric),3) AS pct_sb

FROM batting b
LEFT JOIN people p
on b.playerid = p.playerid

WHERE 
b.yearid = 2016
AND 
CAST(b.sb + b.cs as FLOAT) >= 20

GROUP BY 1
ORDER BY pct_sb DESC