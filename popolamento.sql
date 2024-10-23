DROP TABLE IF EXISTS Recensione;
DROP TABLE IF EXISTS Sottoscrizione;
DROP TABLE IF EXISTS Antivirus;
DROP TABLE IF EXISTS Svolgimento;
DROP TABLE IF EXISTS Assistenza;
DROP TABLE IF EXISTS Lavoro;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Direttore;
DROP TABLE IF EXISTS Professionista;
DROP TABLE IF EXISTS Assistente;
DROP TABLE IF EXISTS Sede;

CREATE TABLE Cliente(
	Email VARCHAR(100) PRIMARY KEY,
	Nome_Azienda VARCHAR(100),
	Partita_IVA VARCHAR(20) UNIQUE,
	Cognome VARCHAR(100) NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	Telefono VARCHAR(20) UNIQUE NOT NULL,
	Paese VARCHAR(20) NOT NULL,
	Cittá VARCHAR(50) NOT NULL,
	CAP VARCHAR(10) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	UNIQUE(Paese, Cittá, CAP, Via)
);

CREATE TABLE Antivirus(
	Versione VARCHAR(100) PRIMARY KEY,
	Descrizione VARCHAR(255) NOT NULL,
	Prezzo_Mensile NUMERIC(5,2) NOT NULL
);

CREATE TABLE Sottoscrizione(
	Cliente VARCHAR(100) NOT NULL,
	Antivirus VARCHAR(100) NOT NULL,
	Licenza VARCHAR(20) PRIMARY KEY,
	Inizio DATE NOT NULL,
	Scadenza DATE NOT NULL,
	FOREIGN KEY (Cliente) REFERENCES Cliente(Email) ON UPDATE CASCADE,
	FOREIGN KEY (Antivirus) REFERENCES Antivirus(Versione) ON UPDATE CASCADE
);

CREATE TABLE Recensione (
	ID INTEGER PRIMARY KEY,
	Cliente VARCHAR(100) NOT NULL,
	Antivirus VARCHAR(100) NOT NULL,
	Data_Pubblicazione DATE NOT NULL,
	Voto INTEGER CHECK(voto >= 0 AND voto <= 5),
	Commento VARCHAR,
	FOREIGN KEY (Cliente) REFERENCES Cliente(Email) ON UPDATE CASCADE,
	FOREIGN KEY (Antivirus) REFERENCES Antivirus(Versione) ON UPDATE CASCADE
);

CREATE TABLE Sede(
	Nome VARCHAR(100) PRIMARY KEY,
	Email VARCHAR(100) UNIQUE NOT NULL,
	Telefono VARCHAR(20) UNIQUE NOT NULL,
	Paese VARCHAR(20) NOT NULL,
	Cittá VARCHAR(50) NOT NULL,
	CAP VARCHAR(10) NOT NULL,
	Via VARCHAR(50) NOT NULL,
	UNIQUE(Paese, Cittá, CAP, Via)
);

CREATE TABLE Direttore(
    CF VARCHAR(16) PRIMARY KEY,
    Cognome VARCHAR(100) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20) UNIQUE NOT NULL,
    Stipendio INTEGER NOT NULL,
	Sede VARCHAR(100) NOT NULL,
    Data_Assunzione DATE NOT NULL,
    FOREIGN KEY (Sede) REFERENCES Sede(Nome) ON UPDATE CASCADE
);

CREATE TABLE Professionista(
    CF VARCHAR(16) PRIMARY KEY,
    Cognome VARCHAR(100) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20) UNIQUE NOT NULL,
    Ruolo VARCHAR(100) NOT NULL,
    Stipendio INTEGER NOT NULL,
	Sede VARCHAR(100) NOT NULL,
    Data_Assunzione DATE NOT NULL,
    FOREIGN KEY (Sede) REFERENCES Sede(Nome) ON UPDATE CASCADE
);

CREATE TABLE Lavoro(
	ID INTEGER PRIMARY KEY,
	Cliente VARCHAR(100) NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	Descrizione VARCHAR(255) NOT NULL,
	Costo INTEGER NOT NULL,
	Inizio DATE NOT NULL,
	Stato VARCHAR(15) NOT NULL CHECK (Stato IN ('Pianificato', 'In Corso', 'Completato', 'Annullato')),
	Fine DATE,
	Coordinatore VARCHAR(100),
	FOREIGN KEY (Cliente) REFERENCES Cliente(Email),
	FOREIGN KEY (Coordinatore) REFERENCES Professionista(CF)
);

