-- Search for a given athlete, along with their current team. The current team is defined here
-- as the last team that they have played for. Because the roster dates are somewhat stale
-- (end with the last game of the previous season), their active status is defined as their last
-- game being played within the last year. Also return which side of the ball they play on
-- (ie. offense, defense, special teams)
-- QUERY TYPE: Question 
-- 15+ query requirement: Not satisfied (No group by, no aggregate function in select statement)
SELECT a.athlete_id,
       a.first_name || ' ' || a.last_name as name,
       a.dob,
       a.height,
       a.weight,
       a.birth_city || ', ' || coalesce(a.birth_state, 'UNKNOWN') AS birth_place,
       r.team_name,
       r.position_name,
       coalesce(p.platoon, 'Unknown') AS platoon,
       r.start_date,
       r.end_date,
       CASE WHEN r.end_date < CURRENT_DATE - INTERVAL '1 year' THEN 'False' ELSE 'True' END AS active
FROM athletes a
         JOIN rosters r ON r.athlete_id = a.athlete_id
JOIN positions p ON p.position_name = r.position_name
WHERE first_name LIKE '%Patrick%'
  AND start_date >= ALL (SELECT start_date
                         FROM athletes a2
                                  JOIN rosters r2 ON r2.athlete_id = a2.athlete_id
                         WHERE a2.athlete_id = a.athlete_id);