DELIMITER $

DROP PROCEDURE IF EXISTS aggiungi_collezione;
CREATE PROCEDURE aggiungi_collezione(
	in nome_collezione varchar(200),
    in nickname varchar(100),
    in email varchar(200),
    in visibilita boolean)
    
BEGIN 
	DECLARE id_collezionista integer unsigned;
    
	SET id_collezionista = (
		SELECT c.id 
		FROM collectors.collezionista c 
        WHERE c.email=email 
		AND c.nickname=nickname);
	
    IF (id_collezionista is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nome utente o email errate!";
    END IF;
    
	INSERT INTO collectors.collezione_di_dischi(`nome`,`visibilita`,`id_collezionista`) 
		VALUES (nome_collezione,visibilita,id_collezionista);
END$
DELIMITER ;	