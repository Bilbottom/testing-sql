
/*
    IN vs EXISTS
    ------------
*/


/*
    V1
*/


/* IN */
SELECT *
FROM small_table
WHERE n IN (SELECT n FROM lots_of_data)
;
/*
    6m 53s
*/


/* EXISTS */
SELECT *
FROM small_table
WHERE EXISTS(SELECT 1 FROM lots_of_data WHERE lots_of_data.n = small_table.n)
;
/*
    over an hour!
*/


/*
    V2
*/


/* IN */
SELECT *
FROM lots_of_data
WHERE n IN (SELECT n FROM small_table)
;
/*
    30ms
*/


/* EXISTS */
SELECT *
FROM lots_of_data
WHERE EXISTS(SELECT n FROM small_table WHERE small_table.n = lots_of_data.n)
;
/*
    30ms
*/


/*
    V3
*/


/* IN */
SELECT *
FROM small_table
WHERE n NOT IN (SELECT n FROM lots_of_data)
;
/*
    6m 53s
*/


/* EXISTS */
SELECT *
FROM small_table
WHERE NOT EXISTS(SELECT n FROM lots_of_data WHERE small_table.n = lots_of_data.n)
;
/*
    super long!
*/


/*
    V4
*/


/* IN */
SELECT *
FROM lots_of_data
WHERE n IN (SELECT n FROM medium_table)
;
/*
    30ms
*/


/* EXISTS */
SELECT *
FROM lots_of_data
WHERE EXISTS(SELECT n FROM medium_table WHERE medium_table.n = lots_of_data.n)
;
/*
    30ms
*/





--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

/* test window functions */
WITH
    base AS (
        SELECT
            n,
            LENGTH(n) AS len
        FROM lots_of_data
--         WHERE n < 100000
    )

SELECT
    n,
    len,
    COUNT(n) OVER(
        PARTITION BY len
    ) AS n_cnt,
    SUM(n) OVER(
        PARTITION BY len
    ) AS n_sum,
    AVG(n) OVER(
        PARTITION BY len
    ) AS n_avg
FROM base
;
/*
Time Taken for 10,000:
    1m 25s
    1m 43s
    1m 42s
    1m 42s
    1m 42s

Time Taken for 100,000:
    1m 43s
*/



/* test sub-queries */
WITH
    base AS (
        SELECT
            n,
            LENGTH(n) AS len
        FROM lots_of_data
--         WHERE n < 100000
    ),
    summary AS (
        SELECT
            len,
            COUNT(n) AS n_cnt,
            SUM(n) n_sum,
            AVG(n) AS n_avg
        FROM base
        GROUP BY 1
    )

SELECT
    base.n,
    base.len,
    summary.n_cnt,
    summary.n_sum,
    summary.n_avg
FROM base
    LEFT JOIN summary USING(len)
;
/*
Time Taken for 10,000:
    1m 42s
    1m 42s
    1m 42s
    1m 43s
    1m 42s

Time Taken for 100,000:
    1m 42s
*/


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

/* test window functions */
SELECT
    n,
    len,
    COUNT(n) OVER(
        PARTITION BY len
    ) AS n_cnt,
    SUM(n) OVER(
        PARTITION BY len
    ) AS n_sum,
    AVG(n) OVER(
        PARTITION BY len
    ) AS n_avg
FROM grouped
WHERE n < 10000
;
/*
Time Taken:
    1m 24s
*/


/* test sub-queries */
WITH
    summary AS (
        SELECT
            len,
            COUNT(n) AS n_cnt,
            SUM(n) n_sum,
            AVG(n) AS n_avg
        FROM grouped
        WHERE n < 10000
        GROUP BY 1
    )

SELECT
    grouped.n,
    grouped.len,
    summary.n_cnt,
    summary.n_sum,
    summary.n_avg
FROM grouped
    LEFT JOIN summary USING(len)
;
/*
Time Taken:
    1m 37s
*/
