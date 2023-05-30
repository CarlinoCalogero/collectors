delimiter $$
drop procedure if exists ricerca_tramite_barcode$$
create procedure ricerca_tramite_barcode(barcode varchar(200))
BEGIN
	select *
    from info_disco as i
    where 
END$$
delimiter ;