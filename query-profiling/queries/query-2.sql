
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
