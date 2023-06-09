delimiter $$
drop procedure if exists ricerca_disco_tramite_barcode$$
create procedure ricerca_disco_tramite_barcode(barcode varchar(200))
BEGIN
	select *
    from info_disco as i
    where i.barcode=barcode;
END$$

drop procedure if exists ricerca_disco_tramite_titolo$$
create procedure ricerca_disco_tramite_titolo(titolo varchar(50))
BEGIN
	select *
    from disco as d
    where d.titolo like concat(titolo,'%');
END$$

drop procedure if exists ricerca_disco_tramite_nome_autore$$
create procedure ricerca_disco_tramite_nome_autore(nomedarte varchar(100))
BEGIN
	select *
    from incide as i
		join disco as d on i.id_disco=d.id
        join autore as a on i.id_autore=a.id
    where a.nome_darte like concat(nomedarte,'%');
END$$
delimiter ;

call ricerca_disco_tramite_nome_autore("m");