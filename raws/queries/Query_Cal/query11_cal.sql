delimiter $$
drop procedure if exists minuti_totali_brani_autore$$
create procedure minuti_totali_brani_autore(id_autore integer unsigned)
BEGIN
	select sum(sub.durata) as "Minuti totali"
    from (
		select distinct t.titolo, t.durata
		from traccia as t
			join disco as d on t.id_disco=d.id
			join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
			join produce as p on t.id=p.id_traccia
		where cd.visibilita=true
			and p.id_autore=id_autore
    ) as sub;
END$$
delimiter ;

call minuti_totali_brani_autore(2);