delimiter $$
drop procedure if exists collezioni_di_collezionista$$
create procedure collezioni_di_collezionista(id_collezionista integer unsigned)
begin
	select cd.nome
	from collezione_di_dischi as cd
	where cd.id_collezionista = id_collezionista;
end$$

drop procedure if exists collezioni_pubbliche$$
create procedure collezioni_pubbliche()
begin
	select cd.nome
    from collezione_di_dischi as cd
    where cd.visibilita=true;
end$$

drop procedure if exists collezioni_condivise_con_collezionista$$
create procedure collezioni_condivise_con_collezionista(id_collezionista integer unsigned)
begin
	select cd.nome
    from condivisa as c
		join collezione_di_dischi as cd on c.id_collezione=cd.id
	where c.id_collezionista=id_collezionista;
end$$

drop procedure if exists collezioni_visibili_da_collezionista$$
create procedure collezioni_visibili_da_collezionista(id_collezionista integer unsigned)
begin
	(/* collezioni_di_collezionista */
		select cd.nome
		from collezione_di_dischi as cd
		where cd.id_collezionista = id_collezionista
    ) union (/* collezioni_pubbliche */
		select cd.nome
		from collezione_di_dischi as cd
		where cd.visibilita=true
    ) union (/* collezioni_condivise_con_collezionista */
		select cd.nome
		from condivisa as c
		join collezione_di_dischi as cd on c.id_collezione=cd.id
		where c.id_collezionista=id_collezionista
    );
end$$

drop procedure if exists ricerca_disco_in_collezioni_di_collezionista$$
create procedure ricerca_disco_in_collezioni_di_collezionista(nomedarte varchar(100),titolo varchar(50),id_collezionista integer unsigned)
begin
	if titolo is null then
		select *
		from disco as d
			join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
            join incide as i on d.id=i.id_disco
            join autore as a on i.id_autore=a.id
		where cd.id_collezionista = id_collezionista
			and a.nome_darte=nomedarte;
	else
		select *
		from disco as d
			join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
            join incide as i on d.id=i.id_disco
            join autore as a on i.id_autore=a.id
		where cd.id_collezionista = id_collezionista
			and a.nome_darte=nomedarte
            and d.titolo=titolo;
	end if;
end$$

drop procedure if exists ricerca_disco_in_collezioni_pubbliche$$
create procedure ricerca_disco_in_collezioni_pubbliche(nomedarte varchar(100),titolo varchar(50))
begin
	if titolo is null then
		select *
		from disco as d
			join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
            join incide as i on d.id=i.id_disco
            join autore as a on i.id_autore=a.id
		where cd.visibilita=true
			and a.nome_darte=nomedarte;
	else
		select *
		from disco as d
			join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
            join incide as i on d.id=i.id_disco
            join autore as a on i.id_autore=a.id
		where cd.visibilita=true
			and a.nome_darte=nomedarte
            and d.titolo=titolo;
	end if;
end$$

drop procedure if exists ricerca_disco_in_collezioni_condivise_con_collezionista$$
create procedure ricerca_disco_in_collezioni_condivise_con_collezionista(nomedarte varchar(100),titolo varchar(50),id_collezionista integer unsigned)
begin
	if titolo is null then
		select *
		from condivisa as c
			join collezione_di_dischi as cd on c.id_collezione=cd.id
            join disco as d on d.id_collezione_di_dischi=cd.id
            join incide as i on i.id_disco=d.id
            join autore as a on i.id_autore=a.id
		where c.id_collezionista=id_collezionista
			and a.nome_darte=nomedarte;
	else
		select *
		from condivisa as c
			join collezione_di_dischi as cd on c.id_collezione=cd.id
            join disco as d on d.id_collezione_di_dischi=cd.id
            join incide as i on i.id_disco=d.id
            join autore as a on i.id_autore=a.id
		where c.id_collezionista=id_collezionista
			and a.nome_darte=nomedarte
            and d.titolo=titolo;
	end if;
end$$
delimiter ;


call ricerca_disco_in_collezioni_condivise_con_collezionista("mieruko","mobius",2);