SELECT ntile(2) OVER(
ORDER BY score DESC,player_id),player_id,score
FROM t1;
