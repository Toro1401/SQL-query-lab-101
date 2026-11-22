-- I-05: SQLite fixture based on the prompt. Dates use ISO 8601.
PRAGMA foreign_keys=ON;
CREATE TABLE t1 ("customer_id" INTEGER, "type" TEXT, "phone_number" TEXT);
INSERT INTO t1 VALUES (1001, 'Cellular', '555-897-5421');
INSERT INTO t1 VALUES (1001, 'Work', '555-897-6542');
INSERT INTO t1 VALUES (1001, 'Home', '555-698-9874');
INSERT INTO t1 VALUES (2002, 'Cellular', '555-963-6544');
INSERT INTO t1 VALUES (2002, 'Work', '555-812-9856');
INSERT INTO t1 VALUES (3003, 'Cellular', '555-987-6541');
