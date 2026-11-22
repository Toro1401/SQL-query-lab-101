WITH d AS(
SELECT workflow,julianday(execution_date)-julianday(lag(execution_date) OVER(PARTITION BY workflow
ORDER BY execution_date)) gap
FROM t1)
SELECT workflow,cast(avg(gap) AS INTEGER)
FROM d
GROUP BY workflow;
