# Aggiunta di nuove condivisioni a una collezione privata.
DELIMITER $

DROP PROCEDURE IF EXISTS aggiungi_condivisione$

CREATE PROCEDURE aggiungi_condivisione(
	in nickname_from varchar(100),
	in email_from varchar(200),
	in nome_collezione varchar(200),
	in nickname_to varchar(100),
	in email_to varchar(200)
)
BEGIN 
	DECLARE id_collezionista_from integer unsigned;
    DECLARE id_collezionista_to integer unsigned;
    DECLARE id_collezione integer unsigned;
    DECLARE visibilita boolean;
    
    #Cerco l'utente che condivide
    SET id_collezionista_from = (
		SELECT c.id
        FROM collezionista c
        WHERE nickname_from=c.nickname
        AND email_from=c.email
    );
    
    IF(id_collezionista_from is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali dell'utente che condivide errate!";
	END IF;
    
    #Cerco la collezione da condividere
	SELECT c.id,c.visibilita
    INTO id_collezione,visibilita
    FROM collezione_di_dischi c
	WHERE c.nome=nome_collezione
	AND c.id_collezionista=id_collezionista;
    
    IF(id_collezione is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nessuna collezione trovata associata a questo utente!";
	END IF;
    
    #Cerco l'utente che riceverà la condivisone
    SET id_collezionista_to = (
		SELECT c.id
        FROM collezionista c
        WHERE nickname_to=c.nickname
        AND email_to=c.email
    );
    
    IF(id_collezionista_to is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali dell'utente con cui condividere errate!";
	END IF;

	#Verifico che la visibilità della collezione da convidere sia privata
    IF(visibilita is true) THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="La collezione è già pubblica!";
	END IF;
    
    INSERT condivisa(id_collezionista,id_collezione) VALUES (id_collezionista_to,id_collezione);
    
END$

DELIMITER ;