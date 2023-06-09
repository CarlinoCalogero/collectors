# 2. Aggiunta di dischi a una collezione e di tracce a un disco.
USE collectors;
DROP PROCEDURE IF EXISTS aggiungi_disco_a_collezione;
DROP PROCEDURE IF EXISTS aggiugi_traccia_a_disco;

DELIMITER $

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

DELIMITER ;