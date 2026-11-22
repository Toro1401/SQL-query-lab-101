-- I-70: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("parent_id" INTEGER, "child_id" TEXT, "age" INTEGER, "gender" TEXT);
INSERT INTO t1 VALUES (1001, 'A', 8, 'M');
INSERT INTO t1 VALUES (1001, 'B', 12, 'F');
INSERT INTO t1 VALUES (2002, 'C', 7, 'F');
INSERT INTO t1 VALUES (2002, 'D', 9, 'F');
INSERT INTO t1 VALUES (2002, 'E', 14, 'M');
INSERT INTO t1 VALUES (3003, 'F', 12, 'F');
INSERT INTO t1 VALUES (3003, 'G', 14, 'M');
INSERT INTO t1 VALUES (4004, 'H', 7, 'M');
