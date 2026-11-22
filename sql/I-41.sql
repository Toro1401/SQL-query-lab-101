WITH RECURSIVE edges(a,b) AS(
SELECT *
FROM t1
UNION
SELECT associate_2,associate_1
FROM t1),reach(root,node) AS(
SELECT a,a
FROM edges
UNION
SELECT root,b
FROM reach
JOIN edges ON a=node),components AS(
SELECT node,min(root) root
FROM reach
GROUP BY node)
SELECT dense_rank() OVER(
ORDER BY root),node
FROM components;
