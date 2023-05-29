DELIMITER $

#Lista di tutti i dischi in una collezione.
DROP PROCEDURE IF EXISTS stampa_disco;
CREATE PROCEDURE stampa_disco(
	in id_disco integer unsigned
)
BEGIN
	SELECT d.*
    FROM disco d
	WHERE d.id=id_disco;
END$

DELIMITER ;