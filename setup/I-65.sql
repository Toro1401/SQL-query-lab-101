-- I-65: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("listing_id" INTEGER, "home_id" TEXT, "status" TEXT);
INSERT INTO t1 VALUES (1, 'Home A', 'New Listing');
INSERT INTO t1 VALUES (2, 'Home A', 'Pending');
INSERT INTO t1 VALUES (3, 'Home A', 'Relisted');
INSERT INTO t1 VALUES (4, 'Home B', 'New Listing');
INSERT INTO t1 VALUES (5, 'Home B', 'Under Contract');
INSERT INTO t1 VALUES (6, 'Home B', 'Relisted');
INSERT INTO t1 VALUES (7, 'Home C', 'New Listing');
INSERT INTO t1 VALUES (8, 'Home C', 'Under Contract');
INSERT INTO t1 VALUES (9, 'Home C', 'Closed');
