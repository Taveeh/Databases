USE AstronomicalObservatory
GO
drop table Meteor
drop table CometVisibleFromPlanet
drop table Comet
drop table StarConstellation
drop table Constellation
drop table Star
drop table Satellite
drop table Planet
drop table SolarSystem
drop table Galaxy
drop table BlackHoles

CREATE TABLE BlackHoles
(
    ID               INT PRIMARY KEY,
    Name             VARCHAR(50),
    GalaxiesDevoured INT
)

CREATE TABLE Galaxy
(
    ID                    INT PRIMARY KEY,
    Name                  VARCHAR(50),
    Awesomeness           INT,
    BlackholeDevouredByID INT REFERENCES BlackHoles (ID)
)

-- There are many solar systems in a galaxy 1:n --
CREATE TABLE SolarSystem
(
    ID              INT PRIMARY KEY,
    GalaxyID        INT REFERENCES Galaxy (ID),
    Interestingness INT -- On a scale 1 - 10 how interesting it is, 10 < any galaxy awesomeness --
)

CREATE TABLE Constellation
(
    ID               INT PRIMARY KEY,
    Name             VARCHAR(50),
    ClarityFromEarth INT,
)

-- There is one star in a solar system 1:1 TBD how--
CREATE TABLE Star
(
    ID            INT PRIMARY KEY,
    Name          VARCHAR(50),
    Brightness    INT,
    SolarSystemID INT FOREIGN KEY REFERENCES SolarSystem (ID) UNIQUE
)

-- Many Stars in a constellation, a star can be in many constellations m:n --
CREATE TABLE StarConstellation
(
    StarID          INT REFERENCES Star (ID),
    ConstellationID INT REFERENCES Constellation (ID),
    Visible         INT,
    PRIMARY KEY (StarID, ConstellationID)
)


-- A solar system has many planets duh 1:n --
-- A planet has only 1 space dust around it 1:1 --
CREATE TABLE Planet
(
    ID            INT PRIMARY KEY,
    SolarSystemID INT REFERENCES SolarSystem (ID),
    Name          VARCHAR(50),
    Age           INT,
    Size          INT,
)


-- A Planet has several satellites, a satellite has only 1 planet, 1:n -- 
CREATE TABLE Satellite
(
    ID       INT PRIMARY KEY,
    PlanetID INT REFERENCES Planet (ID),
    Name     VARCHAR(50),
    Size     INT
)

-- A meteor can hit only one planet --
CREATE TABLE Meteor
(
    ID                INT PRIMARY KEY,
    Name              VARCHAR(50),
    Size              INT,
    WhenWillHitPlanet DATE,
    PlanetThatWillHit INT REFERENCES Planet (ID)
)

CREATE TABLE Comet
(
    ID   INT PRIMARY KEY,
    Name VARCHAR(50),
    Size INT
)

CREATE TABLE CometVisibleFromPlanet
(
    CometID             INT REFERENCES Comet (ID),
    PlanetID            INT REFERENCES Planet (ID),
    DistanceBetweenThem INT,
    PRIMARY KEY (CometID, PlanetID)
)

CREATE TABLE SpaceStation
(
    ID       INT PRIMARY KEY,
    PlanetID INT REFERENCES Planet (ID),
    Name     VARCHAR(50),
    Size     INT
)

CREATE TABLE Asteroid
(
    ID   INT PRIMARY KEY,
    Name VARCHAR(50),
    Size INT
)

CREATE TABLE AsteroidVisibleFromPlanet
(
    AsteroidID INT REFERENCES Asteroid (ID),
    PlanetID   INT REFERENCES Planet (ID),
    Distance   INT,
    PRIMARY KEY (AsteroidID, PlanetID)
)