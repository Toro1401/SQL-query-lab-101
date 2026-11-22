-- I-22: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("workflow" TEXT, "message" TEXT, "occurrences" INTEGER);
INSERT INTO t1 VALUES ('Bravo', 'Error: Cannot Divide by 0', 3);
INSERT INTO t1 VALUES ('Alpha', 'Error: Conversion Failed', 5);
INSERT INTO t1 VALUES ('Charlie', 'Error: Conversion Failed', 7);
INSERT INTO t1 VALUES ('Alpha', 'Error: Unidentified error occurred', 9);
INSERT INTO t1 VALUES ('Bravo', 'Error: Unidentified error occurred', 1);
INSERT INTO t1 VALUES ('Charlie', 'Error: Unidentified error occurred', 10);
INSERT INTO t1 VALUES ('Alpha', 'Status Complete', 8);
INSERT INTO t1 VALUES ('Charlie', 'Status Complete', 6);
