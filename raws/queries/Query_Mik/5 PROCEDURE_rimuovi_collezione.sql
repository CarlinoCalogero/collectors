DELIMITER $

#Rimozione di una collezione

DROP PROCEDURE IF EXISTS rimuovi_collezione$

CREATE PROCEDURE rimuovi_collezione(
	in id_collezionista integer unsigned,
    in nome_collezione varchar(200)
)
BEGIN

	DECLARE id_collezione integer unsigned;
    SET id_collezione = (
		SELECT c.id
        FROM collezione_di_dischi c
        WHERE c.nome=nome_collezione
        AND c.id_collezionista=id_collezionista
    );
    
    IF(id_collezione is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nessuna collezioni associata a tale utente!";
    END IF;
    
    DELETE FROM collezione_di_dischi c WHERE c.id=id_collezione;

END$

DELIMITER ;