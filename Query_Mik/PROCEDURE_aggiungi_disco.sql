DELIMITER $

# Aggiunta di dischi a una collezione
CREATE PROCEDURE aggiungi_disco(
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
	DECLARE id integer unsigned;
    
    # Controllo che il disco non sia già presente
    SET id = (SELECT d.id
    FROM disco d
	WHERE d.titolo=titolo
    AND d.anno_di_uscita=anno_di_uscita 
    AND d.nome_formato=nome_formato 
    AND d.nome_stato=nome_stato
    AND d.id_etichetta=id_etichetta
    AND d.collezionista=d.collezionista);
    
    IF(id is null) THEN
		# Crea il disco
        START TRANSACTION; # Per evitare race condition con last_insert_id()
        INSERT INTO disco(`titolo`,`anno_di_uscita`,`nome_formato`,`nome_stato`,`id_etichetta`,`id_collezionista`) 
        VALUES (titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezionista);
        INSERT INTO info_disco(`id_disco`,`barcode`, `note`) VALUES (last_insert_id(),barcode,note);
        COMMIT;
	ELSE
		#Il disco esiste con tutte le condizioni specificate sopra, incremento il numero di copie
        UPDATE info_disco info
        SET info.numero_copie=info.numero_copie+1
		WHERE info.id=id;
    END IF;
END$

DELIMITER ;