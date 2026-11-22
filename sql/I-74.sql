WITH a AS(
SELECT game_id,bowler,lead(bowler) OVER(PARTITION BY game_id
ORDER BY score DESC,bowler) next
FROM t1),b AS(
SELECT min(bowler,next) lo,max(bowler,next) hi
FROM a
WHERE next IS NOT NULL)
SELECT lo,hi,count(*)
FROM b
GROUP BY lo,hi;