CREATE TABLE Svolgimento(
	Professionista VARCHAR(16),
	Lavoro INTEGER,
	PRIMARY KEY(Professionista, Lavoro),
	FOREIGN KEY (Professionista) REFERENCES Professionista(CF),
	FOREIGN KEY (Lavoro) REFERENCES Lavoro(ID)
);

CREATE TABLE Assistente(
    CF VARCHAR(16) PRIMARY KEY,
    Cognome VARCHAR(100) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20) UNIQUE NOT NULL,
    Stipendio INTEGER NOT NULL,
	Sede VARCHAR(100) NOT NULL,
    Data_Assunzione DATE NOT NULL,
    FOREIGN KEY (Sede) REFERENCES Sede(Nome) ON UPDATE CASCADE
);

CREATE TABLE Assistenza(
	ID INTEGER PRIMARY KEY,
	Cliente VARCHAR(100) NOT NULL,
	Inizio DATE NOT NULL,
	Stato VARCHAR(15) NOT NULL CHECK (Stato IN ('Pianificato', 'In Corso', 'Completato', 'Annullato')),
	Fine DATE,
	Problema VARCHAR(255) NOT NULL,
	Soluzione VARCHAR(255),
	Assistente VARCHAR(16) NOT NULL,
	FOREIGN KEY (Cliente) REFERENCES Cliente(Email) on update cascade,
	FOREIGN KEY (Assistente) REFERENCES Assistente(CF)
);




