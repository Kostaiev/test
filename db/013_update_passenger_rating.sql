UPDATE passenger AS p
LEFT JOIN (
    SELECT
        r.passenger_id,
        ROUND(AVG(pr.rating), 2) AS avg_rating,
        COUNT(*) AS total
    FROM ride AS r
    JOIN passenger_rating AS pr ON pr.ride_id = r.id
    GROUP BY r.passenger_id
) AS stats ON stats.passenger_id = p.id
SET
    p.rating_avg = stats.avg_rating,
    p.rating_count = COALESCE(stats.total, 0);