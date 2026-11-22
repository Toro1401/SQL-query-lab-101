SELECT order_id
FROM t1
GROUP BY order_id
HAVING count(DISTINCT product)=1 AND count(product)=count(*) AND sum(discount IS NOT 'PROMO')=0;
