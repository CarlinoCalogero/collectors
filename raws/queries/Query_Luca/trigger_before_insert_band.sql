drop trigger if exists check_band;
delimiter $
create trigger check_band before insert on band for each row
begin
	declare tipo_autore boolean;
    declare check_data boolean;
    set tipo_autore = (select tipo from autore where id = new.id_autore);
    if(tipo_autore = false)#check del tipo 1/true è il tipo dell'artista singolo
	then
		signal sqlstate "45000" set message_text="Il tipo dell'autore non combacia";
    end if;
    #semplice chiamata a funzione. Se check_data() non lancia un eccezione si puo inserire il nuovo artista
    set check_data = (select check_data(new.data_fondazione));
end$
delimiter ;