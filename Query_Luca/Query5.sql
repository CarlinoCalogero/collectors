#Rimozione di una collezione
drop procedure if exists delete_collezione;
delimiter $
create procedure delete_collezione(in id_collezione integer unsigned)
begin
	delete from collezione_di_dischi where id= id_collezione;
end$
delimiter ;