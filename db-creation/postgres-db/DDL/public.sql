
/*
      SELECT 'raw_title_basics'     AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_title_basics
UNION SELECT 'raw_title_crew'       AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_title_crew
UNION SELECT 'raw_name_basics'      AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_name_basics
UNION SELECT 'raw_title_akas'       AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_title_akas
UNION SELECT 'raw_title_episode'    AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_title_episode
UNION SELECT 'raw_title_principals' AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_title_principals
UNION SELECT 'raw_title_ratings'    AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM public.raw_title_ratings
ORDER BY vol, table_name
;

ANALYSE;
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS public.raw_name_basics;
DROP TABLE IF EXISTS public.raw_title_akas;
DROP TABLE IF EXISTS public.raw_title_basics;
DROP TABLE IF EXISTS public.raw_title_crew;
DROP TABLE IF EXISTS public.raw_title_episode;
DROP TABLE IF EXISTS public.raw_title_principals;
DROP TABLE IF EXISTS public.raw_title_ratings;


CREATE TABLE public.raw_name_basics(
    nconst             TEXT,
    primary_name       TEXT,
    birth_year         TEXT,
    death_year         TEXT,
    primary_profession TEXT,
    known_for_titles   TEXT
);

CREATE TABLE public.raw_title_akas(
    title_id          TEXT,
    ordering          TEXT,
    title             TEXT,
    region            TEXT,
    "language"        TEXT,
    "types"           TEXT,
    attributes        TEXT,
    is_original_title TEXT
);

CREATE TABLE public.raw_title_basics(
    tconst          TEXT,
    title_type      TEXT,
    primary_title   TEXT,
    original_title  TEXT,
    is_adult        TEXT,
    start_year      TEXT,
    end_year        TEXT,
    runtime_minutes TEXT,
    genres          TEXT
);

CREATE TABLE public.raw_title_crew(
    tconst    TEXT,
    directors TEXT,
    writers   TEXT
);

CREATE TABLE public.raw_title_episode(
    tconst         TEXT,
    parent_tconst  TEXT,
    season_number  TEXT,
    episode_number TEXT
);

CREATE TABLE public.raw_title_principals(
    tconst     TEXT,
    ordering   TEXT,
    nconst     TEXT,
    "category" TEXT,
    job        TEXT,
    characters TEXT
);

CREATE TABLE public.raw_title_ratings(
    tconst         TEXT,
    average_rating TEXT,
    num_votes      TEXT
);
