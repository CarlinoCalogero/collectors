#Modifica dello stato di pubblicazione di una collezione (da privata a pubblica e viceversa)
drop procedure if exists change_visibilita;
delimiter $
create procedure change_visibilita(in id_collezione integer unsigned)
begin
	declare newVis boolean;
    select visibilita from collezione_di_dischi where id = id_collezione into newVis;
	update collezione_di_dischi set visibilita = not newVis where id=id_collezione;
end$
delimiter ;