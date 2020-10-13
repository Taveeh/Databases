USE AstronomicalObservatory
GO

drop table Meteor
drop table SpaceDust
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
		BlackHoleID INT PRIMARY KEY,
		BlackHoleName VARCHAR(50),
		GalaxiesDevoured INT
	)

CREATE TABLE Galaxy
	(
		GalaxyID INT PRIMARY KEY,
		GalaxyName VARCHAR(50),
		Awesomeness INT,
		BlackholeDevouredByID INT REFERENCES BlackHoles(BlackHoleID)
	)

 -- There are many solar systems in a galaxy 1:n -- 
CREATE TABLE SolarSystem
	(
		SolarSystemID INT PRIMARY KEY,
		GalaxyID INT REFERENCES Galaxy(GalaxyID),
		Interestingness INT -- On a scale 1 - 10 how interesting it is, 10 < any galaxy awesomeness --
	)

CREATE TABLE Constellation
	(
		ConstellationID INT PRIMARY KEY,
		ConstellationName VARCHAR(50),
		ClarityFromEarth INT,
	)

 -- There is one star in a solar system 1:1 TBD how-- 
CREATE TABLE Star
	(
		StarID INT PRIMARY KEY,
		StarName VARCHAR(50),
		Brightness INT,
		SolarSystemID INT FOREIGN KEY REFERENCES SolarSystem(SolarSystemID) UNIQUE
	)

-- Many Stars in a constellation, a star can be in many constellations m:n --
CREATE TABLE StarConstellation
	(
		StarID INT REFERENCES Star(StarID),
		ConstellationID INT REFERENCES Constellation(ConstellationID),
		Visible INT,
		PRIMARY KEY(StarID, ConstellationID)
	)


 -- A solar system has many planets duh 1:n --
 -- A planet has only 1 space dust around it 1:1 --
CREATE TABLE Planet
	(
		PlanetID INT PRIMARY KEY,
		SolarSystemID INT REFERENCES SolarSystem(SolarSystemID),
		PlanetName VARCHAR(50),
		Age INT,
		Size INT,
	)

CREATE TABLE SpaceDust
	(
		SpaceDustID INT PRIMARY KEY,
		SpaceDustQuality VARCHAR(15),
		NumberOdPeopleThatKnowAboutIt INT,
		PlanetID INT FOREIGN KEY REFERENCES Planet(PlanetID) UNIQUE
	)

-- A Planet has several satellites, a satellite has only 1 planet, 1:n -- 
CREATE TABLE Satellite
	(
		SatelliteID INT PRIMARY KEY,
		PlanetID INT REFERENCES Planet(PlanetID),
		SatelliteName VARCHAR(50),
		Size INT
	)
-- A meteor can hit only one planet --
CREATE TABLE Meteor
	(
		MeteorID INT PRIMARY KEY,
		MeteorName VARCHAR(50),
		WhenWillHitPlanet DATE,
		PlanetThatWillHit INT FOREIGN KEY REFERENCES Planet(PlanetID) UNIQUE
	)



