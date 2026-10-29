CREATE TABLE IF NOT EXISTS house (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    street_id INT UNSIGNED NOT NULL,
    house_number VARCHAR(20) NOT NULL,

    CONSTRAINT chk_house_number_not_empty
    CHECK (CHAR_LENGTH(TRIM(house_number)) > 0),

    CONSTRAINT uq_house_street_number
        UNIQUE (street_id, house_number),

    CONSTRAINT fk_house_street
        FOREIGN KEY (street_id)
        REFERENCES street(id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);
