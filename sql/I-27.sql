DELETE
FROM t1
WHERE rowid NOT IN(
SELECT min(rowid)
FROM t1
GROUP BY integer_value);
SELECT integer_value
FROM t1;
