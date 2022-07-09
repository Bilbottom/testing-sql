
/*
    Q1. Write a query that returns the count of each `customer_type`
*/
SELECT customer_type, COUNT(*)
FROM customers
GROUP BY customer_type
ORDER BY customer_type
;


/*
    Q2. Write a query that returns the total value of loans per `customer_type`
*/
SELECT
    customers.customer_type,
    SUM(COALESCE(loans.loan_value, 0)) AS total_loan_value
FROM customers
    LEFT JOIN loans USING(customer_id)
GROUP BY customers.customer_type
ORDER BY customers.customer_type
;


/*
    Q3. Write a query that returns which businesses have at least two directors
*/
SELECT parent_customer_id AS customer_id
FROM customer_relationships
WHERE relationship_type = 'Director'
GROUP BY parent_customer_id
HAVING COUNT(*) >= 2
;


/*
    Q4. Write a query that returns the total value of loans per business.
        If the business does not have a loan, show 0 for that business
*/
SELECT
    customer_id,
    SUM(COALESCE(loans.loan_value, 0)) AS total_loan_value
FROM customers
    LEFT JOIN loans USING(customer_id)
WHERE customers.customer_type = 'Business'
GROUP BY customers.customer_id
ORDER BY customers.customer_id
;


/*
    Q5. Write a query that returns which businesses have both at least one director and belong to a lending group
*/
SELECT cr1.parent_customer_id AS customer_id
FROM customer_relationships AS cr1
    INNER JOIN customer_relationships AS cr2
        ON cr1.parent_customer_id = cr2.child_customer_id
    INNER JOIN customers
        ON  cr2.parent_customer_id = customers.customer_id
        AND customers.customer_type = 'Lending Group'
WHERE cr1.relationship_type = 'Director'
GROUP BY cr1.parent_customer_id
;


/*
    Q6. Write a query that returns all the children of the `LEN559852` lending group
*/
SELECT child_customer_id AS customer_id
FROM customer_relationships
WHERE parent_customer_id = 'LEN559852'
;


/*
    Q7. Write a query that returns all the children and grandchildren of the `LEN559852` lending group
*/
WITH children AS (
    SELECT child_customer_id AS customer_id
    FROM customer_relationships
    WHERE parent_customer_id = 'LEN559852'
)

    SELECT customer_id FROM children
UNION ALL
    SELECT child_customer_id AS customer_id
    FROM customer_relationships
    WHERE parent_customer_id IN (
        SELECT customer_id FROM children
    )
ORDER BY customer_id
;


/*
    Q8. Write a query that returns all the descendants of the `LEN559852` lending group
*/
WITH children AS (
        SELECT
            child_customer_id AS customer_id,
            1 AS generation
        FROM customer_relationships
        WHERE parent_customer_id = 'LEN559852'
    UNION ALL
        SELECT
            cr.child_customer_id AS customer_id,
            children.generation + 1 AS generation
        FROM customer_relationships AS cr
            INNER JOIN children
                ON cr.parent_customer_id = children.customer_id
)

SELECT DISTINCT customer_id
FROM children
ORDER BY customer_id
;


/*
    Q9. Write a query that returns all the customers related to the `IND154203` individual.
        This should include relatives of all depths and generations
*/
WITH
    rels AS (
            SELECT
                parent_customer_id AS customer_id,
                child_customer_id AS related_customer_id
            FROM customer_relationships
        UNION
            SELECT
                child_customer_id AS customer_id,
                parent_customer_id AS related_customer_id
            FROM customer_relationships
        UNION
            SELECT
                customer_id AS customer_id,
                customer_id AS related_customer_id
            FROM customers
    ),
    all_rels AS (
            SELECT
                customer_id,
                related_customer_id,
                customer_id || '-' || related_customer_id AS cust_id_hist
            FROM rels
            WHERE customer_id = 'IND154203'
        UNION ALL
            SELECT
                all_rels.customer_id,  /* Customer ID that we're 'searching' on */
                rels.related_customer_id,
                all_rels.cust_id_hist || '-' || rels.related_customer_id AS cust_id_hist
            FROM rels
                INNER JOIN all_rels
                    ON  rels.customer_id  = all_rels.related_customer_id
                    AND all_rels.cust_id_hist NOT LIKE '%' || rels.related_customer_id || '%'
    )

SELECT DISTINCT
    customer_id,
    related_customer_id
FROM all_rels
ORDER BY related_customer_id
;


