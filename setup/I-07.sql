-- I-07: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("candidate_id" INTEGER, "description" TEXT);
INSERT INTO t1 VALUES (1001, 'Geologist');
INSERT INTO t1 VALUES (1001, 'Astrogator');
INSERT INTO t1 VALUES (1001, 'Biochemist');
INSERT INTO t1 VALUES (1001, 'Technician');
INSERT INTO t1 VALUES (2002, 'Surgeon');
INSERT INTO t1 VALUES (2002, 'Machinist');
INSERT INTO t1 VALUES (2002, 'Geologist');
INSERT INTO t1 VALUES (3003, 'Geologist');
INSERT INTO t1 VALUES (3003, 'Astrogator');
INSERT INTO t1 VALUES (4004, 'Selenologist');
CREATE TABLE t2 ("description" TEXT);
INSERT INTO t2 VALUES ('Geologist');
INSERT INTO t2 VALUES ('Astrogator');
INSERT INTO t2 VALUES ('Technician');
