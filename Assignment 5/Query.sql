USE AstronomicalObservatory
DROP TABLE Enrollment
DROP TABLE Students
DROP TABLE Course
CREATE TABLE Students
(                                          -- Ta
    StudentID    INT PRIMARY KEY IDENTITY, -- aid
    Name         VARCHAR(50),
    PhoneNumber  INT UNIQUE,               -- a2
    StudentGroup INT
)
CREATE TABLE Course
(                                             -- Tb
    CourseID        INT PRIMARY KEY IDENTITY, -- bid
    Title           VARCHAR(50),
    NumberOfCredits INT                       -- b2
)
CREATE TABLE Enrollment
(                                                     -- Tc
    Student      INT REFERENCES Students (StudentID), -- aid
    Course       INT REFERENCES Course (CourseID),    -- bid
    EnrollmentID INT PRIMARY KEY IDENTITY             -- cid
)

CREATE OR
ALTER PROCEDURE InsertStudent @seed INT
AS
BEGIN
    INSERT INTO Students(Name, PhoneNumber, StudentGroup)
    VALUES ('Student ' + CONVERT(VARCHAR(50), @seed),
            dbo.RandomInt(1000000, 10000000), dbo.RandomInt(1, 10))
END
GO

CREATE OR
ALTER PROCEDURE InsertCourse @seed INT
AS
BEGIN
    INSERT INTO Course(Title, NumberOfCredits)
    VALUES ('Course ' + CONVERT(VARCHAR(50), @seed), dbo.RandomInt(1, 10))
END
GO


CREATE OR
ALTER PROCEDURE InsertEnrollment @seed INT
AS
BEGIN
    DECLARE @studentID INT, @courseID INT, @added SMALLINT
    SELECT @added = 0
    WHILE @added = 0
        BEGIN
            SET @studentID = (SELECT TOP 1 StudentID FROM Students ORDER BY NEWID())
            SET @courseID = (SELECT TOP 1 CourseID FROM Course ORDER BY NEWID())

            IF EXISTS(SELECT *
                      FROM (
                               SELECT *
                               FROM Enrollment
                               WHERE Student = @studentID
                           ) as [CVFP*]
                      WHERE Course = @courseID)
                BEGIN
                    CONTINUE
                END
            INSERT INTO Enrollment(student, course)
            VALUES (@studentID, @courseID)

            SELECT @added = 1
        END
END
GO
EXEC PopulateTable 'Student', 2500
EXEC PopulateTable 'Course', 50000
EXEC PopulateTable 'Enrollment', 5000

DELETE Enrollment
DELETE Students
DELETE Course

-- a
-- Clustered index scan
SELECT *
FROM Students
ORDER BY StudentID

-- Clustered index seek
SELECT *
FROM Students
WHERE StudentID > 1500

-- Non clustered index scan
DROP INDEX IF EXISTS nonClusteredIndexStudent on Students
CREATE NONCLUSTERED INDEX nonClusteredIndexStudent ON Students (PhoneNumber)

SELECT PhoneNumber
FROM Students
ORDER BY PhoneNumber

-- Non clustered index seek
SELECT PhoneNumber
FROM Students
WHERE PhoneNumber > 7000000
  AND PhoneNumber < 8000000

-- Key Lookup
SELECT Name
FROM Students
WHERE PhoneNumber = 7000073

-- b
-- no index: 0.207912
SELECT *
FROM Course
WHERE NumberOfCredits = 5
-- non clustered index: 0.0240686
DROP INDEX IF EXISTS nonClusteredIndexCourse ON Course
CREATE NONCLUSTERED INDEX nonClusteredIndexCourse ON Course (NumberOfCredits) INCLUDE (Title)
SELECT *
FROM Course
WHERE NumberOfCredits = 5

-- c
CREATE OR ALTER VIEW SomeView AS
SELECT TOP 1000 S.Name as Student, C.Title as Course
FROM Students S
         INNER JOIN Enrollment E on S.StudentID = E.Student
         INNER JOIN Course C on C.CourseID = E.Course
WHERE S.PhoneNumber > 7000000
ORDER BY C.NumberOfCredits
GO

SELECT * FROM SomeView -- 0.587
DROP INDEX nonClusteredIndexStudent2 ON Students
DROP INDEX nonClusteredIndexEnrollment ON Enrollment

CREATE NONCLUSTERED INDEX nonClusteredIndexStudent2 ON Students(PhoneNumber) INCLUDE (StudentGroup, Name)
CREATE NONCLUSTERED INDEX nonClusteredIndexEnrollment ON Enrollment(EnrollmentID) INCLUDE (Student, Course)

SELECT * FROM SomeView -- 0.567