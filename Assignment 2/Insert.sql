USE AstronomicalObservatory
GO

INSERT INTO BlackHoles(BlackHoleID, BlackHoleName, GalaxiesDevoured) VALUES
	(1, 'SomeAmazingName', 3),
	(2, 'AnotherAmazingName', 4),
	(3, 'BasicBlackHole', 0)

SELECT * FROM BlackHoles

INSERT INTO Galaxy(GalaxyID, GalaxyName, Awesomeness, BlackholeDevouredByID) VALUES
	(1, 'Milky Way', 100, 1),
	(2, 'Andromeda', 75, 1),
	(3, 'Cartwheel Galaxy', 12, 2)

SELECT * FROM Galaxy

INSERT INTO SolarSystem(SolarSystemID, GalaxyID, Interestingness) VALUES
	(1, 1, 42),
	(2, 1, 23),
	(3, 2, 12),
	(4, 3, 1)

SELECT * FROM SolarSystem

INSERT INTO Star(StarID, StarName, Brightness, SolarSystemID) VALUES
	(1, 'Sun', 15, 1),
	(2, 'Sirius', 16, 2),
	(3, 'Aurora', 20, 3),
	(4, 'Orion', 54, 4)

SELECT * FROM Star

-- Does not work --
INSERT INTO Star(StarID, StarName, Brightness, SolarSystemID) VALUES
	(5, 'Luna', 123, 1)

SELECT * FROM Star

ALTER TABLE Planet
ALTER COLUMN Age FLOAT

ALTER TABLE Planet
ALTER COLUMN Size FLOAT

-- From here it works --
INSERT INTO Planet(PlanetID, SolarSystemID, PlanetName, Age, Size) VALUES
	(1, 1, 'Earth', 4.54, 6.3),
	(2, 1, 'Mars', 4.6, 3.38),
	(3, 1, 'Jupiter', 4.5, 69.9),
	(4, 1, 'Saturn', 4.5, 58.23),
	(5, 1, 'Neptune', 4.5, 24.6),
	(6, 1, 'Pluto', 0.01, 1.18)

SELECT * FROM Planet


INSERT INTO Satellite(SatelliteID, PlanetID, SatelliteName, Size) VALUES
	(1, 1, 'Moon', 1737),
	(2, 2, 'Phobos', 22),
	(3, 2, 'Deimos', 13),
	(4, 3, 'Europa', 1560),
	(5, 3, 'Io', 1821)



ALTER TABLE Meteor
ADD DestroyedOnPlanet SMALLINT

ALTER TABLE Meteor
ADD DEFAULT(0) FOR DestroyedOnPlanet

INSERT INTO Meteor(MeteorID, MeteorName, WhenWillHitPlanet, PlanetThatWillHit) VALUES
	(1, 'Meteorite', '10-10-2020', 1)


SELECT * FROM Meteor