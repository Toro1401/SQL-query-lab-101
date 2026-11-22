-- II-13: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("row" INTEGER, "col" INTEGER);
INSERT INTO t1 VALUES (5, 2);
