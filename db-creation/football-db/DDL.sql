
PRAGMA FOREIGN_KEYS = OFF;


DROP TABLE IF EXISTS soccer_country;
DROP TABLE IF EXISTS soccer_city;
DROP TABLE IF EXISTS soccer_venue;
DROP TABLE IF EXISTS soccer_team;
DROP TABLE IF EXISTS playing_position;
DROP TABLE IF EXISTS player_mast;
DROP TABLE IF EXISTS referee_mast;
DROP TABLE IF EXISTS match_mast;
DROP TABLE IF EXISTS coach_mast;
DROP TABLE IF EXISTS asst_referee_mast;
DROP TABLE IF EXISTS match_details;
DROP TABLE IF EXISTS goal_details;
DROP TABLE IF EXISTS penalty_shootout;
DROP TABLE IF EXISTS player_booked;
DROP TABLE IF EXISTS player_in_out;
DROP TABLE IF EXISTS match_captain;
DROP TABLE IF EXISTS team_coaches;
DROP TABLE IF EXISTS penalty_gk;


CREATE TABLE soccer_country(
    country_id INTEGER PRIMARY KEY,
    country_abbr TEXT,
    country_name TEXT
);

CREATE TABLE soccer_city(
    city_id INTEGER PRIMARY KEY,
    city TEXT,
    country_id INTEGER REFERENCES soccer_country(country_id)
);

CREATE TABLE soccer_venue(
    venue_id INTEGER PRIMARY KEY,
    venue_name TEXT,
    city_id INTEGER REFERENCES soccer_city(city_id),
    aud_capacity INTEGER
);

CREATE TABLE soccer_team(
    team_id INTEGER REFERENCES soccer_country(country_id),
    team_group TEXT,
    match_played INTEGER,
    won INTEGER,
    draw INTEGER,
    lost INTEGER,
    goal_for INTEGER,
    goal_agnst INTEGER,  /* There is a typo here */
    goal_diff INTEGER,
    points INTEGER,
    group_position INTEGER
);

CREATE TABLE playing_position(
    position_id TEXT PRIMARY KEY,
    position_desc TEXT
);

CREATE TABLE player_mast(
    player_id INTEGER PRIMARY KEY,
    team_id INTEGER REFERENCES soccer_country(country_id),
    jersey_no INTEGER,
    player_name TEXT,
    posi_to_play TEXT REFERENCES playing_position(position_id),
    dt_of_bir TEXT,
    age INTEGER,
    playing_club TEXT
);

CREATE TABLE referee_mast(
    referee_id INTEGER PRIMARY KEY,
    referee_name TEXT,
    country_id INTEGER REFERENCES soccer_country(country_id)
);

CREATE TABLE match_mast(
    match_no INTEGER PRIMARY KEY,
    play_stage TEXT,
    play_date TEXT,
    results TEXT,
    decided_by TEXT,
    goal_score TEXT,
    venue_id INTEGER REFERENCES soccer_venue(venue_id),
    referee_id INTEGER REFERENCES referee_mast(referee_id),
    audence INTEGER,  /* There is a typo here */
    plr_of_match INTEGER REFERENCES player_mast(player_id),
    stop1_sec INTEGER,
    stop2_sec INTEGER
);

CREATE TABLE coach_mast(
    coach_id INTEGER PRIMARY KEY,
    coach_name TEXT
);

CREATE TABLE asst_referee_mast(
    ass_ref_id INTEGER PRIMARY KEY,
    ass_ref_name TEXT,
    country_id INTEGER REFERENCES soccer_country(country_id)
);

CREATE TABLE match_details(
    match_no INTEGER REFERENCES match_mast(match_no),
    play_stage TEXT,
    team_id INTEGER REFERENCES soccer_country(country_id),
    win_lose TEXT,
    decided_by TEXT,
    goal_score INTEGER,
    penalty_score INTEGER,
    ass_ref INTEGER REFERENCES asst_referee_mast(ass_ref_id),
    player_gk INTEGER REFERENCES player_mast(player_id)
);

CREATE TABLE goal_details(
    goal_id INTEGER PRIMARY KEY,
    match_no INTEGER REFERENCES match_mast(match_no),
    player_id INTEGER REFERENCES player_mast(player_id),
    team_id INTEGER REFERENCES soccer_country(country_id),
    goal_time INTEGER,
    goal_type TEXT,
    play_stage TEXT,
    goal_schedule TEXT,
    goal_half INTEGER
);

CREATE TABLE penalty_shootout(
    kick_id INTEGER PRIMARY KEY,
    match_no INTEGER REFERENCES match_mast(match_no),
    team_id INTEGER REFERENCES soccer_country(country_id),
    player_id INTEGER REFERENCES player_mast(player_id),
    score_goal TEXT,
    kick_no INTEGER
);

CREATE TABLE player_booked(
    match_no INTEGER REFERENCES match_mast(match_no),
    team_id INTEGER REFERENCES soccer_country(country_id),
    player_id INTEGER REFERENCES player_mast(player_id),
    booking_time TEXT,
    sent_off TEXT,
    play_schedule TEXT,
    play_half INTEGER
);

CREATE TABLE player_in_out(
    match_no INTEGER REFERENCES match_mast(match_no),
    team_id INTEGER REFERENCES soccer_country(country_id),
    player_id INTEGER REFERENCES player_mast(player_id),
    in_out TEXT,
    time_in_out INTEGER,
    play_schedule TEXT,
    play_half INTEGER
);

CREATE TABLE match_captain(
    match_no INTEGER REFERENCES match_mast(match_no),
    team_id INTEGER REFERENCES soccer_country(country_id),
    player_captain INTEGER REFERENCES player_mast(player_id)
);

CREATE TABLE team_coaches(
    team_id INTEGER REFERENCES soccer_country(country_id),
    coach_id INTEGER REFERENCES coach_mast(coach_id)
);

CREATE TABLE penalty_gk(
    match_no INTEGER REFERENCES match_mast(match_no),
    team_id INTEGER REFERENCES soccer_country(country_id),
    player_gk INTEGER REFERENCES player_mast(player_id)
);
