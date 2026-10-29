UPDATE driver AS d
LEFT JOIN (
    SELECT
        r.driver_id,
        ROUND(AVG(dr.rating), 2) AS avg_rating,
        COUNT(*) AS total
    FROM ride AS r
    JOIN driver_rating AS dr ON dr.ride_id = r.id
    WHERE r.driver_id IS NOT NULL
    GROUP BY r.driver_id
) AS stats ON stats.driver_id = d.id
SET
    d.rating_avg = stats.avg_rating,
    d.rating_count = COALESCE(stats.total, 0);