#Add Traccia ad un disco
#insert into traccia(titolo,durata,id_etichetta,id_disco) values("traccia1",5.00,1,1)
drop procedure if exists insert_traccia;
delimiter $
create procedure insert_traccia(titolo varchar(50),durata decimal(10,2),id_disco integer unsigned)
begin
	declare id_et integer unsigned;
    select d.id_etichetta from disco d where d.id=id_disco into id_et;
	insert into traccia(titolo,durata,id_etichetta,id_disco) values(titolo,durata,id_et,id_disco);
end$
delimiter ;