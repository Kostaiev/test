CREATE TABLE IF NOT EXISTS ride (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    passenger_id BIGINT UNSIGNED NOT NULL,
    driver_id BIGINT UNSIGNED,
    operator_id BIGINT UNSIGNED,

    pickup_house_id BIGINT UNSIGNED NOT NULL,
    dropoff_house_id BIGINT UNSIGNED NOT NULL,

    fare_amount DECIMAL(10,2),
    paid BOOLEAN NOT NULL DEFAULT FALSE,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    INDEX idx_ride_passenger (passenger_id),
    INDEX idx_ride_driver (driver_id),
    INDEX idx_ride_operator (operator_id),
    INDEX idx_ride_pickup (pickup_house_id),
    INDEX idx_ride_dropoff (dropoff_house_id),

    CONSTRAINT fk_ride_passenger
        FOREIGN KEY (passenger_id) 
        REFERENCES passenger(id)
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,

    CONSTRAINT fk_ride_driver
        FOREIGN KEY (driver_id) 
        REFERENCES driver(id)
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,

    CONSTRAINT fk_ride_operator
        FOREIGN KEY (operator_id) 
        REFERENCES `operator`(id)
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,

    CONSTRAINT fk_ride_pickup
        FOREIGN KEY (pickup_house_id) 
        REFERENCES house(id)
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,

    CONSTRAINT fk_ride_dropoff
        FOREIGN KEY (dropoff_house_id) 
        REFERENCES house(id)
        ON DELETE RESTRICT 
        ON UPDATE RESTRICT,

    CONSTRAINT chk_ride_paid_before_completion
        CHECK (completed = FALSE OR paid = TRUE),

    CONSTRAINT chk_ride_flags
        CHECK (paid IN (0, 1) AND completed IN (0, 1)),

    CONSTRAINT chk_ride_fare
        CHECK (fare_amount IS NULL OR fare_amount >= 0),

    CONSTRAINT chk_ride_completion
        CHECK (completed = FALSE OR driver_id IS NOT NULL)
) ENGINE = InnoDB;