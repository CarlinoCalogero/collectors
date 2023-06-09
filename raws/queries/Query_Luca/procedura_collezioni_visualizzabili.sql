drop procedure if exists collezioni_visibili_by;
delimiter $
create procedure collezioni_visibili_by(in id_collezionista integer unsigned)
begin 
	#Visualizzare collezioni personali e pubbliche
	select coll.id,coll.nome, coll.visibilita
	from collezione_di_dischi coll
	join collezionista c on coll.id_collezionista = c.id
	where c.id = id_collezionista or coll.visibilita = true
	#Visualizzare le collezioni condivise
	union distinct 
	select coll.id,coll.nome, coll.visibilita
	from condivisa cond
	join collezione_di_dischi coll on cond.id_collezione = coll.id
	join collezionista cls on cond.id_collezionista = cls.id
	where cond.id_collezionista = id_collezionista;
end$
delimiter ;