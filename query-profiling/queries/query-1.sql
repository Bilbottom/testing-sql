
/* Window Function Version */
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
