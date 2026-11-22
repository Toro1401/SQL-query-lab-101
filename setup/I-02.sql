-- I-02: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("employee_id" INTEGER, "manager_id" INTEGER, "job_title" TEXT);
INSERT INTO t1 VALUES (1001, NULL, 'CEO');
INSERT INTO t1 VALUES (2002, 1001, 'Director');
INSERT INTO t1 VALUES (3003, 1001, 'Office Manager');
INSERT INTO t1 VALUES (4004, 2002, 'Engineer');
INSERT INTO t1 VALUES (5005, 2002, 'Engineer');
INSERT INTO t1 VALUES (6006, 2002, 'Engineer');
