-- I-75: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("box_id" TEXT, "length" INTEGER, "width" INTEGER, "height" INTEGER);
INSERT INTO t1 VALUES ('A', 10, 25, 15);
INSERT INTO t1 VALUES ('B', 15, 10, 25);
INSERT INTO t1 VALUES ('C', 10, 16, 24);
