-- --------------------------------------------------------
-- DATABASE STRUCTURE
-- --------------------------------------------------------

--
-- Database initialization
--

drop database if exists collectors;
create database if not exists collectors;
use collectors;

--
-- Dropping existing tables
--

drop table if exists incide;
drop table if exists classificazione;
drop table if exists produce;
drop table if exists costituito;
drop table if exists condivisa;
drop table if exists band;
drop table if exists artista_singolo;
drop table if exists traccia;
drop table if exists immagine;
drop table if exists info_disco;
drop table if exists disco;
drop table if exists collezione_di_dischi;
drop table if exists collezionista;
drop table if exists autore;
drop table if exists etichetta;
drop table if exists tipologia;
drop table if exists stato;
drop table if exists ruolo;
drop table if exists formato;
drop table if exists genere;

--
-- Creating database tables
--

CREATE TABLE genere (
    nome VARCHAR(50),
    CONSTRAINT NOME_genere PRIMARY KEY (nome)
);

CREATE TABLE formato (
    nome VARCHAR(50),
    CONSTRAINT NOME_formato PRIMARY KEY (nome)
);

CREATE TABLE ruolo (
    nome VARCHAR(50),
    CONSTRAINT NOME_ruolo PRIMARY KEY (nome)
);

CREATE TABLE stato (
    nome VARCHAR(50),
    CONSTRAINT NOME_stato PRIMARY KEY (nome)
);

CREATE TABLE tipologia (
    nome VARCHAR(50),
    CONSTRAINT NOME_tipologia PRIMARY KEY (nome)
);

CREATE TABLE etichetta (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(200) NOT NULL,
    partitaIVA VARCHAR(11) NOT NULL,
    CONSTRAINT ID_etichetta PRIMARY KEY (id),
    CONSTRAINT unique_partitaIVA UNIQUE (partitaIVA)
);

CREATE TABLE autore (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    nome_darte VARCHAR(100) NOT NULL,
    tipo BOOLEAN NOT NULL,
    CONSTRAINT ID_autore PRIMARY KEY (id),
    CONSTRAINT unique_autore UNIQUE (nome_darte)
);

CREATE TABLE collezionista (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    nickname VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL,
    CONSTRAINT ID_collezionista PRIMARY KEY (id),
    CONSTRAINT unique_collezionista UNIQUE (nickname , email)
);

CREATE TABLE collezione_di_dischi (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(200) NOT NULL,
    visibilita BOOLEAN NOT NULL,
    id_collezionista INTEGER UNSIGNED NOT NULL,
    CONSTRAINT ID_collezione PRIMARY KEY (id),
    CONSTRAINT collezione_collezionista FOREIGN KEY (id_collezionista)
        REFERENCES collezionista (id)
        ON DELETE CASCADE,
    CONSTRAINT unique_collezione UNIQUE (id_collezionista , nome)
);

CREATE TABLE disco (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    titolo VARCHAR(50) NOT NULL,
    anno_di_uscita DATE NOT NULL,
    nome_formato VARCHAR(50) NOT NULL,
    nome_stato VARCHAR(50) NOT NULL,
    id_etichetta INTEGER UNSIGNED NOT NULL,
    id_collezione_di_dischi INTEGER UNSIGNED NOT NULL,
    CONSTRAINT ID_disco PRIMARY KEY (id),
    CONSTRAINT disco_formato FOREIGN KEY (nome_formato)
        REFERENCES formato (nome)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT disco_etichetta FOREIGN KEY (id_etichetta)
        REFERENCES etichetta (id)
        ON DELETE RESTRICT,
    CONSTRAINT disco_stato FOREIGN KEY (nome_stato)
        REFERENCES stato (nome)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT disco_collezione FOREIGN KEY (id_collezione_di_dischi)
        REFERENCES collezione_di_dischi (id)
        ON DELETE CASCADE,
    CONSTRAINT unique_disco UNIQUE (titolo , anno_di_uscita , nome_formato , nome_stato , id_etichetta , id_collezione_di_dischi)
);

CREATE TABLE info_disco (
    id_disco INTEGER UNSIGNED,
    barcode VARCHAR(200),
    note TEXT,
    numero_copie INTEGER UNSIGNED DEFAULT 1,
    CONSTRAINT ID_info_disco PRIMARY KEY (id_disco),
    CONSTRAINT unique_barcode UNIQUE (barcode),
    CONSTRAINT info_disco_disco FOREIGN KEY (id_disco)
        REFERENCES disco (id)
        ON DELETE CASCADE
);

