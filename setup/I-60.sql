-- I-60: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("product" TEXT, "product_code" TEXT);
INSERT INTO t1 VALUES ('Alpha', '01');
INSERT INTO t1 VALUES ('Alpha', '02');
INSERT INTO t1 VALUES ('Bravo', '03');
INSERT INTO t1 VALUES ('Charlie', '02');
