
DROP TABLE IF EXISTS people;
CREATE TABLE people(
    id INTEGER PRIMARY KEY,
    address TEXT,
    email TEXT,
    password TEXT,
    name TEXT,
    city TEXT,
    longitude REAL,
    state TEXT,
    source TEXT,
    birth_date DATE,
    zip TEXT,
    latitude TEXT,
    created_at DATETIME
);


DROP TABLE IF EXISTS products;
CREATE TABLE products(
    id INTEGER PRIMARY KEY,
    ean TEXT,
    title TEXT,
    category TEXT,
    vendor TEXT,
    price REAL,
    rating REAL,
    created_at DATETIME
);


DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
    id INTEGER PRIMARY KEY,
    user_id INTEGER REFERENCES people(id),
    product_id INTEGER REFERENCES products(id),
    subtotal REAL,
    tax REAL,
    total REAL,
    discount REAL,
    created_at DATETIME,
    quantity INTEGER
);


DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
    id INTEGER PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    reviewer TEXT,
    rating INTEGER,
    body TEXT,
    created_at DATETIME
);
