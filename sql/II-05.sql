WITH RECURSIVE ops(o) AS(VALUES(''),('+'),('-')),r(k,s,total,term,sign) AS(
SELECT 1,'1',0,1,1
UNION ALL
SELECT k+1,s||o||(k+1),CASE WHEN o='' THEN total ELSE total+sign*term END,CASE WHEN o='' THEN term*10+(k+1) ELSE k+1 END,CASE WHEN o='-' THEN -1 WHEN o='+' THEN 1 ELSE sign END
FROM r
CROSS
JOIN ops
WHERE k<(
SELECT n
FROM t1))
SELECT s,total+sign*term
FROM r
WHERE k=(
SELECT n
FROM t1);
