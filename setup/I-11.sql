-- I-11: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("test_case" TEXT);
INSERT INTO t1 VALUES ('A');
INSERT INTO t1 VALUES ('B');
INSERT INTO t1 VALUES ('C');
