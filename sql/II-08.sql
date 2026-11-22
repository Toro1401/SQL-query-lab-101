WITH RECURSIVE people(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM people
WHERE x<10),r(k,mask,seats,prev) AS(
SELECT 0,0,'',0
UNION ALL
SELECT k+1,mask|(1<<x),seats||CASE WHEN k=0 THEN '' ELSE ',' END||x,x
FROM r
CROSS
JOIN people
WHERE (mask&(1<<x))=0 AND (k>=4 OR x<=(
SELECT adults
FROM t1)) AND (k NOT IN(6,8,9) OR x>prev))
SELECT seats
FROM r
WHERE k=10;
