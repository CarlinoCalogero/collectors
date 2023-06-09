delimiter $$
drop procedure if exists modifica_stato_pubblicazione$$
create procedure modifica_stato_pubblicazione(id_collezione_di_dischi integer unsigned)
BEGIN
	declare visibilita_corrente boolean;
    set visibilita_corrente = (select visibilita from collezione_di_dischi where id=id_collezione_di_dischi);
	update collezione_di_dischi set visibilita = not visibilita_corrente where id=id_collezione_di_dischi;
END$$

drop procedure if exists condividi_collezione_con_collezionista$$
create procedure condividi_collezione_con_collezionista(id_collezionista integer unsigned,id_collezione integer unsigned)
	insert into condivisa values (id_collezionista,id_collezione)$$
delimiter ;