
PRAGMA FOREIGN_KEYS = ON;


DROP TABLE IF EXISTS my_table;
DROP TABLE IF EXISTS my_table_history;
DROP TRIGGER IF EXISTS append_to_hist;


CREATE TABLE my_table (
    id       INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    forename TEXT NOT NULL,
    surname  TEXT NOT NULL
);
CREATE TABLE my_table_history(
    id              INTEGER NOT NULL,
    old_forename    TEXT NOT NULL,
    old_surname     TEXT NOT NULL,
    update_datetime TEXT NOT NULL,
    FOREIGN KEY (id) REFERENCES my_table(id) ON UPDATE CASCADE
);


CREATE TRIGGER append_to_hist
    BEFORE UPDATE ON my_table
    WHEN OLD.id = NEW.id
BEGIN
    INSERT INTO my_table_history VALUES
        (OLD.id, OLD.forename, OLD.surname, DATETIME())
    ;
END
;


INSERT INTO my_table(forename, surname)VALUES
    ('Joseph', 'Bloggs'),
    ('John', 'Smith')
;


UPDATE my_table SET forename = 'Joey' WHERE forename = 'Joseph';
UPDATE my_table SET forename = 'Joe' WHERE forename = 'Joey';
