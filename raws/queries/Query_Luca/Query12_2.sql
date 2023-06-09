drop procedure if exists numero_dischi_di_genere;
delimiter $
create procedure numero_dischi_di_genere()
begin
	select c.nome_genere as "genere",count(c.id_disco) as "numero"
    from classificazione c
    group by(c.nome_genere);
end$
delimiter ;