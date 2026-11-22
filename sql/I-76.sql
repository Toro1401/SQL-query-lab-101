SELECT batch,batch_start,(
SELECT min(line)
FROM t2
WHERE t2.batch=t1.batch AND line>=batch_start AND trim(syntax)='GO')
FROM t1;
