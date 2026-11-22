WITH m AS(
SELECT ticket_id,count(DISTINCT CASE WHEN number IN(
SELECT number
FROM t1) THEN number END) n
FROM t2
GROUP BY ticket_id)
SELECT coalesce(sum(CASE WHEN n=(
SELECT count(DISTINCT number)
FROM t1) AND n>0 THEN 100 WHEN n>0 THEN 10 ELSE 0 END),0)
FROM m;
