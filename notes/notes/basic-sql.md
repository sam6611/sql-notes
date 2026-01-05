INTRODUCTION TO SQL
What is SQL?

SQL (Structured Query Language) is used to:

Store data

Retrieve data

Manipulate data

Control database access

Why SQL?

Used in Data Science, Data Analysis, Backend, ML, BI

Works with large structured data

Industry standard (used everywhere)

2️⃣ DATABASE BASICS
What is Database?

A database is an organized collection of data stored electronically.

Types of Databases

Relational (MySQL, PostgreSQL, Oracle, SQL Server)

NoSQL (MongoDB, Cassandra)

RDBMS

Data stored in tables (rows + columns)

Uses primary keys & foreign keys

Follows ACID properties

3️⃣ TABLE STRUCTURE
Table

Row = Record

Column = Attribute

Example
CREATE TABLE Student (
    id INT,
    name VARCHAR(50),
    age INT
);

4️⃣ SQL COMMAND TYPES
1. DDL – Data Definition Language

Used to define structure

CREATE

ALTER

DROP

TRUNCATE

2. DML – Data Manipulation Language

Used to modify data

INSERT

UPDATE

DELETE

3. DQL – Data Query Language

Used to fetch data

SELECT

4. DCL – Data Control Language

Used for permissions

GRANT

REVOKE

5. TCL – Transaction Control Language

Used for transactions

COMMIT

ROLLBACK

SAVEPOINT

5️⃣ DDL COMMANDS
CREATE
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT
);

ALTER
ALTER TABLE Employee ADD department VARCHAR(30);
ALTER TABLE Employee MODIFY salary FLOAT;
ALTER TABLE Employee DROP department;

DROP
DROP TABLE Employee;

TRUNCATE
TRUNCATE TABLE Employee;


👉 Difference:

DELETE → removes rows

TRUNCATE → removes all rows (faster)

DROP → removes table structure

6️⃣ DML COMMANDS
INSERT
INSERT INTO Employee VALUES (1, 'Rahul', 50000);
INSERT INTO Employee (emp_id, emp_name) VALUES (2, 'Aman');

UPDATE
UPDATE Employee
SET salary = 60000
WHERE emp_id = 1;

DELETE
DELETE FROM Employee WHERE emp_id = 2;

7️⃣ SELECT QUERY (MOST IMPORTANT)
Basic SELECT
SELECT * FROM Employee;
SELECT emp_name, salary FROM Employee;

WHERE Clause
SELECT * FROM Employee WHERE salary > 40000;

AND / OR / NOT
SELECT * FROM Employee
WHERE salary > 40000 AND department = 'IT';

8️⃣ OPERATORS
Comparison

=

!=

>

<

>=

<=

BETWEEN
SELECT * FROM Employee WHERE salary BETWEEN 30000 AND 60000;

IN
SELECT * FROM Employee WHERE department IN ('IT','HR');

LIKE
SELECT * FROM Employee WHERE emp_name LIKE 'A%';

IS NULL
SELECT * FROM Employee WHERE department IS NULL;

9️⃣ ORDER BY & LIMIT
ORDER BY
SELECT * FROM Employee ORDER BY salary DESC;

LIMIT
SELECT * FROM Employee LIMIT 5;

🔟 AGGREGATE FUNCTIONS
Function	Use
COUNT()	Number of rows
SUM()	Total
AVG()	Average
MIN()	Minimum
MAX()	Maximum
SELECT COUNT(*) FROM Employee;
SELECT AVG(salary) FROM Employee;

1️⃣1️⃣ GROUP BY & HAVING
GROUP BY
SELECT department, AVG(salary)
FROM Employee
GROUP BY department;

HAVING
SELECT department, COUNT(*)
FROM Employee
GROUP BY department
HAVING COUNT(*) > 2;


👉 WHERE → filters rows
👉 HAVING → filters groups

1️⃣2️⃣ JOINS (VERY IMPORTANT 🔥)
Types of Joins

INNER JOIN

LEFT JOIN

RIGHT JOIN

FULL JOIN

SELF JOIN

INNER JOIN
SELECT e.emp_name, d.dept_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

LEFT JOIN
SELECT *
FROM Employee e
LEFT JOIN Department d
ON e.dept_id = d.dept_id;

1️⃣3️⃣ SUBQUERIES
Subquery in WHERE
SELECT *
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

Subquery in FROM
SELECT *
FROM (SELECT * FROM Employee WHERE salary > 50000) AS temp;

1️⃣4️⃣ CONSTRAINTS
Types

PRIMARY KEY

FOREIGN KEY

UNIQUE

NOT NULL

CHECK

DEFAULT

Example
CREATE TABLE Student (
    id INT PRIMARY KEY,
    email VARCHAR(50) UNIQUE,
    age INT CHECK (age >= 18)
);

1️⃣5️⃣ KEYS
Primary Key

Uniquely identifies a row

Cannot be NULL

Foreign Key

Links two tables

FOREIGN KEY (dept_id) REFERENCES Department(dept_id)

1️⃣6️⃣ NORMALIZATION
Purpose

Reduce redundancy

Improve data integrity

Normal Forms

1NF – Atomic values

2NF – No partial dependency

3NF – No transitive dependency

1️⃣7️⃣ VIEWS
What is View?

A virtual table based on SELECT query

CREATE VIEW emp_view AS
SELECT emp_name, salary FROM Employee;

1️⃣8️⃣ INDEXES
Why Index?

Faster data retrieval

CREATE INDEX idx_salary ON Employee(salary);


⚠️ Slows down INSERT/UPDATE slightly

1️⃣9️⃣ TRANSACTIONS
ACID Properties

Atomicity

Consistency

Isolation

Durability

Example
START TRANSACTION;
UPDATE Employee SET salary = 70000 WHERE emp_id = 1;
COMMIT;

ROLLBACK;

2️⃣0️⃣ STORED PROCEDURES
CREATE PROCEDURE getEmployees()
BEGIN
    SELECT * FROM Employee;
END;

CALL getEmployees();

2️⃣1️⃣ FUNCTIONS
CREATE FUNCTION bonus(salary INT)
RETURNS INT
RETURN salary * 0.10;

2️⃣2️⃣ TRIGGERS

Automatically executed on INSERT/UPDATE/DELETE

CREATE TRIGGER before_insert
BEFORE INSERT ON Employee
FOR EACH ROW
SET NEW.salary = NEW.salary + 1000;

2️⃣3️⃣ WINDOW FUNCTIONS (ADVANCED 🔥)
ROW_NUMBER
SELECT emp_name, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM Employee;

RANK vs DENSE_RANK

RANK → skips numbers

DENSE_RANK → no skip

2️⃣4️⃣ CASE STATEMENT
SELECT emp_name,
CASE
    WHEN salary > 50000 THEN 'High'
    ELSE 'Low'
END AS salary_status
FROM Employee;
