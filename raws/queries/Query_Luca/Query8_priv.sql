drop procedure if exists search_disco_privato;
delimiter $
create procedure search_disco_privato(in id_collezionista integer unsigned, in cercato varchar(100))
begin
#Ricerca di dischi in base a titolo, nome autore e autori nelle tracce in collezioni private
	create temporary table dischi_privati_trovati
    select d.titolo as titolo,
			d.nome_formato as formato,
            d.nome_stato as stato
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