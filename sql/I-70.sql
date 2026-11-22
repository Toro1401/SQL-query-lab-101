WITH a AS(
SELECT *,age-lag(age) OVER(PARTITION BY parent_id
ORDER BY age,child_id) gap
FROM t1)
SELECT parent_id,count(*),cast(avg(1.0*age) AS INTEGER),max(age)-min(age),coalesce(max(gap),0),min(age),max(age),group_concat(gender,', '
ORDER BY age,child_id)
FROM a
GROUP BY parent_id;
