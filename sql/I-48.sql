WITH params(y) AS(VALUES(2021))
SELECT sales_id
FROM t1,params
WHERE year BETWEEN y-2 AND y
GROUP BY sales_id
HAVING count(DISTINCT year)=3;
