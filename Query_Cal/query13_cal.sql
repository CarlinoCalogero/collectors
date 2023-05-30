delimiter $$
drop procedure if exists ricerca_disco$$
create procedure ricerca_disco(barcode varchar(200), titolo varchar(50), nomedarte varchar(100))
BEGIN
	if barcode is not null then
		(/* ricerca_disco_tramite_barcode */
			select d.id,d.titolo
			from info_disco as i
				join disco as d on i.id_disco=d.id
			where i.barcode=barcode
		);
	else
		( /* ricerca_disco_tramite_titolo */
			select d.id,d.titolo
			from disco as d
			where d.titolo like concat(titolo,'%')
		) union ( /* ricerca_disco_tramite_nome_autore */
			select d.id,d.titolo
			from incide as i
				join disco as d on i.id_disco=d.id
				join autore as a on i.id_autore=a.id
			where a.nome_darte like concat(nomedarte,'%')
        );
	end if;
END$$
delimiter ;

/* l'assegnaizone dei punteggi di somiglianza e tutto il resto si fa per forza su interfaccia secondo me */
call ricerca_disco(null,"r","t");