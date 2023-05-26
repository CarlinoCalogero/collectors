drop procedure if exists delete_collezione;
delimiter $
create procedure delete_collezione(id_collezione integer unsigned)
begin
	delete from collezione_di_dischi where id= id_collezione;
end$