CREATE TABLE immagine (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    path VARCHAR(100) NOT NULL,
    descrizione TEXT,
    id_disco INTEGER UNSIGNED NOT NULL,
    nome_tipologia VARCHAR(50) NOT NULL,
    CONSTRAINT ID_immagine PRIMARY KEY (id),
    CONSTRAINT unique_immagine UNIQUE (id_disco , path , nome_tipologia),
    CONSTRAINT immagine_disco FOREIGN KEY (id_disco)
        REFERENCES disco (id)
        ON DELETE CASCADE,
    CONSTRAINT immagine_tipologia FOREIGN KEY (nome_tipologia)
        REFERENCES tipologia (nome)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE traccia (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    titolo VARCHAR(50) NOT NULL,
    durata DECIMAL(10 , 2 ) UNSIGNED DEFAULT 0.0,
    id_etichetta INTEGER UNSIGNED NOT NULL,
    id_disco INTEGER UNSIGNED NOT NULL,
    CONSTRAINT ID_traccia PRIMARY KEY (id),
    CONSTRAINT traccia_etichetta FOREIGN KEY (id_etichetta)
        REFERENCES etichetta (id)
        ON DELETE RESTRICT,
    CONSTRAINT traccia_disco FOREIGN KEY (id_disco)
        REFERENCES disco (id)
        ON DELETE CASCADE,
    CONSTRAINT unique_traccia UNIQUE (titolo , id_etichetta , id_disco)
);
CREATE TABLE artista_singolo (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita VARCHAR(50) NOT NULL,
    id_autore INTEGER UNSIGNED NOT NULL,
    CONSTRAINT ID_artista PRIMARY KEY (id),
    CONSTRAINT artista_singolo_autore FOREIGN KEY (id_autore)
        REFERENCES autore (id)
        ON DELETE CASCADE,
    CONSTRAINT unique_artista_singolo UNIQUE (nome , cognome , data_nascita , luogo_nascita),
    CONSTRAINT unique_autore_artista_singolo UNIQUE (id_autore)
);
CREATE TABLE band (
    id INTEGER UNSIGNED AUTO_INCREMENT,
    id_fondatore INTEGER UNSIGNED NOT NULL,
    data_fondazione DATE NOT NULL,
    id_autore INTEGER UNSIGNED NOT NULL,
    CONSTRAINT ID_band PRIMARY KEY (id),
    CONSTRAINT band_artista_singolo FOREIGN KEY (id_fondatore)
        REFERENCES artista_singolo (id)
        ON DELETE RESTRICT,
    CONSTRAINT band_autore FOREIGN KEY (id_autore)
        REFERENCES autore (id)
        ON DELETE CASCADE,
    CONSTRAINT unique_band UNIQUE (id_fondatore , data_fondazione),
    CONSTRAINT unique_autore_band UNIQUE (id_autore)
);
CREATE TABLE condivisa (
    id_collezionista INTEGER UNSIGNED NOT NULL,
    id_collezione INTEGER UNSIGNED NOT NULL,
    CONSTRAINT primary_condivisione PRIMARY KEY (id_collezionista , id_collezione),
    CONSTRAINT condivisa_collezionista FOREIGN KEY (id_collezionista)
        REFERENCES collezionista (id)
        ON DELETE CASCADE,
    CONSTRAINT condivisa_collezione FOREIGN KEY (id_collezione)
        REFERENCES collezione_di_dischi (id)
        ON DELETE CASCADE
);
CREATE TABLE costituito (
    id_band INTEGER UNSIGNED NOT NULL,
    id_artista INTEGER UNSIGNED NOT NULL,
    CONSTRAINT primary_costituito PRIMARY KEY (id_band , id_artista),
    CONSTRAINT costituito_band FOREIGN KEY (id_band)
        REFERENCES band (id)
        ON DELETE CASCADE,
    CONSTRAINT costituito_artista_singolo FOREIGN KEY (id_artista)
        REFERENCES artista_singolo (id)
        ON DELETE RESTRICT
);
CREATE TABLE produce (
    id_traccia INTEGER UNSIGNED NOT NULL,
    id_autore INTEGER UNSIGNED NOT NULL,
    nome_ruolo VARCHAR(50) NOT NULL,
    CONSTRAINT primary_produce PRIMARY KEY (id_traccia , id_autore , nome_ruolo),
    CONSTRAINT produce_traccia FOREIGN KEY (id_traccia)
        REFERENCES traccia (id)
        ON DELETE CASCADE,
    CONSTRAINT produce_autore FOREIGN KEY (id_autore)
        REFERENCES autore (id)
        ON DELETE RESTRICT,
    CONSTRAINT produce_ruolo FOREIGN KEY (nome_ruolo)
        REFERENCES ruolo (nome)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE classificazione (
    nome_genere VARCHAR(50) NOT NULL,
    id_disco INTEGER UNSIGNED NOT NULL,
    CONSTRAINT primary_classificazione PRIMARY KEY (nome_genere , id_disco),
    CONSTRAINT classificazione_genere FOREIGN KEY (nome_genere)
        REFERENCES genere (nome)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT classificazione_disco FOREIGN KEY (id_disco)
        REFERENCES disco (id)
        ON DELETE CASCADE
);
CREATE TABLE incide (
    id_disco INTEGER UNSIGNED NOT NULL,
    id_autore INTEGER UNSIGNED NOT NULL,
    CONSTRAINT primary_raggruppamento PRIMARY KEY (id_disco , id_autore),
    CONSTRAINT incide_disco FOREIGN KEY (id_disco)
        REFERENCES disco (id)
        ON DELETE CASCADE,
    CONSTRAINT incide_autore FOREIGN KEY (id_autore)
        REFERENCES autore (id)
        ON DELETE RESTRICT
);

--
-- Creating database users
--

DROP USER IF EXISTS 'application'@'localhost';
CREATE USER 'application'@'localhost' IDENTIFIED BY "$app!";
GRANT select,insert,update,execute,delete,show view,create temporary tables ON collectors.* TO 'application'@'localhost';

--
-- Dropping existing triggers
--

DROP TRIGGER IF EXISTS controlla_generi;
DROP TRIGGER IF EXISTS on_update_visibilita;
DROP TRIGGER IF EXISTS check_artista; 
DROP TRIGGER IF EXISTS check_band;

--
-- Creating triggers
--

DELIMITER $

CREATE TRIGGER controlla_generi BEFORE DELETE ON classificazione FOR EACH ROW
BEGIN

	DECLARE numero_generi integer;
	/* Controlla che un disco non rimanga mai con meno di 1 genere */
    
    SET numero_generi = (
		SELECT count(distinct c.nome_genere)
		FROM classificazione c
		WHERE c.id_disco=old.id_disco);
    
    IF(numero_generi <= 1) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Operazione vietata!";
	END IF;

END$

CREATE TRIGGER on_update_visibilita BEFORE UPDATE ON collezione_di_dischi FOR EACH ROW
BEGIN

	IF(old.visibilita = false AND new.visibilita = true) THEN
		DELETE FROM condivisa WHERE id_collezione = old.id;
  END IF;

END$

CREATE TRIGGER check_artista BEFORE INSERT ON artista_singolo FOR EACH ROW
BEGIN

  DECLARE tipo_autore boolean; 

  SET tipo_autore = (
      SELECT tipo
      FROM autore
      WHERE id = new.id_autore); 
      
      /* Controlla che il tipo dichiarato nell'inserimento dell artista combaci con quello
       dell'artista che si sta inserendo (artista singolo o band)*/
      IF(tipo_autore = true) THEN 
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il tipo dell'autore non combacia.";
      END IF; 
      
      /* Controllo sulla data di nascita affinchè non ecceda quella corrente*/
      IF(new.data_nascita > date(now())) THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Errore nella data di nascita.";
      END IF; 
END$

CREATE TRIGGER check_band BEFORE INSERT ON band FOR EACH ROW
BEGIN

	DECLARE tipo_autore boolean;

  SET tipo_autore = (
      SELECT tipo 
      FROM autore 
      WHERE id = new.id_autore);

  /* Controlla che il tipo dichiarato nell'inserimento dell autore combaci con 
  quello dell'artista che si sta inserendo (artista singolo o band)*/
  IF(tipo_autore = false) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il tipo dell'autore non combacia";
  END IF;

  /* Controllo sulla data di nascita affinchè non ecceda quella corrente*/
  IF(new.data_fondazione > date(now())) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Errore nella data di nascita.";
  END IF;

END$

DELIMITER ;

--
-- Dropping existing procedures and functions
--

# 1. Inserimento di una nuova collezione
DROP PROCEDURE IF EXISTS insert_collezione;

# 2. Aggiunta di dischi a una collezione e di tracce a un disco.
DROP PROCEDURE IF EXISTS aggiungi_disco_a_collezione;
DROP PROCEDURE IF EXISTS aggiugi_traccia_a_disco;

/* 3. Modifica dello stato di pubblicazione di una collezione (da privata a pubblica e viceversa) 
e aggiunta di nuove condivisioni a una collezione.*/
DROP PROCEDURE IF EXISTS inserisci_condivisione;
DROP PROCEDURE IF EXISTS cambia_visibilita;

# 4. Rimozione di un disco dalla collezione
DROP PROCEDURE IF EXISTS rimuovi_disco;

# 5. Rimozione di una collezione
DROP PROCEDURE IF EXISTS rimuovi_collezione;

# 6.Lista di tutti i dischi in una collezione
DROP PROCEDURE IF EXISTS dischi_in_collezione;
DROP FUNCTION IF EXISTS generi_disco;

# 7. Track list di un disco.
DROP PROCEDURE IF EXISTS track_list_disco;

# PROF LE VOGLIAMO BENE (CAPIRÀ PERCHÈ PIÙ AVANTI)
/* 8. Ricerca di dischi in base a nomi di autori/compositori/interpreti e/o titoli. 
Si potrà decidere di includere nella ricerca le collezioni di un certo collezionista 
e/o quelle condivise con lo stesso collezionista e/o quelle pubbliche. 
(Suggerimento: potete realizzare diverse query in base alle varie combinazioni di criteri
 di ricerca. Usate la UNION per unire i risultati delle ricerche effettuate sulle collezioni
 private, condivise e pubbliche)
 
 La seguente query si articola così:
 1. Ricerca in collezioni personale, condivise e pubbliche
	1.1 Ricerca con nome d'arte e con titolo
    1.2 Ricerca con titolo
	1.3 Ricerca con nome d'arte
 2. Ricerca in collezioni personali e condivise
	2.1 Ricerca con nome d'arte e con titolo
    2.2 Ricerca con titolo
	2.3 Ricerca con nome d'arte
 3. Ricerca in collezioni personali e pubbliche
	3.1 Ricerca con nome d'arte e con titolo
    3.2 Ricerca con titolo
	3.3 Ricerca con nome d'arte
 4. Ricerca in collezioni pubbliche e condivise
	4.1 Ricerca con nome d'arte e con titolo
    4.2 Ricerca con titolo
	4.3 Ricerca con nome d'arte
 5. Ricerca in collezioni personali
	5.1 Ricerca con nome d'arte e con titolo
    5.2 Ricerca con titolo
	5.3 Ricerca con nome d'arte
 6. Ricerca in collezioni condivise
	6.1 Ricerca con nome d'arte e con titolo
    6.2 Ricerca con titolo
	6.3 Ricerca con nome d'arte
 7. Ricerca in collezioni pubbliche 
	7.1 Ricerca con nome d'arte e con titolo
    7.2 Ricerca con titolo
	7.3 Ricerca con nome d'arte
    
  In questo modo vengono coperte tutte le possibili combinazioni di ricerca 
*/
DROP PROCEDURE IF EXISTS ricerca_di_dischi_con_autore_eo_titolo;

/* 9. Verifica della visibilità di una collezione da parte di un collezionista. 
   (Suggerimento: una collezione è visibile a un collezionista se è sua, condivisa con lui o pubblica)
*/
DROP PROCEDURE IF EXISTS verifica_visibilita_collezione;

/* 10. Numero dei brani (tracce di dischi) distinti di un certo autore (compositore, musicista) 
  presenti nelle collezioni pubbliche.
*/
DROP FUNCTION IF EXISTS conta_brani;

/* 11. Minuti totali di musica riferibili a un certo autore (compositore, musicista) memorizzati nelle
 collezioni pubbliche.
*/
DROP FUNCTION IF EXISTS conta_minuti_autore;

/* 12. Statistiche (una query per ciascun valore): numero di collezioni di ciascun collezionista,
   numero di dischi per genere nel sistema.
*/
DROP PROCEDURE IF EXISTS  conta_collezioni;
DROP PROCEDURE IF EXISTS conta_dischi_per_genere;

--
-- Creating procedures and functions
--

DELIMITER $

# 1. Inserimento di una nuova collezione
CREATE PROCEDURE insert_collezione(
	in id_collezionista integer unsigned,
    in nome_collezione varchar(200),
    in visibilita boolean)
BEGIN
    INSERT INTO collezione_di_dischi(nome,visibilita,id_collezionista) 
    VALUES(nome_collezione,visibilita,id_collezionista);
END$

# 2. Aggiunta di dischi a una collezione e di tracce a un disco.
CREATE PROCEDURE aggiungi_disco_a_collezione(
	in titolo varchar(50),
    in anno_di_uscita date,
    in nome_formato varchar(50),
    in nome_stato varchar(50),
    in id_etichetta integer unsigned,
    in id_collezione_di_dischi integer unsigned,
    in barcode varchar(200),
    in note text,
    in numero_copie integer unsigned)
BEGIN

	DECLARE data_invalida CONDITION FOR SQLSTATE '45000';
    DECLARE disco_gia_inserito CONDITION FOR SQLSTATE '23000';
    
    # Controlla che la data corretta suia valida
    DECLARE EXIT HANDLER FOR data_invalida 
	BEGIN
        RESIGNAL SET MESSAGE_TEXT='Errore! Data invalida' ;
	END;
    
    # Controlla se il disco è gia presente, se si dà errore
    DECLARE EXIT HANDLER FOR disco_gia_inserito
    BEGIN
		RESIGNAL SET MESSAGE_TEXT="Errore! Il disco è gia presente";
    END;
    
	IF(anno_di_uscita > now()) THEN
		SIGNAL data_invalida;
    ELSE
		INSERT INTO disco(titolo,anno_di_uscita,nome_formato,nome_stato,id_etichetta,id_collezione_di_dischi)
        VALUES (titolo,anno_di_uscita,nome_formato,nome_stato,id_etichetta,id_collezione_di_dischi);
        INSERT INTO info_disco VALUES (last_insert_id(),barcode,note,numero_copie);
	END IF;
END$

CREATE PROCEDURE aggiungi_traccia_a_disco(
	in titolo varchar(50),
    in durata decimal(10,2),
    in id_etichetta integer unsigned,
    in id_disco integer unsigned)
BEGIN
	INSERT INTO traccia(titolo,durata,id_etichetta,id_disco) 
    VALUES (titolo,durata,id_etichetta,id_disco);
END$

/* 3. Modifica dello stato di pubblicazione di una collezione (da privata a pubblica e viceversa) 
e aggiunta di nuove condivisioni a una collezione.*/
CREATE PROCEDURE inserisci_condivisione(
	in nickname varchar(100),
	in email varchar(200),
    in id_collezione integer unsigned)
BEGIN
	DECLARE id_coll integer unsigned;
    DECLARE visibilita boolean;
    DECLARE id_condivide integer unsigned;
    
	DECLARE EXIT HANDLER FOR SQLSTATE "45000" BEGIN RESIGNAL; END;
    
    SELECT c.id FROM collezionista c WHERE c.nickname = nickname AND c.email = email INTO id_coll;
    SELECT c.id_collezionista,c.visibilita FROM collezione_di_dischi c WHERE c.id = id_collezione INTO id_condivide,visibilita;
    
    IF(id_coll = id_condivide)
    THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "Non si può condividere con se stessi";
	END IF;
    IF(visibilita = false) 
	THEN
		INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (id_coll,id_collezione);
	ELSE 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "La collezione è gia pubblica";
	END IF;
END$

CREATE PROCEDURE cambia_visibilita(in id_collezione integer unsigned)
BEGIN
	DECLARE newVis boolean;
    
    SELECT visibilita FROM collezione_di_dischi WHERE id = id_collezione INTO newVis;
	UPDATE collezione_di_dischi SET visibilita = not newVis WHERE id=id_collezione;
END$

# 4. Rimozione di un disco dalla collezione
CREATE PROCEDURE rimuovi_disco(in id_disco integer unsigned)
BEGIN
	DELETE FROM disco WHERE id = id_disco;
END$

# 5. Rimozione di una collezione
CREATE PROCEDURE rimuovi_collezione(in id_collezione integer unsigned)
BEGIN
	DELETE FROM collezione_di_dischi WHERE id= id_collezione;
END$

# 6.Lista di tutti i dischi in una collezione
CREATE PROCEDURE dischi_in_collezione(in id_collezione integer unsigned)
BEGIN
	SELECT d.id as "ID",
		   d.titolo as "Titolo",
		   d.anno_di_uscita as "Anno di uscita",
		   d.nome_stato as "Stato",
		   d.nome_formato as "Formato",
		   e.nome as "Etichetta",
           generi_disco(d.id) as "Generi", # Funzione per ricavare tutti i generi in un unica riga
           inf.barcode as "Barcode",
           inf.note as "Note",
           inf.numero_copie as "Copie"
	from disco d
    join etichetta e on d.id_etichetta = e.id
    join info_disco inf on inf.id_disco = d.id
    where d.id_collezione_di_dischi = id_collezione;
END$

#Funzione che ritorna tutti i generi di un disco in un unica concatenazione da usare in altre query
CREATE FUNCTION generi_disco(id_disco integer unsigned) 
RETURNS varchar(200) DETERMINISTIC
BEGIN
	RETURN (SELECT group_concat(g.nome separator ", ") 
			FROM classificazione c
			JOIN genere g ON c.nome_genere = g.nome
			WHERE c.id_disco = id_disco);
END$

# 7. Track list di un disco.
CREATE PROCEDURE track_list_disco(id_disco integer unsigned)
BEGIN
	SELECT t.titolo as "Titolo traccia",t.durata as "Durata" FROM traccia t WHERE t.id_disco=id_disco;
END$

# PROF LE VOGLIAMO BENE (CAPIRÀ PERCHÈ PIÙ AVANTI)
/* 8. Ricerca di dischi in base a nomi di autori/compositori/interpreti e/o titoli. 
Si potrà decidere di includere nella ricerca le collezioni di un certo collezionista 
e/o quelle condivise con lo stesso collezionista e/o quelle pubbliche. 
(Suggerimento: potete realizzare diverse query in base alle varie combinazioni di criteri
 di ricerca. Usate la UNION per unire i risultati delle ricerche effettuate sulle collezioni
 private, condivise e pubbliche)
 
 La seguente query si articola così:
 1. Ricerca in collezioni personale, condivise e pubbliche
	1.1 Ricerca con nome d'arte e con titolo
    1.2 Ricerca con titolo
	1.3 Ricerca con nome d'arte
 2. Ricerca in collezioni personali e condivise
	2.1 Ricerca con nome d'arte e con titolo
    2.2 Ricerca con titolo
	2.3 Ricerca con nome d'arte
 3. Ricerca in collezioni personali e pubbliche
	3.1 Ricerca con nome d'arte e con titolo
    3.2 Ricerca con titolo
	3.3 Ricerca con nome d'arte
 4. Ricerca in collezioni pubbliche e condivise
	4.1 Ricerca con nome d'arte e con titolo
    4.2 Ricerca con titolo
	4.3 Ricerca con nome d'arte
 5. Ricerca in collezioni personali
	5.1 Ricerca con nome d'arte e con titolo
    5.2 Ricerca con titolo
	5.3 Ricerca con nome d'arte
 6. Ricerca in collezioni condivise
	6.1 Ricerca con nome d'arte e con titolo
    6.2 Ricerca con titolo
	6.3 Ricerca con nome d'arte
 7. Ricerca in collezioni pubbliche 
	7.1 Ricerca con nome d'arte e con titolo
    7.2 Ricerca con titolo
	7.3 Ricerca con nome d'arte
    
  In questo modo vengono coperte tutte le possibili combinazioni di ricerca 
*/
CREATE PROCEDURE ricerca_di_dischi_con_autore_eo_titolo(
	in nomedarte varchar(100),
    in titolo varchar(50),
    in id_collezionista integer unsigned, 
    in collezioni boolean,
    in condivise boolean,
    in pubbliche boolean)
BEGIN
	IF(pubbliche AND condivise AND collezioni) THEN
    
		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di un disco in collezioni personali dato l'id del 
				collezionista, il nome d'arte dell'autore e il titolo*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION (/* Ricerca di un disco in collezioni pubbliche dato l'id del 
						collezionista, il nome d'arte dell'autore e il titolo */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION (/* Ricerca di un disco in collezioni condivise con il collezionista 
						dato l'id del collezionista, il nome d'arte dell'autore e il titolo */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
                JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
        ELSE        
		/* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di un disco in collezioni personali dato l'id del 
				collezionista e il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di un disco in collezioni pubbliche dato l'id del 
					collezionista e il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di un disco in collezioni condivise con il collezionista dato 
					l'id del collezionista e il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
		ELSE
        
        /* Se il nomedarte è null */
        IF(nomedarte is null) THEN
			( /* Ricerca di un disco in collezioni personali dato l'id del 
				collezionista e il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di un disco in collezioni pubbliche dato l'id del 
					collezionista e il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di un disco in collezioni condivise con il collezionista dato 
					l'id del collezionista e il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND d.titolo LIKE titolo
            );
		END IF;
        END IF;
        END IF;
        
    ELSE IF(condivise and collezioni) THEN
    
		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di dischi in collezioni personali dato l'id del collezionista
					e il nome dell'autore e il titolo del disco*/
					SELECT d.titolo as "Titolo",
						   d.anno_di_uscita as "Anno di uscita", 
						   d.nome_formato as "Formato", 
						   d.nome_stato as "Condizioni", 
						   cd.nome as "Collezione", 
						   co.nickname as "Proprietario"
					FROM disco d
					JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
					JOIN incide i on d.id=i.id_disco
					JOIN autore a on i.id_autore=a.id
					JOIN collezionista co on cd.id_collezionista=co.id
					WHERE cd.id_collezionista = id_collezionista
					AND a.nome_darte LIKE nomedarte
					AND d.titolo LIKE titolo
				) UNION (/* Ricerca di dischi in collezioni condivise con il collezionista dato l'id 
							del collezionista e il nome dell'autore e il titolo del disco*/
					SELECT d.titolo as "Titolo",
						   d.anno_di_uscita as "Anno di uscita", 
						   d.nome_formato as "Formato", 
						   d.nome_stato as "Condizioni", 
						   cd.nome as "Collezione", 
						   co.nickname as "Proprietario"
					FROM condivisa c
					JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
					JOIN disco d ON d.id_collezione_di_dischi=cd.id
					JOIN incide i ON i.id_disco=d.id
					JOIN autore a ON i.id_autore=a.id
					JOIN collezionista co ON cd.id_collezionista=co.id
					WHERE c.id_collezionista=id_collezionista
					AND a.nome_darte LIKE nomedarte
					AND d.titolo LIKE titolo
				);
		ELSE 
		/* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni personali dato l'id del collezionista
				e il nome dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd on d.id_collezione_di_dischi=cd.id
				JOIN incide i on d.id=i.id_disco
				JOIN autore a on i.id_autore=a.id
				JOIN collezionista co on cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di dischi in collezioni condivise con il collezionista dato l'id 
						del collezionista e il nome dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni",
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
		ELSE
        
        /* Se il nomedarte è null */
        IF(nomedarte is null) THEN
			( /* Ricerca di dischi in collezioni personali dato l'id del collezionista
				e il nome dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd on d.id_collezione_di_dischi=cd.id
				JOIN incide i on d.id=i.id_disco
				JOIN autore a on i.id_autore=a.id
				JOIN collezionista co on cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di dischi in collezioni condivise con il collezionista dato l'id 
						del collezionista e il nome dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni",
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND d.titolo LIKE titolo
            );
		END IF;
		END IF;
        END IF;

    ELSE IF(pubbliche AND collezioni) THEN

		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore e il
				titolo del disco */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore e il
						titolo del disco */
				SELECT d.titolo as "Titolo",
					d.anno_di_uscita as "Anno di uscita", 
                    d.nome_formato as "Formato",
                    d.nome_stato as "Condizioni", 
                    cd.nome as "Collezione", 
                    co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista as co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		ELSE 

		/* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista as co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            );
		ELSE
        
		/* Se il nomedarte è null */
		IF(nomedarte is null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista as co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND d.titolo LIKE titolo
            );
		END IF;
		END IF;
        END IF;
        
    ELSE IF(pubbliche AND condivise) THEN

		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore e il 
				titolo del disco */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd on d.id_collezione_di_dischi=cd.id
				JOIN incide i on d.id=i.id_disco
				JOIN autore a on i.id_autore=a.id
				JOIN collezionista co on cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION  (/* Ricerca di dischi condivisi con il collezionista dato il nome d'arte
						dell'autore e il titolo del disco*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		ELSE 

		/* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
                JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di dischi in collezioni condivise con il collezionista dato il 
						nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni",
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
		ELSE
        
        /* Se il domedarte è null */
		IF(nomedarte is null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
                JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di dischi in collezioni condivise con il collezionista dato il 
						nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni",
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND d.titolo LIKE titolo
            );
		END IF;
        END IF;
        END IF;
        
    ELSE IF(collezioni) THEN

		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore
				e il titolo*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione",
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		ELSE
        
        /* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
		ELSE 
        
        /* Se il nomedarte è null */
        IF(nomedarte is null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND d.titolo LIKE titolo
            );
		END IF;
        END IF;
        END IF;
        
    ELSE IF(condivise) THEN

		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di dischi in collezioni condivise con il collezionista dato
				il nome dell'autore e il titolo*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		ELSE

		/* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni condivise con il collezionista dato
				il nome dell'autore*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita", 
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE
        
        /* Se il nomedarte è null */
		IF(nomedarte is null) THEN
			( /* Ricerca di dischi in collezioni condivise con il collezionista dato
				il nome dell'autore*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita", 
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND d.titolo LIKE titolo
            );
			
		END IF;
        END IF;
        END IF;
        
	ELSE IF(pubbliche) THEN

		/* Se il nomedarte e il titolo sono entrambi not null*/
        IF(titolo is not null and nomedarte is not null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore
				e il titolo del disco*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		ELSE

		/* Se il titolo è null */
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato",
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            );
		ELSE

		/* Se il nomedarte è null */
		IF(nomedarte is null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato",
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND d.titolo LIKE titolo
            );
			
		END IF;
        END IF;
        END IF;
        
	END IF;
	END IF;
	END IF;
	END IF;
	END IF;
	END IF;
	END IF;
END$

/* 9. Verifica della visibilità di una collezione da parte di un collezionista. 
   (Suggerimento: una collezione è visibile a un collezionista se è sua, condivisa con lui o pubblica)
*/
CREATE PROCEDURE verifica_visibilita_collezione(
	in id_collezione_di_dischi integer unsigned, 
	in id_collezionista integer unsigned)
BEGIN
	(/* Verifica della visibiltà per collezioni personali */
		SELECT cd.id as "Visibilità"
		FROM collezione_di_dischi cd
		WHERE cd.id=id_collezione_di_dischi
		AND cd.id_collezionista=id_collezionista 
	) UNION (/* Verifica della visibilità per collezioni pubbliche */
		select cd.id as "Visibilità"
		from collezione_di_dischi as cd
		where cd.id=id_collezione_di_dischi
			and cd.visibilita=true
	) UNION (/* Verifica della visibilità per collezioni condivise */
		SELECT c.id_collezione as "Visibilità"
		FROM condivisa c
		WHERE c.id_collezione=id_collezione_di_dischi
		AND c.id_collezionista=id_collezionista
	);
    
END$

/* 10. Numero dei brani (tracce di dischi) distinti di un certo autore (compositore, musicista) 
  presenti nelle collezioni pubbliche.
*/
CREATE FUNCTION conta_brani(nome_darte varchar(200))
RETURNS integer unsigned DETERMINISTIC
BEGIN

	DECLARE numero_brani integer unsigned;
    
    SET numero_brani = (
		SELECT count(distinct t.id)
		FROM autore a
		JOIN produce p ON p.id_autore=a.id
		JOIN traccia t ON t.id=p.id_traccia
		JOIN disco d ON d.id=t.id_disco
		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
		WHERE c.visibilita=true 
		AND a.nome_darte LIKE nome_darte
		GROUP BY a.id);
	
    # Se numer_brani è null, ritorna 0, altrimenti il numero di brani
    IF(numero_brani is null) THEN
		RETURN 0;
	ELSE
		RETURN numero_brani;
	END IF;
    
END$

/* 11. Minuti totali di musica riferibili a un certo autore (compositore, musicista) memorizzati nelle
 collezioni pubbliche.
*/
CREATE FUNCTION conta_minuti_autore(nome_darte varchar(100))
RETURNS decimal(10,2) DETERMINISTIC
BEGIN 

	DECLARE minutaggio_totale decimal(10,2);
	
    SET minutaggio_totale = (
		SELECT sum(distinct t.durata)
		FROM autore a
		JOIN produce p ON p.id_autore=a.id
		JOIN traccia t ON t.id=p.id_traccia
		JOIN disco d ON d.id=t.id_disco
		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
		WHERE c.visibilita=true 
		AND a.nome_darte=nome_darte
		GROUP BY a.id);
            
	RETURN minutaggio_totale;

END$

/* 12. Statistiche (una query per ciascun valore): numero di collezioni di ciascun collezionista,
   numero di dischi per genere nel sistema.
*/
CREATE PROCEDURE conta_collezioni()
BEGIN
	SELECT c.nickname as "Collezionista" , 
		   count(cd.id) as "Numero di Collezioni"
    FROM collezione_di_dischi cd
	RIGHT JOIN collezionista c ON cd.id_collezionista=c.id
    GROUP BY c.nickname
    ORDER BY Collezionista ASC;
    
END$


CREATE PROCEDURE conta_dischi_per_genere()
BEGIN

	SELECT c.nome_genere as "Genere" , 
		   count(c.id_disco) as "Numero di Dischi"
    FROM classificazione c
    GROUP BY c.nome_genere;
    
END$

DELIMITER ;

--
-- Dropping existing views
--

DROP VIEW IF EXISTS condivisione_collezioni;
DROP VIEW IF EXISTS info_band;
DROP VIEW IF EXISTS info_collezioni;

--
-- Creating databases views
--

CREATE VIEW condivisione_collezioni as
SELECT cd.id, coll2.nickname as proprietario, cd.nome, c.nickname as 'condivisa con' 
	FROM collectors.condivisa con
	JOIN collezionista c on c.id=con.id_collezionista
    JOIN collezione_di_dischi cd on cd.id=con.id_collezione
    JOIN collezionista coll2 on coll2.id=cd.id_collezionista
ORDER BY CD.ID asc;

CREATE VIEW info_band as
SELECT b.id, ak.nome_darte, 
	b.data_fondazione,
    ars.nome as nome_fondatore,
    ars.cognome as cognome_fondatore, 
	a.nome_darte as nome_arte_fondatore,
    au.nome_darte as membro
    FROM band b 
	JOIN artista_singolo ars on b.id_fondatore=ars.id 
	JOIN autore a on ars.id_autore=a.id
	JOIN autore ak on ak.id=b.id_autore
	JOIN costituito c on c.id_band=b.id
    JOIN artista_singolo ars1 on ars1.id=c.id_artista
    JOIN autore au on au.id=ars1.id_autore
ORDER BY b.id ASC;

CREATE VIEW info_collezioni AS
SELECT c.id, c.nome, c.visibilita, ca.nickname, ca.email
	FROM collezione_di_dischi c
	JOIN collezionista ca ON ca.id=c.id_collezionista
ORDER BY c.id DESC;

-- --------------------------------------------------------
-- TEST DATA
-- --------------------------------------------------------

INSERT INTO genere(nome) VALUES ("Rock");
INSERT INTO genere(nome) VALUES ("Pop");
INSERT INTO genere(nome) VALUES ("Rap");
INSERT INTO genere(nome) VALUES ("Indie");
INSERT INTO genere(nome) VALUES ("Metal");
INSERT INTO genere(nome) VALUES ("Cantautorato");

INSERT INTO formato(nome) VALUES ("Vinile");
INSERT INTO formato(nome) VALUES ("CD");
INSERT INTO formato(nome) VALUES ("Digitale");

#Una persona potrebbe avere più di un ruolo? (es. cantante, musicista e proprietario)
INSERT INTO ruolo(nome) VALUES ("Cantante");
INSERT INTO ruolo(nome) VALUES ("Featuring");
INSERT INTO ruolo(nome) VALUES ("Musicista");
INSERT INTO ruolo(nome) VALUES ("Proprietario");

INSERT INTO stato(nome) VALUES ("Perfetto");
INSERT INTO stato(nome) VALUES ("Buono");
INSERT INTO stato(nome) VALUES ("Usurato");
INSERT INTO stato(nome) VALUES ("Molto rovinato");

INSERT INTO tipologia(nome) VALUES ("Copertina");
INSERT INTO tipologia(nome) VALUES ("Retro");
INSERT INTO tipologia(nome) VALUES ("Facciata interna");
INSERT INTO tipologia(nome) VALUES ("Libretto");

INSERT INTO etichetta(nome, partitaIVA) VALUES ("Universal Music Italia", "03802730154");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Capitol Records", "08288100962");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Sony Music", "08072811006");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Warner Music Italy", "02079400152");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Virgin Records", "11186180151");

INSERT INTO autore(nome_darte, tipo) VALUES ("Pink Floyd", true); #capitol
INSERT INTO autore(nome_darte, tipo) VALUES ("Marracash", false); #universal
INSERT INTO autore(nome_darte, tipo) VALUES ("Rino Gaetano", false); #sony
INSERT INTO autore(nome_darte, tipo) VALUES ("Linkin Park", true); #warner
INSERT INTO autore(nome_darte, tipo) VALUES ("The Rolling Stones", true); #virgin
INSERT INTO autore(nome_darte, tipo) VALUES ("Syd", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Chester Bennington",false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Brian Jones",false);
INSERT INTO autore(nome_darte,tipo) VALUES ("George Waters", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Nick Mason", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("David Gilmour", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Mike Shinoda", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Rob Bourdon", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Mr.Hahn", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Mick", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Ronnie", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Rick Brown", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Marz", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Zef", false);

INSERT INTO collezionista(nickname, email) VALUES ("Michael","michael.piccirilli@student.univaq.it");
INSERT INTO collezionista(nickname, email) VALUES ("Luca", "lucafrancesco.macera@student.univaq.it");
INSERT INTO collezionista(nickname, email) VALUES ("Calogero","calogero.carlino@student.univaq.it");

# visibilità true->pubblica false->privata
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Grandi successi mondiali",1,1);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Migliori hit",1,2);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Collezione personale",0,1);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Mie vibes",1,3);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Collezione segreta",0,2);
INSERT INTO collezione_di_dischi(nome,visibilita, ID_collezionista) VALUES("PRIVATISSIMA",0,3);

# date format YYYY-MM-DD
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("The Dark Side Of The Moon","1973-03-01","Vinile", "Perfetto", 2, 1);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Noi, loro, gli altri", "2021-11-19","Digitale","Perfetto",1,3);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Aida","1977-05-24","Vinile","Usurato",3,4);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Meteora","2003-03-25","CD","Buono",4,5);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Stripped","1995-11-13","CD","Molto Rovinato",5,2);

INSERT INTO info_disco(id_disco, barcode, note) 
	VALUES (1, "500902945325", "Rappresenta uno dei dischi più belli della storia della musica");
INSERT INTO info_disco(id_disco, barcode) 
	VALUES (3, "900393283831");
INSERT INTO info_disco(id_disco, note) 
	VALUES (2,"Un grande classico del rap italiano");
INSERT INTO info_disco(id_disco, barcode, note) 
	VALUES (4, "900384822842", "Meteora rappresenta la storia del Metal e di una generazione crescita a cavallo degli anni 2000");
INSERT INTO info_disco(id_disco, barcode, numero_copie) 
	VALUES (5, "688848392234",2);
    
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("TDSOTM_cover.jpeg","Copertina dell'album The Dark Side Of The Moon",1,"Copertina");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("TDSOTM_back.jpeg","Retro dell'album The Dark Side Of The Moon",1,"Retro");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Noi_loro_gli_altri.png","Cover dell'album 'Noi, loro, gli altri'",2,"Copertina");
INSERT INTO immagine(path, id_disco, nome_tipologia) 
	VALUES ("Aida_copertina.jpeg",3,"Copertina");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Meteora_cover.png","Copertina dell'album Meteora",4,"Copertina");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Meteora_facciata1.png","Facciata interna sinistra dell'album Meteora",4,"Facciata interna");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Meteora_facciata2.png","Facciata interna destra dell'album Meteora",4,"Facciata interna");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Stripped.svg","Cover di Stripped by The Rolling Stones",5,"Copertina");
INSERT INTO immagine(path, id_disco, nome_tipologia) 
	VALUES ("Stripped_lib.svg",5,"Libretto");
INSERT INTO immagine(path, id_disco, nome_tipologia) 
	VALUES ("Stripped_lib2.svg",5,"Libretto");
    
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Breathe (In The Air)",2.49, 2, 1);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Time",7.02, 2, 1);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Dubbi", 3.54, 1, 2);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Importante",3.21,1,2);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Crazy Love",3.12,1,2);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Aida",4.25,3,3);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Spendi Spandi Effendi",4.01,3,3);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Numb",3.05,4,4);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Faint",2.42,4,4);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Breaking The Habit",3.16,4,4);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Sweet Virgina",4.15,5,5);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Like A Rolling Stones",5.38,5,5);
    
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Fabio","Bartolo Rizzo", "1979-05-22","Nicosia",2);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Salvatore Antonio","Gaetano", "1950-11-22","Crotone",3);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Roger Keith","Barrett", "1946-01-06","Cambridge",6);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Chester Charles","Bennington", "1976-03-20","Phoenix",7);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Lewis Brian","Hopkin Jones", "1942-02-28","Cheltenham",8);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("George Roger","Waters", "1943-09-06","Great Bookham",9);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Nicholas Berkeley","Mason", "1944-01-27","Birmingham",10);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("David Jon","Gilmour", "1946-03-06","Cambridge",11);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Michael Kenji","Shinoda", "1977-02-11","Los Angeles",12);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Robert Gregory","Bourdon", "1979-01-10","Calabasas",13);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Joseph","Hahn", "1977-03-15","Dallas",14);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Michael Philip","Jagger", "1943-07-26","Dartford",15);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Ronald David","Wood", "1947-06-01","Londra",16);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Ricky","Fenson", "1945-05-22","Chopwell",17);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Alessandro","Pulga", "1990-04-15","Cormano",18);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Stefano","Tognini", "1990-10-24","Sondrio",19);

INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(3,"1965-04-30",1);
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(4,"1996-05-18",4);
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(5,"1962-07-12",5);
    
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (1,5);
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (3,5);
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (2,3);

#pink floyd
INSERT INTO costituito(id_band,id_artista) VALUES (1,6);
INSERT INTO costituito(id_band,id_artista) VALUES (1,7);
INSERT INTO costituito(id_band,id_artista) VALUES (1,8);

#linkin park
INSERT INTO costituito(id_band,id_artista) VALUES (2,9);
INSERT INTO costituito(id_band,id_artista) VALUES (2,10);
INSERT INTO costituito(id_band,id_artista) VALUES (2,11);

#the rolling stones
INSERT INTO costituito(id_band,id_artista) VALUES (3,12);
INSERT INTO costituito(id_band,id_artista) VALUES (3,13);
INSERT INTO costituito(id_band,id_artista) VALUES (3,14);

#pink floyd
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(1,1,"Proprietario"); #breathe
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(1,1,"Cantante"); #breathe
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(1,1,"Musicista"); #breathe
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(2,1,"Proprietario"); #time
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(2,1,"Cantante"); #time
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(2,1,"Musicista"); #time

#marracash
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,2,"Proprietario"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,2,"Cantante"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,15,"Musicista"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,16,"Proprietario"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,2,"Proprietario"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,2,"Cantante"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,15,"Musicista"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,16,"Musicista"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,2,"Proprietario"); #crazy love
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,2,"Cantante"); #crazy love
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,15,"Musicista"); #crazy love
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,16,"Musicista"); #crazy love

