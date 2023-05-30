# Ricerca in base al nome d'arte di un autore che partecipa ad un disco, presente nelle collezioni private di un collezionista
drop procedure if exists search_disco_by_autore_e_titolo;
delimiter $
create procedure search_disco_by_autore_e_titolo(in id_collezionista integer unsigned,in cercato varchar(100))
begin
	select distinct d.titolo as "titolo disco"
    from produce p
    join traccia t on p.id_traccia = t.id
    join autore a on p.id_autore = a.id
    join disco d on t.id_disco = d.id
    join incide i on i.id_disco = d.id
    join autore ai on i.id_autore = ai.id
    join collezione_di_dischi coll on d.id_collezione_di_dischi = coll.id
    where coll.id_collezionista = id_collezionista and (a.nome_darte like cercato or ai.nome_darte like cercato or d.titolo like cercato);
end$
delimiter ;