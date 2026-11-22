-- I-62: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("vehicle_id" INTEGER, "type" TEXT, "model" TEXT, "price" INTEGER);
INSERT INTO t1 VALUES (1, 'Car', 'Rolls-Royce Phantom', 460000);
INSERT INTO t1 VALUES (2, 'Car', 'Cadillac CT5', 39000);
INSERT INTO t1 VALUES (3, 'Car', 'Porsche Boxster', 63000);
INSERT INTO t1 VALUES (4, 'Car', 'Lamborghini Spyder', 290000);
INSERT INTO t1 VALUES (5, 'Boat', 'Malibu', 210000);
INSERT INTO t1 VALUES (6, 'Boat', 'ATX 22-S', 85000);
INSERT INTO t1 VALUES (7, 'Boat', 'Sea Ray SLX', 520000);
INSERT INTO t1 VALUES (8, 'Boat', 'Mastercraft', 25000);
