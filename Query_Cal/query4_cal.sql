delimiter $$
drop procedure if exists rimuovi_disco_da_collezione$$
create procedure rimuovi_disco_da_collezione(id_disco integer unsigned, id_collezione integer unsigned)
	delete from disco where id=id_disco and id_collezione_di_dischi=id_collezione$$
delimiter ;