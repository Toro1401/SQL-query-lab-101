-- I-78: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("statusid" INTEGER, "status" TEXT);
INSERT INTO t1 VALUES (1, 'Completed');
INSERT INTO t1 VALUES (2, 'Fail');
INSERT INTO t1 VALUES (3, 'Unknown');
INSERT INTO t1 VALUES (4, 'Completed');
CREATE TABLE t2 ("statuscode" TEXT);
INSERT INTO t2 VALUES ('AE-Z3FE34-D');
