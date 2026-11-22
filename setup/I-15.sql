-- I-15: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("sequence" INTEGER, "syntax" TEXT);
INSERT INTO t1 VALUES (1, 'SELECT');
INSERT INTO t1 VALUES (2, 'Product,');
INSERT INTO t1 VALUES (3, 'UnitPrice,');
INSERT INTO t1 VALUES (4, 'EffectiveDate');
INSERT INTO t1 VALUES (5, 'FROM');
INSERT INTO t1 VALUES (6, 'Products');
INSERT INTO t1 VALUES (7, 'WHERE');
INSERT INTO t1 VALUES (8, 'UnitPrice');
INSERT INTO t1 VALUES (9, '> 100');
