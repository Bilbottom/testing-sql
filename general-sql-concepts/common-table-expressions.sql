
/* Subquery Version */
SELECT
    loan_id,
    balance_date,
    balance
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY loan_id
            ORDER BY balance_date DESC
        ) AS row_num
    FROM balance_history
    WHERE balance_date < '2022-06-01'
) AS bal
WHERE row_num = 1
;


/* CTE Version */
WITH bal AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY loan_id
            ORDER BY balance_date DESC
        ) AS row_num
    FROM balance_history
    WHERE balance_date < '2022-06-01'
)

SELECT
    loan_id,
    balance_date,
    balance
FROM bal
WHERE row_num = 1
;


/* Multiple CTEs */
WITH
    bal_apr22 AS (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY loan_id
                ORDER BY balance_date DESC
            ) AS row_num
        FROM balance_history
        WHERE balance_date < '2022-05-01'
    ),
    bal_may22 AS (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY loan_id
                ORDER BY balance_date DESC
            ) AS row_num
        FROM balance_history
        WHERE balance_date < '2022-06-01'
    )

SELECT
    bal_apr22.loan_id,
    bal_apr22.balance_date AS balance_date_apr22,
    bal_apr22.balance AS balance_apr22,
    bal_may22.balance_date AS balance_date_may22,
    bal_may22.balance AS balance_may22
FROM bal_apr22
    LEFT JOIN bal_may22 USING(loan_id, row_num)
WHERE bal_apr22.row_num = 1
;
