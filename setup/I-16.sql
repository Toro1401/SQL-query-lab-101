-- I-16: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("player_a" INTEGER, "player_b" INTEGER, "score" INTEGER);
INSERT INTO t1 VALUES (1001, 2002, 150);
INSERT INTO t1 VALUES (3003, 4004, 15);
INSERT INTO t1 VALUES (4004, 3003, 125);
