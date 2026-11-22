WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),doors(d) AS(VALUES(1),(2),(3)),draws AS MATERIALIZED(
SELECT x,1+rnd(x*2+(
SELECT seed
FROM t1))%3 prize,1+rnd(x*2+1+(
SELECT seed
FROM t1))%3 choice
FROM n),host AS(
SELECT *,(
SELECT min(d)
FROM doors
WHERE d<>prize AND d<>choice) opened
FROM draws)
SELECT count(*),sum(prize=choice),sum(prize=6-choice-opened),sum(opened=prize OR opened=choice)
FROM host;
