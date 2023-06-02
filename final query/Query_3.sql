/* 3. Modifica dello stato di pubblicazione di una collezione (da privata a pubblica e viceversa) 
e aggiunta di nuove condivisioni a una collezione.*/

DROP PROCEDURE IF EXISTS inserisci_condivisione;
DROP PROCEDURE IF EXISTS cambia_visibilita;

DELIMITER $

CREATE PROCEDURE inserisci_condivisione(
	in nickname varchar(100),
	in email varchar(200),
    in id_collezione integer unsigned)
BEGIN
	DECLARE id_coll integer unsigned;
    DECLARE visibilita boolean;
    DECLARE id_condivide integer unsigned;
    
	DECLARE EXIT HANDLER FOR SQLSTATE "45000" BEGIN RESIGNAL; END;
    
    SELECT c.id FROM collezionista c WHERE c.nickname = nickname AND c.email = email INTO id_coll;
    SELECT c.id_collezionista FROM collezione_di_dischi c WHERE c.id = id_collezione INTO id_condivide;
    
    IF(id_coll = id_condivide)
    THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "Non si può condividere con se stessi";
	END IF;
    
    SELECT coll.visibilita FROM collezione_di_dischi coll WHERE coll.id = id_collezione INTO visibilita;
    
    IF(visibilita = false) 
	THEN
		INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (id_coll,id_collezione);
	ELSE 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "La collezione è gia pubblica";
	END IF;
END$

CREATE PROCEDURE cambia_visibilita(in id_collezione integer unsigned)
BEGIN
	DECLARE newVis boolean;
    
    SELECT visibilita FROM collezione_di_dischi WHERE id = id_collezione INTO newVis;
	UPDATE collezione_di_dischi SET visibilita = not newVis WHERE id=id_collezione;
END$

DELIMITER ;