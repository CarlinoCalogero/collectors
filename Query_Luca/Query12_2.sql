drop procedure if exists numero_dischi_di_genere;
delimiter $
create procedure numero_dischi_di_genere(in nome_genere varchar(50))
begin
	declare genere_not_found condition for sqlstate "45000";
    declare genere varchar(50);
    declare exit handler for genere_not_found begin resignal set message_text = "Genere non trovato"; end;
    select nome from genere where nome = nome_genere into genere;
    if(genere is null)
    then
		signal genere_not_found;
	end if;
	select count(c.id_disco)
    from classificazione c
    where c.nome_genere like genere;
end$
delimiter ;