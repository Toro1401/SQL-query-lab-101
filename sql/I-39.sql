WITH RECURSIVE n(x) AS(
SELECT 2
UNION ALL
SELECT x+1
FROM n
WHERE x*x<=(
SELECT max(integer_value)
FROM t1))
SELECT integer_value
FROM t1
WHERE integer_value>1 AND NOT EXISTS(
SELECT 1
FROM n
WHERE x*x<=integer_value AND integer_value%x=0);
