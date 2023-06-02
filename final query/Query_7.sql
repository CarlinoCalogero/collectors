# 7. Track list di un disco.

DROP PROCEDURE IF EXISTS track_list_disco;

DELIMITER $

CREATE PROCEDURE track_list_disco(id_disco integer unsigned)
BEGIN
	SELECT t.titolo as "Titolo traccia",t.durata as "Durata" FROM traccia t WHERE t.id_disco=id_disco;
END$

DELIMITER ;