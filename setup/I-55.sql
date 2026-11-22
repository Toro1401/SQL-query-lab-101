-- I-55: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("product_name" TEXT, "quantity" INTEGER);
INSERT INTO t1 VALUES ('Widget', 7);
INSERT INTO t1 VALUES ('Doodad', 9);
INSERT INTO t1 VALUES ('Gizmo', 3);
CREATE TABLE t2 ("product_name" TEXT, "quantity" INTEGER);
INSERT INTO t2 VALUES ('Widget', 7);
INSERT INTO t2 VALUES ('Doodad', 6);
INSERT INTO t2 VALUES ('Dingbat', 9);
