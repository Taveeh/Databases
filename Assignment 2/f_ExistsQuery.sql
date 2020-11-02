USE AstronomicalObservatory
GO

-- Show planets with at least one satellite with size > a quarter of its planet
SELECT P.Name
FROM Planet P
WHERE EXISTS(SELECT S.Name FROM Satellite S WHERE (S.PlanetID = P.ID AND S.Size > (P.Size * 1000 / 4)))

-- Show stars that are in a constellation
SELECT S.Name
FROM Star S
WHERE EXISTS(SELECT * FROM StarConstellation C WHERE C.StarID = S.ID)
