#numero di brani distinti di un certo autore memorizzati nelle collezioni pubbliche

drop procedure if exists numero_brani_collezioni_pubbliche;
delimiter $
create procedure numero_brani_collezioni_pubbliche(in nome_autore  varchar(100))
begin
select count(distinct t.titolo)
from produce p
join traccia t on p.id_traccia = t.id
join autore aat on p.id_autore = aat.id
join disco d on t.id_disco = d.id
join collezione_di_dischi coll on d.id_collezione_di_dischi = coll.id
where coll.visibilita = true and aat.nome_darte like nome_autore
group by aat.id, aat.nome_darte;
end$
delimiter ; 