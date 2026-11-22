-- I-51: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("assembly_id" INTEGER, "part" TEXT);
INSERT INTO t1 VALUES (1001, 'Bolt');
INSERT INTO t1 VALUES (1001, 'Screw');
INSERT INTO t1 VALUES (2002, 'Nut');
INSERT INTO t1 VALUES (2002, 'Washer');
INSERT INTO t1 VALUES (3003, 'Toggle');
INSERT INTO t1 VALUES (3003, 'Bolt');
