SELECT customer_id,max(CASE WHEN type='Cellular' THEN phone_number END) cellular,max(CASE WHEN type='Work' THEN phone_number END) work,max(CASE WHEN type='Home' THEN phone_number END) home
FROM t1
GROUP BY customer_id;
