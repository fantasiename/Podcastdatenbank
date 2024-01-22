--Deklaration der Tabellen
    --Abonnement-Typ
    CREATE TABLE AbonnementTyp (
        Name VARCHAR2(50) PRIMARY KEY,
        Preis NUMBER(10,2) NOT NULL
    );  
    
    --Abonnement
    CREATE TABLE Abonnement (
        /*ToDo: Testen, funktioniert es mit default, wenn nicht nextval nutzen innerhalb des insert-Aufruf*/
        Abo_ID NUMBER DEFAULT Abonnement_id_seq.nextval PRIMARY KEY,
        Abonnementstyp_Name VARCHAR2(50),
        CONSTRAINT fk_Abo_AboTyp FOREIGN KEY (Abonnementstyp_Name) REFERENCES AbonnementTyp(Name)
    );
    
    --Nutzer
    CREATE TABLE Nutzer (
        Ntz_ID NUMBER DEFAULT Nutzer_id_seq.nextval PRIMARY KEY,
        Nutzername VARCHAR2(50) NOT NULL,
        E_Mail VARCHAR2(100) NOT NULL,
        Name VARCHAR2(100) NOT NULL,
        GebDatum DATE NOT NULL,
        Abo_ID NUMBER,
        CONSTRAINT fk_Nutzer_Abo FOREIGN KEY (Abo_ID) REFERENCES Abonnement(Abo_ID)
    );
    
    --Podcast
    CREATE TABLE Podcast (
        Pod_ID NUMBER DEFAULT Podcast_id_seq.nextval PRIMARY KEY,
        Name VARCHAR2(100) NOT NULL,
        Logo BLOB,
        Genre VARCHAR2(50),
        Beschreibung VARCHAR2(500)
    );
        
    --Kuenstler
    CREATE TABLE Kuenstler (
        Kue_ID NUMBER DEFAULT Kuenstler_id_seq.nextval PRIMARY KEY,
        Name VARCHAR2(100) NOT NULL
    );
    
    --Folge
    CREATE TABLE Folge (
        Fol_ID NUMBER DEFAULT Folge_id_seq.nextval PRIMARY KEY,
        Datum DATE NOT NULL,
        Audiospur VARCHAR2(250) NOT NULL,
        Titel VARCHAR2(250) NOT NULL,
        Bild BLOB,
        Beschreibung VARCHAR2(1000),
        Pod_ID NUMBER,
        CONSTRAINT fk_Folge_Podcast FOREIGN KEY (Pod_ID) REFERENCES Podcast(Pod_ID)
    );
    
    --Timestamp
    CREATE TABLE Timestamp (
        Tmp_ID NUMBER DEFAULT Timestamp_id_seq.nextval PRIMARY KEY,
        Beschreibung VARCHAR2(250),
        Fol_ID NUMBER,
        CONSTRAINT fk_Timestamp_Folge FOREIGN KEY (Fol_ID) REFERENCES Folge(Fol_ID)
    );
    
    --Werbetreibender
    CREATE TABLE Werbetreibender (
        Wrt_ID NUMBER DEFAULT Werbetreibender_id_seq.nextval PRIMARY KEY,
        EMail VARCHAR2(100) NOT NULL,
        Telefonnummer VARCHAR2(20),
        Firmenname VARCHAR2(100) NOT NULL,
        Anschrift VARCHAR2(250),
    );
    
    --Werbung
    CREATE TABLE Werbung (
        Wer_ID NUMBER DEFAULT Werbung_id_seq.nextval PRIMARY KEY,
        Thema VARCHAR2(250),
        Audiospur VARCHAR2(250),
        Wrt_ID NUMBER,
        CONSTRAINT fk_Werbung_Wrt FOREIGN KEY (Wrt_ID) REFERENCES Werbetreibender(Wrt_ID)
    );
    

--Deklaration Beziehungen mit Attributen
    --schreibt/Bewertung
    CREATE TABLE Bewertet (
        Ntz_ID NUMBER,
        Pod_ID NUMBER,
        Titel VARCHAR2(250) NOT NULL,
        Datum DATE NOT NULL,
        Sterne NUMBER(1) NOT NULL,
        Bewertungstext VARCHAR2(300),
        PRIMARY KEY (Ntz_ID, Pod_ID),
        CONSTRAINT fk_Bewertet_Nutzer FOREIGN KEY (Ntz_ID) REFERENCES Nutzer(Ntz_ID),
        CONSTRAINT fk_Bewertet_Podcast FOREIGN KEY (Pod_ID) REFERENCES Podcast(Pod_ID),
        CONSTRAINT Sterne CHECK (Sterne between 0 AND 5)
    );
    
    --hoert
    CREATE TABLE Hoert (
        Ntz_ID NUMBER,
        Fol_ID NUMBER,
        Zeit NUMBER(3), -- Speichert die Zeit in Minuten
        PRIMARY KEY (Ntz_ID, Fol_ID),
        CONSTRAINT fk_Hoert_Nutzer FOREIGN KEY (Ntz_ID) REFERENCES Nutzer(Ntz_ID),
        CONSTRAINT fk_Hoert_Folge FOREIGN KEY (Fol_ID) REFERENCES Folge(Fol_ID)
    );
    
