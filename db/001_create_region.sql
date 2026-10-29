CREATE TABLE IF NOT EXISTS region (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,

    CONSTRAINT uq_region_name
        UNIQUE (name),

    CONSTRAINT chk_region_name_not_empty
        CHECK (CHAR_LENGTH(TRIM(name)) > 0)
);
