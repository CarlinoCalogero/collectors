delimiter $$
drop procedure if exists track_list_disco$$
create procedure track_list_disco(id_disco integer unsigned)
	select t.titolo as "Titolo traccia",t.durata as "Durata" from traccia as t where t.id_disco=id_disco$$
delimiter ;