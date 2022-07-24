
/* Turn off foreign key constraints -- the samples are just a subset so misaligned */
SET session_replication_role = 'replica';


/* `public.raw_name_basics`  ->  `imdb.name_basics`  (3 mins) */
INSERT INTO imdb.name_basics
    SELECT
        nconst::VARCHAR(10) AS nconst,
        primary_name::VARCHAR(10) AS primary_name,
        birth_year::SMALLINT AS birth_year,
        death_year::SMALLINT AS death_year,
        STRING_TO_ARRAY(primary_profession, ',') AS primary_profession,
        STRING_TO_ARRAY(known_for_titles, ',') AS known_for_titles
    FROM public.raw_name_basics
;


/* `public.raw_title_akas`  ->  `imdb.title_akas`  (6 mins) */
INSERT INTO imdb.title_akas
    SELECT
        title_id::VARCHAR(10) AS tconst,
        ordering::SMALLINT AS ordering,
        title::VARCHAR(1024) AS title,
        region::VARCHAR(4) AS region,
        "language"::VARCHAR(3) AS "language",
        STRING_TO_ARRAY("types", '') AS "types",
        STRING_TO_ARRAY(attributes, '') AS attributes,
        is_original_title::BOOLEAN AS is_original_title
    FROM public.raw_title_akas
;


/* `public.raw_title_basics`  ->  `imdb.title_basics`  (2 mins) */
INSERT INTO imdb.title_basics
    SELECT
        tconst::VARCHAR(10) AS tconst,
        title_type::VARCHAR(12) AS title_type,
        primary_title::VARCHAR(512) AS primary_title,
        original_title::VARCHAR(512) AS original_title,
        is_adult::BOOLEAN AS is_adult,
        start_year::SMALLINT AS start_year,
        end_year::SMALLINT AS end_year,
        runtime_minutes::INTEGER AS runtime_minutes,
        STRING_TO_ARRAY(genres, ',') AS genres
    FROM public.raw_title_basics
;


/* `public.raw_title_crew`  ->  `imdb.title_crew`  (2 mins) */
INSERT INTO imdb.title_crew
    SELECT
        tconst::VARCHAR(10) AS tconst,
        STRING_TO_ARRAY(directors, ',') AS directors,
        STRING_TO_ARRAY(writers, ',') AS writers
    FROM public.raw_title_crew
;


/* `public.raw_title_episode`  ->  `imdb.title_episode`  (2 mins) */
INSERT INTO imdb.title_episode
    SELECT
        tconst::VARCHAR(10) AS tconst,
        parent_tconst::VARCHAR(10) AS parent_tconst,
        season_number::SMALLINT,
        episode_number::INTEGER
    FROM public.raw_title_episode
;


/* `public.raw_title_principals`  ->  `imdb.title_principals`  (10 mins) */
INSERT INTO imdb.title_principals
    SELECT
        tconst::VARCHAR(10) AS tconst,
        ordering::SMALLINT,
        nconst::VARCHAR(10),
        "category"::VARCHAR(19),
        job::VARCHAR(512),
        TRIM(BOTH '"' FROM RTRIM(LTRIM(TRIM(BOTH '"' FROM characters), '['), ']')) AS characters
    FROM public.raw_title_principals
;


/* `public.raw_title_ratings`  ->  `imdb.title_ratings`  (20 secs) */
INSERT INTO imdb.title_ratings
    SELECT
        tconst::VARCHAR(10) AS tconst,
        average_rating::NUMERIC(5, 3) AS average_rating,
        num_votes::INTEGER AS num_votes
    FROM public.raw_title_ratings
;


/* Turn foreign keys back on */
SET session_replication_role = 'origin';
