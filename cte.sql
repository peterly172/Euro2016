--Number of games per stage where total goals are more than / equal to 4
WITH match_list AS (
SELECT
m.id FROM scores m
WHERE (team1_goal + team2_goal) >= 4)
SELECT s.name AS stage, COUNT(match_list.id) AS matches
FROM scores
JOIN stages AS s
ON scores.stage_id = s.id
LEFT JOIN match_list ON scores.id = match_list.id
GROUP BY s.name
ORDER BY matches DESC

--Matches where 4 or more goals were scored
WITH match_list AS (
SELECT
scores.stage_id, m.date, team1_goal, team2_goal, (team1_goal + team2_goal) AS total_goals
	FROM scores
	LEFT JOIN match m ON scores.id = m.id)
SELECT stage_id, date, team1_goal, team2_goal FROM match_list
WHERE total_goals >= 4  

--Number of goals scored on AVG per venue in June
WITH match_list AS (
SELECT
venue_id, (team1_goal + team2_goal) AS goals
	FROM scores
	WHERE id IN (SELECT id FROM match 
				WHERE venue_id = 5 AND EXTRACT(MONTH FROM date) = 06))
SELECT v.name, AVG(match_list.goals)
FROM venues v
LEFT JOIN match_list 
ON v.id = match_list.venue_id
GROUP BY v.name

Full scoresheet using CTE
WITH team1 AS (
SELECT s.id, m.date, t.name AS team1, s.team1_goal
FROM scores s
LEFT JOIN teams t
ON t.id = s.team1_id
LEFT JOIN match m
ON s.id = m.id),
team2 AS (
SELECT s.id, m.date, t.name AS team2, s.team2_goal
FROM scores s
LEFT JOIN teams t
ON t.id = s.team2_id
LEFT JOIN match m
On s.id = m.id)
SELECT team1.date, team1.team1, team2.team2, team1.team1_goal, team2.team2_goal
FROM team1
JOIN team2
On team1.id = team2.id
ORDER BY date