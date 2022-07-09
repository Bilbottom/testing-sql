

CREATE TABLE tsb_employees (
    name TEXT,
    manager TEXT
);
INSERT INTO tsb_employees (name, manager) VALUES
    ('Vidya Nirmala', NULL),
    ('Abdul Qaiyum', 'Timothy Bedeau'),
    ('Timothy Bedeau', 'Vidya Nirmala'),
    ('Luke Burnett', 'Timothy Bedeau'),
    ('Marek Wazydrag', 'Abdul Qaiyum'),
    ('Charles Bridgen', 'Luke Burnett'),
    ('Claire Wilson', 'Vidya Nirmala'),
    ('Christopher Shaw', 'Claire Wilson'),
    ('Ji Eun Oh', 'Claire Wilson'),
    ('Vera Fernandes', 'Claire Wilson'),
    ('Matthew Stephens', 'Ji Eun Oh'),
    ('Oliver Joyce', 'Christopher Shaw'),
    ('Simon Seidmann', 'Christopher Shaw'),
    ('William Wallis', 'Ji Eun Oh'),
    ('Henry Butler', 'Vera Fernandes'),
    ('David Fearnhead', 'Vidya Nirmala'),
    ('Ketan Bharadwa', 'David Fearnhead'),
    ('Sunit Patel', 'David Fearnhead'),
    ('Tony Zhai', 'David Fearnhead'),
    ('Connor Young', 'Sunit Patel'),
    ('Jonathan Macleod', 'Sunit Patel'),
    ('Kyriakos Katsarakis', 'Ketan Bharadwa'),
    ('Simon Howe', 'Sunit Patel'),
    ('Siobhan Hilliard', 'Ketan Bharadwa')
;



DROP TABLE IF EXISTS tsb_employee_hierarchy;
CREATE TABLE tsb_employee_hierarchy AS
    WITH
        emp_hier AS (
            -- Boss
            SELECT
                name,
                manager,
                1 AS level
            FROM tsb_employees
            WHERE manager IS NULL
            -- Everyone else
            UNION ALL
            SELECT
                emp.name,
                emp.manager,
                eh.level + 1 AS level
            FROM tsb_employees AS emp
                INNER JOIN emp_hier AS eh
                    ON emp.manager = eh.name
            WHERE emp.manager IS NOT NULL
        )

    SELECT * FROM emp_hier
;


DROP TABLE IF EXISTS tsb_employee_id_map;
CREATE TABLE tsb_employee_id_map AS
    SELECT DISTINCT
        name,
        level,
        ROW_NUMBER() OVER(ORDER BY level, name) AS emp_id
    FROM tsb_employee_hierarchy
    ORDER BY emp_id
;


DROP TABLE IF EXISTS tsb_employee_ids;
CREATE TABLE tsb_employee_ids AS
    SELECT
        emp.name,
        emp.manager,
        emp_id.emp_id AS employee_id,
        man_id.emp_id AS manager_id
    FROM tsb_employees AS emp
        LEFT JOIN tsb_employee_id_map AS emp_id
            USING(name)
        LEFT JOIN tsb_employee_id_map AS man_id
            ON emp.manager = man_id.name
;

