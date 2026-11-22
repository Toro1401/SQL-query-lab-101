WITH a AS(
SELECT *,lag(status) OVER(
ORDER BY step_number) prev
FROM t1),b AS(
SELECT *,sum(prev IS NOT status) OVER(
ORDER BY step_number) grp
FROM a)
SELECT min(step_number),max(step_number),status,count(*)
FROM b
GROUP BY grp,status;
