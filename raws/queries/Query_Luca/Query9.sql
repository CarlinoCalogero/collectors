drop function if exists is_visibile_by;
delimiter $
create function is_visibile_by(id_collezionista integer unsigned, id_collezione integer unsigned) returns boolean deterministic
begin
	if(id_collezione in (select coll.id
							from collezione_di_dischi coll
							where coll.id_collezionista = id_collezionista or coll.visibilita=true
							#Visualizzare le collezioni condivise
							union distinct 
							select coll.id
							from condivisa cond
							join collezione_di_dischi coll on cond.id_collezione = coll.id
							where cond.id_collezionista = id_collezionista))
	then
		return true;
	else 
		return false;
	end if;
end$
delimiter ;