drop procedure if exists delete_disco;
delimiter $
create procedure delete_disco(id_disco integer unsigned)
begin
	delete from disco where id = id_disco;
end$
delimiter ;