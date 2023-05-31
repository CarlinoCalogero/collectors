#Statistiche (una query per ciascun valore): 
#numero di collezioni di ciascun collezionista
#numero di dischi per genere nel sistema.
drop procedure if exists numero_collezioni_di;
delimiter $
create procedure numero_collezioni_di(in id_collezionista integer unsigned)
begin
select count(coll.id)
from collezione_di_dischi coll
where coll.id_collezionista = id_collezionista;
end$
delimiter ;
