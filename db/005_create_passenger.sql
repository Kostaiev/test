CREATE TABLE IF NOT EXISTS passenger (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    phone VARCHAR(16) NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT chk_passenger_first_name
        CHECK (CHAR_LENGTH(TRIM(first_name)) > 1),

    CONSTRAINT chk_passenger_last_name
        CHECK (
            last_name IS NULL
            OR CHAR_LENGTH(TRIM(last_name)) > 1
        ),

    CONSTRAINT chk_passenger_phone
        CHECK (
            REGEXP_LIKE(phone, '^[+][1-9][0-9]{0,14}$')
        ),

    CONSTRAINT uq_passenger_phone
        UNIQUE (phone),

    CONSTRAINT uq_passenger_email
        UNIQUE (email),

    INDEX idx_passenger_created_at_id (created_at DESC, id DESC)
) ENGINE = InnoDB;