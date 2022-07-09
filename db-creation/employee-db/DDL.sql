
PRAGMA FOREIGN_KEYS = OFF;


DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salary_grade;


CREATE TABLE department(
    dep_id       INTEGER NOT NULL PRIMARY KEY,
    dep_name     TEXT NOT NULL,
    dep_location TEXT NOT NULL
);

CREATE TABLE employees(
    emp_id     INTEGER NOT NULL PRIMARY KEY,
    emp_name   TEXT NOT NULL,
    job_name   TEXT NOT NULL,
    manager_id INTEGER REFERENCES employees(emp_id),
    hire_date  DATE NOT NULL, /* This is really just `TEXT` */
    salary     REAL NOT NULL,
    commission REAL,
    dep_id     INTEGER NOT NULL REFERENCES department(dep_id)
);

CREATE TABLE salary_grade(
    grade   INTEGER NOT NULL PRIMARY KEY,
    min_sal INTEGER NOT NULL,
    max_sal INTEGER NOT NULL
);