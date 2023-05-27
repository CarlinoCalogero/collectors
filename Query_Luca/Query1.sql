# Inserimento di una nuova collezione
drop procedure if exists insert_collezione;
delimiter $
create procedure insert_collezione(in idcollezionista integer unsigned,in nome_collezione varchar(200),in visibilita boolean)
begin
    insert into collezione_di_dischi(nome,visibilita,id_collezionista) values(nome_collezione,visibilita,idcollezionista);
end$
delimiter ;