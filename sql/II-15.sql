WITH RECURSIVE numbers(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM numbers
WHERE x<52),deck AS MATERIALIZED(
SELECT x card,2+(x-1)%13 rank,row_number() OVER(
ORDER BY rnd(x+(
SELECT seed
FROM t1)),x) pos
FROM numbers),turns AS(
SELECT a.pos,a.card,a.rank,b.card next_card,b.rank next_rank,(
SELECT count(*)
FROM deck c
WHERE c.pos>a.pos AND c.rank>a.rank) hi,(
SELECT count(*)
FROM deck c
WHERE c.pos>a.pos AND c.rank<a.rank) lo
FROM deck a
JOIN deck b ON b.pos=a.pos+1)
SELECT pos,card,rank,next_card,next_rank,hi,lo,CASE WHEN hi>lo THEN 'Higher' WHEN lo>hi THEN 'Lower' WHEN rnd(pos+(
SELECT seed
FROM t1)+1000)%2=0 THEN 'Higher' ELSE 'Lower' END guess
FROM turns
ORDER BY pos;
