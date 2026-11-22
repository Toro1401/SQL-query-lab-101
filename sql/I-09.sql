WITH people AS (
SELECT DISTINCT employee_id id
FROM t1)
SELECT a.id,b.id,(
SELECT count(DISTINCT license)
FROM t1
WHERE employee_id=a.id)
FROM people a
CROSS
JOIN people b
WHERE a.id<>b.id AND NOT EXISTS(
SELECT license
FROM t1
WHERE employee_id=a.id EXCEPT
SELECT license
FROM t1
WHERE employee_id=b.id) AND NOT EXISTS(
SELECT license
FROM t1
WHERE employee_id=b.id EXCEPT
SELECT license
FROM t1
WHERE employee_id=a.id);
