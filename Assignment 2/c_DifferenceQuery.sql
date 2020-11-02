USE AstronomicalObservatory
GO

-- Show all the exoplanets whose age is known
SELECT P.Name, P.Age
FROM Planet P
WHERE P.Age IS NOT NULL
    EXCEPT
SELECT P.Name, P.Age
FROM Planet P
WHERE P.SolarSystemID = 1

-- Show all comets that can be seen from Earth but never from Tatooine

SELECT C.Name
FROM Comet C
WHERE C.ID IN (
    SELECT C1.CometID
    FROM CometVisibleFromPlanet C1
    WHERE C1.PlanetID IN (
        SELECT P.ID
        FROM Planet P
        WHERE P.Name = 'Earth'
    )
)
    EXCEPT
SELECT C.Name
FROM Comet C
WHERE C.ID IN (
    SELECT C1.CometID
    FROM CometVisibleFromPlanet C1
    WHERE C1.PlanetID NOT IN (
        SELECT P.ID
        FROM Planet P
        WHERE P.Name != 'Tatooine'
    )
)