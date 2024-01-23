drop table mmdb_abonnement;
drop table mmdb_abonnementtyp;
drop table mmdb_abonniert;
drop table mmdb_bewertet; 
drop table mmdb_hoert;
drop table mmdb_kuenstler;
drop table mmdb_nutzer;
drop table mmdb_podcast;
drop table mmdb_folge;
drop table mmdb_timestamp;
drop table mmdb_laeuft_in;
drop table mmdb_werbetreibender;
drop table mmdb_hostet;
drop table mmdb_werbung;

drop sequence Abonnement_id_seq;
drop sequence Nutzer_id_seq;
drop sequence Podcast_id_seq;
drop sequence Kuenstler_id_seq;
drop sequence Folge_id_seq;
drop sequence Timestamp_id_seq;
drop sequence Werbung_id_seq;
drop sequence Werbetreibender_id_seq;

begin
ctx_ddl.DROP_PREFERENCE('mylexer');
end;
/
drop Index mmdb_podcast_index;

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
--Deklaration der Tabellen
    --Abonnement-Typ
    CREATE TABLE mmdb_AbonnementTyp (
        Name VARCHAR2(50) PRIMARY KEY,
        Preis NUMBER(10,2) NOT NULL
    );  
    
    --Abonnement
    CREATE TABLE mmdb_Abonnement (
        Abo_ID NUMBER DEFAULT Abonnement_id_seq.nextval PRIMARY KEY,
        Abonnementstyp_Name VARCHAR2(50),
        CONSTRAINT fk_Abo_AboTyp FOREIGN KEY (Abonnementstyp_Name) REFERENCES mmdb_AbonnementTyp(Name)
    );

    --Nutzer
    CREATE TABLE mmdb_Nutzer (
        Ntz_ID NUMBER DEFAULT Nutzer_id_seq.nextval PRIMARY KEY,
        Nutzername VARCHAR2(50) NOT NULL,
        E_Mail VARCHAR2(100) NOT NULL,
        Name VARCHAR2(100) NOT NULL,
        GebDatum DATE NOT NULL,
        Abo_ID NUMBER,
        CONSTRAINT fk_Nutzer_Abo FOREIGN KEY (Abo_ID) REFERENCES mmdb_Abonnement(Abo_ID)
    );
    
    --Podcast
    CREATE TABLE mmdb_Podcast (
        Pod_ID NUMBER DEFAULT Podcast_id_seq.nextval PRIMARY KEY,
        Name VARCHAR2(100) NOT NULL,
        Logo BLOB,
        Genre VARCHAR2(50),
        Beschreibung VARCHAR2(2000)
    );
        
    --Kuenstler
    CREATE TABLE mmdb_Kuenstler (
        Kue_ID NUMBER DEFAULT Kuenstler_id_seq.nextval PRIMARY KEY,
        Name VARCHAR2(100) NOT NULL
    );
    
    /*
    --Folge
    CREATE TABLE mmdb_Folge (
        Fol_ID NUMBER DEFAULT Folge_id_seq.nextval PRIMARY KEY,
        Datum DATE NOT NULL,
        Audiospur BLOB NOT NULL,
        Titel VARCHAR2(250) NOT NULL,
        Bild BLOB,
        Beschreibung VARCHAR2(1000),
        Pod_ID NUMBER,
        CONSTRAINT fk_Folge_Podcast FOREIGN KEY (Pod_ID) REFERENCES mmdb_Podcast(Pod_ID)
    );
    */
    
    --Folge
    CREATE TABLE mmdb_Folge (
        Fol_ID NUMBER DEFAULT Folge_id_seq.nextval PRIMARY KEY,
        Datum DATE NOT NULL,
        Audiospur BLOB,
        Titel VARCHAR2(250) NOT NULL,
        Bild BLOB,
        Beschreibung VARCHAR2(2000),
        Pod_ID NUMBER,
        CONSTRAINT fk_Folge_Podcast FOREIGN KEY (Pod_ID) REFERENCES mmdb_Podcast(Pod_ID)
    );
    
    --Timestamp
    CREATE TABLE mmdb_Timestamp (
        Tmp_ID NUMBER DEFAULT Timestamp_id_seq.nextval PRIMARY KEY,
        Beschreibung VARCHAR2(250),
        timestamp TIMESTAMP,
        Fol_ID NUMBER,
        CONSTRAINT fk_Timestamp_Folge FOREIGN KEY (Fol_ID) REFERENCES mmdb_Folge(Fol_ID)
    );
    
    --Werbetreibender
    CREATE TABLE mmdb_Werbetreibender (
        Wrt_ID NUMBER DEFAULT Werbetreibender_id_seq.nextval PRIMARY KEY,
        EMail VARCHAR2(100) NOT NULL,
        Telefonnummer VARCHAR2(20),
        Firmenname VARCHAR2(100) NOT NULL,
        Anschrift VARCHAR2(250)
    );

    --Werbung
    CREATE TABLE mmdb_Werbung (
        Wer_ID NUMBER DEFAULT Werbung_id_seq.nextval PRIMARY KEY,
        Thema VARCHAR2(250),
        Audiospur BLOB,
        Wrt_ID NUMBER,
        CONSTRAINT fk_Werbung_Wrt FOREIGN KEY (Wrt_ID) REFERENCES mmdb_Werbetreibender(Wrt_ID)
    );
    

