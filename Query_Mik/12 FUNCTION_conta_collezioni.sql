# Statistiche (una query per ciascun valore): numero di collezioni di ciascun collezionista,
# numero di dischi per genere nel sistema.

DELIMITER $

DROP FUNCTION IF EXISTS conta_collezioni$
	
CREATE FUNCTION conta_collezioni(id_collezionista integer unsigned) 
RETURNS integer unsigned DETERMINISTIC

BEGIN

	DECLARE numero_collezioni integer unsigned;
    
    SET numero_collezioni = (
			SELECT count(c.id)
            FROM collezione_di_dischi c 
            JOIN collezionista coll ON c.id_collezionista=coll.id
			WHERE coll.id=id_collezionista);

	RETURN numero_collezioni;
END$

DELIMITER ;
