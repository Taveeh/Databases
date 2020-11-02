USE AstronomicalObservatory
GO

-- Select the planets that are either in Andromeda Galaxy or Milky Way
SELECT P.Name
FROM Planet P
WHERE P.SolarSystemID IN (
    SELECT S.ID
    FROM SolarSystem S
    WHERE S.GalaxyID IN (
        SELECT G.ID
        FROM Galaxy G
        WHERE G.Name = 'Andromeda'
           OR G.Name = 'Milky Way'
    )
)

ALTER TABLE Planet
ADD OrbitalTime INT

UPDATE Planet
SET Planet.OrbitalTime = 12
WHERE Planet.Name = 'Jupiter'

UPDATE Planet
SET Planet.OrbitalTime = 29
WHERE Planet.Name = 'Saturn'

UPDATE Planet
SET Planet.OrbitalTime = 2
WHERE Planet.Name = 'Mars'

UPDATE Planet
SET Planet.OrbitalTime = 1
WHERE Planet.Name = 'Earth'

-- Show satellites of planets that have rotation time triple than of earths
SELECT S.Name FROM Satellite S
WHERE S.PlanetID IN (
    SELECT P.ID
    FROM Planet P
    WHERE P.OrbitalTime > 3 * (
        SELECT P1.OrbitalTime
        FROM Planet P1
        WHERE P1.Name = 'Earth'
    )
)