--Deklaration Beziehungen mit Attributen
    --schreibt/Bewertung
    CREATE TABLE mmdb_Bewertet (
        Ntz_ID NUMBER,
        Pod_ID NUMBER,
        Titel VARCHAR2(250) NOT NULL,
        Datum DATE NOT NULL,
        Sterne NUMBER(1) NOT NULL,
        Bewertungstext VARCHAR2(300),
        PRIMARY KEY (Ntz_ID, Pod_ID),
        CONSTRAINT fk_Bewertet_Nutzer FOREIGN KEY (Ntz_ID) REFERENCES mmdb_Nutzer(Ntz_ID),
        CONSTRAINT fk_Bewertet_Podcast FOREIGN KEY (Pod_ID) REFERENCES mmdb_Podcast(Pod_ID),
        CONSTRAINT Sterne CHECK (Sterne between 0 AND 5)
    );
    
    --hoert
    CREATE TABLE mmdb_Hoert (
        Ntz_ID NUMBER,
        Fol_ID NUMBER,
        Zeit NUMBER(3), -- Speichert die Zeit in Minuten
        PRIMARY KEY (Ntz_ID, Fol_ID),
        CONSTRAINT fk_Hoert_Nutzer FOREIGN KEY (Ntz_ID) REFERENCES mmdb_Nutzer(Ntz_ID),
        CONSTRAINT fk_Hoert_Folge FOREIGN KEY (Fol_ID) REFERENCES mmdb_Folge(Fol_ID)
    );
    
--Deklaration weitere Beziehungen
    --abonniert
    CREATE TABLE mmdb_Abonniert (
        Ntz_ID NUMBER,
        Pod_ID NUMBER,
        PRIMARY KEY (Ntz_ID, Pod_ID),
        CONSTRAINT fk_Abonniert_Nutzer FOREIGN KEY (Ntz_ID) REFERENCES mmdb_Nutzer(Ntz_ID),
        CONSTRAINT fk_Abonniert_Podcast FOREIGN KEY (Pod_ID) REFERENCES mmdb_Podcast(Pod_ID)
    );
    
    --hostet
    CREATE TABLE mmdb_Hostet (
        Kue_ID NUMBER,
        Pod_ID NUMBER,
        PRIMARY KEY (Kue_ID, Pod_ID),
        CONSTRAINT fk_Hostet_Kuenstler FOREIGN KEY (Kue_ID) REFERENCES mmdb_Kuenstler(Kue_ID),
        CONSTRAINT fk_Hostet_Podcast FOREIGN KEY (Pod_ID) REFERENCES mmdb_Podcast(Pod_ID)
    );

    -- laeuft_in
    CREATE TABLE mmdb_Laeuft_in (
        Fol_ID NUMBER,
        Wer_ID NUMBER,
        CONSTRAINT fk_Laeuft_in_Folge FOREIGN KEY (Fol_ID) REFERENCES mmdb_Folge(Fol_ID),
        CONSTRAINT fk_Laeuft_in_Werbung FOREIGN KEY (Wer_ID) REFERENCES mmdb_Werbung(Wer_ID),
        PRIMARY KEY (Fol_ID, Wer_ID)
    );
    
