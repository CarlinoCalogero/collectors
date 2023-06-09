drop procedure if exists search_disco;
delimiter $
create procedure search_disco(in id_collezionista integer unsigned, in cercato varchar(100),
								in priv boolean, in cond boolean, in pub boolean)
begin
	if(priv = true)
    then
		call search_disco_privato(id_collezionista, cercato);
	else
		call search_disco_privato(null,null);
	end if;
    if(cond = true)
    then
		call search_disco_condiviso(id_collezionista, cercato);
	else
		call search_disco_condiviso(null,null);
	end if;
    if(pub = true)
    then
		call search_disco_pubblico(cercato);
	else
		call search_disco_pubblico(null);
	end if;
	select *
    from dischi_privati_trovati 
    union
    select *
    from dischi_condivisi_trovati
    union
    select *
    from dischi_pubblici_trovati;
    drop temporary table if exists dischi_privati_trovati;
	drop temporary table if exists dischi_condivisi_trovati;
	drop temporary table if exists dischi_pubblici_trovati;
end$
delimiter ;