delimiter $$
drop procedure if exists numero_di_collezioni_per_collezionista$$
create procedure numero_di_collezioni_per_collezionista()
BEGIN
	select c.nickname as "Collezionista" , count(cd.id) as "Numero di Collezioni"
    from collezione_di_dischi as cd
		right join collezionista as c on cd.id_collezionista=c.id
    group by c.nickname
    order by Collezionista asc;
END$$

drop procedure if exists numero_di_dischi_per_genere$$
create procedure numero_di_dischi_per_genere()
BEGIN
	select c.nome_genere as "Genere" , count(c.id_disco) as "Numero di Dischi"
    from classificazione as c
    group by c.nome_genere;
END$$
delimiter ;

call numero_di_dischi_per_genere();