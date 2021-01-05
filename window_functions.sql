--Scorelist with the AVG
SELECT sc.id, v.name AS venue, st.name AS stage, sc.team1_goal, team2_goal,
AVG(team1_goal + team2_goal) OVER() AS overall_avg
FROM scores sc
JOIN venues v ON sc.venue_id = v.id
JOIN stages st ON sc.stage_id = st.id

--Venue ranking on Average goals
SELECT v.name AS venue,
ROUND(AVG(team1_goal + team2_goal), 2) AS avg_goals,
RANK() OVER(ORDER BY AVG(team1_goal + team2_goal)DESC) AS venue_rank
FROM venues v
JOIN scores ON v.id = scores.venue_id
GROUP BY v.name
ORDER BY venue_rank

--Stage ranking on Average goals
SELECT s.name AS stage,
ROUND(AVG(team1_goal + team2_goal), 2) AS avg_goals,
RANK() OVER(ORDER BY AVG(team1_goal + team2_goal)DESC) AS stage_rank
FROM stages s
JOIN scores ON s.id = scores.stage_id
GROUP BY s.name
ORDER BY stage_rank

--Partitioning by a column
SELECT m.date, scores.venue_id, scores.team1_goal, scores.team2_goal,
CASE WHEN scores.team1_id = 1 THEN 'home' ELSE 'away' END AS France,
AVG(team1_goal) OVER(PARTITION BY scores.venue_id) AS homeavg,
AVG(team2_goal) OVER(PARTITION BY scores.venue_id) AS awayavg
FROM scores
JOIN match m ON scores.id = m.id
JOIN stages s ON scores.stage_id = s.id
WHERE scores.team1_id = 1
OR scores.team2_id = 1
ORDER BY(team1_goal + team2_goal) DESC


--Assessing Running total of goals and AVG from France when they are team1
SELECT m.date, s.team1_goal, team2_goal,
SUM(team1_goal) OVER(ORDER BY m.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
AVG(team1_goal) OVER(ORDER BY m.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM scores s
JOIN match m ON s.id = m.id
WHERE s.team1_id = 1

--Assessing Running total of goals and AVG from France when they are team1
SELECT m.date, s.team1_goal, team2_goal,
SUM(team2_goal) OVER(ORDER BY m.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
AVG(team2_goal) OVER(ORDER BY m.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM scores s
JOIN match m ON s.id = m.id
WHERE s.team2_id = 1
