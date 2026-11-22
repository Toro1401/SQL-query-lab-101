WITH a AS(
SELECT *,row_number() OVER(PARTITION BY product
ORDER BY manufacture_day,serial) rn
FROM t1)
SELECT max(CASE WHEN product='Bolt' THEN serial END),max(CASE WHEN product='Washer' THEN serial END),max(CASE WHEN product='Nut' THEN serial END)
FROM a
GROUP BY rn;
