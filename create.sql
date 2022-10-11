DROP TABLE IF EXISTS
    dish_ingredient,
    raw_material,
    supply,
    dish,
    cook,
    order_item,
    ingredient,
    recipe,
    menu_item,
    order_,
    waiter,
    visitor,
    reservation,
    table_;

DROP TYPE IF EXISTS
    location_type,
    category_type;


CREATE TYPE location_type AS ENUM('wall', 'window', 'corner', 'center');
CREATE TYPE category_type AS ENUM('hot dishes', 'snacks', 'alcohol', 'cocktails');

CREATE TABLE table_(
    id INT PRIMARY KEY,
    location location_type NOT NULL,
    persons INT NOT NULL,
    CHECK(persons >= 0)
);

CREATE TABLE reservation(
    id INT PRIMARY KEY,
    datetime TIMESTAMP NOT NULL,
    table_ INT REFERENCES table_(id) NOT NULL
);

CREATE TABLE visitor(
    id INT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    table_ INT REFERENCES table_(id),
    reservation INT REFERENCES reservation(id)
);

CREATE TABLE waiter(
    id INT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    salary NUMERIC(12, 2) NOT NULL
);

CREATE TABLE order_(
    id INT PRIMARY KEY,
    time TIME,
    table_ INT REFERENCES table_(id),
    waiter INT REFERENCES waiter(id)
);

CREATE TABLE menu_item(
    name VARCHAR(64) PRIMARY KEY,
    price NUMERIC(12, 2) NOT NULL,
    category category_type NOT NULL,
    description TEXT
);

CREATE TABLE recipe(
    name VARCHAR(64) PRIMARY KEY REFERENCES menu_item(name),
    complexity INT NOT NULL,
    description TEXT NOT NULL
);

CREATE TABLE ingredient(
    id INT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    amount NUMERIC(12, 3) NOT NULL,
    recipe VARCHAR(64) REFERENCES recipe(name) NOT NULL
);

CREATE TABLE order_item(
    id INT PRIMARY KEY,
    order_ INT REFERENCES order_(id) NOT NULL,
    menu_item VARCHAR(64) REFERENCES menu_item(name) NOT NULL
);

CREATE TABLE cook(
    id INT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    experience INT NOT NULL,
    salary NUMERIC(12, 2) NOT NULL
);

CREATE TABLE dish(
    id INT PRIMARY KEY,
    time TIME,
    rating INT,
    order_item INT REFERENCES order_item(id) NOT NULL,
    cook INT REFERENCES cook(id),
    CHECK(rating >= 0 and rating <= 10)
);

CREATE TABLE supply(
    id INT PRIMARY KEY,
    price NUMERIC(12, 2),
    datetime TIMESTAMP,
    supplier VARCHAR(64)
);

CREATE TABLE raw_material(
    id INT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    amount NUMERIC(12, 3) NOT NULL,
    expiration_date DATE,
    supply INT REFERENCES supply(id) NOT NULL
);

CREATE TABLE dish_ingredient(
    id INT PRIMARY KEY,
    dish INT REFERENCES dish(id) NOT NULL,
    ingredient INT REFERENCES ingredient(id) NOT NULL,
    raw_material INT REFERENCES raw_material(id) NOT NULL
);
