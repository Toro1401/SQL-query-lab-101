SELECT birthday,group_concat(student,', '
ORDER BY student)
FROM t1
GROUP BY birthday
HAVING count(*)>1;
