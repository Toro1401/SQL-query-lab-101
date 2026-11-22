WITH RECURSIVE n AS(
SELECT product,quantity,1 k
FROM t1
WHERE quantity>0
UNION ALL
SELECT product,quantity,k+1
FROM n
WHERE k<quantity)
SELECT product,1 quantity
FROM n;
