WITH a AS(
SELECT *,length(string)-length(replace(string,'"','')) n,instr(string,'"') p
FROM t1)
SELECT id,string,CASE WHEN n<>2 THEN 'Error' WHEN instr(substr(string,p+1),'"')-1>10 THEN 'True' ELSE 'False' END
FROM a;