INSERT INTO Cliente (Email, Nome_Azienda, Partita_Iva, Cognome, Nome, Telefono, Paese, Cittá, CAP, Via)
VALUES
    ('john.doe@financecorp.com', 'Financial Solutions Ltd', '0045748392028', 'Doe', 'John', '+1 (111) 222-3333', 'USA', 'New York', '10001', '123 Wall Street'),
    ('maria.girard@mail.com', NULL, NULL, 'Girard', 'Maria', '+1 (555) 234-5679', 'Canada', 'Vancouver', 'V6C 1V4', 'Granville Street 60'),
    ('emma.smith@healthcare.com', 'HealthCare Corp', 'GB345678901', 'Smith', 'Emma', '+44 555-888-7777', 'UK', 'London', 'SW1A2AA', '789 Health Avenue'),
    ('hans.schneider@gmail.com', NULL, NULL, 'Schneider', 'Hans', '+49 555-123-4568', 'Germany', 'Berlin', '10115', 'Wilhelmstraße 10'),
    ('michael.muller@researchinc.com', 'Research Innovations Inc', 'DE901234567', 'Muller', 'Michael', '+49 2468-1357-9000', 'Germany', 'Berlin', '12345', '1010 Research Road'),
    ('david.jackson@globalbanking.com', 'Global Banking Group', 'XY678901234', 'Jackson', 'David', '+1 (777) 777-7777', 'Canada', 'Toronto', 'M5V2H1', '444 Financial Plaza'),
    ('sophie.dupont@pharmatech.com', 'PharmaTech Solutions', 'FRAB789012345', 'Dupont', 'Sophie', '+33 7492-7492-0499', 'France', 'Paris', '75001', '567 Medicine Street'),
    ('giovanni.dupuis@orange.fr', NULL, NULL, 'Dupuis', 'Giovanni', '+33 555-456-7891', 'France', 'Lyon', '69001', 'Rue de la République 14'),
    ('maria.lopez@yahoo.com', NULL, NULL, 'Lopez', 'Maria', '+34 555-987-6544', 'Spain', 'Madrid', '28001', 'Calle de Alcalá 25'),
    ('alexander.schmidt@healthtech.com', 'HealthTech Innovations', 'DE432109876', 'Schmidt', 'Alexander', '+49 444-555-6666', 'Germany', 'Munich', '12345', '200 HealthTech Avenue'),
    ('maria.gonzalez@spahealth.com', 'SpaHealth Solutions', 'ESY89012345', 'Gonzalez', 'Maria', '+34 888-999-0001', 'Spain', 'Madrid', '28001', '456 Wellness Street'),
    ('luca.muller@mail.com', NULL, NULL, 'Muller', 'Luca', '+41 555-234-5679', 'Switzerland', 'Zurich', '8001', 'Bahnhofstrasse 45'),
    ('maria.rossi@libero.it', NULL, NULL, 'Rossi', 'Maria', '+39 555-654-3211', 'Italy', 'Rome', '00185', 'Via del Corso 75'),
    ('laura.wilson@financeuk.com', 'UK Financial Services', 'GB210987654', 'Wilson', 'Laura', '+44 666-777-8882', 'UK', 'London', 'SW1A1AA', '789 Money Lane'),
    ('roberto.rossi@biotechresearch.com', 'Biotech Research Ltd', '567890123', 'Rossi', 'Roberto', '+39 999-888-7773', 'Italy', 'Pesaro', '61121', 'Via del Corso 22'),
    ('marco.smith@hotmail.com', NULL, NULL, 'Smith', 'Marco', '+44 555-789-0124', 'UK', 'London', 'SW1A 1AA', 'Abbey Road 30'),
    ('jessica.nguyen@healthgroup.com', 'Health Group International', '0045678901234', 'Nguyen', 'Jessica', '+1 (555) 666-7774', 'USA', 'New York', '10001', '789 Health Tower'),
    ('elena.muller@gmail.com', NULL, NULL, 'Muller', 'Elena', '+41 555-789-0124', 'Switzerland', 'Geneva', '1204', 'Rue du Rhône 35'),
    ('thomas.muller@innovationent.com', 'Innovation Enterprises', 'DE876543210', 'Muller', 'Thomas', '+49 222-333-4445', 'Germany', 'Berlin', '12345', '1010 Innovation Way'),
    ('francesco.rossi@itabank.com', 'ItaBank Group', '654321098', 'Rossi', 'Francesco', '+39 321-654-9876', 'Italy', 'Rome', '00118', 'via Garibaldi 38'),
    ('simona.johnson@gmail.com', NULL, NULL, 'Johnson', 'Simona', '+1 (555) 321-4568', 'USA', 'New York', '10001', 'Broadway 15'),
    ('paul.leblanc@frenchfinance.com', 'French Finance Solutions', 'FREF432156789', 'Leblanc', 'Paul', '+33 789-456-1234', 'France', 'Lyon', '69001', '321 Finance Road'),
    ('simone.martinelli@itamed.com', 'ItaMed Solutions', '978610234', 'Martinelli', 'Simone', '+39 123-456-7890', 'Italy', 'Milan', '20121', 'via Carducci 89'),
    ('roberto.leblanc@web.de', NULL, NULL, 'Leblanc', 'Roberto', '+49 555-908-7655', 'Germany', 'Munich', '80331', 'Sendlinger Straße 12'),
    ('olivia.schneider@swisshealth.com', 'Swiss Health Solutions', 'CHE512803674', 'Schneider', 'Olivia', '+41 987-654-3210', 'Switzerland', 'Zurich', '8001', '888 Wellness Boulevard'),
    ('antonio.lopez@spafinance.com', 'SpaFinance Corp', 'ESY78912305', 'Lopez', 'Antonio', '+34 147-258-3698', 'Spain', 'Barcelona', '08001', '666 Finance Lane'),
    ('francesca.gagnon@outlook.com', NULL, NULL, 'Gagnon', 'Francesca', '+1 (555) 456-7891', 'Canada', 'Toronto', 'M5V 2H1', 'Yonge Street 5'),
    ('claudia.mueller@swissbanking.com', 'Swiss Banking Group', 'CHE821047365', 'Mueller', 'Claudia', '+41 987-654-3211', 'Switzerland', 'Geneva', '1204', '222 Banking Road'),
    ('alessio.martin@icloud.com', NULL, NULL, 'Martin', 'Alessio', '+33 555-876-5433', 'France', 'Paris', '75001', 'Avenue des Champs-Élysées 20'),
    ('luca.romano@italianhealthcare.com', 'Italian Healthcare Corp', '421907856', 'Romano', 'Luca', '+39 369-852-1477', 'Italy', 'Naples', '80100', 'via Mazzini 12'),
    ('anna.ferrari@virgilio.it', NULL, NULL, 'Ferrari', 'Anna', '+39 555-567-8902', 'Italy', 'Milan', '20121', 'Via Monte Napoleone 8');

INSERT INTO Antivirus (Versione, Descrizione, Prezzo_Mensile)
VALUES
    ('Standard', 'Protezione di base contro malware', 29.99),
    ('Plus', 'Protezione avanzata con firewall', 59.99),
    ('Premium', 'Protezione completa con backup', 79.99),
    ('Business', 'Soluzione antivirus per piccole imprese', 99.99),
    ('Enterprise', 'Protezione avanzata per aziende', 129.99),
    ('Ultimate', 'Massima protezione per grandi aziende', 149.99);

