WITH a AS(
SELECT workflow,message,sum(occurrences) n
FROM t1
GROUP BY workflow,message),b AS(
SELECT *,dense_rank() OVER(PARTITION BY message
ORDER BY n DESC) r
FROM a)
SELECT workflow,message,n
FROM b
WHERE r=1;
