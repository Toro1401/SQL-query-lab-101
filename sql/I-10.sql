WITH r AS(
SELECT integer_value v,row_number() OVER(
ORDER BY integer_value) rn,count(*) OVER() n
FROM t1)
SELECT (
SELECT avg(1.0*integer_value)
FROM t1) mean,(
SELECT avg(1.0*v)
FROM r
WHERE rn IN ((n+1)/2,(n+2)/2)) median,(
SELECT integer_value
FROM t1
GROUP BY integer_value
ORDER BY count(*) DESC,integer_value
LIMIT 1) mode,(
SELECT max(integer_value)-min(integer_value)
FROM t1) range;
