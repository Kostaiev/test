CREATE TABLE IF NOT EXISTS passenger_rating (
    ride_id BIGINT UNSIGNED PRIMARY KEY,
    rating TINYINT UNSIGNED NOT NULL,
    review VARCHAR(1000),
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT chk_passenger_rating_value
        CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT fk_passenger_rating_ride
        FOREIGN KEY (ride_id) 
        REFERENCES ride(id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB;