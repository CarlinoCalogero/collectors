#Modifica dello stato di pubblicazione di una collezione (da privata a pubblica e viceversa)
drop procedure if exists change_visibilita;
delimiter $
create procedure change_visibilita(in id_collezione integer unsigned,in new_visibilita boolean)
begin
	update collezione_di_dischi set visibilita = new_visibilita where id=id_collezione;
end$
delimiter ;