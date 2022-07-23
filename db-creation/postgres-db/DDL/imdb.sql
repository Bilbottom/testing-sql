
/*
      SELECT 'title_basics'     AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_basics
UNION SELECT 'title_crew'       AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_crew
UNION SELECT 'name_basics'      AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.name_basics
UNION SELECT 'title_akas'       AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_akas
UNION SELECT 'title_episode'    AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_episode
UNION SELECT 'title_principals' AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_principals
UNION SELECT 'title_ratings'    AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_ratings
ORDER BY vol, table_name
;

ANALYSE;
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS imdb.name_basics;
DROP TABLE IF EXISTS imdb.title_akas;
DROP TABLE IF EXISTS imdb.title_basics;
DROP TABLE IF EXISTS imdb.title_crew;
DROP TABLE IF EXISTS imdb.title_episode;
DROP TABLE IF EXISTS imdb.title_principals;
DROP TABLE IF EXISTS imdb.title_ratings;


CREATE TABLE imdb.name_basics(
    nconst             VARCHAR(10) PRIMARY KEY,
    primary_name       VARCHAR(128) NOT NULL,
    birth_year         SMALLINT,
    death_year         SMALLINT,
    primary_profession TEXT ARRAY[3] NOT NULL,
    known_for_titles   TEXT ARRAY[6]
);

CREATE TABLE imdb.title_akas(
    title_id          VARCHAR(10),
    ordering          SMALLINT NOT NULL,
    title             VARCHAR(1024) NOT NULL,
    region            VARCHAR(4),
    "language"        VARCHAR(3),
    "types"           VARCHAR(16) ARRAY[16],
    attributes        VARCHAR(64) ARRAY[3],
    is_original_title BOOLEAN,
    PRIMARY KEY(title_id, ordering)
);

CREATE TABLE imdb.title_basics(
    tconst          VARCHAR(10) PRIMARY KEY,
    title_type      VARCHAR(12) NOT NULL,
    primary_title   VARCHAR(512) NOT NULL,
    original_title  VARCHAR(512) NOT NULL,
    is_adult        BOOLEAN NOT NULL,
    start_year      SMALLINT,
    end_year        SMALLINT,
    runtime_minutes INTEGER,
    genres          VARCHAR(11) ARRAY[4]
);

CREATE TABLE imdb.title_crew(
    tconst    VARCHAR(10) PRIMARY KEY,
    directors VARCHAR(10) ARRAY,
    writers   VARCHAR(10) ARRAY
);

CREATE TABLE imdb.title_episode(
    tconst         VARCHAR(10) PRIMARY KEY,
    parent_tconst  VARCHAR(10) /*REFERENCES imdb.title_basics(tconst)*/,
    season_number  SMALLINT,
    episode_number INTEGER
);

CREATE TABLE imdb.title_principals(
    tconst     VARCHAR(10),
    ordering   SMALLINT,
    nconst     VARCHAR(10) NOT NULL /* REFERENCES ???(???) */,
    "category" VARCHAR(19) NOT NULL,
    job        VARCHAR(512),
    characters VARCHAR(512) /* ARRAY */,
    PRIMARY KEY(tconst, ordering)
);

CREATE TABLE imdb.title_ratings(
    tconst         VARCHAR(10) PRIMARY KEY /* REFERENCES ???(???) */,
    average_rating NUMERIC(5, 3) CHECK(1 <= average_rating AND average_rating <= 10),
    num_votes      INTEGER
);
