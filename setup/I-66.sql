-- I-66: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("serial" TEXT, "manufacture_day" INTEGER, "product" TEXT);
INSERT INTO t1 VALUES ('A111', 1, 'Bolt');
INSERT INTO t1 VALUES ('B111', 3, 'Bolt');
INSERT INTO t1 VALUES ('C111', 5, 'Bolt');
INSERT INTO t1 VALUES ('D222', 2, 'Washer');
INSERT INTO t1 VALUES ('E222', 4, 'Washer');
INSERT INTO t1 VALUES ('F222', 6, 'Washer');
INSERT INTO t1 VALUES ('G333', 3, 'Nut');
INSERT INTO t1 VALUES ('H333', 5, 'Nut');
INSERT INTO t1 VALUES ('I333', 7, 'Nut');
