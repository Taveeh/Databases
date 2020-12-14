USE AstronomicalObservatory
GO

---------------------A------------------------

CREATE PROCEDURE SetSizeFloat
AS
    ALTER TABLE Meteor
        ALTER COLUMN Size FLOAT
GO

CREATE PROCEDURE SetSizeBackInt
AS
    ALTER TABLE Meteor
        ALTER COLUMN Size INT
GO

EXEC SetSizeFloat
SELECT *
FROM Meteor
EXEC SetSizeBackInt

---------------------B------------------------

CREATE PROCEDURE AddSpeedOnMeteor
AS
    ALTER TABLE Meteor
        ADD Speed INT
GO

CREATE PROCEDURE RemoveSpeedMeteor
AS
    ALTER TABLE Meteor
        DROP COLUMN Speed
GO

EXEC AddSpeedOnMeteor
SELECT *
FROM Meteor
EXEC RemoveSpeedMeteor

---------------------C------------------------

CREATE PROCEDURE DefaultSpeed15
AS
    ALTER TABLE Meteor
        ADD CONSTRAINT SpeedDefaultConstraint DEFAULT (15) FOR Speed
GO

CREATE PROCEDURE RemoveDefault
AS
    ALTER TABLE Meteor
        DROP CONSTRAINT SpeedDefaultConstraint
GO

EXEC DefaultSpeed15
EXEC RemoveDefault

---------------------G------------------------

CREATE PROCEDURE CreateAlienShip
AS
    CREATE TABLE AlienShip
    (
        ID                    INT
            CONSTRAINT IdPrimaryKey PRIMARY KEY,
        Name                  VARCHAR(50) NOT NULL,
        DestructionPercentage SMALLINT,
        PlanetFrom            INT
    )
GO

CREATE PROCEDURE DropAlienShip
AS
    DROP TABLE AlienShip
GO

EXEC CreateAlienShip
EXEC DropAlienShip


INSERT INTO AlienShip(ID, Name, DestructionPercentage)
VALUES (1, 'Death Star', 100)


---------------------D------------------------
CREATE PROCEDURE AddNamePrimaryKeyAlienShip
AS
    ALTER TABLE AlienShip
        DROP CONSTRAINT IdPrimaryKey
    ALTER TABLE AlienShip
        ADD CONSTRAINT IdAndNamePrimaryKey PRIMARY KEY (ID, Name)
GO

CREATE PROCEDURE RemoveNamePrimaryKeyAlienShip
AS
    ALTER TABLE AlienShip
        DROP CONSTRAINT IdAndNamePrimaryKey
    ALTER TABLE AlienShip
        ADD CONSTRAINT IdPrimaryKey PRIMARY KEY (ID)
GO

SELECT *
FROM AlienShip
EXEC AddNamePrimaryKeyAlienShip
EXEC RemoveNamePrimaryKeyAlienShip

---------------------E------------------------

CREATE PROCEDURE AddNameCandidateKeyAlienShip
AS
    ALTER TABLE AlienShip
        ADD CONSTRAINT NameCandidateKey UNIQUE (Name)
GO

CREATE PROCEDURE RemoveNameCandidateKeyAlienShip
AS
    ALTER TABLE AlienShip
        DROP CONSTRAINT NameCandidateKey
GO

SELECT *
FROM AlienShip
EXEC AddNamePrimaryKeyAlienShip
EXEC RemoveNamePrimaryKeyAlienShip

---------------------F------------------------

CREATE PROCEDURE AddPlanetForeignKey
AS
    ALTER TABLE AlienShip
        ADD CONSTRAINT PlanetForeignKey FOREIGN KEY (PlanetFrom) REFERENCES Planet (ID)
GO

CREATE PROCEDURE RemovePlanetForeignKey
AS
    ALTER TABLE AlienShip
        DROP CONSTRAINT PlanetForeignKey
GO

EXEC AddPlanetForeignKey
EXEC RemovePlanetForeignKey

---------------------------------------------

CREATE TABLE VersionHistory
(
    VERSION INT
)
INSERT INTO VersionHistory
VALUES (0)
CREATE TABLE ProcedureTable
(
    UndoProcedure VARCHAR(100),
    RedoProcedure VARCHAR(100),
    Version       INT PRIMARY KEY
)
SELECT * FROM ProcedureTable
SELECT * FROM VersionHistory
SELECT * FROM AlienShip
EXEC GoToVersion 0
CREATE PROCEDURE GoToVersion @Version INT
AS
DECLARE @var INT;
    SET @var = (SELECT TOP 1 VH.VERSION
                FROM VersionHistory VH)
DECLARE @statements CHAR(100);
DECLARE @procedure NVARCHAR(100);
DECLARE @var2 INT

WHILE @var != @Version
BEGIN
if @var > @Version
BEGIN
DECLARE UndoCursor CURSOR
    FOR SELECT PT.UndoProcedure
        FROM ProcedureTable PT
OPEN UndoCursor

SELECT @var2 = 0
WHILE @var2 != @var
    BEGIN
        FETCH FROM UndoCursor INTO @statements
        SELECT @var2 = @var2 + 1
    END
if @var = @Version
    BEGIN
        print 'Stop here'
        BREAK
    END
ELSE
    BEGIN
        SELECT @procedure = 'exec ' + @statements
        print @procedure
        print 'This was the procedure'
        EXEC sp_executesql @procedure
        UPDATE VersionHistory
        SET VERSION = VERSION - 1
        SET @var = @var - 1;
        FETCH FROM UndoCursor INTO @statements
    END
    CLOSE UndoCursor
    DEALLOCATE UndoCursor
END
    ELSE
    BEGIN
        DECLARE RedoCursor CURSOR FOR SELECT PT.RedoProcedure FROM ProcedureTable PT
        OPEN RedoCursor
SELECT @var2 = -1
WHILE @var2 != @var
    BEGIN
        FETCH FROM RedoCursor INTO @statements
        SELECT @var2 = @var2 + 1
    END
if @var = @Version
    BEGIN
        print 'Stop here'
        BREAK
    END
ELSE
    BEGIN
        SELECT @procedure = 'exec ' + @statements
        print @procedure
        print 'This was the procedure'
        EXEC sp_executesql @procedure
        UPDATE VersionHistory
        SET VERSION = VERSION + 1
        SET @var = @var + 1;
        FETCH FROM RedoCursor INTO @statements
    END
        CLOSE RedoCursor
        DEALLOCATE RedoCursor
    END
END
GO

EXEC CreateAlienShip
EXEC DropAlienShip
UPDATE VersionHistory
SET VERSION = 2

EXEC AddSpeedOnMeteor
EXEC RemoveSpeedMeteor
UPDATE ProcedureTable
SET RedoProcedure = 'AddSpeedOnMeteor'
WHERE Version = 2
INSERT INTO ProcedureTable(UndoProcedure, RedoProcedure, Version)
VALUES
 ('DropAlienShip', 'CreateAlienShip', 1),
       ('RemoveSpeedMeteor', 'AddSpeedMeteor', 2),
       ('SetSizeBackInt', 'SetSizeFloat', 3),
       ('RemoveDefault', 'DefaultSpeed15', 4),
       ('RemoveNameCandidateKeyAlienShip', 'AddNameCandidateKeyAlienShip', 5),
       ('RemovePlanetForeignKey', 'AddPlanetForeignKey', 6),
       ('RemoveNamePrimaryKeyAlienShip', 'AddNamePrimaryKeyAlienShip', 7)
SELECT *
FROM ProcedureTable
SELECT *
FROM VersionHistory

EXECUTE GoToVersion @Version = 1










