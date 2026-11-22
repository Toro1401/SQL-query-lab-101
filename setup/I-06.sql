-- I-06: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("workflow" TEXT, "step_number" INTEGER, "completion_date" TEXT);
INSERT INTO t1 VALUES ('Alpha', 1, '2018-07-02');
INSERT INTO t1 VALUES ('Alpha', 2, '2018-07-02');
INSERT INTO t1 VALUES ('Alpha', 3, '2018-07-01');
INSERT INTO t1 VALUES ('Bravo', 1, '2018-06-25');
INSERT INTO t1 VALUES ('Bravo', 2, NULL);
INSERT INTO t1 VALUES ('Bravo', 3, '2018-06-27');
INSERT INTO t1 VALUES ('Charlie', 1, NULL);
INSERT INTO t1 VALUES ('Charlie', 2, '2018-07-01');
INSERT INTO t1 VALUES ('Charlie', 2, '2018-07-01');
INSERT INTO t1 VALUES ('Delta', 1, NULL);
INSERT INTO t1 VALUES ('Delta', 2, NULL);
