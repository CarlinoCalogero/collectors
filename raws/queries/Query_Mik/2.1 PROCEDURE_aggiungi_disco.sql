DELIMITER $

DROP PROCEDURE IF EXISTS aggiungi_disco$

# Aggiunta di dischi a una collezione
CREATE PROCEDURE aggiungi_disco(
	in nickname varchar(100),
	in email varchar(200),
    in nome_collezione varchar(200),
	in titolo varchar(50),
	in anno_di_uscita date,
	in nome_formato varchar(50),
	in nome_stato varchar(50),
	in partitaIVA varchar(11),
	in barcode varchar(200),
	in note text,
	in numero_copie integer unsigned)
BEGIN
	DECLARE id integer unsigned;
    DECLARE id_etichetta integer unsigned;
    DECLARE id_collezione_di_dischi integer unsigned;
    
    SET id_etichetta = (
		SELECT e.id
		FROM etichetta e
		WHERE e.partitaIVA=partitaIVA
    );
    IF(id_etichetta is null) THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="La partita IVA specificata non esiste o è errata!";
	END IF;
    
    SET id_collezione_di_dischi = (
		SELECT c.id
        FROM collezione_di_dischi c
        JOIN collezionista coll ON c.id_collezionista=coll.id
        WHERE c.nome=nome_collezione
		AND coll.nickname=nickname
        AND coll.email=email
    );
    
    IF(id_collezione_di_dischi is null) THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali utente errate o inesistenti!"; 
	END IF;
    
    # Controllo che il disco non sia già presente
    SET id = (
		SELECT d.id
		FROM disco d
		WHERE d.titolo=titolo
		AND d.anno_di_uscita=anno_di_uscita 
		AND d.nome_formato=nome_formato 
		AND d.nome_stato=nome_stato
		AND d.id_etichetta=id_etichetta
		AND d.id_collezione_di_dischi=id_collezione_di_dischi);
		
    IF(id is null) THEN
		# Crea il disco
        START TRANSACTION; # Per evitare race condition con last_insert_id()
        INSERT INTO disco(`titolo`,`anno_di_uscita`,`nome_formato`,`nome_stato`,`id_etichetta`,`id_collezione_di_dischi`) 
        VALUES (titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi);
        INSERT INTO info_disco(`id_disco`,`barcode`, `note`,`numero_copie`) VALUES (last_insert_id(),barcode,note,numero_copie);
        COMMIT;
	ELSE
		#Il disco esiste con tutte le condizioni specificate sopra, incremento il numero di copie
        UPDATE info_disco info
        SET info.numero_copie=info.numero_copie+numero_copie
		WHERE info.id_disco=id;
    END IF;
END$

DELIMITER ;