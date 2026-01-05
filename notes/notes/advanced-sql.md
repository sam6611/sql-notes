1️⃣ Subqueries (Inner Queries)
What is a Subquery?

A query inside another query.

Used when:

Result of one query is needed by another

Data comparison with aggregate values

Types

Single-row subquery

Multi-row subquery

Correlated subquery

Syntax
SELECT column
FROM table
WHERE column operator (SELECT column FROM table);

Example
SELECT *
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

Practice Question

👉 Find employees earning more than average salary.

2️⃣ Correlated Subqueries
What is it?

Subquery that depends on outer query
Executed row by row

Example
SELECT *
FROM Employee e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = e.department
);

Use Case

Compare employee with department average

Practice Question

👉 Find employees earning more than their department’s average salary.

3️⃣ Joins (Advanced Understanding)
Why Joins?

To combine data from multiple tables using common columns.

INNER JOIN

Returns matching records only.

SELECT e.name, d.dept_name
FROM Employee e
JOIN Department d
ON e.dept_id = d.dept_id;

LEFT JOIN

Returns all records from left table.

SELECT *
FROM Employee e
LEFT JOIN Department d
ON e.dept_id = d.dept_id;

Practice Question

👉 Find customers who never placed an order.

4️⃣ Self Join
What is Self Join?

A table joined with itself.

Example
SELECT e.name AS Employee, m.name AS Manager
FROM Employee e
JOIN Employee m
ON e.managerId = m.id;

Practice Question

👉 Find employees earning more than their managers.

5️⃣ GROUP BY & HAVING (Deep Concept)
GROUP BY

Used with aggregate functions.

HAVING

Used to filter groups, not rows.

Example
SELECT department, COUNT(*)
FROM Employee
GROUP BY department
HAVING COUNT(*) > 3;

Difference
WHERE	HAVING
Filters rows	Filters groups
Before GROUP BY	After GROUP BY
Practice Question

👉 Find departments having more than 5 employees.

6️⃣ Window Functions (VERY IMPORTANT 🔥)
What are Window Functions?

Perform calculations without collapsing rows.

Common Functions

ROW_NUMBER()

RANK()

DENSE_RANK()

SUM() OVER()

AVG() OVER()

Example
SELECT name, salary,
RANK() OVER (ORDER BY salary DESC) AS rank
FROM Employee;

Difference
RANK	DENSE_RANK
Skips ranks	No skipping
Practice Question

👉 Rank employees based on salary department-wise.

7️⃣ Finding Nth Highest Salary
2nd Highest Salary
SELECT MAX(salary)
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

Using Window Function
SELECT salary
FROM (
    SELECT salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) rnk
    FROM Employee
) t
WHERE rnk = 2;

Practice Question

👉 Find 3rd highest salary.

8️⃣ CASE Statement
Purpose

Used for conditional logic in SQL.

Example
SELECT name,
CASE
    WHEN salary >= 60000 THEN 'High'
    WHEN salary >= 40000 THEN 'Medium'
    ELSE 'Low'
END AS salary_level
FROM Employee;

Practice Question

👉 Categorize customers based on purchase amount.

9️⃣ Handling NULL Values
NULL ≠ 0
IS NULL / IS NOT NULL
SELECT * FROM Employee WHERE dept_id IS NULL;

COALESCE

Returns first non-null value.

SELECT COALESCE(dept_id, 0) FROM Employee;

Practice Question

👉 Display department as “Not Assigned” if NULL.

🔟 Duplicate Records
Find Duplicates
SELECT email, COUNT(*)
FROM Users
GROUP BY email
HAVING COUNT(*) > 1;

Remove Duplicates
DELETE FROM Users
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Users
    GROUP BY email
);

Practice Question

👉 Remove duplicate customer records.

1️⃣1️⃣ Transactions & ACID
Transaction

A group of SQL statements executed as a unit.

Commands
START TRANSACTION;
COMMIT;
ROLLBACK;

ACID

Atomicity

Consistency

Isolation

Durability

Practice Question

👉 Why rollback is important in banking systems?

1️⃣2️⃣ Indexes
Purpose

Faster SELECT

Improves search performance

CREATE INDEX idx_salary ON Employee(salary);


⚠️ Overuse slows INSERT/UPDATE

Practice Question

👉 When should indexes NOT be used?

1️⃣3️⃣ Views
What is View?

Virtual table based on SELECT query.

CREATE VIEW emp_view AS
SELECT name, salary FROM Employee;

Use Case

Security

Simplify complex queries

Practice Question

👉 Why views are safer than tables?

1️⃣4️⃣ Stored Procedures
Purpose

Reusable logic

Faster execution

Security

CREATE PROCEDURE getEmployees()
BEGIN
    SELECT * FROM Employee;
END;

Practice Question

👉 Difference between function and procedure.

1️⃣5️⃣ Triggers
What is Trigger?

Auto-executed SQL on INSERT/UPDATE/DELETE.

CREATE TRIGGER before_insert
BEFORE INSERT ON Employee
FOR EACH ROW
SET NEW.salary = NEW.salary + 1000;

Practice Question

👉 Use case of trigger in audit logging.

✅ FINAL REPO STRUCTURE (RECOMMENDED)
📁 advanced-sql-notes
 ┣ 📄 README.md
 ┣ 📄 advanced-sql-notes.md   👈 THIS FILE
 ┣ 📄 practice-questions.md
