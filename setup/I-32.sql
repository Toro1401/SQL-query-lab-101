-- I-32: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("spaceman_id" INTEGER, "job_description" TEXT, "mission_count" INTEGER);
INSERT INTO t1 VALUES (1001, 'Astrogator', 6);
INSERT INTO t1 VALUES (2002, 'Astrogator', 12);
INSERT INTO t1 VALUES (3003, 'Astrogator', 17);
INSERT INTO t1 VALUES (4004, 'Geologist', 21);
INSERT INTO t1 VALUES (5005, 'Geologist', 9);
INSERT INTO t1 VALUES (6006, 'Geologist', 8);
INSERT INTO t1 VALUES (7007, 'Technician', 13);
INSERT INTO t1 VALUES (8008, 'Technician', 2);
INSERT INTO t1 VALUES (9009, 'Technician', 7);
