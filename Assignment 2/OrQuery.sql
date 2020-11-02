use AstronomicalObservatory

SELECT * FROM Constellation
SELECT * FROM Star
SELECT * FROM StarConstellation



-- Select the stars that are in Big Dipper and in Little Dipper
SELECT S.StarName
FROM Star S
WHERE StarID IN (
	SELECT SC.StarID
	FROM Star S1, Star S2, StarConstellation SC, StarConstellation SC2, Constellation C1, Constellation C2
	WHERE SC.StarID = S1.StarID AND SC.ConstellationID = C1.ConstellationID AND C1.ConstellationName = 'Big Dipper'
		AND SC.StarID = S2.StarID AND SC.ConstellationID = C2.ConstellationID AND C2.ConstellationName = 'Big Dipper'
)