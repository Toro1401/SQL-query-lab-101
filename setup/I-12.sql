-- I-12: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("workflow" TEXT, "execution_date" TEXT);
INSERT INTO t1 VALUES ('Alpha', '2018-06-01');
INSERT INTO t1 VALUES ('Alpha', '2018-06-14');
INSERT INTO t1 VALUES ('Alpha', '2018-06-15');
INSERT INTO t1 VALUES ('Bravo', '2018-06-01');
INSERT INTO t1 VALUES ('Bravo', '2018-06-02');
INSERT INTO t1 VALUES ('Bravo', '2018-06-19');
INSERT INTO t1 VALUES ('Charlie', '2018-06-01');
INSERT INTO t1 VALUES ('Charlie', '2018-06-15');
INSERT INTO t1 VALUES ('Charlie', '2018-06-30');
