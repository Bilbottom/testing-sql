
/*
ANALYSE;


      SELECT 'title_basics'     AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_basics
UNION SELECT 'title_crew'       AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_crew
UNION SELECT 'name_basics'      AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.name_basics
UNION SELECT 'title_akas'       AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_akas
UNION SELECT 'title_episode'    AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_episode
UNION SELECT 'title_principals' AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_principals
UNION SELECT 'title_ratings'    AS table_name, TO_CHAR(COUNT(*), 'fm999G999G999') AS vol FROM imdb.title_ratings
ORDER BY vol, table_name
;
*/


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS imdb.title_basics CASCADE;
DROP TABLE IF EXISTS imdb.name_basics CASCADE;
DROP TABLE IF EXISTS imdb.title_akas CASCADE;
DROP TABLE IF EXISTS imdb.title_crew CASCADE;
DROP TABLE IF EXISTS imdb.title_episode CASCADE;
DROP TABLE IF EXISTS imdb.title_principals CASCADE;
DROP TABLE IF EXISTS imdb.title_ratings CASCADE;


CREATE TABLE imdb.title_basics(
    tconst          VARCHAR(10) PRIMARY KEY,
    title_type      VARCHAR(12) NOT NULL,
    primary_title   VARCHAR(512) NOT NULL,
    original_title  VARCHAR(512) NOT NULL,
    is_adult        BOOLEAN NOT NULL,
    start_year      SMALLINT,
    end_year        SMALLINT,
    runtime_minutes INTEGER,
    genres          VARCHAR(11) ARRAY[3]
);

CREATE TABLE imdb.name_basics(
    nconst             VARCHAR(10) PRIMARY KEY,
    primary_name       VARCHAR(128) NOT NULL,
    birth_year         SMALLINT,
    death_year         SMALLINT,
    primary_profession VARCHAR(25) ARRAY[3] NOT NULL,
    known_for_titles   VARCHAR(10) ARRAY[6] /*REFERENCES imdb.title_basics(tconst)*/
);

CREATE TABLE imdb.title_akas(
    tconst            VARCHAR(10) REFERENCES imdb.title_basics(tconst),
    ordering          SMALLINT NOT NULL,
    title             VARCHAR(1024) NOT NULL,
    region            VARCHAR(4),
    "language"        VARCHAR(3),
    "types"           VARCHAR(16) ARRAY[16],
    attributes        VARCHAR(64) ARRAY[3],
    is_original_title BOOLEAN,
    PRIMARY KEY(tconst, ordering)
);

CREATE TABLE imdb.title_crew(
    tconst    VARCHAR(10) PRIMARY KEY REFERENCES imdb.title_basics(tconst),
    directors VARCHAR(10) ARRAY /*REFERENCES imdb.name_basics(nconst)*/,
    writers   VARCHAR(10) ARRAY /*REFERENCES imdb.name_basics(nconst)*/
);

CREATE TABLE imdb.title_episode(
    tconst         VARCHAR(10) PRIMARY KEY REFERENCES imdb.title_basics(tconst),
    parent_tconst  VARCHAR(10) REFERENCES imdb.title_basics(tconst),
    season_number  SMALLINT,
    episode_number INTEGER
);

CREATE TABLE imdb.title_principals(
    tconst     VARCHAR(10) REFERENCES imdb.title_basics(tconst),
    ordering   SMALLINT,
    nconst     VARCHAR(10) NOT NULL REFERENCES imdb.name_basics(nconst),
    "category" VARCHAR(19) NOT NULL,
    job        VARCHAR(512),
    characters VARCHAR(512) /* ARRAY */ /*REFERENCES imdb.name_basics(nconst)*/,
    PRIMARY KEY(tconst, ordering)
);

CREATE TABLE imdb.title_ratings(
    tconst         VARCHAR(10) PRIMARY KEY REFERENCES imdb.title_basics(tconst),
    average_rating NUMERIC(5, 3) CHECK(1 <= average_rating AND average_rating <= 10),
    num_votes      INTEGER
);


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

COMMENT ON TABLE imdb.name_basics IS 'Contains information for names.';
COMMENT ON COLUMN imdb.name_basics.nconst IS 'Alphanumeric unique identifier of the name/person.';
COMMENT ON COLUMN imdb.name_basics.primary_name IS 'Name by which the person is most often credited.';
COMMENT ON COLUMN imdb.name_basics.birth_year IS 'Birth year.';
COMMENT ON COLUMN imdb.name_basics.death_year IS 'Death year.';
COMMENT ON COLUMN imdb.name_basics.primary_profession IS 'The top-3 professions of the person.';
COMMENT ON COLUMN imdb.name_basics.known_for_titles IS 'Titles the person is known for.';


