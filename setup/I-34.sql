-- I-34: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("order_id" INTEGER, "customer_id" INTEGER, "amount" INTEGER);
INSERT INTO t1 VALUES (1, 1001, 25);
INSERT INTO t1 VALUES (2, 1001, 50);
INSERT INTO t1 VALUES (3, 2002, 65);
INSERT INTO t1 VALUES (4, 3003, 50);
