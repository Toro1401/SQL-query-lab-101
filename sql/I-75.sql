WITH a AS(
SELECT box_id,min(length,width,height) lo,max(length,width,height) hi,length+width+height-min(length,width,height)-max(length,width,height) mid
FROM t1)
SELECT box_id,dense_rank() OVER(
ORDER BY lo,mid,hi)
FROM a;
