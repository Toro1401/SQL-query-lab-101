WITH RECURSIVE r(e,p,total,term,sgn) AS(
SELECT equation,1,0,0,1
FROM t1
UNION ALL
SELECT e,p+1,CASE WHEN substr(e,p,1) IN('+','-') THEN total+sgn*term ELSE total END,CASE WHEN substr(e,p,1) IN('+','-') THEN 0 ELSE term*10+cast(substr(e,p,1) AS INTEGER) END,CASE substr(e,p,1) WHEN '+' THEN 1 WHEN '-' THEN -1 ELSE sgn END
FROM r
WHERE p<=length(e))
SELECT e,total+sgn*term
FROM r
WHERE p=length(e)+1;
