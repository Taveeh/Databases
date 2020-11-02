USE AstronomicalObservatory
GO

-- Show top 3 Satellites and Space Stations by Size
SELECT TOP 3 *
FROM (
         SELECT SS.Name, SS.Size
         FROM SpaceStation SS
         WHERE SS.Size IS NOT NULL
         UNION
         SELECT S.Name, S.Size
         FROM Satellite S
         WHERE S.Size IS NOT NULL
     ) as SatellitesAndSpaceStations
ORDER BY Size

-- Number of planets with at least one satellite with size greater than 20
SELECT COUNT(DISTINCT (S.PlanetID)) as NumberOfPlanets FROM Satellite S WHERE S.Size > 20

-- Select Stars that are in Big Dipper or in Cassiopeia
SELECT S.Name
FROM Star S
WHERE ID IN (
    SELECT DISTINCT (SC.StarID)
    FROM StarConstellation SC
    WHERE SC.ConstellationID IN (
        SELECT C.ID
        FROM Constellation C
        WHERE C.Name = 'Big Dipper'
           OR C.Name = 'Cassiopeia'
    )
)
