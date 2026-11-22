-- I-43: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("order_id" INTEGER, "customer_id" INTEGER, "quantity" INTEGER);
INSERT INTO t1 VALUES (1, 1001, 5);
INSERT INTO t1 VALUES (2, 1001, 8);
INSERT INTO t1 VALUES (3, 1001, 3);
INSERT INTO t1 VALUES (4, 1001, 7);
INSERT INTO t1 VALUES (1, 2002, 4);
INSERT INTO t1 VALUES (2, 2002, 9);
