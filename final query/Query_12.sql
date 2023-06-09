/* 12. Statistiche (una query per ciascun valore): numero di collezioni di ciascun collezionista,
   numero di dischi per genere nel sistema.
*/

DROP PROCEDURE IF EXISTS  conta_collezioni;
DROP PROCEDURE IF EXISTS conta_dischi_per_genere;

DELIMITER $

CREATE PROCEDURE conta_collezioni()
BEGIN
	SELECT c.nickname as "Collezionista" , 
		   count(cd.id) as "Numero di Collezioni"
    FROM collezione_di_dischi cd
	RIGHT JOIN collezionista c ON cd.id_collezionista=c.id
    GROUP BY c.nickname
    ORDER BY Collezionista ASC;
    
END$


CREATE PROCEDURE conta_dischi_per_genere()
BEGIN

	SELECT c.nome_genere as "Genere" , 
		   count(c.id_disco) as "Numero di Dischi"
    FROM classificazione c
    GROUP BY c.nome_genere;
    
END$

DELIMITER ;