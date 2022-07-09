
/* 15 minutes */
DROP TABLE IF EXISTS lots_of_data;
CREATE TABLE lots_of_data
(
    n INTEGER NOT NULL
)
;
INSERT INTO lots_of_data
    WITH
        tmp AS (
                  SELECT 0 AS n
            UNION SELECT 1
            UNION SELECT 2
            UNION SELECT 3
            UNION SELECT 4
            UNION SELECT 5
            UNION SELECT 6
            UNION SELECT 7
            UNION SELECT 8
            UNION SELECT 9
        )

    SELECT
        0
            + tmp_1.n
            + tmp_2.n * 10
            + tmp_3.n * 100
            + tmp_4.n * 1000
            + tmp_5.n * 10000
            + tmp_6.n * 100000
            + tmp_7.n * 1000000
            + tmp_8.n * 10000000
            + tmp_9.n * 100000000
        AS n
    FROM tmp AS tmp_1
        CROSS JOIN tmp AS tmp_2
        CROSS JOIN tmp AS tmp_3
        CROSS JOIN tmp AS tmp_4
        CROSS JOIN tmp AS tmp_5
        CROSS JOIN tmp AS tmp_6
        CROSS JOIN tmp AS tmp_7
        CROSS JOIN tmp AS tmp_8
        CROSS JOIN tmp AS tmp_9
    ORDER BY n
;
/* 10 minutes */
-- CREATE UNIQUE INDEX lots_of_data_n_index
-- 	ON lots_of_data(n)
-- ;


/* 10 minutes */
-- CREATE TABLE grouped AS
--     SELECT
--         n,
--         LENGTH(n) AS len
--     FROM lots_of_data
-- ;


/* 3 minutes */
DROP TABLE IF EXISTS small_table;
CREATE TABLE small_table
(
	n INTEGER NOT NULL
);
WITH
    base AS (SELECT n FROM lots_of_data WHERE n < 1000)

INSERT INTO small_table
        SELECT n      FROM base
    UNION
        SELECT n * -1 FROM base
;
-- CREATE UNIQUE INDEX small_table_n_index
-- 	ON small_table(n)
-- ;


/* 3 minutes */
DROP TABLE IF EXISTS medium_table;
CREATE TABLE medium_table
(
	n INTEGER NOT NULL
);
WITH
    base AS (SELECT n FROM lots_of_data WHERE n < 100000)

INSERT INTO medium_table
        SELECT n      FROM base
    UNION
        SELECT n * -1 FROM base
;
-- CREATE UNIQUE INDEX small_table_n_index
-- 	ON small_table(n)
-- ;
