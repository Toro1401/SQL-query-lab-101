-- II-09: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("statement" TEXT);
INSERT INTO t1 VALUES ('SELECT EmpID FROM Emps;');
INSERT INTO t1 VALUES ('SELECT * FROM Trans;');
