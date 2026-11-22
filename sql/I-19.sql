WITH a AS(
SELECT *,max(end_date) OVER(
ORDER BY start_date,end_date ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) prev
FROM t1), b AS(
SELECT *,sum(prev IS NULL OR start_date>prev) OVER(
ORDER BY start_date,end_date) grp
FROM a)
SELECT min(start_date),max(end_date)
FROM b
GROUP BY grp;
