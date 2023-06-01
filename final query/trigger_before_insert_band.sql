drop trigger if exists check_band;
delimiter $
create trigger check_band before insert on band for each row
begin
	declare tipo_autore boolean;
    set tipo_autore = (select tipo from autore where id = new.id_autore);
    if(tipo_autore = false)#check del tipo 1/true è il tipo dell'artista singolo
	then
		signal sqlstate "45000" set message_text="Il tipo dell'autore non combacia";
    end if;
    if(new.data_nascita > date(now()))
    then
		signal sqlstate "45000" set message_text="Errore nella data di nascita.";
    end if;
end$
delimiter ;