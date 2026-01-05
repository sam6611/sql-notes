🔥 SQL Window Functions

Window functions are **advanced SQL functions** that perform calculations  
across a set of rows **without collapsing the result set**.

They are heavily used in:
- Interviews
- Analytics
- Data Science
- Real-world reporting

---

## 1️⃣ What is a Window Function?

A window function:
- Performs calculation across related rows
- Does NOT reduce number of rows
- Uses `OVER()` clause

### Syntax
sql
function_name() OVER (
    PARTITION BY column_name
    ORDER BY column_name
)
2️⃣ ROW_NUMBER()
Purpose
Assigns a unique sequential number to rows.

Example
sql
Copy code
SELECT name, department, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM Employee;
Use Case
Remove duplicates

Pagination

Practice Question
👉 Assign unique row numbers to employees ordered by salary.

3️⃣ RANK()
Purpose
Assigns rank to rows, skips rank if tie occurs.

Example
sql
Copy code
SELECT name, salary,
RANK() OVER (ORDER BY salary DESC) AS rank
FROM Employee;
Behavior
Salaries: 100, 90, 90, 80
Ranks: 1, 2, 2, 4

Practice Question
👉 Rank employees based on salary.

4️⃣ DENSE_RANK()
Purpose
Assigns rank without skipping numbers.

Example
sql
Copy code
SELECT name, salary,
DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM Employee;
Behavior
Salaries: 100, 90, 90, 80
Ranks: 1, 2, 2, 3

Difference
RANK	DENSE_RANK
Skips ranks	No skipping

Practice Question
👉 Find second highest salary using DENSE_RANK.

5️⃣ PARTITION BY
Purpose
Divides result set into groups (windows).

Example
sql
Copy code
SELECT name, department, salary,
RANK() OVER (
    PARTITION BY department
    ORDER BY salary DESC
) AS dept_rank
FROM Employee;
Use Case
Ranking within departments

Group-wise analysis

Practice Question
👉 Rank employees department-wise by salary.

6️⃣ Aggregate Window Functions
SUM() OVER()
sql
Copy code
SELECT name, salary,
SUM(salary) OVER () AS total_salary
FROM Employee;
AVG() OVER()
sql
Copy code
SELECT name, salary,
AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM Employee;
Use Case
Running totals

Group averages without GROUP BY

7️⃣ Running Total (Cumulative Sum)
sql
Copy code
SELECT name, salary,
SUM(salary) OVER (
    ORDER BY name
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total
FROM Employee;
Practice Question
👉 Calculate running total of salaries.

8️⃣ Window Functions vs GROUP BY
Window Functions	GROUP BY
Does not reduce rows	Reduces rows
Works row-wise	Works group-wise
Used for ranking	Used for aggregation

9️⃣ Common Interview Questions
Difference between RANK and DENSE_RANK?

When to use ROW_NUMBER?

Can we use WHERE with window functions?
