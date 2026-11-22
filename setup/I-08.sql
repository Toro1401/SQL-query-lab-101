-- I-08: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("workflow" TEXT, "case_1" INTEGER, "case_2" INTEGER, "case_3" INTEGER);
INSERT INTO t1 VALUES ('Alpha', 0, 0, 0);
INSERT INTO t1 VALUES ('Bravo', 0, 1, 1);
INSERT INTO t1 VALUES ('Charlie', 1, 0, 0);
INSERT INTO t1 VALUES ('Delta', 0, 0, 0);
