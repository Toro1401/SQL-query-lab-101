-- I-25: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("order_id" INTEGER, "customer_id" INTEGER, "count" INTEGER, "vendor" TEXT);
INSERT INTO t1 VALUES (1, 1001, 35, 'Direct Parts');
INSERT INTO t1 VALUES (2, 1001, 35, 'Direct Parts');
INSERT INTO t1 VALUES (3, 1001, 50, 'ACME');
INSERT INTO t1 VALUES (4, 2002, 10, 'ACME');
INSERT INTO t1 VALUES (5, 2002, 10, 'ACME');
INSERT INTO t1 VALUES (6, 2002, 15, 'Direct Parts');
