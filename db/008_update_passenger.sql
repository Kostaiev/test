ALTER TABLE passenger
    ADD COLUMN rating_avg DECIMAL(3,2) DEFAULT NULL,
    ADD COLUMN rating_count INT UNSIGNED NOT NULL DEFAULT 0,

    ADD CONSTRAINT chk_passenger_rating_summary
        CHECK (
            (rating_count = 0 AND rating_avg IS NULL)
            OR
            (rating_count > 0 AND rating_avg IS NOT NULL
             AND rating_avg BETWEEN 1 AND 5)
        );