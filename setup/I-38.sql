-- I-38: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("region" TEXT, "distributor" TEXT, "sales" INTEGER);
INSERT INTO t1 VALUES ('North', 'ACE', 10);
INSERT INTO t1 VALUES ('South', 'ACE', 67);
INSERT INTO t1 VALUES ('East', 'ACE', 54);
INSERT INTO t1 VALUES ('North', 'ACME', 65);
INSERT INTO t1 VALUES ('South', 'ACME', 9);
INSERT INTO t1 VALUES ('East', 'ACME', 1);
INSERT INTO t1 VALUES ('West', 'ACME', 7);
INSERT INTO t1 VALUES ('North', 'Direct Parts', 8);
INSERT INTO t1 VALUES ('South', 'Direct Parts', 7);
INSERT INTO t1 VALUES ('West', 'Direct Parts', 12);
