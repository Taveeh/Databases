UPDATE BlackHoles 
SET GalaxiesDevoured += 2
WHERE GalaxiesDevoured <= 1

SELECT * FROM BlackHoles

UPDATE Galaxy 
SET Awesomeness -= 15
WHERE BlackholeDevouredByID BETWEEN 2 AND 3

SELECT * FROM Galaxy

UPDATE Meteor
SET Meteor.DestroyedOnPlanet = 1
WHERE  DATEDIFF(DAYOFYEAR,'10-13-2021', Meteor.WhenWillHitPlanet)  <= 0

SELECT * FROM Meteor

