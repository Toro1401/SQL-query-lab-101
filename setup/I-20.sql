-- I-20: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("product_id" INTEGER, "effective_date" TEXT, "unit_price" REAL);
INSERT INTO t1 VALUES (1001, '2018-01-01', 1.99);
INSERT INTO t1 VALUES (1001, '2018-04-15', 2.99);
INSERT INTO t1 VALUES (1001, '2018-06-08', 3.99);
INSERT INTO t1 VALUES (2002, '2018-04-17', 1.99);
INSERT INTO t1 VALUES (2002, '2018-05-19', 2.99);
