
/*
    Select employees whose salary is greater than the average of their corresponding department
*/

/* using correlated subquery */
SELECT
    emp_id,
    name,
    department
FROM employees AS emp
WHERE True
    AND salary > (
        SELECT AVG(salary)
        FROM employees
        WHERE department = emp.department
    )
;


/* using window function */
WITH
    base AS (
        SELECT
            *,
            AVG(salary) OVER(
                PARTITION BY department
            ) AS dep_avg_salary
        FROM employees
    )

SELECT
    emp_id,
    name,
    department
FROM base
WHERE salary > dep_avg_salary
;


----------------------------------------------------------------------------------------------------

/* HAVING example */
SELECT department
FROM employees
GROUP BY department HAVING SUM(salary) > 5000
;