-----------------------------------------------------------------------
--Datensaetze einfuegen
    --Abonnement-Typ
    INSERT INTO mmdb_AbonnementTyp (Name, Preis) VALUES ('Einzelabo', 9.99);
    INSERT INTO mmdb_AbonnementTyp (Name, Preis) VALUES ('Familienabo', 19.99);
    INSERT INTO mmdb_AbonnementTyp (Name, Preis) VALUES ('Premiumabo', 14.99);
    INSERT INTO mmdb_AbonnementTyp (Name, Preis) VALUES ('Studentenabo', 6.99);
    
    --Abonnement
    INSERT INTO mmdb_Abonnement (Abonnementstyp_Name) VALUES ('Einzelabo');
    INSERT INTO mmdb_Abonnement (Abonnementstyp_Name) VALUES ('Familienabo');
    INSERT INTO mmdb_Abonnement (Abonnementstyp_Name) VALUES ('Premiumabo');
    INSERT INTO mmdb_Abonnement (Abonnementstyp_Name) VALUES ('Studentenabo');

    --Nutzer
    INSERT INTO mmdb_Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Ali', 'alice@gmail.com', 'Alice Johnson', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 1);

    INSERT INTO mmdb_Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('BobRockt', 'bob@gmail.com', 'Bob Smith', TO_DATE('1991-02-02', 'YYYY-MM-DD'), 2);

    INSERT INTO mmdb_Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Charlie_J', 'charlie@web.de', 'Charlie Johnson', TO_DATE('1992-03-03', 'YYYY-MM-DD'), 2);

    INSERT INTO mmdb_Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('Schlumpf157', 'david@t-online.de', 'David Miller', TO_DATE('1993-04-04', 'YYYY-MM-DD'), 4);

    INSERT INTO mmdb_Nutzer (Nutzername, E_Mail, Name, GebDatum, Abo_ID) 
    VALUES ('EJohnson', 'eva@freenet.de', 'Eva Johnson', TO_DATE('1994-05-05', 'YYYY-MM-DD'), 2);

     --Podcast
    INSERT INTO mmdb_Podcast (Name, Logo, Genre, Beschreibung)
    VALUES ('Cinema Strikes Back', EMPTY_BLOB(), 'TV und Film', 
        'Cinema Strikes Back ist das Paradies f�r Nerds, in dem man sich auf informative und unterhaltsame Weise mit Filmen, Comics, Serien, Videospielen und B�chern besch�ftigen kann.');
        
    INSERT INTO mmdb_Podcast (Name, Logo, Genre, Beschreibung)
    VALUES ('Y-Kollektiv � Der Podcast', EMPTY_BLOB(), 'Journalismus',
        'Wir zeigen die Welt, wie wir sie erleben � und nicht anders. Wir sind Journalistinnen und Journalisten mit Haltung, nicht immer unvoreingenommen, aber immer ehrlich und authentisch. F�r euch gehen wir an die Grenzen und dar�ber hinaus. Wir tauchen in unterschiedliche Mikrokosmen ein, unsere Recherche machen wir transparent. Jede Woche');

    INSERT INTO mmdb_Podcast (Name, Logo, Genre, Beschreibung)
    VALUES ('Mordlust', EMPTY_BLOB(), 'True Crime', 
        'Im True Crime-Podcast �Mordlust - Verbrechen und ihre Hintergr�nde� sprechen die Journalistinnen Paulina Krasa und Laura Wohlers �ber wahre Kriminalf�lle aus Deutschland. In jeder Folge widmen sich die Reporterinnen zwei F�llen zu einem spezifischen Thema und diskutieren strafrechtliche und psychologische Aspekte. Dabei gehen sie Fragen nach wie: Was sind die Schwierigkeiten bei einem Indizienprozess? Wie �berredet man Unbeteiligte zu einem falschen Gest�ndnis? Und wie h�tte die Tat wom�glich verhindert werden k�nnen? Mord aus Habgier, niedrigen Beweggr�nden oder Mordlust - f�r die meisten Verbrechen gibt es eine Erkl�rung und nach der suchen die beiden. Au�erdem diskutieren die Freundinnen �ber beliebte True Crime-Formate, begleiten Gerichtsprozesse und f�hren Interviews mit Expert:innen. Bei �Mordlust� wird die Stimmung zwischendurch auch mal aufgelockert - das ist aber nicht despektierlich gemeint.');
    
    INSERT INTO mmdb_Podcast (Name, Logo, Genre, Beschreibung)
    VALUES ('50 + 2 - Der Fussballpodcast', EMPTY_BLOB(), 'Sport und Freizeit - Fu�ball',
        'Der w�chentliche Fussball-Podcast mit Niklas Levinsohn und Nico Heymer');

    --Kuenstler
    INSERT INTO mmdb_Kuenstler (Name) VALUES ('Alper Turfan');
    INSERT INTO mmdb_Kuenstler (Name) VALUES ('Francine Fester');
    INSERT INTO mmdb_Kuenstler (Name) VALUES ('Paulina Krasa');
    INSERT INTO mmdb_Kuenstler (Name) VALUES ('Laura Wohlers');
    INSERT INTO mmdb_Kuenstler (Name) VALUES ('Nico Heymer');
    INSERT INTO mmdb_Kuenstler (Name) VALUES ('Niklas Levinsohn');
    
    --Folge
    INSERT INTO mmdb_Folge (Datum, Audiospur, Titel, Beschreibung, Pod_ID)
    VALUES (TO_DATE('2023-12-31', 'YYYY-MM-DD'),
            EMPTY_BLOB(),
            'Die 30 schlechtesten Filme und Serien des Jahres 2023',
            'Zum Abschluss des Jahres pr�sentieren wir euch heute die 30 schlechtesten Filme und Serien und gr��ten Entt�uschungen des Jahres 2023. Dieses Jahr gab es wirklich einiges an Schund auf dem Film- und Serienmarkt. Daher haben Alper, Marius, Lenny und Xenia sich die M�he gemacht, die wirklich gr�sslichsten Werke des Jahres zusammenzutragen. Viel Spa� mit dem letzten Podcast des Jahres!',
            1);
    
    INSERT INTO mmdb_Folge (Datum, Audiospur, Titel, Beschreibung, Pod_ID)
    VALUES (TO_DATE('2024-01-23', 'YYYY-MM-DD'),
            EMPTY_BLOB(),
            'Golden Globes und mehr', 
            'Die Award Season 2024 hat begonnen! Wie jedes Jahr machen die Golden Globes den Anfang. Dabei haben vor allem OPPENHEIMER und POOR THINGS ordentlich abger�umt. Was es noch so an interessanten Auszeichnungen (und Outfits!) gab, das bequatschen Lenny, Jonas und Xenia im heutigen Podcast.',
            1);
    
    INSERT INTO mmdb_Folge (Datum, Audiospur, Titel, Beschreibung, Pod_ID)
    VALUES (TO_DATE('2024-01-30', 'YYYY-MM-DD'),
            EMPTY_BLOB(),
            'Das Jahr 2024 ist angebrochen und damit auch ein weiteres Jahr unseres Podcasts!', 
            'Alper, Lenny und Xenia besprechen dabei heute einige hervorragende Serien und Filme, die sie zwischen den Jahren gesehen haben. Nicht nur die ganze Welt redet gerade �ber SALTBURN mit Barry Keoghan und Jacob Elordi, sondern nat�rlich auch Cinema Strikes Back! Was den Film so besonders macht und wie sie ihn fanden, erz�hlen die drei im heutigen Podcast. Alper hat au�erdem ATTACK ON TITAN begonnen und Xenia NARUTO! Neben Weihnachtsfilmen, lustigen Abenteuerfilmen und grenzwertigen Entt�uschungen (REBEL MOON!) gibt es diese Woche au�erdem noch einige spannende Starts! Viel Spa� mit unserem ersten Podcast im brandneuen Jahr 2024!',
            1);
        
    INSERT INTO mmdb_Folge (Datum, Audiospur, Titel, Beschreibung, Pod_ID)
    VALUES (TO_DATE('2022-08-25', 'YYYY-MM-DD'),
            EMPTY_BLOB(),
            'Kryonik: Eingefroren f�r ein Leben nach dem Tod', 
            'Sie lassen sich in knapp -200 Grad kaltem, fl�ssigen Stickstoff auf unbestimmte Zeit konservieren. Ihre Hoffnung: Dass die Wissenschaft in ein paar Jahrzehnten oder Jahrhunderten soweit ist, sie wiederzubeleben. Kryokonservierung hei�t das Verfahren, an das Menschen auch in Deutschland glauben. Y-Reporterin Francine Fester hat Veronika getroffen, die ihren K�rper nach ihrem Tod einfrieren lassen m�chte. Wie gro� ist die Chance, dass sie eines Tages wiederbelebt wird? Oder ist Kryonik einfach nur Geldmacherei?',
            2);
        
    INSERT INTO mmdb_Folge (Datum, Audiospur, Titel, Beschreibung, Pod_ID)
    VALUES (TO_DATE('2022-08-25', 'YYYY-MM-DD'),
            EMPTY_BLOB(),
            '#136 Pandoras Erbe', 
            'Triggerwarnung: In der gesamten Folge geht es um sexualisierte Gewalt. Im zweiten Fall geht es zudem um Gewalt gegen Kinder.   Liebevoll, f�rsorglich, aber auch zickig und handwerklich sowie mathematisch v�llig unbegabt. Vorurteile gegen�ber Frauen gibt es viele. Eines, das dabei immer �ber allem schwebt: Frauen w�ren das schw�chere Geschlecht. Woher die M�r kommt und warum sie lebensgef�hrlich ist, darum geht es in dieser Folge von �Mordlust � Verbrechen und ihre Hintergr�nde�. Lorena und Tilda wollen Fasching feiern. Mit guter Laune im Gep�ck machen sie sich auf zu Severin, ihrem guten Freund, der sie zu sich eingeladen hat. Der 53-J�hrige hat Drinks vorbereitet, in denen bunte Schirmchen stecken. Doch statt Fasching hat Severin andere Pl�ne im Kopf, sowie ein dunkles Geheimnis, das heute ans Tageslicht kommen wird. Als Veronikas Vater seine Tochter von einer Freundin abholen m�chte, ist sie nicht da. Von der Zw�lfj�hrigen fehlt jede Spur. Der einzige Anhaltspunkt ist eine WhatsApp-Nachricht, die Vroni am Vorabend selbst verfasst und an ihre Freundinnen geschickt hat: �Da ist das Auto, hab voll Angst, das verfolgt mich.� In dieser Episode geht es um ein Thema, das bereits in vielen unserer F�lle eine Rolle gespielt hat, aber zu oft nicht benannt wird: Misogynie � der Hass bzw. die Ablehnung von Frauen und allem Weiblichen. Wie das mit Partnerschaftsgewalt, Sexualdelikten und digitalen Attacken � aber auch mit Adam und Eva, Pandoras B�chse und Aristoteles zusammenh�ngt � erfahrt ihr in der Folge. Expertin in dieser Folge ist Christina Clemm, Fachanw�ltin f�r Familien- und Strafrecht sowie Autorin.',
            3);
    
    --Timestamp
    --Folge 1 CSB
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Anmoderation', '00:00:00', 1);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Inhalt', '00:03:38', 1);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Die Golden Globes wurden verliehen!', '00:04:54', 1);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Stranger Things Staffel 5 - und anderer Wahnsinn', '00:35:26', 1);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Newsticker', '00:45:59', 1);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Starts der Woche', '00:51:48', 1);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Abmoderation', '01:21:55', 1);
    --Folge 2 CSB
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Anmoderation', '00:00:00', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Inhalt', '00:03:23', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Saltburn', '00:07:27', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Attack on Titan', '00:17:56', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Naruto', '00:24:49', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('The Holdovers', '00:29:32', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('The Iron Claw', '00:40:14', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Alpers Filmklassiker', '00:46:21', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('The Boy Who Lived', '00:54:48', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('The Batman', '00:58:41', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Merry Little Batman', '01:00:41', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Notting Hill', '01:03:33', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Dungeons und Dragons: Ehre unter Dieben', '01:06:47', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Rebel Moon', '01:09:32', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Starts der Woche', '01:12:00', 2);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Abmoderation', '01:34:26', 2);
    
    --Folge 3 CSB
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Anmoderation', '00:00:00', 3);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Rebel Moon � Teil 1: Kind des Feuers', '00:05:55', 3);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('The Idol', '00:18:19', 3);
        
        INSERT INTO mmdb_Timestamp (Beschreibung, timestamp, Fol_ID)
        VALUES ('Zu oft schon besprochen und Honorable Mentions', '02:22:31', 3);
    
    --Werbetreibender 
    INSERT INTO mmdb_Werbetreibender (EMail, Telefonnummer, Firmenname, Anschrift)
    VALUES ('yummysnacks@info.com', NULL, 'Crunch Snacks Ltd.', 'Goerdelerring 9, 04109 Leipzig');
    
    INSERT INTO mmdb_Werbetreibender (EMail, Telefonnummer, Firmenname, Anschrift)
    VALUES ('dynamic.software_solutions@info.com', '111222333', 'Dynamic Software Solutions', 'Friedrichstra�e 112, 10969 Berlin');

    INSERT INTO mmdb_Werbetreibender (EMail, Telefonnummer, Firmenname, Anschrift)
    VALUES ('home_improvement_center@info.com', '555666777', 'Home Improvement Center', 'Heimwerkerweg 77, Bauhausen');

    INSERT INTO mmdb_Werbetreibender (EMail, Telefonnummer, Firmenname, Anschrift)
    VALUES ('fitpro@dynamics.com', '987654321', 'FitPro Dynamics', 'Elbchaussee 56, 22765 Hamburg');

    --Werbung
    INSERT INTO mmdb_Werbung (Thema, Audiospur, Wrt_ID)
    VALUES ('Vegane Snacks', EMPTY_BLOB(), 1);
    
    INSERT INTO mmdb_Werbung (Thema, Audiospur, Wrt_ID)
    VALUES ('New KI Tool', EMPTY_BLOB(), 2);
    
    INSERT INTO mmdb_Werbung (Thema, Audiospur, Wrt_ID)
    VALUES ('Gartenger�te im Sale', EMPTY_BLOB(), 3);
    
    INSERT INTO mmdb_Werbung (Thema, Audiospur, Wrt_ID)
    VALUES ('Fit in 2024! Programmstart', EMPTY_BLOB(), 4);
    
    --schreibt/Bewertung
    -- Positive Bewertungen
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (1, 1, 'Mordlust macht lust', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 5, 'Toller Podcast! Interessante Kriminalf�lle.');
    
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (2, 2, 'Cinema Strikes Back', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 4, 'Gute Film- und Serienbesprechungen.');
    
    -- Negative Bewertungen
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (3, 3, 'Y so boring', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 1, 'Uninteressante Themen.');
    
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (4, 4, 'Cinema Strikes Back', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 2, 'Schlechte Filmauswahl.');
    
    -- Ausgeglichene Bewertungen
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (5, 1, 'Angsteinfl��end', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 3, 'Gut, aber manchmal zu gruselig.');
    
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (1, 2, 'Cinema Strikes Back', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 4, 'Informativ und unterhaltsam.');
    
    -- Weitere Bewertungen
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (2, 3, 'G�hn!!!!1!', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 1, 'Langweilige Reportagen.');
    
    INSERT INTO mmdb_Bewertet (Ntz_ID, Pod_ID, Titel, Datum, Sterne, Bewertungstext)
    VALUES (3, 4, 'Super', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 5, 'Unglaublich lustig und unterhaltsam. Warum gibt es aber keine Folgen?');

    --hoert
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (1, 1, 1);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (2, 1, 25);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (3, 1, 50);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (5, 1, 10);
    
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (2, 2, 45);
    
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (3, 3, 15);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (2, 3, 59);
    
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (4, 4, 60);
    
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (5, 5, 20);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (1, 5, 55);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (2, 5, 30);
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (3, 5, 20);   
    INSERT INTO mmdb_Hoert (Ntz_ID, Fol_ID, Zeit) VALUES (4, 5, 45);

    --abonniert
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (1, 1);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (2, 1);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (3, 1);
    
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (1, 2);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (4, 2);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (5, 2);
    
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (2, 3);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (3, 3);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (5, 3);
    
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (1, 4);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (3, 4);
    INSERT INTO mmdb_Abonniert (NTZ_ID, Pod_ID) VALUES (4, 4);
    
    --hostet
    INSERT INTO mmdb_Hostet (Kue_ID, Pod_ID)
    VALUES (1, 1);
    
    INSERT INTO mmdb_Hostet (Kue_ID, Pod_ID)
    VALUES (2, 2);
    
    INSERT INTO mmdb_Hostet (Kue_ID, Pod_ID)
    VALUES (3, 3);
    
    INSERT INTO mmdb_Hostet (Kue_ID, Pod_ID)
    VALUES (4, 3);
    
    INSERT INTO mmdb_Hostet (Kue_ID, Pod_ID)
    VALUES (5, 4);
    
    INSERT INTO mmdb_Hostet (Kue_ID, Pod_ID)
    VALUES (6, 4);

    --laeuft_in
    INSERT INTO mmdb_Laeuft_In (Fol_ID, Wer_ID)
    VALUES (1, 4);
    INSERT INTO mmdb_Laeuft_In (Fol_ID, Wer_ID)
    VALUES (3, 2);
    INSERT INTO mmdb_Laeuft_In (Fol_ID, Wer_ID)
    VALUES (2, 1);
    INSERT INTO mmdb_Laeuft_In (Fol_ID, Wer_ID)
    VALUES (4, 3);
    INSERT INTO mmdb_Laeuft_In (Fol_ID, Wer_ID)
    VALUES (5, 3);
    INSERT INTO mmdb_Laeuft_In (Fol_ID, Wer_ID)
    VALUES (3, 3);
    
