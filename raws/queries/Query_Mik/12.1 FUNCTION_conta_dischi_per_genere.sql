# Statistiche (una query per ciascun valore): numero di collezioni di ciascun collezionista,
# numero di dischi per genere nel sistema

DELIMITER $

DROP FUNCTION IF EXISTS conta_dischi_per_genere$

CREATE FUNCTION conta_dischi_per_genere(genere varchar(50))
RETURNS integer unsigned DETERMINISTIC

BEGIN

	DECLARE genra varchar(50);
    DECLARE numero_dischi integer unsigned;
    
    SET genra = (
		SELECT g.nome
        FROM genere g
        WHERE g.nome=genere
    );

	IF(genra is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il genere inserito non è valido o non esiste";
    END IF;
    
    SET numero_dischi = (
		SELECT count(d.id)
        FROM disco d
        JOIN classificazione cl ON d.id=cl.id_disco
        WHERE cl.nome_genere=genra
    );
    
    RETURN numero_dischi;
    
END$

DELIMITER ;