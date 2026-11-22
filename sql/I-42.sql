WITH e(a,b) AS(
SELECT friend_1,friend_2
FROM t1
UNION
SELECT friend_2,friend_1
FROM t1)
SELECT a,b,(
SELECT count(*)
FROM e x
JOIN e y ON x.b=y.b
WHERE x.a=e.a AND y.a=e.b)
FROM e
WHERE a<b;
