WITH RECURSIVE options AS(
SELECT order_id,line_item a,line_item b,'('||line_item||')' label,1<<line_item mask
FROM t1
WHERE cost>=10
UNION ALL
SELECT a.order_id,a.line_item,b.line_item,'('||a.line_item||','||b.line_item||')',(1<<a.line_item)|(1<<b.line_item)
FROM t1 a
JOIN t1 b ON a.order_id=b.order_id AND a.line_item<b.line_item
WHERE a.cost+b.cost>=10),o AS(
SELECT *,row_number() OVER(PARTITION BY order_id
ORDER BY a,b) rn
FROM options),r(order_id,last,mask,k,labels) AS(
SELECT DISTINCT order_id,0,0,0,''
FROM t1
UNION ALL
SELECT r.order_id,o.rn,r.mask|o.mask,k+1,labels||CASE WHEN k=0 THEN '' ELSE ',' END||label
FROM r
JOIN o ON r.order_id=o.order_id AND o.rn>last AND (r.mask&o.mask)=0),ranked AS(
SELECT *,max(k) OVER(PARTITION BY order_id) best
FROM r)
SELECT order_id,k,nullif(labels,'')
FROM ranked
WHERE k=best;
