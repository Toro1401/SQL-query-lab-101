WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),positions(p) AS(
SELECT 0
UNION ALL
SELECT p+1
FROM positions
WHERE p+1<(
SELECT people
FROM t1)),r(trial,step,pos,mask) AS(
SELECT x,0,0,1
FROM n
UNION ALL
SELECT trial,step+1,(pos+CASE rnd((
SELECT seed
FROM t1)+trial*100000+step)%2 WHEN 0 THEN 1 ELSE -1 END+(
SELECT people
FROM t1))%(
SELECT people
FROM t1),mask|(1<<((pos+CASE rnd((
SELECT seed
FROM t1)+trial*100000+step)%2 WHEN 0 THEN 1 ELSE -1 END+(
SELECT people
FROM t1))%(
SELECT people
FROM t1)))
FROM r
WHERE bitcount(mask)<(
SELECT people-1
FROM t1) AND step<10000)
SELECT p,count(*)
FROM r
JOIN positions ON (mask&(1<<p))=0
WHERE bitcount(mask)=(
SELECT people-1
FROM t1)
GROUP BY p;