COMMENT ON TABLE imdb.title_akas IS 'Contains information for titles.';
COMMENT ON COLUMN imdb.title_akas.tconst IS 'An alphanumeric unique identifier of the title.';
COMMENT ON COLUMN imdb.title_akas.ordering IS 'A number to uniquely identify rows for a given titleId.';
COMMENT ON COLUMN imdb.title_akas.title IS 'The localized title.';
COMMENT ON COLUMN imdb.title_akas.region IS 'The region for this version of the title.';
COMMENT ON COLUMN imdb.title_akas.language IS 'The language of the title.';
COMMENT ON COLUMN imdb.title_akas.types IS 'Enumerated set of attributes for this alternative title. One or more of the following: "alternative", "dvd", "festival", "tv", "video", "working", "original", "imdbDisplay". New values may be added in the future without warning.';
COMMENT ON COLUMN imdb.title_akas.attributes IS 'Additional terms to describe this alternative title, not enumerated.';
COMMENT ON COLUMN imdb.title_akas.is_original_title IS '0: not original title; 1: original title.';


COMMENT ON TABLE imdb.title_basics IS 'Contains information for titles.';
COMMENT ON COLUMN imdb.title_basics.tconst IS 'Alphanumeric unique identifier of the title.';
COMMENT ON COLUMN imdb.title_basics.title_type IS 'The type/format of the title (e.g. movie, short, tvseries, tvepisode, video, etc).';
COMMENT ON COLUMN imdb.title_basics.primary_title IS 'The more popular title / the title used by the filmmakers on promotional materials at the point of release.';
COMMENT ON COLUMN imdb.title_basics.original_title IS 'Original title, in the original language.';
COMMENT ON COLUMN imdb.title_basics.is_adult IS '0: non-adult title; 1: adult title.';
COMMENT ON COLUMN imdb.title_basics.start_year IS 'Represents the release year of a title. In the case of TV Series, it is the series start year.';
COMMENT ON COLUMN imdb.title_basics.end_year IS 'TV Series end year. NULL for all other title types.';
COMMENT ON COLUMN imdb.title_basics.runtime_minutes IS 'Primary runtime of the title, in minutes.';
COMMENT ON COLUMN imdb.title_basics.genres IS 'Includes up to three genres associated with the title.';


COMMENT ON TABLE imdb.title_crew IS 'Contains the director and writer information for all the titles in IMDb.';
COMMENT ON COLUMN imdb.title_crew.tconst IS 'Alphanumeric unique identifier of the title.';
COMMENT ON COLUMN imdb.title_crew.directors IS 'Director(s) of the given title.';
COMMENT ON COLUMN imdb.title_crew.writers IS 'Writer(s) of the given title.';


COMMENT ON TABLE imdb.title_episode IS 'Contains the tv episode information.';
COMMENT ON COLUMN imdb.title_episode.tconst IS 'Alphanumeric identifier of episode.';
COMMENT ON COLUMN imdb.title_episode.parent_tconst IS 'Alphanumeric identifier of the parent TV Series.';
COMMENT ON COLUMN imdb.title_episode.season_number IS 'Season number the episode belongs to.';
COMMENT ON COLUMN imdb.title_episode.episode_number IS 'Episode number of the tconst in the TV series.';


COMMENT ON TABLE imdb.title_principals IS 'Contains the principal cast/crew for titles.';
COMMENT ON COLUMN imdb.title_principals.tconst IS 'Alphanumeric unique identifier of the title.';
COMMENT ON COLUMN imdb.title_principals.ordering IS 'A number to uniquely identify rows for a given titleId.';
COMMENT ON COLUMN imdb.title_principals.nconst IS 'Alphanumeric unique identifier of the name/person.';
COMMENT ON COLUMN imdb.title_principals.category IS 'The category of job that person was in.';
COMMENT ON COLUMN imdb.title_principals.job IS 'The specific job title if applicable, else NULL.';
COMMENT ON COLUMN imdb.title_principals.characters IS 'The name of the character played if applicable, else NULL.';


COMMENT ON TABLE imdb.title_ratings IS 'Contains the IMDb rating and votes information for titles.';
COMMENT ON COLUMN imdb.title_ratings.tconst IS 'Alphanumeric unique identifier of the title.';
COMMENT ON COLUMN imdb.title_ratings.average_rating IS 'Weighted average of all the individual user ratings.';
COMMENT ON COLUMN imdb.title_ratings.num_votes IS 'Number of votes the title has received.';