-----------------------------------------------------------------------
--Index
    --Basic Lexer
    --es sollte schon einen lexer geben, den man benutzen kann
    /*
    begin
        ctx_ddl.create_preference('mmdb_lexer', 'BASIC_LEXER' );
        ctx_ddl.set_attribute ( 'mmdb_lexer', 'mixed_case', 'NO' );
    end;
    /*/

    --Storage Preference
    begin
        ctx_ddl.create_preference('mmdb_store', 'BASIC_STORAGE');
        ctx_ddl.set_attribute('mmdb_store', 'I_TABLE_CLAUSE', 'tablespace INDX');
        ctx_ddl.set_attribute('mmdb_store', 'K_TABLE_CLAUSE', 'tablespace INDX');
        ctx_ddl.set_attribute('mmdb_store', 'R_TABLE_CLAUSE', 'tablespace INDX');
        ctx_ddl.set_attribute('mmdb_store', 'N_TABLE_CLAUSE', 'tablespace INDX');
        ctx_ddl.set_attribute('mmdb_store', 'I_INDEX_CLAUSE', 'tablespace INDX');
        ctx_ddl.set_attribute('mmdb_store', 'P_TABLE_CLAUSE', 'tablespace INDX');
    end;
    /

    --Index fuer Podcast
    CREATE INDEX mmdb_podcast_index ON mmdb_Podcast ( Titel, Beschreibung )
    INDEXTYPE IS CTXSYS.CONTEXT
    PARAMETERS ( 'LEXER mmdb_lexer STORAGE mmdb_store SYNC (ON COMMIT)' );



    --TEST
    /* UPDATE mmdb_Werbung
    SET Audiospur = BFILENAME('C:\Users\lstaengl\Documents\Sounds', 'zirpen.wav');
    
    create directory sounds_werbung as 'C:\Users\lstaengl\Documents\Sounds';
    
    INSERT INTO mmdb_Werbung (Thema, Audiospur, Wrt_ID)
    VALUES ('Thema1', EMPTY_BLOB(), 2);
    
    declare
        f_lob BFILE := BFILENAME('C:\Users\lstaengl\Documents\Sounds', 'zirpen.wav');
        b_lob BLOB;
        length INTEGER;
    begin
        INSERT INTO mmdb_Werbung (Thema, Audiospur, Wrt_ID)
        VALUES ('Thema1', EMPTY_BLOB(), 2);
        
        select audiospur into b_lob from mmdb_werbung where wer_id=10 for update;
        
        dbms_lob.open(f_lob, dbms_lob.file_readonly);
        dbms_lob.open(b_lob, dbms_lob.lob_readwrite);
        
        dbms_lob.loadfromfile(b_lob, f_lob, dbms_lob.getlength(f_lob));
        
        dbms_lob.close(b_lob);
        dbms_lob.close(f_lob);
        commit;
        
    end;*/
    
    
