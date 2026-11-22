SELECT account_id
FROM t1
GROUP BY account_id
HAVING max(balance)<=0 AND count(balance)=count(*);
SELECT DISTINCT a.account_id
FROM t1 a
WHERE NOT EXISTS(
SELECT 1
FROM t1 b
WHERE b.account_id=a.account_id AND (b.balance>0 OR b.balance IS NULL));
