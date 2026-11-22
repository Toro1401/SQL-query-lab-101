-- I-74: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("game_id" INTEGER, "bowler" TEXT, "score" INTEGER);
INSERT INTO t1 VALUES (1, 'John', 167);
INSERT INTO t1 VALUES (1, 'Susan', 139);
INSERT INTO t1 VALUES (1, 'Ralph', 95);
INSERT INTO t1 VALUES (1, 'Mary', 90);
INSERT INTO t1 VALUES (2, 'Susan', 187);
INSERT INTO t1 VALUES (2, 'John', 155);
INSERT INTO t1 VALUES (2, 'Dennis', 100);
INSERT INTO t1 VALUES (2, 'Anthony', 78);
