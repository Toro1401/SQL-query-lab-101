SELECT a.item AS cart1,b.item AS cart2
FROM t1 a
FULL
JOIN t2 b ON a.item=b.item;
