WITH RECURSIVE p AS(
SELECT *,row_number() OVER(PARTITION BY batter_id
ORDER BY pitch_number) rn
FROM t1),r(batter_id,pitch_number,result,rn,b,s,nb,ns) AS(
SELECT batter_id,pitch_number,result,rn,0,0,result='Ball',result IN('Foul','Strike')
FROM p
WHERE rn=1
UNION ALL
SELECT p.batter_id,p.pitch_number,p.result,p.rn,r.nb,r.ns,r.nb+(p.result='Ball'),r.ns+(p.result='Strike' OR(p.result='Foul' AND r.ns<2))
FROM r
JOIN p ON p.batter_id=r.batter_id AND p.rn=r.rn+1
WHERE r.nb<4 AND r.ns<3 AND r.result<>'In Play')
SELECT batter_id,pitch_number,result,b||' - '||s,CASE WHEN result='In Play' THEN 'In-Play' ELSE nb||' - '||ns END
FROM r;
