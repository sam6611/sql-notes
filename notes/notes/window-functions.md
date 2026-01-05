 SQL Window Functions

Window functions are **advanced SQL functions** that perform calculations  
across a set of rows **without collapsing the result set**.

They are widely used in:
- Technical interviews
- Analytics and reporting
- Data science workflows
- Real-world business queries

---

## 1. What is a Window Function?

A window function:
- Performs calculations across related rows
- Does **not** reduce the number of rows
- Uses the `OVER()` clause

### Syntax
sql
function_name() OVER (
    PARTITION BY column_name
    ORDER BY column_name
)
2. ROW_NUMBER()
Purpose
Assigns a unique sequential number to each row.

Example
sql

SELECT name, department, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM Employee;
Use Cases
Removing duplicates

Pagination

Practice Question
Assign unique row numbers to employees ordered by salary.

3. RANK()
Purpose
Assigns a rank to rows and skips rank values when ties occur.

Example
sql

SELECT name, salary,
RANK() OVER (ORDER BY salary DESC) AS rank
FROM Employee;
Behavior
Salary	Rank
100	1
90	2
90	2
80	4

Practice Question
Rank employees based on salary.

4. DENSE_RANK()
Purpose
Assigns rank without skipping numbers when ties occur.

Example
sql

SELECT name, salary,
DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM Employee;
Behavior
Salary	Dense Rank
100	1
90	2
90	2
80	3

Difference Between RANK and DENSE_RANK
RANK	DENSE_RANK
Skips ranks	Does not skip ranks

Practice Question
Find the second highest salary using DENSE_RANK().

5. PARTITION BY
Purpose
Divides the result set into logical groups (windows).

Example

SELECT name, department, salary,
RANK() OVER (
    PARTITION BY department
    ORDER BY salary DESC
) AS dept_rank
FROM Employee;
Use Cases
Ranking within departments

Group-wise analysis

Practice Question
Rank employees department-wise based on salary.

6. Aggregate Window Functions
SUM() OVER()
sql

SELECT name, salary,
SUM(salary) OVER () AS total_salary
FROM Employee;
AVG() OVER()
sql

SELECT name, salary,
AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM Employee;
Use Cases
Running totals

Group averages without using GROUP BY

7. Running Total (Cumulative Sum)
sql

SELECT name, salary,
SUM(salary) OVER (
    ORDER BY name
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total
FROM Employee;
Practice Question
Calculate the running total of salaries.

Common Interview Questions

What is the difference between RANK() and DENSE_RANK()?

When should ROW_NUMBER() be used?

Can WHERE be used directly with window functions?

Difference between GROUP BY and window functions?
8. Window Functions vs GROUP BY
Window Functions	GROUP BY
Does not reduce rows	Reduces rows
Works row-wise	Works group-wise
Used for ranking	Used for aggregation

