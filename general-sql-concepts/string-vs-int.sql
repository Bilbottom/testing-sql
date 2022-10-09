
/**/
CREATE TEMPORARY TABLE string_table AS
    SELECT
        (ROW_NUMBER() OVER(ORDER BY tconst))::VARCHAR(10) AS id,
        tconst,
        ordering,
        nconst,
        category,
        job,
        characters
    FROM imdb.title_principals
;

/**/
CREATE TEMPORARY TABLE int_table AS
    SELECT
        ROW_NUMBER() OVER(ORDER BY tconst) AS id,
        tconst,
        ordering,
        nconst,
        category,
        job,
        characters
    FROM imdb.title_principals
;


/**/
\TIMING ON;


/* String Version */
SELECT
    st1.id,
    st1.tconst,
    st2.tconst
FROM string_table AS st1
    LEFT JOIN string_table AS st2 USING(id)
;
/* Int Version */
SELECT
    it1.id,
    it1.tconst,
    it2.tconst
FROM int_table AS it1
    LEFT JOIN int_table AS it2 USING(id)
;
/* String Version */
SELECT
    st1.id,
    st1.tconst,
    st2.tconst
FROM string_table AS st1
    LEFT JOIN string_table AS st2 USING(id)
;
/* Int Version */
SELECT
    it1.id,
    it1.tconst,
    it2.tconst
FROM int_table AS it1
    LEFT JOIN int_table AS it2 USING(id)
;
/* String Version */
SELECT
    st1.id,
    st1.tconst,
    st2.tconst
FROM string_table AS st1
    LEFT JOIN string_table AS st2 USING(id)
;
/* Int Version */
SELECT
    it1.id,
    it1.tconst,
    it2.tconst
FROM int_table AS it1
    LEFT JOIN int_table AS it2 USING(id)
;
/* String Version */
SELECT
    st1.id,
    st1.tconst,
    st2.tconst
FROM string_table AS st1
    LEFT JOIN string_table AS st2 USING(id)
;
/* Int Version */
SELECT
    it1.id,
    it1.tconst,
    it2.tconst
FROM int_table AS it1
    LEFT JOIN int_table AS it2 USING(id)
;
/* String Version */
SELECT
    st1.id,
    st1.tconst,
    st2.tconst
FROM string_table AS st1
    LEFT JOIN string_table AS st2 USING(id)
;
/* Int Version */
SELECT
    it1.id,
    it1.tconst,
    it2.tconst
FROM int_table AS it1
    LEFT JOIN int_table AS it2 USING(id)
;
/* String Version */
SELECT
    st1.id,
    st1.tconst,
    st2.tconst
FROM string_table AS st1
    LEFT JOIN string_table AS st2 USING(id)
;
/* Int Version */
SELECT
    it1.id,
    it1.tconst,
    it2.tconst
FROM int_table AS it1
    LEFT JOIN int_table AS it2 USING(id)
;
