delimiter $$
drop procedure if exists verifica_visibilita_collezione_per_collezionista$$
create procedure verifica_visibilita_collezione_per_collezionista(id_collezione_di_dischi integer unsigned, id_collezionista integer unsigned)
BEGIN
	(/* verifica_visibilita_collezione_per_collezionista_se_sua */
		select cd.id as "Visibilità"
		from collezione_di_dischi as cd
		where cd.id=id_collezione_di_dischi
			and cd.id_collezionista=id_collezionista 
	) union (/* verifica_visibilita_collezione_per_collezionista_se_pubblica */
		select cd.id as "Visibilità"
		from collezione_di_dischi as cd
		where cd.id=id_collezione_di_dischi
			and cd.visibilita=true
	) union (/* verifica_visibilita_collezione_per_collezionista_se_condivisa */
		select c.id_collezione as "Visibilità"
		from condivisa as c
		where c.id_collezione=id_collezione_di_dischi
			and c.id_collezionista=id_collezionista
	);
END$$
delimiter ;

call verifica_visibilita_collezione_per_collezionista(6,1);