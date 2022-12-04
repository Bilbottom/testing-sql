
/*
    Note that SQLite PRIMARY KEY does not imply NOT NULL for legacy reasons
    https://sqlite.org/foreignkeys.html
*/

--------------------------
/* Turn on FOREIGN_KEYS */
PRAGMA FOREIGN_KEYS = ON;
PRAGMA FOREIGN_KEYS;


-----------------------
/* Set Up the Tables */

DROP TABLE IF EXISTS hist_table;
DROP TABLE IF EXISTS some_table;

CREATE TABLE some_table
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    forename TEXT NOT NULL,
    surname TEXT NOT NULL
);
CREATE TABLE hist_table
(
    id INTEGER NOT NULL,
    old_forename TEXT NOT NULL,
    old_surname TEXT NOT NULL,
    update_datetime TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES some_table(id) ON UPDATE CASCADE
);


-----------------------------
/* Create History Triggers */

DROP TRIGGER IF EXISTS append_to_hist;
CREATE TRIGGER append_to_hist
    BEFORE UPDATE ON some_table
WHEN OLD.id = NEW.id
BEGIN
    INSERT INTO hist_table VALUES
(OLD.id, OLD.forename, OLD.surname, DATETIME())
    ;
END
;


--------------------------
/* Fiddle with Contents */

DELETE FROM hist_table WHERE True;
DELETE FROM some_table WHERE True;


INSERT INTO some_table(forename, surname) VALUES
    ('Joseph', 'Bloggs'),
    ('John', 'Smith')
;
-- INSERT INTO hist_table(id, old_forename, old_surname) VALUES
--     (1, 'Joseph', 'Bloggs'),
--     (2, 'John', 'Smith')
-- ;


-------------------
/* Test Triggers */

UPDATE some_table SET forename = 'Joey' WHERE forename = 'Joseph';
UPDATE some_table SET forename = 'Joe' WHERE forename = 'Joey';


------------------------------
/* Test PK/FK Relationships */

/* this should pass when data is in hist_table */
UPDATE some_table SET id = 99 WHERE forename = 'Joe';

/* this should fail */
INSERT INTO hist_table(id, old_forename, old_surname, update_datetime) VALUES
    (-1, 'Joseph', 'Bloggs', DATETIME()),
    (-2, 'John', 'Smith', DATETIME())
;
