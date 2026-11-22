-- I-76: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("batch" TEXT, "batch_start" INTEGER);
INSERT INTO t1 VALUES ('A', 1);
INSERT INTO t1 VALUES ('A', 5);
CREATE TABLE t2 ("batch" TEXT, "line" INTEGER, "syntax" TEXT);
INSERT INTO t2 VALUES ('A', 1, 'SELECT *');
INSERT INTO t2 VALUES ('A', 2, 'FROM Account;');
INSERT INTO t2 VALUES ('A', 3, 'GO');
INSERT INTO t2 VALUES ('A', 4, NULL);
INSERT INTO t2 VALUES ('A', 5, 'TRUNCATE TABLE Accounts;');
INSERT INTO t2 VALUES ('A', 6, 'GO');
