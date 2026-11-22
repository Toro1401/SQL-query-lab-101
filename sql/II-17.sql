WITH RECURSIVE n(x) AS(
SELECT 1
UNION ALL
SELECT x+1
FROM n
WHERE x<(
SELECT trials
FROM t1)),r(trial,step,score,penalty) AS(
SELECT x,0,0,0
FROM n
UNION ALL
SELECT trial,step+1,CASE WHEN penalty=1 THEN max(0,score-(1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6)) WHEN 1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6=6 THEN score ELSE score+1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6 END,1+rnd((
SELECT seed
FROM t1)+trial*100000+step)%6=6
FROM r
WHERE score<(
SELECT target
FROM t1) AND step<10000)
SELECT count(*),avg(1.0*step),min(step),max(step)
FROM r
WHERE score>=(
SELECT target
FROM t1);
