TRUNCATE TABLE
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


INSERT INTO table_(id, location, persons)
VALUES
    (1, 'wall', 2),
    (2, 'window', 0),
    (3, 'corner', 1);

INSERT INTO reservation(id, datetime, table_)
VALUES
    (1, '2022-10-19 17:10:00', 1),
    (2, '2022-10-19 17:20:00', 2),
    (3, '2022-10-19 20:30:00', 2);

INSERT INTO visitor(id, name, table_, reservation)
VALUES
    (1, 'Charlie', 1, 1),
    (2, 'Alice', 1, 1),
    (3, 'Bob', 3, NULL);

INSERT INTO waiter(id, name, salary)
VALUES
    (1, 'Sam', 2000.00),
    (2, 'Lisa', 2200.00),
    (3, 'Greg', 1900.00);

INSERT INTO order_(id, time, table_, waiter)
VALUES
    (1, '17:15:00', 1, 1),
    (2, '17:15:00', 3, 2),
    (3, '17:45:00', 3, 3);

INSERT INTO menu_item(name, price, category, description)
VALUES
    ('Kebab', 6.00, 'hot dishes', 'Nice'),
    ('Shawarma', 3.00, 'hot dishes', NULL),
    ('Beer', 3.50, 'alcohol', 'Cold drink');

INSERT INTO recipe(name, complexity, description)
VALUES
    ('Kebab', 1, 'There should be kebab recipe'),
    ('Shawarma', 1, 'There should be shawarma recipe');

INSERT INTO ingredient(id, name, amount, recipe)
VALUES
    (1, 'Chicken', 0.100, 'Shawarma'),
    (2, 'Tomato', 0.050, 'Shawarma'),
    (3, 'Pork', 0.400, 'Kebab');

INSERT INTO order_item(id, order_, menu_item)
VALUES
    (1, 1, 'Kebab'), 
    (2, 1, 'Beer'), 
    (3, 2, 'Shawarma'); 

INSERT INTO cook(id, name, experience, salary)
VALUES
    (1, 'Gordon', 25, 7500.00),
    (2, 'Basil', 17, 6000.00),
    (3, 'Alex', 2, 1850.00);

INSERT INTO dish(id, time, rating, order_item, cook)
VALUES
    (1, '17:30:00', 7, 1, 1),
    (2, '17:16:00', 10, 2, NULL),
    (3, '17:23:00', 8, 3, 3);

INSERT INTO supply(id, price, datetime, supplier)
VALUES
    (1, 50700.00, '2022-10-17 12:00:00', 'FreshFood'),
    (2, 44300.00, '2022-10-18 12:00:00', 'Red&Blue'),
    (3, 71000.00, '2022-10-19 14:00:00', 'Grassery');

INSERT INTO raw_material(id, name, amount, expiration_date, supply)
VALUES
    (1, 'Chicken', 12.500, '2022-10-22', 1),
    (2, 'Tomato', 15.000, '2022-11-08', 2),
    (3, 'Pork', 8.400, '2022-10-21', 3);

INSERT INTO dish_ingredient(id, dish, ingredient, raw_material)
VALUES
    (1, 3, 1, 1),
    (2, 3, 2, 2),
    (3, 1, 3, 3);
