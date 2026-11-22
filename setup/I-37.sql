-- I-37: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("order_id" INTEGER, "distributor" TEXT, "facility" INTEGER, "zone" TEXT, "amount" INTEGER);
INSERT INTO t1 VALUES (1, 'ACME', 123, 'ABC', 100);
INSERT INTO t1 VALUES (2, 'ACME', 123, 'ABC', 75);
INSERT INTO t1 VALUES (3, 'Direct Parts', 789, 'XYZ', 150);
INSERT INTO t1 VALUES (4, 'Direct Parts', 789, 'XYZ', 125);
