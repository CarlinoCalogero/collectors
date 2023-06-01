drop trigger if exists check_artista;
delimiter $
create trigger check_artista before insert on artista_singolo for each row
begin
	declare tipo_autore boolean;
    set tipo_autore = (select tipo from autore where id = new.id_autore);
    if(tipo_autore = true)#check del tipo 0/false è il tipo dell'artista singolo
	then
		signal sqlstate "45000" set message_text="Il tipo dell'autore non combacia.";
    end if;
    if((datediff(now(),"2002-07-29")/365) < 16)
    then
		signal sqlstate "45000" set message_text="Errore nella data di nascita.";
    end if;
end$
delimiter ;