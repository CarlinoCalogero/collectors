# 4. Rimozione di un disco dalla collezione

DROP PROCEDURE IF EXISTS rimuovi_disco;

DELIMITER $

CREATE PROCEDURE rimuovi_disco(in id_disco integer unsigned)
BEGIN
	DELETE FROM disco WHERE id = id_disco;
END$

DELIMITER ;