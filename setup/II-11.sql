-- II-11: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("step_number" INTEGER, "status" TEXT);
INSERT INTO t1 VALUES (1, 'Passed');
INSERT INTO t1 VALUES (2, 'Passed');
INSERT INTO t1 VALUES (3, 'Passed');
INSERT INTO t1 VALUES (4, 'Passed');
INSERT INTO t1 VALUES (5, 'Failed');
INSERT INTO t1 VALUES (6, 'Failed');
INSERT INTO t1 VALUES (7, 'Failed');
INSERT INTO t1 VALUES (8, 'Failed');
INSERT INTO t1 VALUES (9, 'Failed');
INSERT INTO t1 VALUES (10, 'Passed');
INSERT INTO t1 VALUES (11, 'Passed');
INSERT INTO t1 VALUES (12, 'Passed');
