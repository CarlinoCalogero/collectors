DELIMITER $$
drop procedure if exists aggiungi_disco_a_collezione$$
create procedure aggiungi_disco_a_collezione(titolo varchar(50),anno_di_uscita date,nome_formato varchar(50),nome_stato varchar(50),id_etichetta integer unsigned,id_collezione_di_dischi integer unsigned)
begin
	declare data_invalida condition for sqlstate '45000';
    declare exit handler for data_invalida 
	begin 
        resignal set MESSAGE_TEXT='Errore! Data invalida' ;
	end;
	if anno_di_uscita > now() then
		signal data_invalida;
    else 
		insert into disco(titolo,anno_di_uscita,nome_formato,nome_stato,id_etichetta,id_collezione_di_dischi) values (titolo,anno_di_uscita,nome_formato,nome_stato,id_etichetta,id_collezione_di_dischi);
	end if;
end$$
    
drop procedure if exists aggiugi_traccia_a_disco$$
create procedure aggiugi_traccia_a_disco(titolo varchar(50),durata decimal(10,2),id_etichetta integer unsigned,id_disco integer unsigned)
	insert into traccia(titolo,durata,id_etichetta,id_disco) values (titolo,durata,id_etichetta,id_disco)$$
DELIMITER ;