CREATE TABLE phones(customer_id INTEGER PRIMARY KEY,phone_number TEXT NOT NULL CHECK(length(phone_number)=14 AND phone_number GLOB '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'));
INSERT INTO phones
SELECT *
FROM t1;
SELECT *
FROM phones;
