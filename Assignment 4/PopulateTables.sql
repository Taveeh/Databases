use AstronomicalObservatory
GO

CREATE VIEW RandomView
AS
SELECT RAND() AS Value
GO

CREATE FUNCTION RandomInt(@lower INT, @upper INT)
    RETURNS INT
AS
BEGIN
    RETURN FLOOR((SELECT Value FROM RandomView) * (@upper - @lower) + @lower)
END
GO

CREATE OR
ALTER PROCEDURE InsertPlanet @seed INT
AS
BEGIN
    INSERT INTO Planet(ID, SolarSystemID, Name, Size)
    VALUES (@seed, (SELECT TOP 1 ID FROM SolarSystem), 'Planet X-AE-A ' + CONVERT(VARCHAR(50), @seed),
            dbo.RandomInt(1, 100))
END
GO

EXEC InsertPlanet 1000
SELECT *
FROM Planet
DELETE
FROM Planet
WHERE ID = 1000


CREATE OR
ALTER PROCEDURE InsertComet @seed INT
AS
BEGIN
    INSERT INTO Comet(ID, Name, Size)
    VALUES (@seed, 'Comet ' + CONVERT(VARCHAR(50), @seed), dbo.RandomInt(1, 30))
END
GO

EXEC InsertComet 100
SELECT *
FROM Comet
DELETE
FROM Comet
WHERE ID = 100
CREATE OR
ALTER PROCEDURE InsertCometVisibleFromPlanet @seed INT
AS
BEGIN
    DECLARE @cometId INT, @planetId INT, @added SMALLINT
    SELECT @added = 0
    WHILE @added = 0
        BEGIN
            SET @cometId = (SELECT TOP 1 ID FROM Comet ORDER BY NEWID())
            SET @planetId = (SELECT TOP 1 ID FROM Planet ORDER BY NEWID())

            IF EXISTS(SELECT *
                      FROM (
                               SELECT *
                               FROM CometVisibleFromPlanet
                               WHERE CometID = @cometId
                           ) as [CVFP*]
                      WHERE PlanetID = @planetId)
                BEGIN
                    CONTINUE
                END
            INSERT INTO CometVisibleFromPlanet(CometID, PlanetID, DistanceBetweenThem)
            VALUES (@cometId, @planetId, dbo.RandomInt(0, 100000))

            SELECT @added = 1
        END
END
    EXEC InsertCometVisibleFromPlanet 0
SELECT *
FROM CometVisibleFromPlanet
    CREATE OR
    ALTER PROCEDURE PopulateTable @tableName VARCHAR(50),
                                  @noRows INT
    AS
    BEGIN
        DECLARE @currentRow INT, @command VARCHAR(256)
        SET @currentRow = 0
        WHILE @currentRow < @noRows
            BEGIN
                SELECT @command = 'Insert' + @tableName + ' ' + CONVERT(VARCHAR(10), @currentRow)
                EXEC (@command)
                SET @currentRow = @currentRow + 1
            END
    END
GO
SELECT *
INTO BackupPlanet
FROM Planet
SELECT *
INTO BackupSatellite
FROM Satellite
SELECT *
INTO BackupSpaceStation
FROM SpaceStation

DELETE CometVisibleFromPlanet
DELETE Comet
DELETE Satellite
DELETE SpaceStation
DELETE AsteroidVisibleFromPlanet
DELETE Meteor
DELETE Planet

SELECT *
FROM Comet
EXEC PopulateTable 'Planet', 3000
EXEC PopulateTable 'Comet', 1500
EXEC PopulateTable 'CometVisibleFromPlanet', 2000
SELECT *
FROM Planet
SELECT *
FROM Comet
SELECT *
FROM CometVisibleFromPlanet
DELETE CometVisibleFromPlanet
DELETE Planet
DELETE Comet

CREATE PROCEDURE ClearTable @tableName VARCHAR(50)
AS
    EXEC ('DELETE FROM ' + @tableName)
GO

CREATE VIEW LargePlanets AS
SELECT P.Name, P.Age, P.Size, P.OrbitalTime
FROM BackupPlanet P
WHERE P.Size > 50

-- Each satellite with its planet
CREATE VIEW PlanetSatellite AS
SELECT S.Name as Satellite, P.Name as Planet
FROM BackupPlanet P
         INNER JOIN BackupSatellite S on P.ID = S.PlanetID


-- Show every star that is in a constellation together with their constellation, alphabetical by stars then constellation
CREATE VIEW ViewStarConstellation AS
SELECT C.Name as Constellation, S.Name as Star
FROM Star S
         RIGHT JOIN StarConstellation SC on S.ID = SC.StarID
         RIGHT JOIN Constellation C on C.ID = SC.ConstellationID
GROUP BY S.Name, C.Name
