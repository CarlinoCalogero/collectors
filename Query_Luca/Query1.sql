# Inserimento di una nuova collezione
drop procedure if exists insert_collezione;
delimiter $
create procedure insert_collezione(idcollezionista integer unsigned, nome_collezione varchar(200), visibilita boolean)
begin
    insert into collezione_di_dischi(nome,visibilita,id_collezionista) values(nome_collezione,visibilita,idcollezionista);
end$
delimiter ;