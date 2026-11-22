WITH a AS(
SELECT *,score-first_value(score) OVER w df,score-last_value(score) OVER(PARTITION BY player_id
ORDER BY attempt_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) dl,CASE WHEN lag(score) OVER w IS NULL OR score>lag(score) OVER w THEN 1 ELSE 0 END improved
FROM t1
WINDOW w AS(PARTITION BY player_id
ORDER BY attempt_id))
SELECT attempt_id,player_id,score,df,dl,improved,min(improved) OVER(PARTITION BY player_id)
FROM a;
