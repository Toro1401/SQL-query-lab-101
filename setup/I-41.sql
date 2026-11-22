-- I-41: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("associate_1" TEXT, "associate_2" TEXT);
INSERT INTO t1 VALUES ('Anne', 'Betty');
INSERT INTO t1 VALUES ('Anne', 'Charles');
INSERT INTO t1 VALUES ('Betty', 'Dan');
INSERT INTO t1 VALUES ('Charles', 'Emma');
INSERT INTO t1 VALUES ('Francis', 'George');
INSERT INTO t1 VALUES ('George', 'Harriet');
