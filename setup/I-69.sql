-- I-69: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("parent" TEXT, "child" TEXT);
INSERT INTO t1 VALUES ('A', 'B');
INSERT INTO t1 VALUES ('A', 'C');
INSERT INTO t1 VALUES ('B', 'D');
INSERT INTO t1 VALUES ('B', 'E');
INSERT INTO t1 VALUES ('D', 'G');
INSERT INTO t1 VALUES ('C', 'F');
