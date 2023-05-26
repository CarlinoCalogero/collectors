#update collezione_di_dischi set visibilita = true where id=1
#Si potrebbe anche fare con visibilita come parametro senza fare uno switch completo (più scalabile)
drop procedure if exists change_visibilita;
delimiter $
create procedure change_visibilita(id_collezione integer unsigned)
begin
	declare newVis boolean;
    select visibilita from collezione_di_dischi where id = id_collezione into newVis;
	update collezione_di_dischi set visibilita = not newVis where id=id_collezione;
end$
delimiter ;