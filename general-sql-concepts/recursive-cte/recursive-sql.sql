

SELECT * FROM tsb_employees;


SELECT employee_id, manager_id FROM tsb_employee_ids;


EXPLAIN QUERY PLAN
-- DROP TABLE IF EXISTS employee_hierarchy;
-- CREATE TEMPORARY TABLE employee_hierarchy AS
    WITH
        emp_hier AS (
            -- Boss
            SELECT
                employee_id,
                manager_id,
                1 AS level
            FROM tsb_employee_ids
            WHERE manager_id IS NULL
            -- Everyone else
            UNION ALL
            SELECT
                emp.employee_id,
                emp.manager_id,
                eh.level + 1 AS level
            FROM tsb_employee_ids AS emp
                INNER JOIN emp_hier AS eh
                    ON emp.manager_id = eh.employee_id
            WHERE emp.manager_id IS NOT NULL
        )

    SELECT * FROM emp_hier ORDER BY employee_id
;


SELECT * FROM tsb_employee_ids;



EXPLAIN --QUERY PLAN
    WITH
        emp_hier AS (
            -- Boss
            SELECT
                employee_id,
                manager_id,
                1 AS level
            FROM tsb_employee_ids
            WHERE manager_id IS NULL
            -- Everyone else
            UNION ALL
            SELECT
                emp.employee_id,
                emp.manager_id,
                eh.level + 1 AS level
            FROM tsb_employee_ids AS emp
                INNER JOIN emp_hier AS eh
                    ON emp.manager_id = eh.employee_id
            WHERE emp.manager_id IS NOT NULL
        )

    SELECT * FROM emp_hier ORDER BY employee_id
;

/*
https://www.sqlite.org/lang_explain.html
*/
