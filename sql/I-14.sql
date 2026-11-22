SELECT workflow,CASE WHEN count(DISTINCT status)=1 THEN min(status) WHEN sum(status='Error')>0 THEN 'Indeterminate' ELSE 'Running' END
FROM t1
GROUP BY workflow;
