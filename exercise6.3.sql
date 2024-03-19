--1)
CREATE VIEW KundeTotal AS
SELECT Kunde.Etternavn, Kunde.Fornavn, SUM(PrisPrEnhet * Antall) AS Total
FROM Kunde INNER JOIN Ordre
    ON Kunde.KNr = Ordre.KNr
INNER JOIN Ordrelinje
    ON Ordre.OrdreNr = Ordrelinje.OrdreNr
GROUP BY Kunde.KNr;

SELECT * FROM KundeTotal
WHERE Total = (SELECT MAX(Total) FROM KundeTotal);

--2)
SELECT Vare.Betegnelse
FROM Vare LEFT OUTER JOIN Ordrelinje
    ON Vare.VNr = Ordrelinje.VNr
WHERE Ordrelinje.VNr IS NULL;

--3)
CREATE VIEW OrdrePrVare AS
SELECT Vare.VNr, Vare.Betegnelse, COUNT(OrdreNr) AS AntallOrdre
FROM Vare INNER JOIN Ordrelinje
    ON Vare.VNr = Ordrelinje.VNr
GROUP BY Vare.VNr;

SELECT * FROM OrdrePrVare
WHERE AntallOrdre = (SELECT MAX(AntallOrdre) FROM OrdrePrVare);

CREATE VIEW OrdrePrVareSep2019 AS
SELECT Vare.Vnr, Vare.Betegnelse, COUNT(Ordrelinje.OrdreNr) AS AntallOrdre
FROM Vare INNER JOIN Ordrelinje
    ON Vare.VNr = Ordrelinje.VNr
INNER JOIN Ordre
    ON Ordrelinje.OrdreNr = Ordre.OrdreNr
WHERE MONTH(OrdreDato) = 9
    AND YEAR(OrdreDato) = 2019
GROUP BY Vare.VNr;

SELECT * FROM OrdrePrVareSep2019
WHERE AntallOrdre = (SELECT MAX(AntallOrdre) FROM OrdrePrVareSep2019);

--5)
SELECT Kunde.Etternavn, Kunde.Fornavn
FROM Kunde INNER JOIN Ordre
    ON Kunde.KNr = Ordre.KNr
GROUP BY Kunde.KNr
HAVING COUNT(*) > 10;

--6)
CREATE VIEW OrdrePrKunde AS
SELECT Kunde.Knr, Kunde.Etternavn, Kunde.Fornavn, COUNT(Ordre.OrdreNr) AS Antall
FROM Kunde LEFT OUTER JOIN Ordre
    ON Kunde.KNr = Ordre.KNr
GROUP BY Kunde.Knr;

SELECT * FROM OrdrePrKunde
WHERE Antall = (SELECT MAX(Antall) FROM OrdrePrKunde);

--7)
SELECT * FROM OrdrePrKunde
WHERE Antall = (SELECT MIN(Antall) FROM OrdrePrKunde);

--8)
SELECT Kunde.KNr, Kunde.Etternavn, Kunde.Fornavn, Kunde.Adresse, Kunde.PostNr
FROM Kunde INNER JOIN Poststed
    ON Kunde.PostNr = Poststed.PostNr
WHERE Poststed.Poststed = 'HAMAR'
ORDER BY Kunde.Etternavn;

--9)
SELECT DISTINCT Poststed FROM Poststed
WHERE Poststed NOT IN (
    SELECT DISTINCT Poststed
    FROM Poststed INNER JOIN Kunde
        ON Poststed.PostNr = Kunde.PostNr
    UNION
    SELECT DISTINCT Poststed
    FROM Poststed INNER JOIN Ansatt
        ON Poststed.PostNr = Ansatt.PostNr
);

--10)
CREATE VIEW SalgPrDag AS
SELECT OrdreDato, SUM(PrisPrEnhet * Antall) AS Total, COUNT(*) AS AntallSalg
FROM Ordre INNER JOIN Ordrelinje
    ON Ordre.OrdreNr = Ordrelinje.OrdreNr
GROUP BY OrdreDato;

SELECT OrdreDato, AntallSalg
FROM SalgPrDag
WHERE Total = (SELECT MAX(Total) FROM SalgPrDag);


DROP VIEW KundeTotal;
DROP VIEW OrdrePrVare;
DROP VIEW OrdrePrVareSep2019;
DROP VIEW OrdrePrKunde;
DROP VIEW SalgPrDag;