#Rino Gaetano
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(6,3,"Proprietario"); #aida
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(6,3,"Cantante"); #aida
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(6,3,"Musicista"); #aida
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(7,3,"Proprietario"); #spendi spandi effendi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(7,3,"Cantante"); #spendi spandi effendi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(7,3,"Musicista"); #spendi spandi effendi

#Linkin Park
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(8,4,"Proprietario"); #numb
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(8,4,"Cantante"); #numb
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(8,4,"Musicista"); #numb
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(9,4,"Proprietario"); #faint
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(9,4,"Cantante"); #faint
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(9,4,"Musicista"); #faint
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(10,4,"Proprietario"); #breaking the habit
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(10,4,"Cantante"); #breaking the habit
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(10,4,"Musicista"); #breaking the habit

#Rolling stones
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(11,5,"Proprietario"); #sweet virgina
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(11,5,"Cantante"); #sweet virgina
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(11,5,"Musicista"); #sweet virgina
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(12,5,"Proprietario"); #like a rolling stones
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(12,5,"Cantante"); #like a rolling stones
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(12,5,"Musicista"); #like a rolling stones

INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rock",1); #the dark side of the moon
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rap",2); #noi, loro, gli altri
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Pop",3); #aida
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Cantautorato",3); #aida
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Metal",4); #meteora
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rap",4); #meteora
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rock",4); #meteora
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rock",5); #stripped

INSERT INTO incide(id_disco,id_autore) VALUES(1,1);
INSERT INTO incide(id_disco,id_autore) VALUES(2,2);
INSERT INTO incide(id_disco,id_autore) VALUES(3,3);
INSERT INTO incide(id_disco,id_autore) VALUES(4,4);
INSERT INTO incide(id_disco,id_autore) VALUES(5,5);

-- --------------------------------------------------------
-- QUERIES
-- --------------------------------------------------------

# Abbiamo realizzato le query sotto forma di procedure e funzioni (righe 450-1440)