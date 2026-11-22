CREATE TABLE products_data(product_id INTEGER PRIMARY KEY,product_name TEXT);
INSERT INTO products_data VALUES (1,'Widget');
CREATE VIEW products AS
SELECT product_id,product_name,forbid_star() AS forbidden
FROM products_data;
SELECT product_id,product_name
FROM products;
