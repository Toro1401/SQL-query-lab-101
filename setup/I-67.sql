-- I-67: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("student" TEXT, "birthday" TEXT);
INSERT INTO t1 VALUES ('Susan', '2015-04-15');
INSERT INTO t1 VALUES ('Tim', '2015-04-15');
INSERT INTO t1 VALUES ('Jacob', '2015-04-15');
INSERT INTO t1 VALUES ('Earl', '2015-02-05');
INSERT INTO t1 VALUES ('Mike', '2015-05-23');
INSERT INTO t1 VALUES ('Angie', '2015-05-23');
INSERT INTO t1 VALUES ('Jenny', '2015-11-19');
INSERT INTO t1 VALUES ('Michelle', '2015-12-12');
INSERT INTO t1 VALUES ('Aaron', '2015-12-18');
