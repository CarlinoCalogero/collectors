# Verifica della visibilità di una collezione da parte di un collezionista. (Suggerimento: una
# collezione è visibile a un collezionista se è sua, condivisa con lui o pubblica)
DELIMITER $
DROP FUNCTION IF EXISTS verifica_visibilita;
CREATE FUNCTION verifica_visibilita(
	id_collezionista integer unsigned,
	id_collezione integer unsigned) # Usare il nome della collezione non sarebbe bastato, da chiedere al prof
RETURNS boolean DETERMINISTIC 
BEGIN
	DECLARE visibile boolean;
    DECLARE personale boolean;
    DECLARE condivisa boolean;
    
    SET visibile = (
		SELECT c.visibilita 
        FROM collezione_di_dischi c 
        WHERE c.id=id_collezione);
        
	# 1. Verifico se la collezione è pubblica, se si restituisco true
    IF(visibile = true) THEN
		BEGIN
			RETURN true;
		END;
	END IF;
    
    # 2. Verifico se è una mia collezione
    SET personale = (SELECT EXISTS(
		SELECT * 
        FROM collezione_di_dischi c 
        WHERE c.id_collezionista=id_collezionista
        AND c.id=id_collezione)
    );
    
    IF(personale=true) THEN
		BEGIN
			RETURN true; #è una collezione del collezionista IN INPUT
		END;
    END IF;
    
    # 3. Controllo se è una collezione condivisa con me
    SET condivisa = (SELECT EXISTS(
		SELECT * 
        FROM collezione_di_dischi c
        JOIN condivisa cond ON cond.id_collezione=c.id
        JOIN collezionista coll ON coll.id=cond.id_collezionista
        WHERE coll.id=id_collezionista
        AND c.id=id_collezione)
    );
    
    IF(condivisa=true) THEN 
		BEGIN
			RETURN true; #è una collezione condivisa con il collezionista passato
		END;
    END IF;
		
	RETURN false; # La collezione non è nè pubblica, nè mia, nè condivisa con me
	
END$

DELIMITER ;