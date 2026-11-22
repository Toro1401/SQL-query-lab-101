SELECT *
FROM t1 a
WHERE EXISTS(
SELECT 1
FROM t1 b
WHERE b.customer_id=a.customer_id AND b.start_date>a.start_date AND b.start_date<=a.end_date);
