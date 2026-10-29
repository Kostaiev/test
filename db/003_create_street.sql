CREATE TABLE IF NOT EXISTS street (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    city_id INT UNSIGNED NOT NULL,
    name VARCHAR(150) NOT NULL,
    drivable BOOLEAN NOT NULL DEFAULT TRUE,
    

    CONSTRAINT chk_street_name_not_empty
    CHECK (CHAR_LENGTH(TRIM(name)) > 0),

    CONSTRAINT uq_street_city_name
    UNIQUE (city_id, name),

    CONSTRAINT fk_street_city
    FOREIGN KEY (city_id)
    REFERENCES city(id)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
);
