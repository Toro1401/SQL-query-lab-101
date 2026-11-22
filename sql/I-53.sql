SELECT dense_rank() OVER(
ORDER BY max(primary_id,spouse_id)),primary_id,spouse_id
FROM t1;
