-- I-68: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("team" TEXT, "year" INTEGER, "score" INTEGER);
INSERT INTO t1 VALUES ('Cougars', 2015, 50);
INSERT INTO t1 VALUES ('Cougars', 2016, 45);
INSERT INTO t1 VALUES ('Cougars', 2017, 65);
INSERT INTO t1 VALUES ('Cougars', 2018, 92);
INSERT INTO t1 VALUES ('Bulldogs', 2015, 65);
INSERT INTO t1 VALUES ('Bulldogs', 2016, 60);
INSERT INTO t1 VALUES ('Bulldogs', 2017, 58);
INSERT INTO t1 VALUES ('Bulldogs', 2018, 12);
