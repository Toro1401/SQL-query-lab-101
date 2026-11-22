-- I-42: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("friend_1" TEXT, "friend_2" TEXT);
INSERT INTO t1 VALUES ('Jason', 'Mary');
INSERT INTO t1 VALUES ('Mike', 'Mary');
INSERT INTO t1 VALUES ('Mike', 'Jason');
INSERT INTO t1 VALUES ('Susan', 'Jason');
INSERT INTO t1 VALUES ('John', 'Mary');
INSERT INTO t1 VALUES ('Susan', 'Mary');
