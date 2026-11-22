-- I-01: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("item" TEXT);
INSERT INTO t1 VALUES ('Sugar');
INSERT INTO t1 VALUES ('Bread');
INSERT INTO t1 VALUES ('Juice');
INSERT INTO t1 VALUES ('Soda');
INSERT INTO t1 VALUES ('Flour');
CREATE TABLE t2 ("item" TEXT);
INSERT INTO t2 VALUES ('Sugar');
INSERT INTO t2 VALUES ('Bread');
INSERT INTO t2 VALUES ('Butter');
INSERT INTO t2 VALUES ('Cheese');
INSERT INTO t2 VALUES ('Fruit');