INSERT INTO Sottoscrizione (Cliente, Antivirus, Licenza, Inizio, Scadenza)
VALUES
    ('john.doe@financecorp.com', 'Ultimate', 'K3H7F9G8E5D4C2A1', '2023-03-22', '2024-08-06'),
    ('maria.girard@mail.com', 'Plus', 'P6N2L5M1R8K3Z7Y', '2023-02-15', '2024-09-15'),
    ('emma.smith@healthcare.com', 'Business', 'Q9W4T5X2A7V3B1D', '2023-07-17', '2024-10-22'),
    ('david.jackson@globalbanking.com', 'Enterprise', 'J8U3O2I6T5R7E9F', '2023-01-29', '2024-11-29'),
    ('sophie.dupont@pharmatech.com', 'Business', 'C1A3S8D7F5G4H6J', '2023-04-04', '2023-12-04'),
    ('maria.gonzalez@spahealth.com', 'Enterprise', 'Y5B1V9N6M3X2Z8', '2023-01-11', '2024-01-11'),
    ('luca.muller@mail.com', 'Premium', 'D4C2H1K7E5G9F8', '2023-02-18', '2025-02-18'),
    ('maria.rossi@libero.it', 'Standard', 'T6U3O5J2I1R4F7', '2023-05-27', '2024-03-27'),
    ('laura.wilson@financeuk.com', 'Business', 'R9W8Q3Z5X1V2B6', '2023-05-03', '2024-05-03'),
    ('roberto.rossi@biotechresearch.com', 'Enterprise', 'E7F5A6G9H4J3K2', '2023-06-10', '2025-06-10'),
    ('jessica.nguyen@healthgroup.com', 'Ultimate', 'M1N2P5Y3L4S7T8', '2023-07-17', '2024-07-17'),
    ('elena.muller@gmail.com', 'Premium', 'V3Z7X8B2W4Q1R9', '2023-04-24', '2024-08-24'),
    ('thomas.muller@innovationent.com', 'Business', 'G4F9A2D6E1C5H3', '2023-02-28', '2023-09-28'),
    ('francesca.gagnon@outlook.com', 'Premium', 'X2B3V1Z6Y7N8M9', '2023-07-07', '2023-11-07'),
    ('claudia.mueller@swissbanking.com', 'Business', 'S5T8L3K4R6J7P1', '2023-06-14', '2024-12-14'),
    ('anna.ferrari@virgilio.it', 'Standard', 'W6Q9R7Z8X2B5V1', '2023-01-20', '2025-01-20');

INSERT INTO Recensione (ID, Cliente, Antivirus, Data_Pubblicazione, Voto, Commento)
VALUES
    (1, 'john.doe@financecorp.com', 'Ultimate', '2023-05-15', 4, 'We opted for the Ultimate version of this antivirus, and it has proven to be a reliable security solution. The malware detection and real-time scanning capabilities are commendable, providing a strong defense against potential threats. The additional features included in the Ultimate version are valuable and enhance our overall security posture. However, we did experience a slight performance impact on some of our older devices during intensive scans. The user interface is straightforward, but we feel it could benefit from a more modern and intuitive design. Despite these minor concerns, this antivirus has helped us fortify our cyber defenses significantly. We give it a solid 4-star rating for being a robust security suite with room for further enhancements.'),
    (2, 'maria.girard@mail.com', 'Plus', '2023-07-11', 3, 'The malware detection and removal capabilities are decent, but I have noticed a few instances where threats were not detected in time.'),
    (3, 'david.jackson@globalbanking.com', 'Enterprise', '2023-02-27', 5, '"We made the decision to invest in the enterprise version of this antivirus, and it has truly exceeded our expectations! The level of protection it offers is unparalleled, and it has proven to be a robust defense against even the most sophisticated cyber threats. The centralized management console is a game-changer, allowing us to effortlessly monitor and manage security across all our devices. The seamless integration and automated updates make maintenance a breeze. The customer support has been exceptional, providing us with timely assistance whenever needed. With this antivirus safeguarding our network, we feel confident in our data security. A perfect 5-star rating for this outstanding enterprise antivirus solution!"'),
    (4, 'sophie.dupont@pharmatech.com', 'Business', '2023-06-08', 2, 'The user interface is clunky and not very intuitive, making it challenging to manage settings efficiently. Additionally, the customer support response times have been disappointingly slow, leaving us with unresolved issues for extended periods. Overall, we expected better performance and support from this antivirus, and we are quite disappointed. Regrettably, we can only give it a 2-star rating.'),
    (5, 'laura.wilson@financeuk.com', 'Business', '2023-07-29', 5, 'Excellent product! I am extremely satisfied with my purchase. The software is user-friendly, feature-rich, and delivers outstanding performance. It has exceeded my expectations in every way possible. The customer support team is also top-notch, providing quick and helpful responses to any queries. I highly recommend this product to anyone in need of a reliable and efficient solution. Truly deserving of a perfect 5-star rating!'),
    (6, 'elena.muller@gmail.com', 'Premium', '2023-06-24', 1, 'Es funktioniert nicht auf Arch Linux.'),
    (7, 'thomas.muller@innovationent.com', 'Business', '2023-03-28', 3, NULL),
    (8, 'anna.ferrari@virgilio.it', 'Standard', '2023-04-14', 4, NULL);

