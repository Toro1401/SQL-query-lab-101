SELECT *
FROM t1 o
WHERE delivery_state='TX' AND EXISTS(
SELECT 1
FROM t1 c
WHERE c.customer_id=o.customer_id AND c.delivery_state='CA');