/*
    
--------------------------------------------------------------------
CREATE OR REPLACE DIRECTORY audio_files_dir AS 'C:\Users\fromeis';
----------------------------------------------------------------------
DECLARE
    mp3_blob BLOB;
     mp3_file_path VARCHAR2(255) := 'CSB-1.mp3';
    mp3_bfile BFILE;
BEGIN
    -- Erstelle ein tempor�res BLOB
    DBMS_LOB.CREATETEMPORARY(mp3_blob, TRUE);

    -- Erstelle einen BFILE
    mp3_bfile := BFILENAME('N:\', 'CSB-1.mp3');

    -- �ffne das tempor�re BLOB zum Schreiben
    DBMS_LOB.OPEN(mp3_blob, DBMS_LOB.LOB_READWRITE);

    -- Lade Daten aus der Datei in das BLOB
    DBMS_LOB.LOADFROMFILE(mp3_blob, mp3_bfile, DBMS_LOB.GETLENGTH(mp3_bfile));

    -- Schlie�e das tempor�re BLOB
    DBMS_LOB.CLOSE(mp3_blob);

    -- F�ge das BLOB in die Tabelle ein
    INSERT INTO mmdb_Folge (Fol_ID, Audiospur, Datum, Titel, Beschreibung)
    VALUES (1, mp3_blob, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'Golden Globes und mehr', 'Die Award Season 2024 hat begonnen! Wie jedes Jahr machen die Golden Globes den Anfang. Dabei haben vor allem OPPENHEIMER und POOR THINGS ordentlich abger�umt. Was es noch so an interessanten Auszeichnungen (und Outfits!) gab, das bequatschen Lenny, Jonas und Xenia im heutigen Podcast.');

    -- L�sche tempor�res BLOB
    DBMS_LOB.FREETEMPORARY(mp3_blob);
END;
/
----------------------------------------------------------------------------------
   */