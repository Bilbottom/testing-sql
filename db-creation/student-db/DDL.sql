
PRAGMA FOREIGN_KEYS = OFF;


DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS onsite_course;
DROP TABLE IF EXISTS online_course;
DROP TABLE IF EXISTS student_grade;
DROP TABLE IF EXISTS course_instructor;
DROP TABLE IF EXISTS office_assignment;


CREATE TABLE department(
    department_id INTEGER NOT NULL PRIMARY KEY,
    name          TEXT NOT NULL,
    budget        REAL NOT NULL,
    start_date    TEXT NOT NULL,
    administrator INTEGER
);

CREATE TABLE person(
    person_id       INTEGER NOT NULL PRIMARY KEY,
    last_name       TEXT NOT NULL,
    first_name      TEXT NOT NULL,
    hire_date       DATE,
    enrollment_date TEXT,
    discriminator   TEXT NOT NULL
);

CREATE TABLE course(
    course_id     INTEGER NOT NULL PRIMARY KEY,
    title         TEXT NOT NULL,
    credits       INTEGER NOT NULL,
    department_id INTEGER NOT NULL REFERENCES department(department_id)
);

CREATE TABLE onsite_course(
    course_id INTEGER NOT NULL PRIMARY KEY REFERENCES course(course_id),
    location TEXT NOT NULL,
    days TEXT NOT NULL,
    time TEXT NOT NULL
);


CREATE TABLE online_course(
    course_id INTEGER NOT NULL PRIMARY KEY REFERENCES course(course_id),
    url TEXT NOT NULL
);

CREATE TABLE student_grade(
    enrollment_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    course_id     INTEGER NOT NULL REFERENCES course(course_id),
    student_id    INTEGER NOT NULL REFERENCES person(person_id),
    grade         REAL
);

CREATE TABLE course_instructor(
    course_id INTEGER NOT NULL REFERENCES course(course_id),
    person_id INTEGER NOT NULL REFERENCES person(person_id),
    PRIMARY KEY (course_id, person_id)
);

CREATE TABLE office_assignment(
    instructor_id INTEGER NOT NULL PRIMARY KEY REFERENCES person(person_id),
    location      TEXT NOT NULL,
    timestamp     TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
