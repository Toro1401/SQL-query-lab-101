WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),p(k) AS(
SELECT 1
UNION ALL
SELECT k+1
FROM p
WHERE k<(
SELECT people
FROM t1)),g AS(
SELECT x,count(DISTINCT rnd((
SELECT seed
FROM t1)+x*1000+k)%365) distinct_days
FROM n
CROSS
JOIN p
GROUP BY x)
SELECT count(*),sum(distinct_days<(
SELECT people
FROM t1)),avg(distinct_days<(
SELECT people
FROM t1))
FROM g;
