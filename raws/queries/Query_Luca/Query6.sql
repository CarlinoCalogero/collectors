#Lista di tutti i dischi in una collezione
drop procedure if exists dischi_in_collezione;
delimiter $
create procedure dischi_in_collezione(in id_collezione integer unsigned)
begin
	select d.titolo as "titolo",
			d.anno_di_uscita as "anno di uscita",
            d.nome_stato as "stato",
            d.nome_formato as "formato",
            e.nome as "etichetta",
            generi_disco(d.id) as "generi" #funzione per ricavare tutti i generi in un unica riga
	from disco d
    join etichetta e on d.id_etichetta = e.id
    where d.id_collezione_di_dischi = id_collezione;
end$