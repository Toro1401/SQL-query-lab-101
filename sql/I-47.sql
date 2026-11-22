WITH bounds(id,t) AS(
SELECT schedule_id,start_time
FROM t1
UNION
SELECT schedule_id,end_time
FROM t1
UNION
SELECT a.schedule_id,max(a.start_time,s.start_time)
FROM t2 a
JOIN t1 s USING(schedule_id)
WHERE a.end_time>s.start_time AND a.start_time<s.end_time
UNION
SELECT a.schedule_id,min(a.end_time,s.end_time)
FROM t2 a
JOIN t1 s USING(schedule_id)
WHERE a.end_time>s.start_time AND a.start_time<s.end_time),segments AS(
SELECT id,t,lead(t) OVER(PARTITION BY id
ORDER BY t) fin
FROM bounds)
SELECT id,coalesce((
SELECT activity
FROM t2 a
WHERE a.schedule_id=id AND a.start_time<=t AND a.end_time>=fin
ORDER BY a.rowid
LIMIT 1),'Work'),t,fin
FROM segments
WHERE fin>t;
