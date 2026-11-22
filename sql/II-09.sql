WITH RECURSIVE w(id,string,start,rest,rn) AS(
SELECT rowid,statement,1,statement,1
FROM t1
UNION ALL
SELECT id,string,start+instr(rest,' '),substr(rest,instr(rest,' ')+1),rn+1
FROM w
WHERE instr(rest,' ')>0)
SELECT rn,id,string,start,CASE WHEN instr(rest,' ')>0 THEN start+instr(rest,' ')-1 END,rtrim(CASE WHEN instr(rest,' ')=0 THEN rest ELSE substr(rest,1,instr(rest,' ')-1) END,';'),length(string)-length(replace(string,' ',''))
FROM w;
