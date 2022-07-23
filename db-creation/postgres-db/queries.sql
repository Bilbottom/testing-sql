
WITH RECURSIVE dates AS (
        SELECT CAST('2020-01-01' AS DATE) AS report_date
    UNION ALL
        SELECT CAST(report_date + INTERVAL '1 month' AS DATE)
        FROM dates
        WHERE report_date < CURRENT_DATE
)

SELECT *
FROM dates
;


-- DROP TABLE IF EXISTS title_ratings;
CREATE TEMPORARY TABLE title_ratings AS
    SELECT
        tconst,
        CAST(average_rating AS NUMERIC(4, 2)) AS average_rating,
        CAST(num_votes AS INTEGER) AS num_votes
    FROM raw_title_ratings
    LIMIT 1000
;
-- CREATE INDEX title_ratings_pk ON title_ratings(tconst);
ALTER TABLE title_ratings ADD PRIMARY KEY (tconst);

SELECT * FROM title_ratings;


/* Confidence ratings */
SELECT
    tconst,
    average_rating,
    num_votes,
    CAST(1.0 * num_votes / MAX(num_votes) OVER() AS NUMERIC(5, 4)) AS confidence_rating
FROM title_ratings
;


/* Running totals */
SELECT
    tconst,
    average_rating,
    num_votes,
    SUM(num_votes) OVER(ORDER BY tconst) AS num_votes_running_total
FROM title_ratings
ORDER BY tconst
;


/* Running averages */
SELECT
    tconst,
    average_rating,
    num_votes,
    CAST(
        (1.0
            * SUM(num_votes) OVER(ORDER BY tconst ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
            / COUNT(num_votes) OVER(ORDER BY tconst ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
        ) AS DECIMAL(15, 4)
    ) AS num_votes_3_month_moving_average
FROM title_ratings
ORDER BY tconst
;


/* Running averages */
SELECT
    tconst,
    average_rating,
    num_votes,
    CAST(
        (1.0
            * SUM(num_votes) OVER(ORDER BY tconst ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
            / COUNT(num_votes) OVER(ORDER BY tconst ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
        ) AS DECIMAL(15, 4)
    ) AS num_votes_3_month_moving_average
FROM title_ratings
ORDER BY tconst
;


/* Running averages */
WITH cte_agg AS (
    SELECT
        tconst,
        average_rating,
        num_votes,
        MIN(num_votes) OVER (ORDER BY tconst ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS min_in_window,
        MAX(num_votes) OVER (ORDER BY tconst ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS max_in_window
    FROM title_ratings
    ORDER BY tconst
)

SELECT
    tconst,
    average_rating,
    num_votes,
    min_in_window,
    max_in_window,
    CAST(2.0 * num_votes / (max_in_window + min_in_window) AS NUMERIC(6, 4)) AS ratio_from_avg
FROM cte_agg
;


SELECT
    tconst,
    average_rating,
    num_votes,
    num_votes > 500 AS threshold_met
FROM title_ratings
;


SELECT 'Hello' = 'hello';



SELECT
    col1,
    col2,
    col1 = col2 AS check_equal
FROM (
    VALUES
        ('a', 'b'),
        ('c', 'c'),
        ('d', NULL)
) AS vals(col1, col2)
WHERE (col2 IN ('b')) IS NULL
;


SELECT
    oid,
    datname,
    datdba,
    encoding,
    datcollate,
    datctype,
    datistemplate,
    datallowconn,
    datconnlimit,
    datlastsysoid,
    datfrozenxid,
    datminmxid,
    dattablespace,
    datacl
FROM pg_database
;

SELECT *
FROM pg_collation
;
