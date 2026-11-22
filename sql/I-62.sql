SELECT a.model,b.model
FROM t1 a
CROSS
JOIN t1 b
WHERE a.type='Car' AND b.type='Boat' AND a.price>=b.price+200000;
