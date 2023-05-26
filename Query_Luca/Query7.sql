#Track list di un disco.
drop procedure if exists track_list_disco;
delimiter $
create procedure track_list_disco(id_disco integer unsigned)
begin
	select t.titolo,
			t.durata,
            e.nome as "etichetta"
	from traccia t
    join disco d on t.id_disco = d.id
    join etichetta e on t.id_etichetta = e.id
    where d.id = id_disco;
end$
