SELECT row_number,(
SELECT b.test_case
FROM t1 b
WHERE b.row_number<=a.row_number AND b.test_case IS NOT NULL
ORDER BY b.row_number DESC
LIMIT 1)
FROM t1 a;
