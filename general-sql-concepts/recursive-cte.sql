
/* Row Generation - Dates */
WITH dates AS (
        SELECT '2020-01-01' AS month_date
    UNION ALL
        SELECT DATE(month_date, '+1 month')
        FROM dates
        WHERE month_date < '2022-12-01'
)

SELECT *
FROM dates
;


/* Row Generation - Fibonacci Sequence */
WITH fib AS (
        SELECT
            1 AS n,
            0 AS f,
            1 AS f_1
    UNION ALL
        SELECT
            n + 1 AS n,
            f_1 AS f,
            f + f_1 AS f_1
        FROM fib
        WHERE n < 20
)

SELECT *
FROM fib
;


/* Employee Hierarchy */
WITH emps AS (
        SELECT
            emp_id,
            manager_id,
            emp_name,
            NULL AS manager_name,
            0 AS level
        FROM employees
        WHERE manager_id IS NULL
    UNION ALL
        SELECT
            employees.emp_id,
            employees.manager_id,
            employees.emp_name,
            emps.emp_name AS manager_name,
            emps.level + 1 AS level
        FROM employees
            INNER JOIN emps
                ON employees.manager_id = emps.emp_id
)

SELECT *
FROM emps
;
