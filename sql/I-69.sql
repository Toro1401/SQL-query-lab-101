WITH RECURSIVE roots AS(
SELECT DISTINCT parent root
FROM t1
WHERE parent NOT IN(
SELECT child
FROM t1)),seeds AS(
SELECT root,child,dense_rank() OVER(
ORDER BY root,child) grp
FROM roots
JOIN t1 ON parent=root),r(grp,node) AS(
SELECT grp,root
FROM seeds
UNION
SELECT grp,child
FROM seeds
UNION
SELECT r.grp,t1.child
FROM r
JOIN t1 ON parent=node
WHERE node NOT IN(
SELECT root
FROM roots))
SELECT grp,node
FROM r;