INSERT INTO Sede (Nome, Email, Telefono, Paese, Cittá, CAP, Via)
VALUES
('Berlin Office', 'germany@securenet.com', '+49 354-765-9647', 'Germany', 'Berlin', '10115', 'Unter den Linden 15'),
('London Office', 'uk@securenet.com', '+44 269-621-8443', 'UK', 'London', 'W1B3DG', 'Baker Street 221B'),
('New York Office', 'usa@securenet.com', '+1 (212) 536-3621', 'USA', 'New York', '10001', 'Broadway 1'),
('Madrid Office', 'spain@securenet.com', '+34 899-554-2563', 'Spain', 'Madrid', '28001', 'Gran Via 36'),
('Zurich Office', 'switzerland@securenet.com', '+41 441-878-2311', 'Switzerland', 'Zurich', '8001', 'Bahnhofstrasse 24'),
('Rome Office', 'italy@securenet.com', '+39 096-654-1299', 'Italy', 'Rome', '00186', 'Via Montenapoleone 4');

INSERT INTO Direttore (CF, Cognome, Nome, Email, Telefono, Stipendio, Sede, Data_Assunzione)
VALUES
    ('FRNKLW95A01Y200T', 'Franklin', 'William', 'william.franklin@gmail.com', '+49 30 5678901', 105000, 'Berlin Office', '2015-01-15'),
    ('WLLCST95A01B309E', 'Wallace', 'Elizabeth', 'elizabeth.wallace@outlook.com', '+44 20 7890123', 125000, 'London Office', '2014-09-02'),
    ('JNSMTH95A01U567A', 'Johnson', 'Sarah', 'sarah.johnson@icloud.com', '+1 (415) 234-5678', 140000, 'New York Office', '2015-12-15'),
    ('GRRDZ95A01S321D', 'García', 'Rodrigo', 'rodrigo.garcia@mail.com', '+34 91 9876543', 95000, 'Madrid Office', '2015-05-27'),
    ('BRGMRN95A01Z104F', 'Burger', 'Manuel', 'manuel.burger@gmail.com', '+41 44 7654321', 135000, 'Zurich Office', '2014-08-08'),
    ('FRRNZN95A01I345P', 'Ferrari', 'Anna', 'anna.ferrari@libero.it', '+39 02 3456789', 110000, 'Rome Office', '2016-03-10');

