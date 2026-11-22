SELECT customer_id,balance_date,coalesce(date(lead(balance_date) OVER(PARTITION BY customer_id
ORDER BY balance_date),'-1 day'),'9999-12-31'),amount
FROM t1;
