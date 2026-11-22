WITH offsets(dx,dy) AS(VALUES(1,2),(1,-2),(-1,2),(-1,-2),(2,1),(2,-1),(-2,1),(-2,-1))
SELECT (x+dx)||char(64+y+dy)
FROM t1
CROSS
JOIN offsets
WHERE x+dx BETWEEN 1 AND 8 AND y+dy BETWEEN 1 AND 8;
