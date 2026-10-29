START TRANSACTION;

-- Regions
INSERT INTO region (name) VALUES
    ('Львівська'),
    ('Київcька')
ON DUPLICATE KEY UPDATE id = id;

SET @lviv_region = (SELECT id FROM region WHERE name = 'Львівська');
SET @kyiv_region = (SELECT id FROM region WHERE name = 'Київcька');

-- Cities
INSERT INTO city (region_id, name) VALUES
    (@lviv_region, 'Львів'),
    (@kyiv_region, 'Київ')
ON DUPLICATE KEY UPDATE id = id;

SET @lviv_city = (SELECT id FROM city WHERE region_id = @lviv_region AND name = 'Львів');
SET @kyiv_city = (SELECT id FROM city WHERE region_id = @kyiv_region AND name = 'Київ');

-- Streets
INSERT INTO street (city_id, name, drivable) VALUES
    (@lviv_city, 'Шевченка', TRUE),
    (@lviv_city, 'Садова', TRUE),
    (@lviv_city, 'Пішохідна', FALSE),
    (@kyiv_city, 'Шевченка', TRUE)
ON DUPLICATE KEY UPDATE id = id;

SET @lviv_shevchenka = (SELECT id FROM street WHERE city_id = @lviv_city AND name = 'Шевченка');
SET @lviv_sadova = (SELECT id FROM street WHERE city_id = @lviv_city AND name = 'Садова');
SET @lviv_pishohidna = (SELECT id FROM street WHERE city_id = @lviv_city AND name = 'Пішохідна');
SET @kyiv_shevchenka = (SELECT id FROM street WHERE city_id = @kyiv_city AND name = 'Шевченка');

-- Houses
INSERT INTO house (street_id, house_number) VALUES
    (@lviv_shevchenka, '10'),
    (@lviv_shevchenka, '12А'),
    (@lviv_sadova, '5'),
    (@lviv_pishohidna, '1'),
    (@kyiv_shevchenka, '10')
ON DUPLICATE KEY UPDATE id = id;

-- Passengers
INSERT INTO passenger (first_name, last_name, phone, email) VALUES
    ('Brunhilde', 'Pompidur', '+12025550101', 'brunhilde@example.com'),
    ('Carl', NULL, '+12025550102', 'carl@example.com')
ON DUPLICATE KEY UPDATE id = id;

-- Drivers
INSERT INTO driver (first_name, last_name, phone, email) VALUES
    ('Anita', 'Job', '+12025550103', 'anita.driver@example.com'),
    ('Robin', 'Banks', '+12025550104', 'robin.driver@example.com')
ON DUPLICATE KEY UPDATE id = id;

-- Operators
INSERT INTO `operator` (first_name, last_name, email) VALUES
    ('Justin', 'Case', 'justin.operator@example.com')
ON DUPLICATE KEY UPDATE id = id;

-- IDs
SET @p1 = (SELECT id FROM passenger WHERE phone = '+12025550101');
SET @p2 = (SELECT id FROM passenger WHERE phone = '+12025550102');

SET @d1 = (SELECT id FROM driver WHERE phone = '+12025550103');
SET @d2 = (SELECT id FROM driver WHERE phone = '+12025550104');

SET @op1 = (SELECT id FROM `operator` WHERE email = 'justin.operator@example.com');

SET @h1 = (SELECT id FROM house WHERE street_id = @lviv_shevchenka AND house_number = '10');
SET @h2 = (SELECT id FROM house WHERE street_id = @lviv_shevchenka AND house_number = '12А');
SET @h3 = (SELECT id FROM house WHERE street_id = @lviv_sadova AND house_number = '5');
SET @h4 = (SELECT id FROM house WHERE street_id = @lviv_pishohidna AND house_number = '1');
SET @h5 = (SELECT id FROM house WHERE street_id = @kyiv_shevchenka AND house_number = '10');

-- Rides
INSERT INTO ride (
    passenger_id, driver_id, operator_id,
    pickup_house_id, dropoff_house_id,
    fare_amount, paid, completed, created_at
)
SELECT v.*
FROM (
    SELECT
        @p1 AS passenger_id, @d1 AS driver_id, @op1 AS operator_id,
        @h1 AS pickup_house_id, @h3 AS dropoff_house_id,
        120.00 AS fare_amount, TRUE AS paid, TRUE AS completed,
        '2026-10-24 10:00:00' AS created_at
    UNION ALL
    SELECT @p2, @d2, NULL, @h3, @h2, 165.00, TRUE, TRUE, '2026-10-24 11:00:00'
    UNION ALL
    SELECT @p1, @d1, NULL, @h4, @h1, 110.00, TRUE, TRUE, '2026-10-24 12:00:00'
    UNION ALL
    SELECT @p2, NULL, @op1, @h5, @h2, NULL, FALSE, FALSE, '2026-10-24 13:00:00'
) AS v
LEFT JOIN ride AS existing
    ON existing.passenger_id = v.passenger_id
   AND existing.created_at = v.created_at
WHERE existing.id IS NULL;

-- Ride IDs
SET @r1 = (SELECT id FROM ride WHERE passenger_id = @p1 AND created_at = '2026-10-24 10:00:00');
SET @r2 = (SELECT id FROM ride WHERE passenger_id = @p2 AND created_at = '2026-10-24 11:00:00');
SET @r3 = (SELECT id FROM ride WHERE passenger_id = @p1 AND created_at = '2026-10-24 12:00:00');

-- Driver ratings
INSERT INTO driver_rating (ride_id, rating, review) VALUES
    (@r1, 5, 'Great ride'),
    (@r2, 4, NULL),
    (@r3, 4, 'Good driver')
ON DUPLICATE KEY UPDATE ride_id = ride_id;

-- Passenger ratings
INSERT INTO passenger_rating (ride_id, rating, review) VALUES
    (@r1, 5, 'It was awesome'),
    (@r2, 3, NULL),
    (@r3, 4, 'Cool')
ON DUPLICATE KEY UPDATE ride_id = ride_id;

-- Driver rating summary
UPDATE driver AS d
LEFT JOIN (
    SELECT r.driver_id,
           ROUND(AVG(dr.rating), 2) AS avg_rating,
           COUNT(*) AS total
    FROM ride AS r
    JOIN driver_rating AS dr ON dr.ride_id = r.id
    GROUP BY r.driver_id
) AS stats ON stats.driver_id = d.id
SET d.rating_avg = stats.avg_rating,
    d.rating_count = COALESCE(stats.total, 0)
WHERE d.id IN (@d1, @d2);

-- Passenger rating summary
UPDATE passenger AS p
LEFT JOIN (
    SELECT r.passenger_id,
           ROUND(AVG(pr.rating), 2) AS avg_rating,
           COUNT(*) AS total
    FROM ride AS r
    JOIN passenger_rating AS pr ON pr.ride_id = r.id
    GROUP BY r.passenger_id
) AS stats ON stats.passenger_id = p.id
SET p.rating_avg = stats.avg_rating,
    p.rating_count = COALESCE(stats.total, 0)
WHERE p.id IN (@p1, @p2);

COMMIT;