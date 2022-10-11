DROP FUNCTION IF EXISTS
    is_reserved,
    has_recipe,
    save_resevation,
    save_order_item,
    save_dish,
    save_dish_ingredient_before,
    save_dish_ingredient_after
CASCADE;


----- GENERAL PURPOSE FUNCTIONS -----

CREATE FUNCTION is_reserved(
    table_id INT,
    selected_datetime TIMESTAMP,
    old_reservation_id INT DEFAULT NULL
) RETURNS BOOLEAN AS $$
    BEGIN
        RETURN EXISTS(
            SELECT datetime FROM reservation
            WHERE table_ = table_id
                AND selected_datetime > datetime - '2:00:00'::INTERVAL
                AND selected_datetime < datetime + '2:00:00'::INTERVAL
                AND (old_reservation_id IS NULL OR id != old_reservation_id)
        );
    END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION has_recipe(
    order_item_id INT
) RETURNS BOOLEAN AS $$
    BEGIN
        RETURN EXISTS(
            SELECT name FROM recipe
            WHERE name = (
                SELECT menu_item FROM order_item
                WHERE id = order_item_id
            )
        );
    END;
$$ LANGUAGE plpgsql;


------ TRIGGER FUNCTIONS -----

CREATE FUNCTION save_resevation()
RETURNS TRIGGER AS $$
    BEGIN
        IF is_reserved(NEW.table_, NEW.datetime, OLD.id) THEN
            RAISE EXCEPTION 'These time and date have already reserved';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION save_order_item()
RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS(
            SELECT * FROM raw_material AS rm
            JOIN (
                SELECT * FROM ingredient
                WHERE recipe = NEW.menu_item
            ) AS i
            ON rm.name = i.name AND rm.amount < i.amount
        ) THEN
            RAISE EXCEPTION 'Not enough ingredients for corresponding dish';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION save_dish()
RETURNS TRIGGER AS $$
    BEGIN
        IF (
            NOT has_recipe(NEW.order_item)
            AND NEW.cook IS NOT NULL
        ) THEN
            RAISE EXCEPTION 'Uncookable dish has a cook';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION save_dish_ingredient_before()
RETURNS TRIGGER AS $$
    BEGIN
        IF (
                SELECT recipe FROM ingredient
                WHERE id = NEW.ingredient
            ) != (
                SELECT menu_item FROM order_item
                WHERE id = (
                    SELECT order_item FROM dish
                    WHERE id = NEW.dish
                )
        ) THEN
            RAISE EXCEPTION 'Wrong ingredient for dish';
        ELSIF (
                SELECT name FROM ingredient
                WHERE id = NEW.ingredient
            ) != (
                SELECT name FROM raw_material
                WHERE id = NEW.raw_material
        ) THEN
            RAISE EXCEPTION 'Ingredient name has to match raw material name';
        ELSIF (
                SELECT amount FROM ingredient
                WHERE id = NEW.ingredient
            ) > (
                SELECT amount FROM raw_material
                WHERE id = NEW.raw_material
        ) THEN
            RAISE EXCEPTION 'Not enough raw material';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION save_dish_ingredient_after()
RETURNS TRIGGER AS $$
    BEGIN
        UPDATE raw_material SET amount = amount - (
            SELECT amount FROM ingredient
            WHERE id = NEW.ingredient
        ) WHERE id = NEW.raw_material;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


----- TRIGGERS -----

CREATE TRIGGER save_resevation
BEFORE INSERT OR UPDATE ON reservation
FOR EACH ROW EXECUTE FUNCTION save_resevation();

CREATE TRIGGER save_order_item
BEFORE INSERT OR UPDATE ON order_item
FOR EACH ROW EXECUTE FUNCTION save_order_item();

CREATE TRIGGER save_dish
BEFORE INSERT OR UPDATE ON dish
FOR EACH ROW EXECUTE FUNCTION save_dish();

CREATE TRIGGER save_dish_ingredient_before
BEFORE INSERT OR UPDATE ON dish_ingredient
FOR EACH ROW EXECUTE FUNCTION save_dish_ingredient_before();

CREATE TRIGGER save_dish_ingredient_after
AFTER INSERT OR UPDATE ON dish_ingredient
FOR EACH ROW EXECUTE FUNCTION save_dish_ingredient_after();
