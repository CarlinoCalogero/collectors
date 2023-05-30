# Modifica dello stato di pubblicazione di una collezione (da privata a pubblica e viceversa) e
# aggiunta di nuove condivisioni a una collezione.
DELIMITER $

DROP PROCEDURE IF EXISTS cambia_visibilita$

CREATE PROCEDURE cambia_visibilita(
	in nome varchar(200), 
    in nickname varchar(100),
	in email varchar(200)
)
BEGIN
	DECLARE id_utente integer unsigned;
    DECLARE id_collezione integer unsigned;
    DECLARE visibilita boolean;
    
	#Cerco l'utente
	SET id_utente = (
		SELECT c.id
        FROM collezionista c
        WHERE c.nickname=nickname
        AND c.email=email
    );
    IF(id_utente is null) THEN SIGNAL SQLSTATE "45000" 
		SET MESSAGE_TEXT = "Credenziali utente errate o inesistenti!";
	END IF;
    
    #Cerco la visibilità della collezione
	SELECT c.visibilita, c.id
    INTO visibilita, id_collezione
	FROM collezione_di_dischi c
	WHERE c.nome=nome
	AND c.id_collezionista=id_utente;
    
    # Se la collezione è privata devo metterla pubblica e cancellare i record di condivisione
    IF(visibilita=false) THEN
		UPDATE collezione_di_dischi c
        SET c.visibilita=true
		WHERE c.id=id_collezione;
        
        DELETE FROM condivisa cond
		WHERE cond.id_collezione=id_collezione;
	ELSE 
		#Se la collezione è pubblica devo metterla privata
        UPDATE collezione_di_dischi c
        SET c.visibilita=false
		WHERE c.id=id_collezione;
    END IF;
END$

DELIMITER ;