INSERT INTO Professionista (CF, Cognome, Nome, Email, Telefono, Ruolo, Stipendio, Sede, Data_Assunzione)
VALUES
    ('BNCMRC95A01F205Q', 'Bianchi', 'Marco', 'marco.bianchi@gmail.com', '+39 02 1234567', 'Security Analyst', 45000, 'Rome Office', '2020-03-15'),
    ('MULLHN95A01Z104E', 'Muller', 'Hans', 'hans.mueller@icloud.com', '+49 30 8765432', 'Information Security Officer', 58000, 'Berlin Office', '2019-01-10'),
    ('GNZLPB95A01Z117R', 'Gonzalez', 'Pablo', 'pablo.gonzalez@outlook.com', '+34 91 7654321', 'Security Engineer', 47000, 'Madrid Office', '2017-02-28'),
    ('JHNSEM95A01Y200T', 'Johnson', 'Emily', 'emily.johnson@mail.com', '+1 (212) 345-6789', 'Cyber Threat Intelligence Analyst', 60000, 'New York Office', '2023-01-22'),
    ('WLLEMM95A01H192W', 'Williams', 'Emma', 'emma.williams@yahoo.com', '+44 20 7123 4567', 'Security Consultant', 58000, 'London Office', '2015-03-10'),
    ('MULLCD95A01L876X', 'Müller', 'Claudia', 'claudia.mueller@web.de', '+41 43 4567890', 'Cybersecurity Manager', 65000, 'Zurich Office', '2016-01-15'),
    ('RSSLRA95A01F205W', 'Rossi', 'Laura', 'laura.rossi@virgilio.it', '+39 06 9876543', 'Cybersecurity Specialist', 52000, 'Rome Office', '2019-06-20'),
    ('SCHMNA95A01I345B', 'Schmidt', 'Anna', 'anna.schmidt@gmail.com', '+49 89 4567890', 'Penetration Tester', 60000, 'Zurich Office', '2020-04-05'),
    ('LPSFSA95A01Z109S', 'Lopez', 'Sofia', 'sofia.lopez@gmail.com', '+34 93 2345678', 'Cybersecurity Analyst', 49000, 'Madrid Office', '2021-07-12'),
    ('SMTHJN95A01D345E', 'Smith', 'John', 'john.smith@hotmail.com', '+1 (415) 876-5432', 'Network Security Specialist', 55000, 'New York Office', '2022-05-18'),
    ('BRWNWL95A01B309T', 'Brown', 'William', 'william.brown@outlook.com', '+44 161 789 1234', 'Ethical Hacker', 52000, 'Madrid Office', '2023-06-28'),
    ('FSCLKS95A01G205P', 'Fischer', 'Lukas', 'lukas.fischer@icloud.com', '+41 44 9876543', 'Incident Response Specialist', 62000, 'Zurich Office', '2021-05-05'),
    ('ANDMCH95A01C314G', 'Anderson', 'Michael', 'michael.anderson@outlook.com', '+1 (312) 567-8901', 'Security Operations Center Analyst', 58000, 'New York Office', '2019-02-08'),
    ('SPSGUL95A01H081B', 'Esposito', 'Giulia', 'giulia.esposito@libero.it', '+39 081 3456789', 'Cybersecurity Analyst', 48000, 'Rome Office', '2017-07-20'),
    ('SCTOLV95A01A794W', 'Scott', 'Olivia', 'olivia.scott@mail.com', '+44 161 2345678', 'Malware Analyst', 54000, 'London Office', '2018-04-15'),
    ('WGNRFX95A01Z104T', 'Wagner', 'Felix', 'felix.wagner@web.de', '+49 30 7890123', 'Cybersecurity Engineer', 55000, 'Berlin Office', '2019-03-05'),
    ('LWSMTH95A01Z317T', 'Lewis', 'Samantha', 'samantha.lewis@gmail.com', '+1 (415) 234-5678', 'Cyber Threat Analyst', 53000, 'New York Office', '2017-08-12'),
    ('MRTZDN95A01A094W', 'Martinez', 'Daniel', 'daniel.martinez@icloud.com', '+34 91 9876543', 'Security Consultant', 57000, 'Madrid Office', '2022-02-18');

INSERT INTO Lavoro (ID, Cliente, Nome, Descrizione, Costo, Inizio, Stato, Fine, Coordinatore)
VALUES
    (1, 'john.doe@financecorp.com', 'Valutazione delle Vulnerabilità', 'Condurre una valutazione completa delle vulnerabilità della rete e dei sistemi aziendali.', 5000, '2023-08-01', 'In Corso', NULL, NULL),
    (2, 'michael.muller@researchinc.com', 'Test di Penetrazione', 'Effettuare test di penetrazione su applicazioni e infrastrutture critiche per individuare possibili falle di sicurezza.', 8000, '2023-07-20', 'Completato', '2023-08-05', NULL),
    (3, 'emma.smith@healthcare.com', 'Gestione delle Risposte agli Incidenti di Sicurezza', 'Sviluppare e implementare un piano di risposta agli incidenti di sicurezza per gestire efficacemente gli incidenti di cybersecurity.', 6000, '2023-07-28', 'Pianificato', NULL, 'WLLEMM95A01H192W'),
    (4, 'david.jackson@globalbanking.com', 'Formazione sulla Consapevolezza della Sicurezza', 'Fornire formazione sulla consapevolezza della sicurezza ai dipendenti per migliorare la loro comprensione dei rischi della cybersecurity.', 3000, '2023-06-15', 'Completato', '2023-06-25', NULL),
    (5, 'alexander.schmidt@healthtech.com', 'Audit di Sicurezza della Rete', 'Condurre un audit della rete aziendale per valutarne la sicurezza complessiva e individuare possibili vulnerabilità.', 4500, '2023-07-29', 'Pianificato', NULL, NULL),
    (6, 'sophie.dupont@pharmatech.com', 'Individuazione delle Minacce', 'Effettuare rilevamento proattivo delle minacce per individuare e mitigare potenziali minacce prima che causino danni.', 7000, '2023-07-02', 'In Corso', NULL, NULL),
    (7, 'maria.gonzalez@spahealth.com', 'Sviluppo di Politiche di Cybersecurity', 'Sviluppare politiche e procedure complete di cybersecurity adattate alle esigenze dell''azienda.', 5500, '2023-07-10', 'In Corso', NULL, NULL),
    (8, 'jessica.nguyen@healthgroup.com', 'Implementazione della Crittografia dei Dati', 'Implementare misure di crittografia dei dati per proteggere i dati sensibili dall''accesso non autorizzato.', 4000, '2023-06-11', 'Completato', '2023-07-21', 'WLLEMM95A01H192W'),
    (9, 'thomas.muller@innovationent.com', 'Valutazione della Sicurezza Cloud', 'Valutare la sicurezza dell''infrastruttura e delle applicazioni cloud dell''azienda.', 6500, '2023-07-10', 'In Corso', NULL, NULL),
    (10, 'francesco.rossi@itabank.com', 'Indagine sugli Incidenti di Sicurezza', 'Indagare su un recente incidente di sicurezza e fornire raccomandazioni per la risoluzione.', 5200, '2023-08-01', 'Pianificato', NULL, NULL),
    (11, 'paul.leblanc@frenchfinance.com', 'Test di Sicurezza delle Applicazioni Mobile', 'Effettuare test di sicurezza sulle applicazioni mobili dell''azienda per individuare potenziali vulnerabilità.', 4800, '2023-07-20', 'Annullato', NULL, NULL),
    (12, 'roberto.rossi@biotechresearch.com', 'Implementazione della Gestione delle Identità e degli Accessi', 'Implementare soluzioni di gestione delle identità e degli accessi per garantire controlli di accesso adeguati.', 6000, '2023-06-25', 'In Corso', NULL, 'SPSGUL95A01H081B'),
    (13, 'simone.martinelli@itamed.com', 'Formazione sulla Risposta agli Incidenti di Cybersecurity', 'Fornire formazione al team di risposta agli incidenti dell''azienda sulla gestione degli incidenti di sicurezza.', 3500, '2023-08-02', 'Pianificato', NULL, NULL),
    (14, 'luca.romano@italianhealthcare.com', 'Valutazione della Sicurezza delle Applicazioni Web', 'Valutare la sicurezza delle applicazioni web dell''azienda e suggerire miglioramenti di sicurezza.', 5500, '2023-06-05', 'Completato', '2023-07-12', NULL);
	
