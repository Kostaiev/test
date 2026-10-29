CREATE TABLE IF NOT EXISTS `operator` (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100)NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT uq_operator_email UNIQUE (email),

    CONSTRAINT chk_operator_name
        CHECK (CHAR_LENGTH(TRIM(first_name)) > 0),
    
    CONSTRAINT chk_operator_last_name
        CHECK (CHAR_LENGTH(TRIM(last_name)) > 0)
) ENGINE = InnoDB;