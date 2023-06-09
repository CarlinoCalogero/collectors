delimiter $$
drop procedure if exists numero_di_brani_di_autore_da_collezioni_pubbliche$$
create procedure numero_di_brani_di_autore_da_collezioni_pubbliche(id_autore integer unsigned)
BEGIN
	select count(distinct t.titolo) as "Numero di tracce"
	from traccia as t
		join disco as d on t.id_disco=d.id
        join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
        join produce as p on t.id=p.id_traccia
	where cd.visibilita=true
		and p.id_autore=id_autore;
END$$
delimiter ;

call numero_di_brani_di_autore_da_collezioni_pubbliche(2);