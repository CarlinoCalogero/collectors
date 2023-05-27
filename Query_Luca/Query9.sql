drop procedure if exists collezioni_visibili_by;
delimiter $
create procedure collezioni_visibili_by(in id_collezionista integer unsigned)
begin
	#Visualizzare collezioni personali
	select coll.nome, coll.visibilita
	from collezione_di_dischi coll
	join collezionista c on coll.id_collezionista = c.id
	where c.id = 3
	#Visualizzare le collezioni condivise
	union distinct 
	select coll.nome, coll.visibilita
	from condivisa cond
	join collezione_di_dischi coll on cond.id_collezione = coll.id
	join collezionista cls on cond.id_collezionista = cls.id
	where cond.id_collezionista = 3
	#Collezioni Pubbliche
	union distinct
	select cp.nome,cp.visibilita from collezioni_pubbliche cp;
end$
delimiter ;