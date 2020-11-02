USE AstronomicalObservatory
GO

SELECT *
FROM Planet
SELECT *
FROM Satellite

INSERT INTO SpaceStation(ID, PlanetID, Name, Size)
VALUES (3, 1, 'The Ark', 12)

INSERT INTO Asteroid(ID, Name, Size)
VALUES (1, 'Ceres', 15),
       (2, 'Icarus', 18),
       (3, 'Eros', 22)

SELECT *
FROM AsteroidVisibleFromPlanet
DELETE
FROM AsteroidVisibleFromPlanet
WHERE PlanetID = 4

INSERT INTO AsteroidVisibleFromPlanet(AsteroidID, PlanetID, Distance)
VALUES
--     (1, 1, 432),
--     (2, 1, 421),
--     (2, 9, 315541),
(3, 4, 3214)

-- Show Planets with their Satellites including those with no satellites
SELECT P.Name as Planet, S.Name as Satellite
FROM Planet P
         LEFT JOIN Satellite S on P.ID = S.PlanetID

-- Show each Comet with the Planets it is visible from and the distance between them
SELECT C.Name as Comet, P.Name as Planet, CVFP.DistanceBetweenThem as Distance
FROM Comet C
         INNER JOIN CometVisibleFromPlanet CVFP on C.ID = CVFP.CometID
         INNER JOIN Planet P on P.ID = CVFP.PlanetID

-- Show each planet with every comet and asteroid that is seen from it
SELECT P.Name as PlanetName, C.Name as CometName, A.Name as AsteroidName
FROM Comet C
         FULL JOIN CometVisibleFromPlanet CVFP on C.ID = CVFP.CometID
         FULL JOIN Planet P on P.ID = CVFP.PlanetID
         FULL JOIN AsteroidVisibleFromPlanet AVFP on P.ID = AVFP.PlanetID
         LEFT JOIN Asteroid A on A.ID = AVFP.AsteroidID
GROUP BY P.Name, C.Name, A.Name

-- Show every star that is in a constellation together with their constellation, alphabetical by stars then constellation
SELECT C.Name as Constellation, S.Name as Star
FROM Star S
         RIGHT JOIN StarConstellation SC on S.ID = SC.StarID
         RIGHT JOIN Constellation C on C.ID = SC.ConstellationID
GROUP BY S.Name, C.Name

DELETE FROM CometVisibleFromPlanet
WHERE PlanetID = 2

-- Number of comets seen from planets from our solar system
SELECT COUNT(DISTINCT (C.ID)) FROM Comet C
INNER JOIN CometVisibleFromPlanet CVFP on C.ID = CVFP.CometID
INNER JOIN Planet P on P.ID = CVFP.PlanetID
INNER JOIN SolarSystem SS on SS.ID = P.SolarSystemID
WHERE SS.ID = 1