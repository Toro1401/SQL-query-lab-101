SELECT city
FROM t1
ORDER BY CASE city WHEN 'Baltimore' THEN 1 WHEN 'Denver' THEN 2 WHEN 'Atlanta' THEN 3 WHEN 'Chicago' THEN 4 ELSE 5 END,city;
