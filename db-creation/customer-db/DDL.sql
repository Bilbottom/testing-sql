
PRAGMA FOREIGN_KEYS = OFF;


DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS customer_relationships;
DROP TABLE IF EXISTS loans;


CREATE TABLE customers(
    customer_id   TEXT NOT NULL PRIMARY KEY,
    customer_type TEXT NOT NULL
);

CREATE TABLE customer_relationships(
    parent_customer_id TEXT NOT NULL REFERENCES customers(customer_id),
    child_customer_id  TEXT NOT NULL REFERENCES customers(customer_id),
    relationship_type  TEXT NOT NULL
);

CREATE TABLE loans(
    loan_id     TEXT NOT NULL PRIMARY KEY,
    loan_value  REAL NOT NULL,
    customer_id TEXT NOT NULL REFERENCES customers(customer_id)
);

CREATE TABLE balance_history(
    loan_id      TEXT NOT NULL REFERENCES loans(loan_id),
    balance_date DATE NOT NULL,
    balance      REAL NOT NULL,
    PRIMARY KEY (loan_id, balance_date)
);
