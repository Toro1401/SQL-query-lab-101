-- I-33: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("order_id" INTEGER, "component" TEXT, "days_to_deliver" INTEGER);
INSERT INTO t1 VALUES (1, 'Aurora', 7);
INSERT INTO t1 VALUES (2, 'Twilight', 3);
INSERT INTO t1 VALUES (3, 'SunRay', 9);
CREATE TABLE t2 ("product" TEXT, "component" TEXT, "days_to_manufacture" INTEGER);
INSERT INTO t2 VALUES ('Aurora', 'Photon Coil', 7);
INSERT INTO t2 VALUES ('Aurora', 'Filament', 2);
INSERT INTO t2 VALUES ('Aurora', 'Shine Capacitor', 3);
INSERT INTO t2 VALUES ('Aurora', 'Glow Sphere', 1);
INSERT INTO t2 VALUES ('Twilight', 'Photon Coil', 7);
INSERT INTO t2 VALUES ('Twilight', 'Filament', 2);
INSERT INTO t2 VALUES ('SunRay', 'Shine Capacitor', 3);
INSERT INTO t2 VALUES ('SunRay', 'Photon Coil', 1);
