SELECT SCORE(42) as score, titel FROM Podcast
WHERE CONTAINS ( (Name, Beschreibung), 'film', 42 ) >= 0 /* >= nur für Testzwecke */
ORDER BY score DESC;