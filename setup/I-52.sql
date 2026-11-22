-- I-52: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("customer_id" INTEGER, "phone_number" TEXT);
INSERT INTO t1 VALUES (1001, '(555)-555-5555');
INSERT INTO t1 VALUES (2002, '(555)-555-5555');
INSERT INTO t1 VALUES (3003, '(555)-555-5555');
