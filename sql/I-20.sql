SELECT product_id,effective_date,unit_price
FROM(
SELECT *,row_number() OVER(PARTITION BY product_id
ORDER BY effective_date DESC,rowid DESC) rn
FROM t1
WHERE effective_date<='2018-12-31')
WHERE rn=1;
