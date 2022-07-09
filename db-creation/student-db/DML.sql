
PRAGMA FOREIGN_KEYS = ON;


INSERT INTO person(person_id, last_name, first_name, hire_date, enrollment_date, discriminator)
VALUES
    (1, 'Abercrombie', 'Kim', '1995-03-11', NULL, 'Instructor'),
    (2, 'Barzdukas', 'Gytis', NULL, '2005-09-01', 'Student'),
    (3, 'Justice', 'Peggy', NULL, '2001-09-01', 'Student'),
    (4, 'Fakhouri', 'Fadi', '2002-08-06', NULL, 'Instructor'),
    (5, 'Harui', 'Roger', '1998-07-01', NULL, 'Instructor'),
    (6, 'Li', 'Yan', NULL, '2002-09-01', 'Student'),
    (7, 'Norman', 'Laura', NULL, '2003-09-01', 'Student'),
    (8, 'Olivotto', 'Nino', NULL, '2005-09-01', 'Student'),
    (9, 'Tang', 'Wayne', NULL, '2005-09-01', 'Student'),
    (10, 'Alonso', 'Meredith', NULL, '2002-09-01', 'Student'),
    (11, 'Lopez', 'Sophia', NULL, '2004-09-01', 'Student'),
    (12, 'Browning', 'Meredith', NULL, '2000-09-01', 'Student'),
    (13, 'Anand', 'Arturo', NULL, '2003-09-01', 'Student'),
    (14, 'Walker', 'Alexandra', NULL, '2000-09-01', 'Student'),
    (15, 'Powell', 'Carson', NULL, '2004-09-01', 'Student'),
    (16, 'Jai', 'Damien', NULL, '2001-09-01', 'Student'),
    (17, 'Carlson', 'Robyn', NULL, '2005-09-01', 'Student'),
    (18, 'Zheng', 'Roger', '2004-02-12', NULL, 'Instructor'),
    (19, 'Bryant', 'Carson', NULL, '2001-09-01', 'Student'),
    (20, 'Suarez', 'Robyn', NULL, '2004-09-01', 'Student'),
    (21, 'Holt', 'Roger', NULL, '2004-09-01', 'Student'),
    (22, 'Alexander', 'Carson', NULL, '2005-09-01', 'Student'),
    (23, 'Morgan', 'Isaiah', NULL, '2001-09-01', 'Student'),
    (24, 'Martin', 'Randall', NULL, '2005-09-01', 'Student'),
    (25, 'Kapoor', 'Candace', '2001-01-15', NULL, 'Instructor'),
    (26, 'Rogers', 'Cody', NULL, '2002-09-01', 'Student'),
    (27, 'Serrano', 'Stacy', '1999-06-01', NULL, 'Instructor'),
    (28, 'White', 'Anthony', NULL, '2001-09-01', 'Student'),
    (29, 'Griffin', 'Rachel', NULL, '2004-09-01', 'Student'),
    (30, 'Shan', 'Alicia', NULL, '2003-09-01', 'Student'),
    (31, 'Stewart', 'Jasmine', '1997-10-12', NULL, 'Instructor'),
    (32, 'Xu', 'Kristen', '2001-7-23', NULL, 'Instructor'),
    (33, 'Gao', 'Erica', NULL, '2003-01-30', 'Student'),
    (34, 'Van Houten', 'Roger', '2000-12-07', NULL, 'Instructor')
;

INSERT INTO department(department_id, name, budget, start_date, administrator)
VALUES
    (1, 'Engineering', 350000.00, '2007-09-01', 2),
    (2, 'English', 120000.00, '2007-09-01', 6),
    (4, 'Economics', 200000.00, '2007-09-01', 4),
    (7, 'Mathematics', 250000.00, '2007-09-01', 3)
;

INSERT INTO course(course_id, title, credits, department_id)
VALUES
    (1050, 'Chemistry', 4, 1),
    (1061, 'Physics', 4, 1),
    (1045, 'Calculus', 4, 7),
    (2030, 'Poetry', 2, 2),
    (2021, 'Composition', 3, 2),
    (2042, 'Literature', 4, 2),
    (4022, 'Microeconomics', 3, 4),
    (4041, 'Macroeconomics', 3, 4),
    (4061, 'Quantitative', 2, 4),
    (3141, 'Trigonometry', 4, 7)
;

INSERT INTO online_course(course_id, url)
VALUES
    (2030, 'https://www.fineartschool.net/Poetry'),
    (2021, 'https://www.fineartschool.net/Composition'),
    (4041, 'https://www.fineartschool.net/Macroeconomics'),
    (3141, 'https://www.fineartschool.net/Trigonometry')
;

INSERT INTO onsite_course(course_id, location, days, time)
VALUES
    (1050, '123 Smith', 'MTWH', '11:30'),
    (1061, '234 Smith', 'TWHF', '13:15'),
    (1045, '121 Smith','MWHF', '15:30'),
    (4061, '22 Williams', 'TH', '11:15'),
    (2042, '225 Adams', 'MTWH', '11:00'),
    (4022, '23 Williams', 'MWF', '9:00')
;

INSERT INTO course_instructor(course_id, person_id)
VALUES
    (1050, 1),
    (1061, 31),
    (1045, 5),
    (2030, 4),
    (2021, 27),
    (2042, 25),
    (4022, 18),
    (4041, 32),
    (4061, 34)
;

INSERT INTO office_assignment(instructor_id, location)
VALUES
    (1, '17 Smith'),
    (4, '29 Adams'),
    (5, '37 Williams'),
    (18, '143 Smith'),
    (25, '57 Adams'),
    (27, '271 Williams'),
    (31, '131 Smith'),
    (32, '203 Williams'),
    (34, '213 Smith')
;

INSERT INTO student_grade(course_id, student_id, grade)
VALUES
    (2021, 2, 4),
    (2030, 2, 3.5),
    (2021, 3, 3),
    (2030, 3, 4),
    (2021, 6, 2.5),
    (2042, 6, 3.5),
    (2021, 7, 3.5),
    (2042, 7, 4),
    (2021, 8, 3),
    (2042, 8, 3),
    (4041, 9, 3.5),
    (4041, 10, NULL),
    (4041, 11, 2.5),
    (4041, 12, NULL),
    (4061, 12, NULL),
    (4022, 14, 3),
    (4022, 13, 4),
    (4061, 13, 4),
    (4041, 14, 3),
    (4022, 15, 2.5),
    (4022, 16, 2),
    (4022, 17, NULL),
    (4022, 19, 3.5),
    (4061, 20, 4),
    (4061, 21, 2),
    (4022, 22, 3),
    (4041, 22, 3.5),
    (4061, 22, 2.5),
    (4022, 23, 3),
    (1045, 23, 1.5),
    (1061, 24, 4),
    (1061, 25, 3),
    (1050, 26, 3.5),
    (1061, 26, 3),
    (1061, 27, 3),
    (1045, 28, 2.5),
    (1050, 28, 3.5),
    (1061, 29, 4),
    (1050, 30, 3.5),
    (1061, 30, 4)
;
