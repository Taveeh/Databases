USE AstronomicalObservatory
GO

CREATE OR
ALTER PROCEDURE CreateTest @name VARCHAR(50)
AS
BEGIN
    IF EXISTS(SELECT * FROM Tests T WHERE Name = @name)
        BEGIN
            PRINT 'Test already exists'
            RETURN
        END
    INSERT INTO Tests(Name) VALUES (@name)
END
    EXEC CreateTest 'FirstTestSoWeCanNameItHelloWorld'
SELECT *
FROM Tests


CREATE OR
    ALTER PROCEDURE AddTableToTestTable @tableName VARCHAR(50)
    AS
    BEGIN
        IF NOT EXISTS(SELECT * FROM sys.tables WHERE name = @tableName)
            BEGIN
                PRINT 'Table' + @tableName + ' does not exist'
                RETURN
            END
        IF EXISTS(SELECT * FROM Tables T WHERE T.Name = @tableName)
            BEGIN
                PRINT 'Table ' + @tableName + ' already added to test'
                RETURN
            END
        INSERT INTO Tables(Name) VALUES (@tableName)
    END

EXEC AddTableToTestTable 'Planet'
EXEC AddTableToTestTable 'Comet'
EXEC AddTableToTestTable 'CometVisibleFromPlanet'



CREATE OR ALTER PROCEDURE RelateTestsAndTables @tableName VARCHAR(50), @testName VARCHAR(50), @noRows INT, @position INT
AS
    BEGIN
        IF @position < 0
        BEGIN
            PRINT 'Position must be >0'
            RETURN
        END
        IF @noRows < 0
        BEGIN
            PRINT 'Number of rows must be >0'
            RETURN
        END

        DECLARE @testID INT, @tableID INT
        SET @testID = (SELECT T.TestID FROM Tests T WHERE T.Name = @testName)
        SET @tableID = (SELECT T.TableID FROM Tables T WHERE T.Name = @tableName)
        INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
        (@testID, @tableID, @noRows, @position)
    END

EXEC RelateTestsAndTables 'CometVisibleFromPlanet', 'FirstTestSoWeCanNameItHelloWorld', 2000, 0

CREATE OR ALTER PROCEDURE AddViewToTestTable @viewName VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = @viewName)
    BEGIN
        PRINT 'View does not exist'
        RETURN
    end
    IF EXISTS(SELECT * FROM Views WHERE Name = @viewName)
    BEGIN
        PRINT 'View already added'
        RETURN
    end
    INSERT INTO Views(Name) VALUES (@viewName)
end

CREATE OR ALTER PROCEDURE RelateTestsAndViews @viewName VARCHAR(50), @testName VARCHAR(50)
AS
    BEGIN
        DECLARE @testID INT, @viewID INT
        SET @testID = (SELECT TestID FROM Tests WHERE Name = @testName)
        SET @viewID = (SELECT ViewID FROM Views WHERE Name = @viewName)
        INSERT INTO TestViews(testid, viewid) VALUES (@testID, @viewID)
    end






