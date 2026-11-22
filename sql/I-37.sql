SELECT dense_rank() OVER(
ORDER BY distributor,facility,zone),*
FROM t1;
