-- I-14: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("workflow" TEXT, "step_number" INTEGER, "status" TEXT);
INSERT INTO t1 VALUES ('Alpha', 1, 'Error');
INSERT INTO t1 VALUES ('Alpha', 2, 'Complete');
INSERT INTO t1 VALUES ('Alpha', 3, 'Running');
INSERT INTO t1 VALUES ('Bravo', 1, 'Complete');
INSERT INTO t1 VALUES ('Bravo', 2, 'Complete');
INSERT INTO t1 VALUES ('Charlie', 1, 'Running');
INSERT INTO t1 VALUES ('Charlie', 2, 'Running');
INSERT INTO t1 VALUES ('Delta', 1, 'Error');
INSERT INTO t1 VALUES ('Delta', 2, 'Error');
INSERT INTO t1 VALUES ('Echo', 1, 'Running');
INSERT INTO t1 VALUES ('Echo', 2, 'Complete');
