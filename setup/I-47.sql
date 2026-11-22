-- I-47: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("schedule_id" TEXT, "start_time" TEXT, "end_time" TEXT);
INSERT INTO t1 VALUES ('A', '2021-10-01 10:00', '2021-10-01 15:00');
INSERT INTO t1 VALUES ('B', '2021-10-01 10:15', '2021-10-01 12:15');
CREATE TABLE t2 ("schedule_id" TEXT, "activity" TEXT, "start_time" TEXT, "end_time" TEXT);
INSERT INTO t2 VALUES ('A', 'Meeting', '2021-10-01 10:00', '2021-10-01 10:30');
INSERT INTO t2 VALUES ('A', 'Break', '2021-10-01 12:00', '2021-10-01 12:30');
INSERT INTO t2 VALUES ('A', 'Meeting', '2021-10-01 13:00', '2021-10-01 13:30');
INSERT INTO t2 VALUES ('B', 'Break', '2021-10-01 11:00', '2021-10-01 11:15');
