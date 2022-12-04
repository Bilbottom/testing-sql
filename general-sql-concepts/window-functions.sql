
/* example_base */
SELECT * FROM example_base;

/* base_table */
SELECT * FROM base_table ORDER BY c1, c2;

/* row_number */
SELECT
    c1,
    c2,
    ROW_NUMBER() OVER(                                   ) AS row_num,
    ROW_NUMBER() OVER(PARTITION BY c1     ORDER BY c1    ) AS row_num_c1,
    ROW_NUMBER() OVER(PARTITION BY     c2 ORDER BY     c2) AS row_num_c2,
    ROW_NUMBER() OVER(PARTITION BY c1, c2 ORDER BY c1, c2) AS row_num_c1_c2
FROM base_table
ORDER BY c1, c2
;
/* c1-ranks */
SELECT
    c1,
    ROW_NUMBER() OVER(ORDER BY c1) AS c1_row_number,
    RANK()       OVER(ORDER BY c1) AS c1_rank,
    DENSE_RANK() OVER(ORDER BY c1) AS c1_dense_rank
FROM base_table
ORDER BY c1
;
/* c2-ranks */
SELECT
    c2,
    ROW_NUMBER() OVER(ORDER BY c2) AS c2_row_number,
    RANK()       OVER(ORDER BY c2) AS c2_rank,
    DENSE_RANK() OVER(ORDER BY c2) AS c2_dense_rank
FROM base_table
ORDER BY c1
;
/* c1-c2-ranks */
SELECT
    c1,
    c2,
    ROW_NUMBER() OVER(ORDER BY c1) AS c1_row_number,
    RANK()       OVER(ORDER BY c1) AS c1_rank,
    DENSE_RANK() OVER(ORDER BY c1) AS c1_dense_rank,
    ROW_NUMBER() OVER(ORDER BY c2) AS c2_row_number,
    RANK()       OVER(ORDER BY c2) AS c2_rank,
    DENSE_RANK() OVER(ORDER BY c2) AS c2_dense_rank,
    ROW_NUMBER() OVER(ORDER BY c1, c2) AS c1_c2_row_number,
    RANK()       OVER(ORDER BY c1, c2) AS c1_c2_rank,
    DENSE_RANK() OVER(ORDER BY c1, c2) AS c1_c2_dense_rank
FROM base_table
ORDER BY c1, c2
;
