CREATE TABLE IF NOT EXISTS paths
(
    point1 varchar NOT NULL,
    point2 varchar NOT NULL,
    cost int NOT NULL,
    UNIQUE (point1, point2, cost)
);

INSERT INTO paths (point1, point2, cost)
VALUES ('a','b',10), ('b','a',10),
       ('b','c',35), ('c','b',35),
       ('c','a',15), ('a','c',15),
       ('c','d',30), ('d','c',30),
       ('a','d',20), ('d','a',20),
       ('b','d',25), ('d','b',25)
       ON CONFLICT DO NOTHING;


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
    AND cost = (SELECT cost FROM trevel WHERE LENGTH(tour) = 7 AND point2 LIKE 'a' ORDER BY cost LIMIT 1) 
ORDER BY 1, 2;
