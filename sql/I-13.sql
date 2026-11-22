SELECT date,quantity_adjustment,sum(quantity_adjustment) OVER(
ORDER BY date,rowid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) inventory
FROM t1
ORDER BY date,rowid;
