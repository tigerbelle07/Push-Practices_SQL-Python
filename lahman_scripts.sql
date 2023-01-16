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
SELECT
p.namegiven AS full_name,
t.name AS team_name,
--a.teamid,
a.g_all AS total_games,
MIN(p.height) AS shortest_height

FROM people p
LEFT JOIN appearances a 
ON p.playerid = a.playerid
LEFT JOIN teams t
ON a.teamid = t.teamid

GROUP BY 1,2,3
ORDER BY shortest_height asc
LIMIT 10
--Edward Carl at 43 inches played 1 game.