INSERT INTO Svolgimento (Professionista, Lavoro)
VALUES
    ('BNCMRC95A01F205Q',1),
    ('MRTZDN95A01A094W',2),
    ('LWSMTH95A01Z317T',4),
    ('GNZLPB95A01Z117R',6),
    ('JHNSEM95A01Y200T',7),
    ('ANDMCH95A01C314G',8),
    ('WLLEMM95A01H192W',9),
	('SPSGUL95A01H081B',12),
    ('MULLCD95A01L876X',12),
    ('SMTHJN95A01D345E',12),
    ('SCTOLV95A01A794W',12),
    ('WGNRFX95A01Z104T',14);

INSERT INTO Assistente (CF, Cognome, Nome, Email, Telefono, Stipendio, Sede, Data_Assunzione)
VALUES
('STNJMS85A15Z404X', 'Stone', 'James', 'james.stone@berlin_office.com', '+49 354-765-9647', 30000, 'Berlin Office', '2022-03-15'),
('MGRLEN92E13D789A', 'Magro', 'Elena', 'elena.magro@london_office.com', '+44 269-621-8443', 25000, 'London Office', '2021-11-02'),
('JHNMCH92E03D456P', 'Johnson', 'Michael', 'michael.johnson@newyork_office.com', '+1 (212) 536-3621', 40000, 'New York Office', '2023-01-18'),
('GRCISB91P45M567A', 'Garcia', 'Isabella', 'isabella.garcia@madrid_office.com', '+34 899-554-2563', 20000, 'Madrid Office', '2020-09-30'),
('GRTLSI93E09D123P', 'Giaretta', 'Alessio', 'gyarik.alex@zurich_office.com', '+41 441-878-2311', 60000, 'Zurich Office', '2022-07-09'),
('RSSGLI93H54D567B', 'Rossi', 'Giulia', 'giulia.rossi@rome_office.com', '+39 096-654-1299', 25000, 'Rome Office', '2023-05-05');
	
