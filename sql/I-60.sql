SELECT product_code
FROM t1
GROUP BY product_code
HAVING count(DISTINCT product)=1;
