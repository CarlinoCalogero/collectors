# 1. Inserimento di una nuova collezione
USE collectors;
DROP PROCEDURE IF EXISTS insert_collezione;

DELIMITER $

CREATE PROCEDURE insert_collezione(
	in id_collezionista integer unsigned,
    in nome_collezione varchar(200),
    in visibilita boolean)
BEGIN
    INSERT INTO collezione_di_dischi(nome,visibilita,id_collezionista) 
    VALUES(nome_collezione,visibilita,id_collezionista);
END$

DELIMITER ;