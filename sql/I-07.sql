SELECT DISTINCT c.candidate_id
FROM t1 c
WHERE NOT EXISTS(
SELECT 1
FROM t2 r
WHERE NOT EXISTS(
SELECT 1
FROM t1 s
WHERE s.candidate_id=c.candidate_id AND s.description=r.description));
