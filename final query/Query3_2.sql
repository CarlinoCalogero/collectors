<<<<<<< HEAD
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
    
    DECLARE errore_pubblica CONDITION FOR SQLSTATE "45000";
    DECLARE errore_autocondivisione CONDITION FOR SQLSTATE "45000";
    
	DECLARE EXIT HANDLER FOR SQLSTATE "45000" BEGIN RESIGNAL; END;
    
    SELECT c.id FROM collezionista c WHERE c.nickname = nickname AND c.email = email INTO id_coll;
    SELECT c.id_collezionista FROM collezione_di_dischi c WHERE c.id = id_collezione INTO id_condivide;
    
    IF(id_coll = id_condivide)
    THEN
		SIGNAL errore_autocondivisione SET MESSAGE_TEXT = "Non si può condividere con se stessi";
	END IF;
    
    SELECT coll.visibilita FROM collezione_di_dischi coll WHERE coll.id = id_collezione INTO visibilita;
    IF(visibilita = false) 
	THEN
		INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (id_coll,id_collezione);
	ELSE 
		SIGNAL errore_pubblica SET MESSAGE_TEXT = "La collezione è gia pubblica";
	END IF;
END$

CREATE PROCEDURE cambia_visibilita(in id_collezione integer unsigned)
BEGIN
	DECLARE newVis boolean;
    
    SELECT visibilita FROM collezione_di_dischi WHERE id = id_collezione INTO newVis;
	UPDATE collezione_di_dischi SET visibilita = not newVis WHERE id=id_collezione;
END$

=======
#Aggiunta di nuove condivisioni
drop procedure if exists insert_condivisione;
delimiter $
create procedure insert_condivisione(in nickname varchar(100),in email varchar(200),in id_collezione integer unsigned)
begin
	declare id_coll integer unsigned;
    declare visibilita boolean;
    declare id_condivide integer unsigned;
	declare exit handler for sqlstate "45000" begin resignal; end;
    select c.id from collezionista c where c.nickname = nickname and c.email = email into id_coll;
    select c.id_collezionista from collezione_di_dischi c where c.id = id_collezione into id_condivide;
    if(id_coll = id_condivide)
    then
		signal sqlstate "45000" set message_text = "Non si può condividere con se stessi";
	end if;
    select coll.visibilita from collezione_di_dischi coll where coll.id = id_collezione into visibilita;
    if(visibilita = false) 
	then
		insert into condivisa(id_collezionista,id_collezione) values(id_coll,id_collezione);
	else 
		signal sqlstate "45000" set message_text = "La collezione è gia pubblica";
	end if;
end$
>>>>>>> 506cd72488c47b6506090ed90afc530efe0c0080
delimiter ;