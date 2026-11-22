WITH r AS(
SELECT DISTINCT region
FROM t1),d AS(
SELECT DISTINCT distributor
FROM t1),s AS(
SELECT region,distributor,sum(sales) sales
FROM t1
GROUP BY region,distributor)
SELECT r.region,d.distributor,coalesce(s.sales,0)
FROM r
CROSS
JOIN d
LEFT
JOIN s USING(region,distributor);
