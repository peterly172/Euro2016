-- Scores from the first matchday
SELECT * FROM scores
WHERE stage_id = 1

-- Scores from the group stages
SELECT * FROM scores
WHERE stage_id BETWEEN 1 AND 3

-- Scores that took place in Stade de France
SELECT * FROM scores
WHERE venue_id= 1
--Matches that took place within matchday 3
SELECT * FROM match
WHERE stage_id = 3
