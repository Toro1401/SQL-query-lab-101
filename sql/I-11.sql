WITH RECURSIVE p(path,used,n) AS(
SELECT '',',',0
UNION ALL
SELECT path||CASE WHEN n=0 THEN '' ELSE ',' END||test_case,used||test_case||',',n+1
FROM p
CROSS
JOIN t1
WHERE instr(used,','||test_case||',')=0)
SELECT path
FROM p
WHERE n=(
SELECT count(*)
FROM t1);
