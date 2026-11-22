CREATE TABLE pay (employee_id INTEGER NOT NULL CHECK(employee_id>0), fiscal_year INTEGER NOT NULL CHECK(fiscal_year BETWEEN 1900 AND 9998), start_date TEXT NOT NULL, end_date TEXT NOT NULL, pay_cents INTEGER NOT NULL CHECK(pay_cents>0), PRIMARY KEY(employee_id,fiscal_year), CHECK(start_date=printf('%04d-01-01',fiscal_year)), CHECK(end_date=printf('%04d-12-31',fiscal_year)));
INSERT INTO pay VALUES (1,2024,'2024-01-01','2024-12-31',10000);
SELECT *
FROM pay;
