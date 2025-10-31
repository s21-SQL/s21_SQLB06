WITH RECURSIVE trevel AS (
    SELECT point1 AS tour,
        point1, 
        point2, 
        cost
    FROM paths
    WHERE point1 = 'a'
    UNION
    SELECT CONCAT(trevel.tour, ',', paths.point1) AS path,
        paths.point1, 
        paths.point2,
        trevel.cost + paths.cost
    FROM trevel
        JOIN paths ON trevel.point2 = paths.point1
    WHERE tour NOT LIKE CONCAT('%', paths.point1, '%')
    )
SELECT 
    cost AS total_cost,
    CONCAT('{', tour, ',a}') AS tour 
FROM trevel 
WHERE LENGTH(tour) = 7 
    AND point2 LIKE 'a' 
    AND (cost = (SELECT cost FROM trevel WHERE LENGTH(tour) = 7 AND point2 LIKE 'a' ORDER BY cost LIMIT 1) 
    OR cost = (SELECT cost FROM trevel WHERE LENGTH(tour) = 7 AND point2 LIKE 'a' ORDER BY cost DESC LIMIT 1))
ORDER BY 1, 2;