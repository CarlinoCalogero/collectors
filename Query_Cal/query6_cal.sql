delimiter $$
drop procedure if exists lista_dischi_collezione$$
create procedure lista_dischi_collezione(id_collezione integer unsigned)
	select d.titolo as "Titolo", d.anno_di_uscita as "Data di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", e.nome as "Etichetta" from disco as d join etichetta as e on e.id=d.id_etichetta where d.id_collezione_di_dischi=id_collezione$$
delimiter ;