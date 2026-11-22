WITH RECURSIVE nums(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM nums
WHERE x<(
SELECT n
FROM t1)),p(path,mask,k,last) AS(
SELECT '',0,0,0
UNION ALL
SELECT path||CASE WHEN k=0 THEN '' ELSE ',' END||x,mask|(1<<x),k+1,x
FROM p
CROSS
JOIN nums
WHERE (mask&(1<<x))=0)
SELECT path
FROM p
WHERE k=(
SELECT k
FROM t1);
