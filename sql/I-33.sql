WITH m AS(
SELECT product,max(days_to_manufacture) days
FROM t2
GROUP BY product)
SELECT order_id,component,days,days_to_deliver,CASE WHEN days=days_to_deliver THEN 'On Schedule' WHEN days>days_to_deliver THEN 'Behind Schedule' ELSE 'Ahead of Schedule' END
FROM t1
JOIN m ON product=component;
