drop procedure if exists query13;
delimiter $
create procedure query13(in barcode varchar(200), in titolo varchar(100), in autore varchar(100))
begin
	declare search_1 varchar(100);
    declare coerenza integer unsigned;
	select d.titolo
    from info_disco ind
    join disco d on ind.id_disco = d.id
    where ind.barcode is not null and ind.barcode like barcode
    into search_1,coerenza;
end$
delimiter ;