-- I-35: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("invoice_id" INTEGER, "sales_rep_id" INTEGER, "amount" INTEGER, "sales_type" TEXT);
INSERT INTO t1 VALUES (1, 1001, 13454, 'International');
INSERT INTO t1 VALUES (2, 2002, 3434, 'International');
INSERT INTO t1 VALUES (3, 4004, 54645, 'International');
INSERT INTO t1 VALUES (4, 5005, 234345, 'International');
INSERT INTO t1 VALUES (5, 1001, 4564, 'Domestic');
INSERT INTO t1 VALUES (6, 2002, 34534, 'Domestic');
INSERT INTO t1 VALUES (7, 3003, 345, 'Domestic');
INSERT INTO t1 VALUES (8, 6006, 6543, 'Domestic');
