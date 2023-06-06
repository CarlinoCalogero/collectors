# 5. Rimozione di una collezione

DROP PROCEDURE IF EXISTS rimuovi_collezione;

DELIMITER $

CREATE PROCEDURE rimuovi_collezione(in id_collezione integer unsigned)
BEGIN
	DELETE FROM collezione_di_dischi WHERE id= id_collezione;
END$

DELIMITER ;