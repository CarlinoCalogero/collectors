#Versione SQL
#insert into collezione_di_dischi(nome,visibilita,id_collezionista) values("coll1",false,1)
delimiter $
create procedure insert_collezione(nickname varchar(100),email varchar(200), nome_collezione varchar(200), visibilita boolean)
begin
	declare id_collezionista varchar(100);
	select c.id from collezionista c where c.nickname = nickname and c.email= email into id_collezionista;
    insert into collezione_di_dischi(nome,visibilita,id_collezionista) values(nome_collezione,visibilita,id_collezionista);
end$
delimiter ;