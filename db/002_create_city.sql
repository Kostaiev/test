CREATE TABLE IF NOT EXISTS city (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    region_id INT UNSIGNED NOT NULL,
    name VARCHAR(150) NOT NULL,

    CONSTRAINT chk_city_name_not_empty
    CHECK (CHAR_LENGTH(TRIM(name)) > 0),

    CONSTRAINT uq_city_region_name
    UNIQUE (region_id, name),

    CONSTRAINT fk_city_region
    FOREIGN KEY (region_id)
    REFERENCES region(id)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);
