#Add Traccia ad un disco
drop procedure if exists insert_traccia;
delimiter $
create procedure insert_traccia(in id_disco integer unsigned, in titolo varchar(50),in durata decimal(10,2))
begin
	declare id_et integer unsigned;
    select d.id_etichetta from disco d where d.id=id_disco into id_et;
	insert into traccia(titolo,durata,id_etichetta,id_disco) values(titolo,durata,id_et,id_disco);
end$
delimiter ;