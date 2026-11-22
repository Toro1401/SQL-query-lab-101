WITH RECURSIVE r(city,path,cost,visited) AS(
SELECT 'Austin','Austin',0,',Austin,'
UNION ALL
SELECT arrival_city,path||' --> '||arrival_city,r.cost+t1.cost,visited||arrival_city||','
FROM r
JOIN t1 ON departure_city=city
WHERE city<>'Des Moines' AND instr(visited,','||arrival_city||',')=0)
SELECT path,cost
FROM r
WHERE city='Des Moines';
