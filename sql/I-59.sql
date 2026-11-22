WITH RECURSIVE r(id,original,s) AS(
SELECT id,string,string
FROM t1
UNION ALL
SELECT id,original,replace(replace(replace(s,'()',''),'[]',''),'{}','')
FROM r
WHERE s<>replace(replace(replace(s,'()',''),'[]',''),'{}',''))
SELECT id,original,CASE WHEN s='' THEN 'Balanced' ELSE 'Unbalanced' END
FROM r
WHERE s=replace(replace(replace(s,'()',''),'[]',''),'{}','');
