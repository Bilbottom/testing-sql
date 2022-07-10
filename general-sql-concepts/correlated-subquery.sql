
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


/* Correlated Subquery Version */
SELECT
    bh.loan_id,
    bh.balance_date,
    bh.balance
FROM balance_history AS bh
WHERE bh.balance_date = (
    SELECT MAX(bhi.balance_date)
    FROM balance_history AS bhi
    WHERE bhi.balance_date < '2022-06-01'
      AND bh.loan_id = bhi.loan_id
)
;
