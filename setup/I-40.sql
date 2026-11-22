-- I-40: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("city" TEXT);
INSERT INTO t1 VALUES ('Atlanta');
INSERT INTO t1 VALUES ('Baltimore');
INSERT INTO t1 VALUES ('Chicago');
INSERT INTO t1 VALUES ('Denver');
