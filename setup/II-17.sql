-- II-17: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("trials" INTEGER, "target" INTEGER, "seed" INTEGER);
INSERT INTO t1 VALUES (10000, 100, 20261121);
