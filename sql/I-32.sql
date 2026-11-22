SELECT job_description,(
SELECT spaceman_id
FROM t1 b
WHERE b.job_description=a.job_description
ORDER BY mission_count DESC,spaceman_id
LIMIT 1),(
SELECT spaceman_id
FROM t1 b
WHERE b.job_description=a.job_description
ORDER BY mission_count,spaceman_id
LIMIT 1)
FROM t1 a
GROUP BY job_description;
