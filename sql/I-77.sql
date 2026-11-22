WITH a AS(
SELECT *, (
SELECT temperature_value
FROM t1 b
WHERE b.temperature_id<a.temperature_id AND temperature_value IS NOT NULL
ORDER BY temperature_id DESC
LIMIT 1) prev,(
SELECT temperature_value
FROM t1 b
WHERE b.temperature_id>a.temperature_id AND temperature_value IS NOT NULL
ORDER BY temperature_id
LIMIT 1) next
FROM t1 a)
SELECT temperature_id,coalesce(temperature_value,CASE WHEN prev IS NULL THEN next WHEN next IS NULL THEN prev ELSE max(prev,next) END)
FROM a;
