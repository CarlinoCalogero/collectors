delimiter $$
drop procedure if exists rimuovi_collezione$$
create procedure rimuovi_collezione(id_collezione integer unsigned)
	delete from collezione_di_dischi where id=id_collezione$$
delimiter ;