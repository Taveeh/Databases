USE AstronomicalObservatory
GO

INSERT INTO BlackHoles(ID, Name, GalaxiesDevoured)
VALUES (1, 'SomeAmazingName', 3),
       (2, 'AnotherAmazingName', 4),
       (3, 'BasicBlackHole', 0),
       (4, 'Anakin Skywalker', 1)

SELECT *
FROM BlackHoles

INSERT INTO Galaxy(ID, Name, Awesomeness, BlackholeDevouredByID)
VALUES (1, 'Milky Way', 100, 1),
       (2, 'Andromeda', 75, 1),
       (3, 'Cartwheel Galaxy', 12, 2),
       (4, 'Outer Rim Territories', 100, 4)

SELECT *
FROM Galaxy

INSERT INTO SolarSystem(ID, GalaxyID, Interestingness)
VALUES (1, 1, 42),
       (2, 1, 23),
       (3, 2, 12),
       (4, 3, 1),
       (5, 2, 4),
       (6, 4, 100)


SELECT *
FROM SolarSystem

INSERT INTO Star(ID, Name, Brightness, SolarSystemID)
VALUES (1, 'Sun', 15, 1),
       (2, 'Sirius', 16, 2),
       (3, 'Aurora', 20, 3),
       (4, 'Orion', 54, 4),
       (5, 'Polaris', 32, 5),
       (6, 'Tatoo 1', 43, 6)

SELECT *
FROM Star

-- Does not work --
INSERT INTO Star(ID, Name, Brightness, SolarSystemID)
VALUES (5, 'Luna', 123, 1)

SELECT *
FROM Star

ALTER TABLE Planet
    ALTER COLUMN Age FLOAT

ALTER TABLE Planet
    ALTER COLUMN Size FLOAT

-- From here it works --
INSERT INTO Planet(ID, SolarSystemID, Name, Age, Size)
VALUES (1, 1, 'Earth', 4.54, 6.3),
       (2, 1, 'Mars', 4.6, 3.38),
       (3, 1, 'Jupiter', 4.5, 69.9),
       (4, 1, 'Saturn', 4.5, 58.23),
       (5, 1, 'Neptune', 4.5, 24.6),
       (6, 1, 'Pluto', 0.01, 1.18),
       (8, 2, 'PSR 1257+12', 2, 0.01),
       (7, 3, '47 Ursae Majoris b', NULL, 176.9),
       (9, 6, 'Tatooine', NULL, 10.4)

SELECT *
FROM Planet


INSERT INTO Satellite(ID, PlanetID, Name, Size)
VALUES (1, 1, 'Moon', 1737),
       (2, 2, 'Phobos', 22),
       (3, 2, 'Deimos', 13),
       (4, 3, 'Europa', 1560),
       (5, 3, 'Io', 1821),
       (6, 1, 'International Space Station', 109),
       (7, 9, 'Ghomrassen', NULL),
       (8, 9, 'Guermessa', NULL),
       (9, 9, 'Chenini', NULL)

INSERT INTO SpaceStation(ID, PlanetID, Name, Size)
VALUES (1, 1, 'International Space Station', 109),
       (2, 2, 'Marspost', 30)

SELECT *
FROM SpaceStation
SELECT *
FROM Satellite

ALTER TABLE Meteor
    ADD DestroyedOnPlanet SMALLINT

ALTER TABLE Meteor
    ADD DEFAULT (0) FOR DestroyedOnPlanet

INSERT INTO Meteor(ID, Name, WhenWillHitPlanet, PlanetThatWillHit)
VALUES (1, 'Meteorite', '10-10-2020', 1)


SELECT *
FROM Meteor

INSERT INTO Constellation(ID, Name, ClarityFromEarth)
VALUES (1, 'Big Dipper', 10),
       (2, 'Little Dipper', 9),
       (3, 'Cassiopeia', 7)

SELECT *
FROM Constellation
SELECT *
FROM Star

INSERT INTO StarConstellation(StarID, ConstellationID, Visible)
VALUES (5, 1, 1),
       (5, 3, 1),
       (4, 2, 0),
       (3, 3, 0)

INSERT INTO Comet(ID, Name, Size)
VALUES (1, 'Halley', 16),
       (2, 'Shoemaker Levy-9', 3),
       (3, 'Hyakutake', 570),
       (4, 'Heylin', 3)

INSERT INTO CometVisibleFromPlanet(CometID, PlanetID, DistanceBetweenThem)
VALUES (1, 1, 75),
       (2, 1, 100),
       (2, 9, 5464),
       (3, 9, 6372),
       (4, 1, 87)

