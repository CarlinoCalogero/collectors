drop trigger if exists on_update_visibilita;
delimiter $
create trigger on_update_visibilita before update on collezione_di_dischi for each row
begin
	if(old.visibilita = false and new.visibilita = true)
    then
		delete from condivisa where id_collezione = old.id;
    end if;
end$
delimiter ;