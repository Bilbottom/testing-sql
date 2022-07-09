
PRAGMA FOREIGN_KEYS = ON;


INSERT INTO department(dep_id, dep_name, dep_location)
VALUES
    (1001, 'Finance', 'Sydney'),
    (2001, 'Audit', 'Melbourne'),
    (3001, 'Marketing', 'Perth'),
    (4001, 'Production', 'Brisbane')
;

INSERT INTO employees(emp_id, emp_name, job_name, manager_id, hire_date, salary, commission, dep_id)
VALUES
    (63679, 'Sandrine', 'Clerk', 69062, '1990-12-18', 900, NULL, 2001),
    (64989, 'Adelyn', 'Salesman', 66928, '1991-02-20', 1700, 400, 3001),
    (65271, 'Wade', 'Salesman', 66928, '1991-02-22', 1350, 600, 3001),
    (65646, 'Jonas', 'Manager', 68319, '1991-04-02', 2957, NULL, 2001),
    (66564, 'Madden', 'Salesman', 66928, '1991-09-28', 1350, 1500, 3001),
    (66928, 'Blaze', 'Manager', 68319, '1991-05-01', 2750, NULL, 3001),
    (67832, 'Clare', 'Manager', 68319, '1991-06-09', 2550, NULL, 1001),
    (67858, 'Scarlet', 'Analyst', 65646, '1997-04-19', 3100, NULL, 2001),
    (68319, 'Kayling', 'President', NULL, '1991-11-18', 6000, NULL, 1001),
    (68454, 'Tucker', 'Salesman', 66928, '1991-09-08', 1600, 0, 3001),
    (68736, 'Adnres', 'Clerk', 67858, '1997-05-23', 1200, NULL, 2001),
    (69000, 'Julius', 'Clerk', 66928, '1991-12-03', 1050, NULL, 3001),
    (69062, 'Frank', 'Analyst', 65646, '1991-12-03', 3100, NULL, 2001),
    (69324, 'Marker', 'Clerk', 67832, '1992-01-23', 1400, NULL, 1001)
;

INSERT INTO salary_grade(grade, min_sal, max_sal)
VALUES
    (1, 800, 1300),
    (2, 1301, 1500),
    (3, 1501, 2100),
    (4, 2101, 3100),
    (5, 3101, 9999)
;
