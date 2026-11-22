-- I-17: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("product" TEXT, "quantity" INTEGER);
INSERT INTO t1 VALUES ('Pencil', 3);
INSERT INTO t1 VALUES ('Eraser', 4);
INSERT INTO t1 VALUES ('Notebook', 2);
