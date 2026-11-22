WITH a AS(
SELECT *,lag(repair_id) OVER w prev_id,lag(repair_date) OVER w prev_date
FROM t1
WINDOW w AS(PARTITION BY customer_id
ORDER BY repair_date,repair_id)),b AS(
SELECT *,julianday(repair_date)-julianday(prev_date) gap
FROM a),c AS(
SELECT *,sum(gap IS NULL OR gap>30) OVER(PARTITION BY customer_id
ORDER BY repair_date,repair_id) grp
FROM b),d AS(
SELECT *,row_number() OVER(PARTITION BY customer_id,grp
ORDER BY repair_date,repair_id)-1 seq
FROM c)
SELECT customer_id,repair_id,prev_id,repair_date,prev_date,seq,gap
FROM d
WHERE gap<=30;
