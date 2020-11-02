USE AstronomicalObservatory
GO

UPDATE Satellite
SET Satellite.Size = 43
WHERE Satellite.PlanetID = 9

-- SELECT Planets that are from Andromeda or Outer Rim Territories Galaxies
SELECT P.Name
FROM Planet P
WHERE P.SolarSystemID = ANY (
    SELECT S.ID
    FROM SolarSystem S
    WHERE S.GalaxyID = ANY (
        SELECT G.ID
        FROM Galaxy G
        WHERE G.Name = 'Andromeda'
           OR G.Name = 'Outer Rim Territories'))

SELECT P.Name
FROM Planet P
WHERE P.SolarSystemID IN (
    SELECT S.ID
    FROM SolarSystem S
    WHERE S.GalaxyID IN (
        SELECT G.ID
        FROM Galaxy G
        WHERE G.Name = 'Andromeda'
           OR G.Name = 'Outer Rim Territories'))

-- Show comets that are at at most 100m from any planet

SELECT C.Name FROM Comet C
WHERE C.ID = ANY(
    SELECT CP.CometID FROM CometVisibleFromPlanet CP
    WHERE CP.DistanceBetweenThem <= 100
    )

SELECT C.Name FROM Comet C
WHERE C.ID IN (
    SELECT CP.CometID FROM CometVisibleFromPlanet CP
    WHERE CP.DistanceBetweenThem <= 100
    )

-- Show comets that are visible only from Tatooine from more than 6000
SELECT C.Name FROM Comet C
WHERE C.ID = ALL (
    SELECT CP.CometID FROM CometVisibleFromPlanet CP
    WHERE CP.PlanetID = ALL(
        SELECT P.ID FROM Planet P WHERE P.Name = 'Tatooine'
        ) AND CP.DistanceBetweenThem > 6000
    )

SELECT C.Name FROM Comet C
WHERE C.ID = (
    SELECT AVG(CP.CometID) FROM CometVisibleFromPlanet CP
    WHERE CP.PlanetID = (
        SELECT AVG(P.ID) FROM Planet P WHERE P.Name = 'Tatooine'
        ) AND CP.DistanceBetweenThem > 6000
    )

-- Show planets that have size greater than all their planets
SELECT P.Name from Planet P
WHERE P.Size * 1000 > ALL(
    SELECT S.Size FROM Satellite S, Planet P2
    WHERE S.PlanetID = P.ID AND P2.ID = P.ID
    )

SELECT P.Name from Planet P
WHERE P.Size * 1000 > (
    SELECT MAX(S.Size) FROM Satellite S, Planet P2
    WHERE S.PlanetID = P2.ID AND P2.ID = P.ID
    )


