# Ricerca in base al nome d'arte di un autore che ha inciso un disco
drop procedure if exists search_disco_by_autore;
delimiter $
create procedure search_disco_by_autore(cercato varchar(100))
begin
	select d.*,a.nome_darte
    from incide i
    join autore a on i.id_autore = a.id
    join disco d on i.id_disco = d.id
    where a.nome_darte like concat("%",cercato,"%");
end$
delimiter ;