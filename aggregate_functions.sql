-- Number of matches in Euro 2016
SELECT COUNT(id) AS total_matches
FROM scores

-- Number of matches taken place each stadium
SELECT v.name, COUNT(*) AS matches
FROM scores
JOIN venues AS v
ON scores.venue_id = v.id
GROUP BY v.name
ORDER BY matches DESC

--  Number of matches per stage
SELECT stages.name, COUNT(*) AS matches
FROM scores
JOIN stages 
ON scores.stage_id = stages.id
GROUP BY stages.name
ORDER BY matches DESC, stages.name

--What times do France play and how many times?
SELECT time_bst, COUNT(*)
FROM match
WHERE team1_id = 1
OR team2_id = 1
GROUP BY time_bst
ORDER BY COUNT(*)

-- Number of goals scored in Euro 2016
SELECT SUM(team1_goal + team2_goal)
FROM scores

--  Number of goals scored in each round
SELECT stages.name, SUM(team1_goal + team2_goal) AS total_goals
FROM scores
JOIN stages
ON scores.stage_id = stages.id
GROUP BY stages.name 
ORDER BY total_goals DESC, stages.name

--Number of goals scored in each stadium
SELECT venues.name, SUM(team1_goal + team2_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
GROUP BY venues.name 
ORDER BY total_goals DESC

-- Maximum number of goals scored in a single match in Euro 2016
SELECT MAX(team1_goal + team2_goal) FROM scores
--Maximum number of goals scored in a match per round
SELECT stages.name, MAX(team1_goal + team2_goal) AS max_goals
FROM scores
JOIN stages 
ON scores.venue_id = stages.id
GROUP BY stages.name
ORDER BY max_goals DESC, stages.name

--Maximum number of goals scored in a match per stadium
SELECT venues.name, MAX(team1_goal + team2_goal) AS max_goals
FROM scores
JOIN venues 
ON scores.venue_id = venues.id
GROUP BY venues.name
ORDER BY max_goals DESC
