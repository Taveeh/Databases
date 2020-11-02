USE AstronomicalObservatory
GO

UPDATE Planet
SET Planet.OrbitalTime = 1254
WHERE Planet.Name = 'Tatooine'

-- Select top 25% planets by orbital time
SELECT TOP 25 PERCENT *
FROM (
         SELECT P.Name, P.OrbitalTime
         FROM Planet P
         WHERE P.OrbitalTime IS NOT NULL

     ) as Pl
ORDER BY 0 - Pl.OrbitalTime


-- We define tenacity of a planet by computing age + size + orbitalTime / 3
-- Show planets sorted by tenacity

SELECT T.Name, T.Tenacity FROM (
                               SELECT P.Name, (P.Age + P.Size + P.OrbitalTime) / 3 AS Tenacity FROM Planet P
                                   ) as T
WHERE T.Tenacity IS NOT NULL
ORDER BY T.Tenacity