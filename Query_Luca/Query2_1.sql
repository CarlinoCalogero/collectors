#insert into disco(titolo,anno_di_uscita,nome_stato,nome_formato,id_etichetta,id_collezione_di_dischi)values("d1","2023-05-26","Buono","Vinile",1,1)
delimiter $
drop procedure if exists insert_disco;
create procedure insert_disco(titolo varchar(50),data_uscita date,stato varchar(50),formato varchar(50),partitaIVA varchar(11),id_collezione integer unsigned)
begin
	declare id_et integer unsigned;
    select e.id from etichetta e where e.partitaIVA = partitaIVA into id_et;
    insert into disco(titolo,anno_di_uscita,nome_stato,nome_formato,id_etichetta,id_collezione_di_dischi)
    values(titolo,data_uscita,stato,formato,id_et,id_collezione);
end$
delimiter ;