--Deklaration weitere Beziehungen
    --abonniert
    CREATE TABLE Abonniert (
        Ntz_ID NUMBER,
        Pod_ID NUMBER,
        PRIMARY KEY (Ntz_ID, Pod_ID),
        CONSTRAINT fk_Abonniert_Nutzer FOREIGN KEY (Ntz_ID) REFERENCES Nutzer(Ntz_ID),
        CONSTRAINT fk_Abonniert_Podcast FOREIGN KEY (Pod_ID) REFERENCES Podcast(Pod_ID)
    );
    
    --hostet
    CREATE TABLE Hostet (
        Kue_ID NUMBER,
        Pod_ID NUMBER,
        PRIMARY KEY (Kue_ID, Pod_ID),
        CONSTRAINT fk_Hostet_Podcast FOREIGN KEY (Kue_ID) REFERENCES Kuenstler(Kue_ID),
        CONSTRAINT fk_Hostet_Podcast FOREIGN KEY (Pod_ID) REFERENCES Podcast(Pod_ID)
    );

    -- laeuft_in
    CREATE TABLE Laeuft_in (
        Fol_ID NUMBER,
        Wer_ID NUMBER,
        CONSTRAINT fk_Laeuft_in_Folge FOREIGN KEY (Fol_ID) REFERENCES Folge(Fol_ID),
        CONSTRAINT fk_Laeuft_in_Werbung FOREIGN KEY (Wer_ID) REFERENCES Werbung(Wer_ID),
        PRIMARY KEY (Fol_ID, Wer_ID)
    );

-----------------------------------------------------------------------
--Sequenzen fuer die Primaerschluessel

    create sequence Abonnement_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Nutzer_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Podcast_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Kuenstler_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Folge_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Timestamp_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Werbung_id_seq
    start with 1
    increment by 1
    nomaxvalue;

    create sequence Werbetreibender_id_seq
    start with 1
    increment by 1
    nomaxvalue;
    
-----------------------------------------------------------------------
--Datensaetze einfuegen
    --Abonnement-Typ
    INSERT INTO AbonnementTyp (Name, Preis) VALUES ('Einzelabo', 9.99);
    INSERT INTO AbonnementTyp (Name, Preis) VALUES ('Familienabo', 19.99);
    INSERT INTO AbonnementTyp (Name, Preis) VALUES ('Premiumabo', 14.99);
    INSERT INTO AbonnementTyp (Name, Preis) VALUES ('Studentenabo', 6.99);
    
    --Abonnement
    /*falls default nicht funktioniert*/
    -- INSERT INTO Abonnement (Abo_ID, Abonnementstyp_Name) VALUES (Abonnement_id_seq.nextval, 'Einzelabo');
    -- INSERT INTO Abonnement (Abo_ID, Abonnementstyp_Name) VALUES (Abonnement_id_seq.nextval,'Familienabo');
    -- INSERT INTO Abonnement (Abo_ID, Abonnementstyp_Name) VALUES (Abonnement_id_seq.nextval,'Premiumabo');
    -- INSERT INTO Abonnement (Abo_ID, Abonnementstyp_Name) VALUES (Abonnement_id_seq.nextval,'Studentenabo');
    INSERT INTO Abonnement (Abonnementstyp_Name) VALUES ('Einzelabo');
    INSERT INTO Abonnement (Abonnementstyp_Name) VALUES ('Familienabo');
    INSERT INTO Abonnement (Abonnementstyp_Name) VALUES ('Premiumabo');
    INSERT INTO Abonnement (Abonnementstyp_Name) VALUES ('Studentenabo');

    --Nutzer
    -- Fünf Nutzer einfügen
    INSERT INTO Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Alice123', 'alice@example.com', 'Alice Johnson', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 1);

    INSERT INTO Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Bob456', 'bob@example.com', 'Bob Smith', TO_DATE('1991-02-02', 'YYYY-MM-DD'), 2);

    INSERT INTO Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Charlie789', 'charlie@example.com', 'Charlie Johnson', TO_DATE('1992-03-03', 'YYYY-MM-DD'), 2);

    INSERT INTO Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('David101', 'david@example.com', 'David Miller', TO_DATE('1993-04-04', 'YYYY-MM-DD'), 4);

    INSERT INTO Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Eva202', 'eva@example.com', 'Eva Johnson', TO_DATE('1994-05-05', 'YYYY-MM-DD'), 2);

    
    --Podcast
    
    --Kuenstler
    
    --Folge
    
    --Timestamp
    
    --Werbung
    
    --Werbetreibender

    --schreibt
    
    --hoert

