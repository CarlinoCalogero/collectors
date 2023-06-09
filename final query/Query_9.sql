/* 9. Verifica della visibilità di una collezione da parte di un collezionista. 
   (Suggerimento: una collezione è visibile a un collezionista se è sua, condivisa con lui o pubblica)
*/

DROP PROCEDURE IF EXISTS verifica_visibilita_collezione;

DELIMITER $

CREATE PROCEDURE verifica_visibilita_collezione(
	in id_collezione_di_dischi integer unsigned, 
	in id_collezionista integer unsigned)
BEGIN
	(/* Verifica della visibiltà per collezioni personali */
		SELECT cd.id as "Visibilità"
		FROM collezione_di_dischi cd
		WHERE cd.id=id_collezione_di_dischi
		AND cd.id_collezionista=id_collezionista 
	) UNION (/* Verifica della visibilità per collezioni pubbliche */
		select cd.id as "Visibilità"
		from collezione_di_dischi as cd
		where cd.id=id_collezione_di_dischi
			and cd.visibilita=true
	) UNION (/* Verifica della visibilità per collezioni condivise */
		SELECT c.id_collezione as "Visibilità"
		FROM condivisa c
		WHERE c.id_collezione=id_collezione_di_dischi
		AND c.id_collezionista=id_collezionista
	);
    
END$

DELIMITER ;