-- II-20: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("days" INTEGER, "seed" INTEGER);
INSERT INTO t1 VALUES (100000, 20261121);
