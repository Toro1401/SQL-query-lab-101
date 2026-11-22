-- I-63: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("order_id" INTEGER, "product" TEXT, "discount" TEXT);
INSERT INTO t1 VALUES (1, 'Item 1', 'PROMO');
INSERT INTO t1 VALUES (1, 'Item 1', 'PROMO');
INSERT INTO t1 VALUES (1, 'Item 1', 'MARKDOWN');
INSERT INTO t1 VALUES (1, 'Item 2', 'PROMO');
INSERT INTO t1 VALUES (2, 'Item 2', NULL);
INSERT INTO t1 VALUES (2, 'Item 3', 'MARKDOWN');
INSERT INTO t1 VALUES (2, 'Item 3', NULL);
INSERT INTO t1 VALUES (3, 'Item 1', 'PROMO');
INSERT INTO t1 VALUES (3, 'Item 1', 'PROMO');
INSERT INTO t1 VALUES (3, 'Item 1', 'PROMO');
INSERT INTO t1 VALUES (4, 'Item 1', 'PROMO');
INSERT INTO t1 VALUES (4, 'Item 1', 'MARKDOWN');