CREATE OR ALTER PROCEDURE RunTest @name VARCHAR(50)
AS
    DECLARE @test INT
    SET @test = (SELECT T.TestID FROM Tests T WHERE T.Name = @name)

    DECLARE @tableName VARCHAR(50), @noRows INT, @tableID INT,
        @allTestsStartTime DATETIME2, @allTestsEndTime DATETIME2,
        @currentTestStartTime DATETIME2, @currentTestEndTime DATETIME2,
        @testRunID INT, @command VARCHAR(256),
        @viewName VARCHAR(50), @viewID INT

    INSERT INTO TestRuns(Description) VALUES (@name)
    SET @testRunID = CONVERT(INT, (SELECT last_value FROM sys.identity_columns WHERE name = 'TestRunID'))

    DECLARE TablesCursor CURSOR SCROLL FOR
    SELECT T2.TableID, T2.Name, TT.NoOfRows FROM TestTables TT INNER JOIN Tables T2 on T2.TableID = TT.TableID
    WHERE TT.TestID = @test
    ORDER BY TT.Position

    DECLARE ViewsCursor CURSOR FOR
    SELECT V.ViewID, V.Name FROM Views V INNER JOIN TestViews TV on V.ViewID = TV.ViewID
    WHERE TV.TestID = @test

    SET @allTestsStartTime = SYSDATETIME();
    OPEN TablesCursor

    FETCH FIRST FROM TablesCursor INTO @tableID, @tableName, @noRows

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @currentTestStartTime = SYSDATETIME();
        SET @command = 'PopulateTable ' + char(39) + @tableName + char(39) + ', ' + CONVERT(VARCHAR(10), @noRows)
        PRINT @noRows
        EXEC(@command)
        SET @currentTestEndTime = SYSDATETIME();
        INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@testRunID, @tableID, @currentTestStartTime, @currentTestEndTime)
        FETCH NEXT FROM TablesCursor INTO @tableID, @tableName, @noRows
    end

    CLOSE TablesCursor
    OPEN TablesCursor
    FETCH LAST FROM TablesCursor INTO @tableID, @tableName, @noRows

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC ClearTable @tableName
        FETCH PRIOR FROM TablesCursor INTO @tableID, @tableName, @noRows
    end
    CLOSE TablesCursor
    DEALLOCATE TablesCursor

    OPEN ViewsCursor
    FETCH FROM ViewsCursor INTO @viewID, @viewName
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @currentTestStartTime = SYSDATETIME()
            DECLARE @statement VARCHAR(256)
            SET @statement = 'SELECT * FROM ' + @viewName
            PRINT @statement
            EXEC (@statement)
            SET @currentTestEndTime = SYSDATETIME()
            INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunID, @viewID, @currentTestStartTime, @currentTestEndTime)
            FETCH NEXT FROM ViewsCursor INTO @viewID, @viewName
        end
    SET @allTestsEndTime = SYSDATETIME();
    CLOSE ViewsCursor
    DEALLOCATE ViewsCursor
    UPDATE TestRuns
	SET StartAt = @allTestsStartTime, EndAt = @allTestsEndTime
	WHERE TestRunID = @testRunID
go

SELECT * FROM CometVisibleFromPlanet
SELECT * FROM Comet
SELECT * FROM Planet
DELETE TestRunTables
DELETE TestTables

EXEC RelateTestsAndTables 'Planet', 'FirstTestSoWeCanNameItHelloWorld', 2530, 1
EXEC RelateTestsAndTables 'Comet', 'FirstTestSoWeCanNameItHelloWorld', 3000, 2
EXEC RelateTestsAndTables 'CometVisibleFromPlanet', 'FirstTestSoWeCanNameItHelloWorld', 2000, 3

EXEC CreateTest 'FastTestShouldBeShort'
EXEC RelateTestsAndTables 'Planet', 'FastTestShouldBeShort', 100, 2
EXEC RelateTestsAndTables 'Comet', 'FastTestShouldBeShort', 150, 1
EXEC RelateTestsAndTables 'CometVisibleFromPlanet', 'FastTestShouldBeShort', 33, 3

EXEC AddViewToTestTable 'LargePlanets'
EXEC AddViewToTestTable 'PlanetSatellite'
EXEC AddViewToTestTable 'ViewStarConstellation'

EXEC RelateTestsAndViews 'LargePlanets', 'FastTestShouldBeShort'
EXEC RelateTestsAndViews 'PlanetSatellite', 'FastTestShouldBeShort'
EXEC RelateTestsAndViews 'ViewStarConstellation', 'FastTestShouldBeShort'

SELECT * FROM Views
SELECT * FROM TestViews

SELECT * FROM TestTables
SELECT * FROM TestRunTables
SELECT * FROM TestRuns
SELECT * FROM TestRunViews

PRINT SYSDATETIME()
EXEC RunTest 'FastTestShouldBeShort'
EXEC RunTest 'FirstTestSoWeCanNameItHelloWorld'


