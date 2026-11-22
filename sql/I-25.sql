WITH a AS(
SELECT customer_id,vendor,count(*) n
FROM t1
GROUP BY customer_id,vendor),b AS(
SELECT *,dense_rank() OVER(PARTITION BY customer_id
ORDER BY n DESC) r
FROM a)
SELECT customer_id,vendor
FROM b
WHERE r=1;
