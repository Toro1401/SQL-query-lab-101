-- II-18: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("trials" INTEGER, "people" INTEGER, "seed" INTEGER);
INSERT INTO t1 VALUES (10000, 23, 20261121);
