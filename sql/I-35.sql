SELECT sales_rep_id
FROM t1
WHERE sales_type IN('Domestic','International')
GROUP BY sales_rep_id
HAVING count(DISTINCT sales_type)=1;
