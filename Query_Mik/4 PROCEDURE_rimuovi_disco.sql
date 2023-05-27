DELIMITER $
# Rimozione di un disco da una collezione
DROP PROCEDURE IF EXISTS rimuovi_disco;
CREATE PROCEDURE rimuovi_disco(
	in id_disco integer unsigned,
    in nome_collezione varchar(200),
    in nickname varchar(100),
	in email varchar(200)
)
BEGIN
	DECLARE id_collezionista integer unsigned;
    DECLARE id_collezione integer unsigned;
    
    #Cerco l'utente 
    SET id_collezionista = (
		SELECT c.id
        FROM collezionista c
        WHERE nickname=c.nickname
        AND email=c.email
    );
    
    IF(id_collezionista is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali dell'utente errate!";
	END IF;
    
    # Cerco la collezione 
	SET id_collezione = (
		SELECT c.id
		FROM collezione_di_dischi c
		WHERE c.nome=nome_collezione
		AND c.id_collezionista=id_collezionista);
    
    IF(id_collezione is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nessuna collezione con quel nome trovata!";
	END IF;

	DELETE FROM disco d
    WHERE d.id=id_disco AND d.id_collezione_di_dischi=id_collezione;
    
END$

DELIMITER ;