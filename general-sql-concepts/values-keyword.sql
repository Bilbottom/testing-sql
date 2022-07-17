
/* Using VALUES for a SELECT clause */
SELECT
    column1,
    column2
FROM (
    VALUES
        (1, 2),
        (3, 4)
)
;


/* Using VALUES to implement LEAST/GREATEST functions (SQL Server) */
WITH base AS (
    SELECT
        '2020-01-01' AS c1,
        '2020-02-01' AS c2,
        '2020-03-01' AS c3,
        '2020-04-01' AS c4,
        '2020-05-01' AS c5
    UNION SELECT
        '2021-01-01' AS c1,
        '2021-02-01' AS c2,
        '2021-03-01' AS c3,
        '2021-04-01' AS c4,
        '2021-05-01' AS c5
)

-- SELECT *, LEAST(c1, c2, c3, c4, c5)
-- FROM base

SELECT
    c1,
    c2,
    c3,
    c4,
    c5,
    (
        SELECT MIN(c)
        FROM (VALUES (c1), (c2), (c3), (c4), (c5)) AS v(c)
    ) AS min_c,
    (
        SELECT MAX(c)
        FROM (VALUES (c1), (c2), (c3), (c4), (c5)) AS v(c)
    ) AS max_c
FROM base
;

