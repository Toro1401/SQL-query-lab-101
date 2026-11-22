WITH RECURSIVE h AS (
SELECT *,0 depth,','||employee_id||',' path
FROM t1
WHERE manager_id IS NULL
UNION ALL
SELECT e.*,h.depth+1,h.path||e.employee_id||','
FROM t1 e
JOIN h ON e.manager_id=h.employee_id
WHERE instr(h.path,','||e.employee_id||',')=0)
SELECT employee_id,manager_id,job_title,depth
FROM h;
