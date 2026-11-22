-- I-53: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("primary_id" TEXT, "spouse_id" TEXT);
INSERT INTO t1 VALUES ('Pat', 'Charlie');
INSERT INTO t1 VALUES ('Jordan', 'Casey');
INSERT INTO t1 VALUES ('Ashley', 'Dee');
INSERT INTO t1 VALUES ('Charlie', 'Pat');
INSERT INTO t1 VALUES ('Casey', 'Jordan');
INSERT INTO t1 VALUES ('Dee', 'Ashley');
