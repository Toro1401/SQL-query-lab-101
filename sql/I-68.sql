WITH a AS(
SELECT *,avg(1.0*score) OVER(PARTITION BY team) mean
FROM t1),b AS(
SELECT *,row_number() OVER(PARTITION BY team
ORDER BY abs(score-mean) DESC,year) rn
FROM a)
SELECT team,cast(avg(1.0*score) AS INTEGER)
FROM b
WHERE rn>1
GROUP BY team;
