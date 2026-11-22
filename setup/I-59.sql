-- I-59: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("id" INTEGER, "string" TEXT);
INSERT INTO t1 VALUES (1, '()');
INSERT INTO t1 VALUES (2, '[]');
INSERT INTO t1 VALUES (3, '{}');
INSERT INTO t1 VALUES (4, '((({})))');
INSERT INTO t1 VALUES (5, '()[]');
INSERT INTO t1 VALUES (6, '({})');
INSERT INTO t1 VALUES (7, '({)');
INSERT INTO t1 VALUES (8, '((())))');
INSERT INTO t1 VALUES (9, '}()[][');
