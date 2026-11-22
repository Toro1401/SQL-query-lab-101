-- I-49: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("line_order" INTEGER, "name" TEXT, "weight" INTEGER);
INSERT INTO t1 VALUES (1, 'Haruto', 611);
INSERT INTO t1 VALUES (2, 'Minato', 533);
INSERT INTO t1 VALUES (3, 'Haruki', 623);
INSERT INTO t1 VALUES (4, 'Sota', 569);
INSERT INTO t1 VALUES (5, 'Aoto', 610);
INSERT INTO t1 VALUES (6, 'Hinata', 525);
