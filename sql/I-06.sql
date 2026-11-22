SELECT workflow
FROM t1
GROUP BY workflow
HAVING count(completion_date)>0 AND count(completion_date)<count(*);
