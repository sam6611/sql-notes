# Advanced SQL Notes

This document covers **advanced SQL concepts** commonly required for:
- Technical interviews
- Placements
- Data analysis roles
- Backend development

Each topic includes:
- Concept explanation  
- SQL syntax and examples  
- Practice questions  

---

## 1. Subqueries (Inner Queries)

### Definition
A **subquery** is a query written inside another SQL query.

### When to Use
- When the result of one query is required by another
- When comparing values with aggregate results

### Types of Subqueries
- Single-row subquery  
- Multi-row subquery  
- Correlated subquery  

### Syntax
sql
SELECT column
FROM table
WHERE column operator (
    SELECT column FROM table
);
Example
sql

SELECT *
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);
Practice Question
Find employees earning more than the average salary.

2. Correlated Subqueries
Definition
A correlated subquery depends on the outer query and is executed row by row.

Example
sql

SELECT *
FROM Employee e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = e.department
);
Use Case
Compare an employee’s salary with the department average

Practice Question
Find employees earning more than their department’s average salary.

3. Joins (Advanced Understanding)
Why Joins?
Joins are used to combine data from multiple tables using common columns.

INNER JOIN
Returns only matching records from both tables.

sql

SELECT e.name, d.dept_name
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id;
LEFT JOIN
Returns all records from the left table and matching records from the right table.

sql

SELECT *
FROM Employee e
LEFT JOIN Department d
ON e.dept_id = d.dept_id;
Practice Question
Find customers who never placed an order.

4. Self Join
Definition
A self join joins a table with itself.

Example
sql

SELECT e.name AS Employee, m.name AS Manager
FROM Employee e
JOIN Employee m
ON e.managerId = m.id;
Practice Question
Find employees earning more than their managers.

5. GROUP BY and HAVING
GROUP BY
Used with aggregate functions to group rows.

HAVING
Used to filter groups, not individual rows.

Example
sql

SELECT department, COUNT(*)
FROM Employee
GROUP BY department
HAVING COUNT(*) > 3;
Difference Between WHERE and HAVING
WHERE	HAVING
Filters rows	Filters groups
Used before GROUP BY	Used after GROUP BY

Practice Question
Find departments having more than 5 employees.

6. Window Functions
Definition
Window functions perform calculations across related rows without collapsing rows.

Common Window Functions
ROW_NUMBER()

RANK()

DENSE_RANK()

SUM() OVER()

AVG() OVER()

Example
sql

SELECT name, salary,
RANK() OVER (ORDER BY salary DESC) AS rank
FROM Employee;
RANK vs DENSE_RANK
RANK	DENSE_RANK
Skips ranks	Does not skip ranks

Practice Question
Rank employees department-wise based on salary.

7. Finding Nth Highest Salary
Second Highest Salary (Subquery)
sql

SELECT MAX(salary)
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);
Using Window Function
sql

SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM Employee
) t
WHERE rnk = 2;
Practice Question
Find the third highest salary.

8. CASE Statement
Purpose
Used to apply conditional logic in SQL queries.

Example
sql

SELECT name,
CASE
    WHEN salary >= 60000 THEN 'High'
    WHEN salary >= 40000 THEN 'Medium'
    ELSE 'Low'
END AS salary_level
FROM Employee;
Practice Question
Categorize customers based on purchase amount.

9. Handling NULL Values
Important Note
NULL is not equal to 0.

IS NULL / IS NOT NULL
sql

SELECT *
FROM Employee
WHERE dept_id IS NULL;
COALESCE
Returns the first non-null value.

sql

SELECT COALESCE(dept_id, 'Not Assigned')
FROM Employee;
Practice Question
Display department as “Not Assigned” if it is NULL.

10. Duplicate Records
Find Duplicate Records
sql

SELECT email, COUNT(*)
FROM Users
GROUP BY email
HAVING COUNT(*) > 1;
Remove Duplicate Records
sql

DELETE FROM Users
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Users
    GROUP BY email
);
Practice Question
Remove duplicate customer records.

11. Transactions and ACID Properties
Transaction
A transaction is a group of SQL statements executed as a single unit.

Commands
sql

START TRANSACTION;
COMMIT;
ROLLBACK;
ACID Properties
Atomicity

Consistency

Isolation

Durability

Practice Question
Why is rollback important in banking systems?

12. Indexes
Purpose
Faster SELECT queries

Improved search performance

sql

CREATE INDEX idx_salary
ON Employee(salary);
Important Note
Overuse of indexes can slow down INSERT, UPDATE, and DELETE operations.

Practice Question
When should indexes not be used?

13. Views
Definition
A view is a virtual table created using a SELECT query.

sql

CREATE VIEW emp_view AS
SELECT name, salary
FROM Employee;
Use Cases
Security

Simplifying complex queries

Practice Question
Why are views safer than tables?

14. Stored Procedures
Purpose
Reusable logic

Faster execution

Improved security

sql

CREATE PROCEDURE getEmployees()
BEGIN
    SELECT * FROM Employee;
END;
Practice Question
Difference between a function and a stored procedure.

15. Triggers
Definition
A trigger is automatically executed when an INSERT, UPDATE, or DELETE occurs.

sql

CREATE TRIGGER before_insert
BEFORE INSERT ON Employee
FOR EACH ROW
SET NEW.salary = NEW.salary + 1000;
Use Cases
Audit logging

Automatic validation
