USE AstronomicalObservatory
GO

-- Show space stations that are satellites
SELECT SS.Name, SS.Size
FROM SpaceStation SS
INTERSECT
SELECT S.Name, S.Size
FROM Satellite S

SELECT *
FROM Satellite

-- Show Satellites that are not Earth's nor Mars'
SELECT S.Name, S.Size
FROM Satellite S
WHERE S.PlanetID IN (
    SELECT P.ID
    FROM Planet P
    WHERE P.Name NOT IN ('Earth', 'Mars')
)