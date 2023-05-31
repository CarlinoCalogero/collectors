drop procedure if exists query13;
delimiter $
create procedure query13(in cerca varchar(200))
begin
	select d.titolo,10 as coerenza
    from info_disco ifd
    join disco d on ifd.id_disco = d.id
    where ifd.barcode like cerca
	union
    select d.titolo,length(d.titolo)-length(replace(lower(d.titolo),lower(cerca),""))+1 as coerenza
    from disco d
    where d.titolo like concat("%",cerca,"%")
    union
    select d.titolo,length(a.nome_darte)-length(replace(lower(a.nome_darte),lower(cerca),"")) as coerenza
    from incide i
    join disco d on i.id_disco = d.id
    join autore a on i.id_autore = a.id
    where a.nome_darte like concat("%",cerca,"%")
    order by coerenza desc;
end$
delimiter ;