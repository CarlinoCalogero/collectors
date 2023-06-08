/* 8. Ricerca di dischi in base a nomi di autori/compositori/interpreti e/o titoli. 
Si potrà decidere di includere nella ricerca le collezioni di un certo collezionista 
e/o quelle condivise con lo stesso collezionista e/o quelle pubbliche. 
(Suggerimento: potete realizzare diverse query in base alle varie combinazioni di criteri
 di ricerca. Usate la UNION per unire i risultati delle ricerche effettuate sulle collezioni
 private, condivise e pubbliche)
 
 La seguente query si articola così:
 1. Ricerca in collezioni personale, condivise e pubbliche
	1.1 Ricerca con nome d'arte
    1.2 Ricerca con nome d'arte e con titolo
 2. Ricerca in collezioni personali e condivise
	2.1 Ricerca con nome d'arte
    2.2 Ricerca con nome d'arte e con titolo
 3. Ricerca in collezioni personali e pubbliche
	3.1 Ricerca con nome d'arte
    3.2 Ricerca con nome d'arte con titolo
 4. Ricerca in collezioni pubbliche e condivise
	4.1 Ricerca con nome d'arte
    4.2 Ricerca con nome d'arte e titolo
 5. Ricerca in collezioni personali
	5.1 Ricerca con nome d'arte
    5.2 Ricerca con nome d'arte e titolo
 6. Ricerca in collezioni condivise
	6.1 Ricerca con nome d'arte
    6.2 Ricerca con nome d'arte e con titolo
 7. Ricerca in collezioni pubbliche 
	7.1 Ricerca con nome d'arte
    7.2 Ricerca con nome d'arte e con titolo
    
  In questo modo vengono coperte tutte le possibili combinazioni di ricerca 
*/

DROP PROCEDURE IF EXISTS ricerca_di_dischi_con_autore_eo_titolo;

DELIMITER $

CREATE PROCEDURE ricerca_di_dischi_con_autore_eo_titolo(
	in nomedarte varchar(100),
    in titolo varchar(50),
    in id_collezionista integer unsigned, 
    in collezioni boolean,
    in condivise boolean,
    in pubbliche boolean)
BEGIN
	IF(pubbliche AND condivise AND collezioni) THEN
		IF(titolo is null) THEN
			( /* Ricerca di un disco in collezioni personali dato l'id del 
				collezionista e il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di un disco in collezioni pubbliche dato l'id del 
					collezionista e il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di un disco in collezioni condivise con il collezionista dato 
					l'id del collezionista e il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE /* Il titolo non è null */

			( /* Ricerca di un disco in collezioni personali dato l'id del 
				collezionista, il nome d'arte dell'autore e il titolo*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION (/* Ricerca di un disco in collezioni pubbliche dato l'id del 
						collezionista, il nome d'arte dell'autore e il titolo */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION (/* Ricerca di un disco in collezioni condivise con il collezionista 
						dato l'id del collezionista, il nome d'arte dell'autore e il titolo */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
                JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
    ELSE IF(condivise and collezioni) THEN
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni personali dato l'id del collezionista
				e il nome dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd on d.id_collezione_di_dischi=cd.id
				JOIN incide i on d.id=i.id_disco
				JOIN autore a on i.id_autore=a.id
				JOIN collezionista co on cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di dischi in collezioni condivise con il collezionista dato l'id 
						del collezionista e il nome dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni",
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE /* Il titolo non è null*/

			( /* Ricerca di dischi in collezioni personali dato l'id del collezionista
				e il nome dell'autore e il titolo del disco*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i on d.id=i.id_disco
				JOIN autore a on i.id_autore=a.id
				JOIN collezionista co on cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION (/* Ricerca di dischi in collezioni condivise con il collezionista dato l'id 
						del collezionista e il nome dell'autore e il titolo del disco*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
					   d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
    ELSE IF(pubbliche AND collezioni) THEN
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista as co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE

			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore e il
				titolo del disco */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION ( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore e il
						titolo del disco */
				SELECT d.titolo as "Titolo",
					d.anno_di_uscita as "Anno di uscita", 
                    d.nome_formato as "Formato",
                    d.nome_stato as "Condizioni", 
                    cd.nome as "Collezione", 
                    co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista as co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
    ELSE IF(pubbliche AND condivise) THEN
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
                JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            ) UNION ( /* Ricerca di dischi in collezioni condivise con il collezionista dato il 
						nome d'arte dell'autore */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni",
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE /* Il titolo non è null */

			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore e il 
				titolo del disco */
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd on d.id_collezione_di_dischi=cd.id
				JOIN incide i on d.id=i.id_disco
				JOIN autore a on i.id_autore=a.id
				JOIN collezionista co on cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            ) UNION  (/* Ricerca di dischi condivisi con il collezionista dato il nome d'arte
						dell'autore e il titolo del disco*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
    ELSE IF(collezioni) THEN
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita",
                       d.nome_formato as "Formato", 
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione", 
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE

			( /* Ricerca di dischi in collezioni personali dato il nome d'arte dell'autore
				e il titolo*/
				SELECT d.titolo as "Titolo",
					   d.anno_di_uscita as "Anno di uscita", 
                       d.nome_formato as "Formato",
                       d.nome_stato as "Condizioni", 
                       cd.nome as "Collezione",
                       co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.id_collezionista = id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
    ELSE IF(condivise) THEN
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni condivise con il collezionista dato
				il nome dell'autore*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita", 
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE

			( /* Ricerca di dischi in collezioni condivise con il collezionista dato
				il nome dell'autore e il titolo*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM condivisa c
				JOIN collezione_di_dischi cd ON c.id_collezione=cd.id
				JOIN disco d ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON i.id_disco=d.id
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE c.id_collezionista=id_collezionista
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
	ELSE IF(pubbliche) THEN
		IF(titolo is null) THEN
			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato",
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
            );
			
		ELSE

			( /* Ricerca di dischi in collezioni pubbliche dato il nome d'arte dell'autore
				e il titolo del disco*/
				SELECT d.titolo as "Titolo",
                d.anno_di_uscita as "Anno di uscita",
                d.nome_formato as "Formato", 
                d.nome_stato as "Condizioni", 
                cd.nome as "Collezione", 
                co.nickname as "Proprietario"
				FROM disco d
				JOIN collezione_di_dischi cd ON d.id_collezione_di_dischi=cd.id
				JOIN incide i ON d.id=i.id_disco
				JOIN autore a ON i.id_autore=a.id
				JOIN collezionista co ON cd.id_collezionista=co.id
				WHERE cd.visibilita=true
				AND a.nome_darte LIKE nomedarte
				AND d.titolo LIKE titolo
            );
		END IF;
	END IF;
	END IF;
	END IF;
	END IF;
	END IF;
	END IF;
	END IF;
END$

DELIMITER ;