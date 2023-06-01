#Aggiunta di nuove condivisioni
drop procedure if exists insert_condivisione;
delimiter $
create procedure insert_condivisione(in nickname varchar(100),in email varchar(200),in id_collezione integer unsigned)
begin
	declare id_coll integer unsigned;
    declare visibilita boolean;
    declare id_condivide integer unsigned;
	declare exit handler for sqlstate "45000" begin resignal; end;
    select c.id from collezionista c where c.nickname = nickname and c.email = email into id_coll;
    select c.id_collezionista from collezione_di_dischi c where c.id = id_collezione into id_condivide;
    if(id_coll = id_condivide)
    then
		signal sqlstate "45000" set message_text = "Non si può condividere con se stessi";
	end if;
    select coll.visibilita from collezione_di_dischi coll where coll.id = id_collezione into visibilita;
    if(visibilita = false) 
	then
		insert into condivisa(id_collezionista,id_collezione) values(id_coll,id_collezione);
	else 
		signal sqlstate "45000" set message_text = "La collezione è gia pubblica";
	end if;
end$
delimiter ;