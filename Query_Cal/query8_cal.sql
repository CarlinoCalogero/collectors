delimiter $$
drop procedure if exists ricerca_di_dischi_con_autore_eo_titolo$$
create procedure ricerca_di_dischi_con_autore_eo_titolo(nomedarte varchar(100),titolo varchar(50),id_collezionista integer unsigned, collezioni boolean, condivise boolean, pubbliche boolean)
begin
	if pubbliche and condivise and collezioni then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
            ) union ( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
            ) union ( /* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            ) union ( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            ) union (/* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
    else if condivise and collezioni then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
            ) union ( /* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            ) union (/* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
    else if pubbliche and collezioni then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
            ) union ( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            ) union ( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
    else if pubbliche and condivise then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
            ) union ( /* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            ) union (/* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
    else if collezioni then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_di_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.id_collezionista = id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
    else if condivise then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_condivise_con_collezionista */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from condivisa as c
					join collezione_di_dischi as cd on c.id_collezione=cd.id
					join disco as d on d.id_collezione_di_dischi=cd.id
					join incide as i on i.id_disco=d.id
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where c.id_collezionista=id_collezionista
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
    else if pubbliche then
		if titolo is null then
			( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
            );
			
		else

			( /* ricerca_disco_in_collezioni_pubbliche */
				select d.titolo as "Titolo",d.anno_di_uscita as "Anno di uscita", d.nome_formato as "Formato", d.nome_stato as "Condizioni", cd.nome as "Collezione", co.nickname as "Proprietario"
				from disco as d
					join collezione_di_dischi as cd on d.id_collezione_di_dischi=cd.id
					join incide as i on d.id=i.id_disco
					join autore as a on i.id_autore=a.id
                    join collezionista as co on cd.id_collezionista=co.id
				where cd.visibilita=true
					and a.nome_darte=nomedarte
					and d.titolo=titolo
            );
		end if;
	end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
end$$
delimiter ;

call ricerca_di_dischi_con_autore_eo_titolo("mieruko",null,2,true,false,false);