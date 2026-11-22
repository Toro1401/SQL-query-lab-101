-- I-71: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("employee_id" INTEGER, "department" TEXT);
INSERT INTO t1 VALUES (1001, 'Engineering');
INSERT INTO t1 VALUES (2002, 'Sales');
INSERT INTO t1 VALUES (3003, 'Marketing');
CREATE TABLE t2 ("employee_id" INTEGER, "department" TEXT);
INSERT INTO t2 VALUES (4004, 'Marketing');
INSERT INTO t2 VALUES (5005, 'Accounting');
INSERT INTO t2 VALUES (6006, 'Accounting');
CREATE TABLE t3 ("employee_id" INTEGER, "name" TEXT);
INSERT INTO t3 VALUES (1001, 'John');
INSERT INTO t3 VALUES (2002, 'Eric');
INSERT INTO t3 VALUES (3003, 'Jennifer');
INSERT INTO t3 VALUES (4004, 'Bob');
INSERT INTO t3 VALUES (5005, 'Stuart');
INSERT INTO t3 VALUES (6006, 'Angie');
