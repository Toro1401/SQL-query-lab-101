WITH monthly AS(
SELECT state,customer_id,substr(order_date,1,7) month,avg(1.0*amount) m
FROM t1
GROUP BY state,customer_id,substr(order_date,1,7)), customers AS(
SELECT state,customer_id,avg(m) m
FROM monthly
GROUP BY state,customer_id)
SELECT state
FROM customers
GROUP BY state
HAVING min(m)>100;
