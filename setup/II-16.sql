-- II-16: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("trials" INTEGER, "seed" INTEGER);
INSERT INTO t1 VALUES (10000, 20261121);