INSERT INTO Assistenza (ID, Cliente, Inizio, Stato, Fine, Problema, Soluzione, Assistente)
VALUES
    (1, 'maria.girard@mail.com', '2023-07-20', 'Pianificato', NULL, 'Configurazione VPN', NULL, 'MGRLEN92E13D789A'),
    (2, 'david.jackson@globalbanking.com', '2023-07-10', 'Completato', '2023-07-15', 'Perdita di dati critici a causa di un errore di backup, necessità di recupero dati.', 'Backup completato con successo.', 'RSSGLI93H54D567B'),
    (3, 'maria.lopez@yahoo.com', '2023-07-18', 'Annullato', NULL, 'Accesso non autorizzato', NULL, 'MGRLEN92E13D789A'),
    (4, 'elena.muller@gmail.com', '2023-07-08', 'In Corso', NULL, 'Attacco DDoS', NULL, 'STNJMS85A15Z404X'),
    (5, 'claudia.mueller@swissbanking.com', '2023-07-05', 'Completato', '2023-07-15', 'Individuata una violazione dei dati, necessità di analisi forense.', 'Pianificazione indagine effettuata.', 'GRTLSI93E09D123P'),
    (6, 'paul.leblanc@frenchfinance.com', '2023-07-14', 'In Corso', NULL, 'Compromissione account amministratore, necessità di ripristino.', NULL, 'RSSGLI93H54D567B'),
    (7, 'roberto.leblanc@web.de', '2023-06-27', 'Pianificato', NULL, 'Clienti lamentano accessi non autorizzati ai loro account, richiesta di audit delle autenticazioni.', NULL, 'STNJMS85A15Z404X'),
    (8, 'olivia.schneider@swisshealth.com', '2023-07-11', 'In Corso', NULL, 'Problema durante aggiornamento antivirus alla versione 4.1.1', NULL, 'GRTLSI93E09D123P');
	
CREATE INDEX idx_EmailCliente ON Cliente(Email);

SELECT c.Email FROM Cliente c JOIN Sottoscrizione s ON c.Email = s.Cliente
JOIN Antivirus a ON s.Antivirus = a.Versione
LEFT JOIN Recensione r ON c.Email = r.Cliente AND a.Versione = r.Antivirus
GROUP BY c.email, c.nome, c.cognome, a.prezzo_mensile, r.id
HAVING a.Prezzo_Mensile * 12 > 50 AND r.ID IS NULL;

SELECT a.Versione AS Antivirus, COUNT(DISTINCT s.Cliente) AS NumeroSottoscrizioni, ROUND(AVG(r.Voto),1) AS MediaVoti
FROM Antivirus a
LEFT JOIN Sottoscrizione s ON a.Versione = s.Antivirus LEFT JOIN Recensione r ON a.Versione = r.Antivirus
GROUP BY a.Versione
ORDER BY NumeroSottoscrizioni DESC;

SELECT P.Cognome, P.Nome, COUNT(L.ID) AS NumeroProgetti
FROM Professionista P
JOIN Lavoro L ON P.CF = L.Coordinatore
GROUP BY P.Cognome,P.Nome
ORDER BY NumeroProgetti DESC;

SELECT S.Nome AS Sede, SUM(P.Stipendio) AS TotaleStipendi
FROM (SELECT CF, Sede, Stipendio FROM Professionista
UNION ALL
SELECT CF, Sede, Stipendio FROM Direttore
UNION ALL
SELECT CF, Sede, Stipendio FROM Assistente) P JOIN Sede S ON P.Sede = S.Nome
GROUP BY S.Nome
ORDER BY S.Nome;

SELECT A.Nome AS NomeAssistente, A.cognome AS CognomeAssistente,
SUM(CASE WHEN C.Partita_IVA IS NOT NULL THEN 1 ELSE 0 END) AS NumeroAssistenzeOrganizzazioni,
SUM(CASE WHEN C.Partita_IVA IS NULL THEN 1 ELSE 0 END) AS NumeroAssistenzePrivati
FROM Assistente A
JOIN Assistenza Asst ON A.CF = Asst.Assistente
JOIN Cliente C ON Asst.Cliente = C.Email
GROUP BY A.Nome, A.Cognome;

SELECT
(SELECT SUM(ALL costo) as GuadagnoProgetti
FROM lavoro l
WHERE EXTRACT(YEAR FROM(l.fine))='2023'),
(SELECT SUM(prezzo_mensile * ((s.scadenza - s.inizio) / 30)) as GuadagnoAntivirus
FROM sottoscrizione s
JOIN antivirus a ON s.antivirus = a.versione
    WHERE EXTRACT(YEAR FROM(s.inizio)) = '2023');

SELECT d.nome, d.cognome, se.nome, SUM(l.costo) as guadagno
FROM lavoro l,svolgimento sv, sede se, direttore d, professionista p
WHERE l.id=sv.lavoro
AND sv.professionista=p.cf
AND p.sede=se.nome 
AND d.sede=se.nome
GROUP BY d.nome, d.cognome, se.nome
ORDER BY guadagno DESC;