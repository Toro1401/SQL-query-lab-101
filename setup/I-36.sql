-- I-36: fixture SQLite, dati dalla traccia; date ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("route_id" INTEGER, "departure_city" TEXT, "arrival_city" TEXT, "cost" INTEGER);
INSERT INTO t1 VALUES (1, 'Austin', 'Dallas', 100);
INSERT INTO t1 VALUES (2, 'Dallas', 'Memphis', 200);
INSERT INTO t1 VALUES (3, 'Memphis', 'Des Moines', 300);
INSERT INTO t1 VALUES (4, 'Dallas', 'Des Moines', 400);
