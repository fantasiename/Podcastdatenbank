--Deklaration der Tabellen
    --Abonnement-Typ
    CREATE TABLE AbonnementTyp (
        Name VARCHAR2(50) PRIMARY KEY,
        Preis NUMBER(10,2) NOT NULL
    );  
    
    --Abonnement
    CREATE TABLE Abonnement (
        Abo_ID NUMBER PRIMARY KEY,
        Abonnementstyp_Name VARCHAR2(50) REFERENCES AbonnementTyp(Name),
        CONSTRAINT fk_Abo_AboTyp FOREIGN KEY (Abonnementstyp_Name) REFERENCES AbonnementTyp(Name)
    );
    
    --Nutzer
    CREATE TABLE Nutzer (
        Ntz_ID NUMBER PRIMARY KEY,
        Nutzername VARCHAR2(50) NOT NULL,
        E_Mail VARCHAR2(100) NOT NULL,
        Name VARCHAR2(100) NOT NULL,
        GebDatum DATE NOT NULL,
        Abo_ID NUMBER REFERENCES Abonnement(Abo_ID),
        CONSTRAINT fk_Nutzer_Abo FOREIGN KEY (Abo_ID) REFERENCES Abonnement(Abo_ID)
    );
    
    --Podcast
    CREATE TABLE Podcast (
        Pod_ID NUMBER PRIMARY KEY,
        Name VARCHAR2(100) NOT NULL,
        Logo BLOB,
        Genre VARCHAR2(50),
        Beschreibung VARCHAR2(500)
    );
        
    --Kuenstler
    CREATE TABLE Kuenstler (
        Kue_ID NUMBER PRIMARY KEY,
        Name VARCHAR2(100) NOT NULL
    );
    
    --Folge
    
    --Timestamp
    
    --Werbung
    
    --Werbetreibender

--Deklaration Beziehungen mit Attributen
    --schreibt/Bewertung
    CREATE TABLE Bewertung (
        Ntz_ID NUMBER REFERENCES Nutzer(Ntz_ID),
        Pod_ID NUMBER REFERENCES Podcast(Pod_ID),
        Bewertungstext VARCHAR2(1000),
        Bewertung NUMBER(2, 1),
        Datum DATE,
        Titel VARCHAR2(100),
        PRIMARY KEY (Ntz_ID, Pod_ID)
    );
    
    --hoert
    
--Deklaration weitere Beziehungen
    --abonniert
    CREATE TABLE Abonniert (
        Ntz_ID NUMBER REFERENCES Nutzer(Ntz_ID),
        Pod_ID NUMBER REFERENCES Podcast(Pod_ID),
        PRIMARY KEY (Ntz_ID, Pod_ID)
    );
    
    --hostet
    CREATE TABLE Hostet (
        Kue_ID NUMBER REFERENCES K�nstler(Kue_ID),
        Pod_ID NUMBER REFERENCES Podcast(Pod_ID),
        PRIMARY KEY (Kue_ID, Pod_ID)
    );
    
-----------------------------------------------------------------------
--Datensaetze einfuegen
    --Abonnement-Typ
    
    --Abonnement
    
    --Nutzer
    
    --Podcast
    
    --Kuenstler
    
    --Folge
    
    --Timestamp
    
    --Werbung
    
    --Werbetreibender

    --schreibt
    
    --hoert

