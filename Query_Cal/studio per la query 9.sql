delimiter $$
drop procedure if exists verifica_visibilita_collezione_per_collezionista_se_sua$$
create procedure verifica_visibilita_collezione_per_collezionista_se_sua(id_collezione_di_dischi integer unsigned, id_collezionista integer unsigned)
BEGIN
	select count(*)
    from collezione_di_dischi as cd
    where cd.id=id_collezione_di_dischi
		and cd.id_collezionista=id_collezionista;
END$$

drop procedure if exists verifica_visibilita_collezione_per_collezionista_se_pubblica$$
create procedure verifica_visibilita_collezione_per_collezionista_se_pubblica(id_collezione_di_dischi integer unsigned)
BEGIN
	select count(*)
    from collezione_di_dischi as cd
    where cd.id=id_collezione_di_dischi
		and cd.visibilita=true;
END$$

drop procedure if exists verifica_visibilita_collezione_per_collezionista_se_condivisa$$
create procedure verifica_visibilita_collezione_per_collezionista_se_condivisa(id_collezione_di_dischi integer unsigned, id_collezionista integer unsigned)
BEGIN
	select count(*)
    from condivisa as c
    where c.id_collezione=id_collezione_di_dischi
		and c.id_collezionista=id_collezionista;
END$$
delimiter ;

call verifica_visibilita_collezione_per_collezionista_se_condivisa(8,2)