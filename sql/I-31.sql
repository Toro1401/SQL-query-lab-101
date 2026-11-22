SELECT max(integer_value)
FROM t1
WHERE integer_value<(
SELECT max(integer_value)
FROM t1);
SELECT DISTINCT integer_value
FROM t1
ORDER BY integer_value DESC
LIMIT 1 OFFSET 1;
WITH r AS(
SELECT integer_value,dense_rank() OVER(
ORDER BY integer_value DESC) r
FROM t1)
SELECT DISTINCT integer_value
FROM r
WHERE r=2;
SELECT max(salary)
FROM t2
WHERE salary<(
SELECT max(salary)
FROM t2);
