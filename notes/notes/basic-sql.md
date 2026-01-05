# Introduction to SQL

## What is SQL?

SQL (Structured Query Language) is used to:
- Store data
- Retrieve data
- Manipulate data
- Control database access

## Why SQL?
- Used in Data Science, Data Analysis, Backend, Machine Learning, and Business Intelligence
- Works efficiently with large structured datasets
- Industry-standard language used across organizations

---

## Database Basics

### What is a Database?
A database is an organized collection of data stored electronically.

### Types of Databases
- **Relational Databases**: MySQL, PostgreSQL, Oracle, SQL Server
- **NoSQL Databases**: MongoDB, Cassandra

### RDBMS (Relational Database Management System)
- Data stored in tables (rows and columns)
- Uses primary keys and foreign keys
- Follows ACID properties

---

## Table Structure

- **Row** → Record  
- **Column** → Attribute  

### Example
sql
CREATE TABLE Student (
    id INT,
    name VARCHAR(50),
    age INT
);

SQL Command Types
DDL – Data Definition Language

Used to define database structure:

CREATE

ALTER

DROP

TRUNCATE

DML – Data Manipulation Language

Used to modify data:

INSERT

UPDATE

DELETE

DQL – Data Query Language

Used to retrieve data:

SELECT

DCL – Data Control Language

Used to manage permissions:

GRANT

REVOKE

TCL – Transaction Control Language

Used for transactions:

COMMIT

ROLLBACK

SAVEPOINT

DDL Commands
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

Difference Between DELETE, TRUNCATE, DROP

DELETE → Removes rows

TRUNCATE → Removes all rows (faster)

DROP → Removes table structure

DML Commands
INSERT
INSERT INTO Employee VALUES (1, 'Rahul', 50000);
INSERT INTO Employee (emp_id, emp_name) VALUES (2, 'Aman');

UPDATE
UPDATE Employee
SET salary = 60000
WHERE emp_id = 1;

DELETE
DELETE FROM Employee
WHERE emp_id = 2;

SELECT Query
Basic SELECT
SELECT * FROM Employee;
SELECT emp_name, salary FROM Employee;

WHERE Clause
SELECT * FROM Employee
WHERE salary > 40000;

AND / OR / NOT
SELECT *
FROM Employee
WHERE salary > 40000 AND department = 'IT';

Operators
Comparison Operators

=

!=

<

=

<=

BETWEEN
SELECT *
FROM Employee
WHERE salary BETWEEN 30000 AND 60000;

IN
SELECT *
FROM Employee
WHERE department IN ('IT', 'HR');

LIKE
SELECT *
FROM Employee
WHERE emp_name LIKE 'A%';

IS NULL
SELECT *
FROM Employee
WHERE department IS NULL;

ORDER BY and LIMIT
ORDER BY
SELECT *
FROM Employee
ORDER BY salary DESC;

LIMIT
SELECT *
FROM Employee
LIMIT 5;

Aggregate Functions
Function	Description
COUNT()	Number of rows
SUM()	Total value
AVG()	Average value
MIN()	Minimum value
MAX()	Maximum value
SELECT COUNT(*) FROM Employee;
SELECT AVG(salary) FROM Employee;

GROUP BY and HAVING
GROUP BY
SELECT department, AVG(salary)
FROM Employee
GROUP BY department;

HAVING
SELECT department, COUNT(*)
FROM Employee
GROUP BY department
HAVING COUNT(*) > 2;


WHERE filters rows

HAVING filters groups

Joins
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

Subqueries
Subquery in WHERE
SELECT *
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

Subquery in FROM
SELECT *
FROM (
    SELECT *
    FROM Employee
    WHERE salary > 50000
) AS temp;

Constraints
Types of Constraints

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

Keys
Primary Key

Uniquely identifies each record

Cannot be NULL

Foreign Key

Links two tables

FOREIGN KEY (dept_id) REFERENCES Department(dept_id);

Normalization
Purpose

Reduce redundancy

Improve data integrity

Normal Forms

1NF – Atomic values

2NF – No partial dependency

3NF – No transitive dependency

Views
What is a View?

A virtual table created using a SELECT query.

CREATE VIEW emp_view AS
SELECT emp_name, salary
FROM Employee;

Indexes
Why Index?

Improves data retrieval speed

CREATE INDEX idx_salary
ON Employee(salary);


Note: Indexes slightly slow down INSERT and UPDATE operations.

Transactions
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

Stored Procedures
CREATE PROCEDURE getEmployees()
BEGIN
    SELECT * FROM Employee;
END;

CALL getEmployees();

Functions
CREATE FUNCTION bonus(salary INT)
RETURNS INT
RETURN salary * 0.10;

Triggers

Triggers are automatically executed on INSERT, UPDATE, or DELETE.

CREATE TRIGGER before_insert
BEFORE INSERT ON Employee
FOR EACH ROW
SET NEW.salary = NEW.salary + 1000;

Window Functions
ROW_NUMBER()
SELECT emp_name, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM Employee;

RANK vs DENSE_RANK

RANK → Skips numbers

DENSE_RANK → Does not skip numbers

CASE Statement
SELECT emp_name,
CASE
    WHEN salary > 50000 THEN 'High'
    ELSE 'Low'
END AS salary_status
FROM Employee;


