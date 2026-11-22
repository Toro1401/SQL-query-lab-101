SELECT CASE WHEN a.product_name IS NULL THEN 'Product does not exist in table A' WHEN b.product_name IS NULL THEN 'Product does not exist in table B' WHEN a.quantity IS b.quantity THEN 'Matches in both table A and table B' ELSE 'Quantity in table A and table B do not match' END,coalesce(a.product_name,b.product_name)
FROM t1 a
FULL
JOIN t2 b USING(product_name);
