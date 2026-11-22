WITH RECURSIVE n(x) AS(
SELECT 1
WHERE (
SELECT max(seat_number)
FROM t1)>=1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT max(seat_number)
FROM t1)), missing AS(
SELECT x
FROM n
WHERE NOT EXISTS(
SELECT 1
FROM t1
WHERE seat_number=x)), g AS(
SELECT x,x-row_number() OVER(
ORDER BY x) grp
FROM missing)
SELECT min(x),max(x)
FROM g
GROUP BY grp
ORDER BY min(x);
WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT max(seat_number)
FROM t1))
SELECT count(*)
FROM n
WHERE x NOT IN(
SELECT seat_number
FROM t1);
SELECT CASE seat_number%2 WHEN 0 THEN 'Even Numbers' ELSE 'Odd Numbers' END,count(*)
FROM t1
GROUP BY seat_number%2;
