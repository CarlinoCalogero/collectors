#Aggiunta di nuove condivisioni
drop procedure if exists insert_condivisione;
delimiter $
create procedure insert_condivisione(nickname varchar(100), email varchar(200),id_collezione integer unsigned)
begin
	declare id_coll integer unsigned;
    declare visibilita boolean;
	declare exit handler for sqlstate "45000" begin resignal; end;
    select c.id from collezionista c where c.nickname = nickname and c.email = email into id_coll;
    select coll.visibilita from collezione_di_dischi coll where coll.id = id_collezione into visibilita;
    if(visibilita = false) 
		then
			insert into condivisa(id_collezionista,id_collezione) values(id_coll,id_collezione);
		else 
			signal sqlstate "45000" set message_text = "La collezione è pubblica";
		end if;
end$
delimiter ;