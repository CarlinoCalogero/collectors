#Aggiunta di dischi a una collezione
delimiter $
drop procedure if exists insert_disco;
create procedure insert_disco(in id_collezione integer unsigned,in titolo varchar(50),in data_uscita date,
								in stato varchar(50),in formato varchar(50),in partitaIVA varchar(11),
                                in barcode varchar(200), in note text, in copie integer unsigned)
begin
	declare id_et integer unsigned;
    declare errore_data condition for sqlstate "45000";
    declare exit handler for errore_data begin resignal; end;
    if(check_data(data_uscita) = true)
    then
		select e.id from etichetta e where e.partitaIVA = partitaIVA into id_et;
		insert into disco(titolo,anno_di_uscita,nome_stato,nome_formato,id_etichetta,id_collezione_di_dischi)
							values(titolo,data_uscita,stato,formato,id_et,id_collezione);
		if(copie is null)
        then
			set copie = 0;
		end if;
        insert into info_disco(id_disco,barcode,note,numero_copie) values(last_insert_id(),barcode,note,copie);
	end if;
end$
delimiter ;