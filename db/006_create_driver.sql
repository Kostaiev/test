CREATE TABLE IF NOT EXISTS driver (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(16) NOT NULL,
    email VARCHAR(254) NOT NULL,
    rating_avg DECIMAL(3,2) DEFAULT NULL,
    rating_count INT UNSIGNED NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT uq_driver_phone UNIQUE (phone),
    CONSTRAINT uq_driver_email UNIQUE (email),

    CONSTRAINT chk_driver_name
        CHECK (
            CHAR_LENGTH(TRIM(first_name)) > 0
        ),

    CONSTRAINT chk_driver_last_name
        CHECK (
            CHAR_LENGTH(TRIM(last_name)) > 0
        ),

    CONSTRAINT chk_driver_phone
        CHECK (
            REGEXP_LIKE(phone, '^[+][1-9][0-9]{0,14}$')
        ),

    CONSTRAINT chk_driver_rating_summary
        CHECK (
            (rating_count = 0 AND rating_avg IS NULL)
            OR
            (rating_count > 0 AND rating_avg IS NOT NULL
             AND rating_avg BETWEEN 1 AND 5)
        )
) ENGINE = InnoDB;