/*
    Q10. Write a query to identify how many distinct family trees belong in the database with the count of members in each family
*/
WITH
    rels AS (
            SELECT
                parent_customer_id AS customer_id,
                child_customer_id AS related_customer_id
            FROM customer_relationships
        UNION
            SELECT
                child_customer_id AS customer_id,
                parent_customer_id AS related_customer_id
            FROM customer_relationships
        UNION
            SELECT
                customer_id AS customer_id,
                customer_id AS related_customer_id
            FROM customers
    ),
    all_rels AS (
            SELECT
                customer_id,
                related_customer_id,
                customer_id || '-' || related_customer_id AS cust_id_hist
            FROM rels
        UNION ALL
            SELECT
                all_rels.customer_id,  /* Customer ID that we're 'searching' on */
                rels.related_customer_id,
                all_rels.cust_id_hist || '-' || rels.related_customer_id AS cust_id_hist
            FROM rels
                INNER JOIN all_rels
                    ON  rels.customer_id  = all_rels.related_customer_id
                    AND all_rels.cust_id_hist NOT LIKE '%' || rels.related_customer_id || '%'
    ),
    families AS (
        SELECT DISTINCT
            customer_id,
            related_customer_id
        FROM all_rels
    ),
    dist_families AS (
        SELECT
            customer_id,
            related_customer_id,
            GROUP_CONCAT(related_customer_id, '-') OVER(
                PARTITION BY customer_id
                ORDER BY related_customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS family
        FROM families
    )

SELECT
    ROW_NUMBER() OVER() AS family_id,
    family,
    COUNT(DISTINCT customer_id) AS members
FROM dist_families
GROUP BY family
ORDER BY family
;


/*
    Q11. Define the total relative capital for a customer to be the sum of their loans values, plus the sum of the loan values for all of their descendants.
         Write a query that returns the customer(s) with the highest total relative capital
*/
WITH
    children AS (
            SELECT
                customer_id AS customer_id,
                customer_id AS descendant_customer_id
            FROM customers
        UNION ALL
            SELECT
                children.customer_id,
                cr.child_customer_id AS descendant_customer_id
            FROM customer_relationships AS cr
                INNER JOIN children
                    ON cr.parent_customer_id = children.descendant_customer_id
    ),
    relative_capital AS (
        SELECT
            children.customer_id,
            SUM(COALESCE(loan_values.loan_value, 0)) AS loan_value
        FROM (
            /* Drop the duplicated descendents (happens where there are multiple 'routes' to the descendent) */
            SELECT DISTINCT * FROM children
        ) AS children
            LEFT JOIN (
                SELECT
                    customer_id,
                    SUM(loan_value) AS loan_value
                FROM loans
                GROUP BY customer_id
            ) AS loan_values
                ON children.descendant_customer_id = loan_values.customer_id
        GROUP BY children.customer_id
    ),
    ranked AS (
        SELECT
            customer_id,
            loan_value,
            RANK() OVER(ORDER BY loan_value DESC) AS loan_value_rank
        FROM relative_capital
    )

SELECT
    customer_id,
    loan_value
FROM ranked
WHERE loan_value_rank = 1
;


/*
    Q12. Repeat Q11 but exclude the `LEN559852` lending group
*/
WITH
    children AS (
            SELECT
                customer_id AS customer_id,
                customer_id AS descendant_customer_id
            FROM customers
            WHERE customer_id != 'LEN559852'
        UNION ALL
            SELECT
                children.customer_id,
                cr.child_customer_id AS descendant_customer_id
            FROM customer_relationships AS cr
                INNER JOIN children
                    ON cr.parent_customer_id = children.descendant_customer_id
            WHERE 1=1
                AND cr.parent_customer_id != 'LEN559852'
                AND cr.child_customer_id != 'LEN559852'
    ),
    relative_capital AS (
        SELECT
            children.customer_id,
            SUM(COALESCE(loan_values.loan_value, 0)) AS loan_value
        FROM (
            /* Drop the duplicated descendents (happens where there are multiple 'routes' to the descendent) */
            SELECT DISTINCT * FROM children
        ) AS children
            LEFT JOIN (
                SELECT
                    customer_id,
                    SUM(loan_value) AS loan_value
                FROM loans
                GROUP BY customer_id
            ) AS loan_values
                ON children.descendant_customer_id = loan_values.customer_id
        GROUP BY children.customer_id
    ),
    ranked AS (
        SELECT
            customer_id,
            loan_value,
            RANK() OVER(ORDER BY loan_value DESC) AS loan_value_rank
        FROM relative_capital
    )

SELECT
    customer_id,
    loan_value
FROM ranked
WHERE loan_value_rank = 1
;


/*
    Q13. Write a query to show the balance for every account as at 2022-01-31
*/
SELECT
    loan_id,
    balance_date,
    balance
FROM balance_history
WHERE balance_date = (
        SELECT MAX(balance_date)
        FROM balance_history AS bi
        WHERE bi.balance_date <= '2022-01-31'
          AND balance_history.loan_id = bi.loan_id
    )
ORDER BY loan_id
;


/*
    Q14. Write a query to show the sum of month-end balances for each month from 2020-01 to 2022-12
*/
-- noinspection SqlSignature
WITH
    dates AS (
            SELECT
                '2020-01-01' AS month_date,   /* The reporting date (the "month-end" date) */
                '2020-01-01' AS balance_date  /* The date that balances need to be before */
        UNION ALL
            SELECT
                DATE(month_date, '+1 month'),
                DATE(balance_date, '+1 month')
            FROM dates
            WHERE month_date < '2022-12-01'
    ),
    accounts AS (
        SELECT
            loan_id,
            MIN(balance_date) AS opening_date  /* The earliest balance record corresponds to the account opening */
        FROM balance_history
        GROUP BY loan_id
    ),
    month_end_balances AS (
        SELECT
            month_date,
            accounts.loan_id,
            (
                SELECT balance
                FROM balance_history AS bal_inner
                WHERE accounts.loan_id = bal_inner.loan_id
                  AND dates.balance_date > bal_inner.balance_date
                ORDER BY bal_inner.balance_date DESC
                LIMIT 1
            ) AS balance
        FROM dates
            LEFT JOIN accounts
                ON dates.balance_date > accounts.opening_date
    )

SELECT
    STRFTIME('%Y-%m', month_date) AS reporting_month,
    PRINTF('%.2f', SUM(balance)) AS month_end_balance
FROM month_end_balances
GROUP BY month_date
ORDER BY month_date
;
