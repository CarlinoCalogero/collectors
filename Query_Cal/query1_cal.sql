DELIMITER $$
drop procedure if exists crea_collezione$$
create procedure crea_collezione(nome varchar(200),visibilita boolean, id_collezionista integer unsigned)
	INSERT INTO collezione_di_dischi (nome,visibilita,id_collezionista) VALUES (nome,visibilita,id_collezionista)$$
DELIMITER ;