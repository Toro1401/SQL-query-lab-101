-- I-73: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("step_id" INTEGER, "workflow" TEXT, "status" TEXT);
INSERT INTO t1 VALUES (1, 'Alpha', 'Open');
INSERT INTO t1 VALUES (2, 'Alpha', 'Open');
INSERT INTO t1 VALUES (3, 'Alpha', 'Inactive');
INSERT INTO t1 VALUES (4, 'Alpha', 'Open');
INSERT INTO t1 VALUES (5, 'Bravo', 'Closed');
INSERT INTO t1 VALUES (6, 'Bravo', 'Closed');
INSERT INTO t1 VALUES (7, 'Bravo', 'Open');
INSERT INTO t1 VALUES (8, 'Bravo', 'Inactive');
