WITH a AS(
SELECT *,sum(status IN('New Listing','Relisted')) OVER(
ORDER BY listing_id ROWS UNBOUNDED PRECEDING) global_id
FROM t1)
SELECT listing_id,home_id,status,max(CASE WHEN status IN('New Listing','Relisted') THEN global_id END) OVER(PARTITION BY home_id
ORDER BY listing_id ROWS UNBOUNDED PRECEDING)
FROM a;
