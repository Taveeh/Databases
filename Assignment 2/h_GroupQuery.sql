USE AstronomicalObservatory
GO
SELECT *
FROM Galaxy

-- Select Galaxies that have awesomeness greater than the number of solar systems in it together with their total interestingness and average brightness
SELECT G.Name, G.Awesomeness, sum(SS.Interestingness) AS Interestingness, avg(S.Brightness) AS Brightness
FROM Galaxy G
         INNER JOIN SolarSystem SS ON SS.GalaxyID = G.ID
         INNER JOIN Star S ON S.SolarSystemID = SS.ID
GROUP BY G.ID, G.Name, G.Awesomeness
HAVING G.Awesomeness > (SELECT COUNT(*) FROM SolarSystem SS2 WHERE SS2.GalaxyID = G.ID)

-- Select the Galaxy with the greatest average interestingness and with awesomeness greater than the total interestingness of the galaxy
SELECT G2.Name, MAX(G2.InterestingessAvg) as Interestingness
FROM (
         SELECT G.Name as Name, avg(S.Interestingness) as InterestingessAvg
         FROM Galaxy G
                  INNER JOIN SolarSystem S ON S.GalaxyID = G.ID
         GROUP BY G.Name, G.ID, G.Awesomeness
         HAVING G.Awesomeness > (SELECT SUM(S2.Interestingness) FROM SolarSystem S2 WHERE S2.GalaxyID = G.ID)
     ) G2
GROUP BY G2.Name

-- Select the Planets and its size having at least 2 satellites with size > 13 or undefined
SELECT P.Name, P.Size
FROM Planet P
GROUP BY P.Size, P.Name, P.ID
HAVING 2 <= (SELECT COUNT(*)
             FROM Satellite S,
                  Planet P2
             WHERE P2.ID = S.PlanetID
               and P2.ID = P.ID
               and (S.Size > 13 or S.Size IS NULL))

SELECT * FROM Comet
SELECT * FROM CometVisibleFromPlanet

-- Select Planets having size > 5
SELECT P.Name, P.Size as Name from Planet P
GROUP BY P.Size, P.Name
HAVING P.Size > 5