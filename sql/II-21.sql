WITH RECURSIVE trials(t) AS(
SELECT 1
UNION ALL
SELECT t+1
FROM trials
WHERE t<(
SELECT trials
FROM t1)),nums(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM nums
WHERE x<(
SELECT prisoners
FROM t1)),ranked AS MATERIALIZED(
SELECT t,x,row_number() OVER(PARTITION BY t
ORDER BY rnd((
SELECT seed
FROM t1)+t*1000+x),x) pos
FROM trials
CROSS
JOIN nums),perms AS MATERIALIZED(
SELECT t,json_group_array(x
ORDER BY pos) p
FROM ranked
GROUP BY t),r(t,p,cur,start,seen,len,longest,steps) AS(
SELECT t,p,1,1,',',0,0,0
FROM perms
UNION ALL
SELECT t,p,CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN (
SELECT min(x)
FROM nums
WHERE x<>cur AND instr(seen,','||x||',')=0) ELSE json_extract(p,'$['||(cur-1)||']') END,CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN (
SELECT min(x)
FROM nums
WHERE x<>cur AND instr(seen,','||x||',')=0) ELSE start END,seen||cur||',',CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN 0 ELSE len+1 END,CASE WHEN json_extract(p,'$['||(cur-1)||']')=start THEN max(longest,len+1) ELSE longest END,steps+1
FROM r
WHERE cur IS NOT NULL AND steps<(
SELECT prisoners
FROM t1))
SELECT count(*),sum(longest<=(
SELECT prisoners/2
FROM t1)),avg(longest<=(
SELECT prisoners/2
FROM t1)),max(steps)
FROM r
WHERE steps=(
SELECT prisoners
FROM t1);
