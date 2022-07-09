/*
    https://www.youtube.com/watch?v=SM9cDMxAeK4&ab_channel=Techtud
    https://youtu.be/SM9cDMxAeK4
*/

CREATE TABLE employees(
    emp_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL CHECK(TRIM(name) != ''),
    salary INTEGER NOT NULL CHECK (salary > 0),
    department TEXT NOT NULL CHECK(TRIM(salary) != '')
)
;
INSERT INTO employees(name, salary, department) VALUES
    ('A', 1000, 'CSE'),
    ('B', 2000, 'EC'),
    ('C', 3000, 'CSE'),
    ('D', 4000, 'EC')
;
