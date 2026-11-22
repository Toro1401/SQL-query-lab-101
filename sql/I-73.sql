SELECT a.*,(
SELECT count(DISTINCT b.status)
FROM t1 b
WHERE b.workflow=a.workflow AND b.step_id<=a.step_id)
FROM t1 a;
