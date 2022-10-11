DROP INDEX IF EXISTS
    ingredient_name,
    ingredient_recipe,
    raw_material_name;

CREATE INDEX ingredient_name ON ingredient
USING HASH(LOWER(name));

CREATE INDEX ingredient_recipe ON ingredient
USING HASH(LOWER(recipe));

CREATE INDEX raw_material_name ON ingredient
USING HASH(LOWER(name));
