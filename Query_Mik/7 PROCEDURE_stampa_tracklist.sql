DELIMITER $
# Track list di un disco.
DROP PROCEDURE IF EXISTS stampa_tracklist;
CREATE PROCEDURE stampa_tracklist(
	in id_disco integer unsigned
)
BEGIN

	SELECT t.id AS ID,
		   t.titolo AS Titolo,
           t.durata AS Durata,
           e.nome AS Etichetta,
           d.titolo AS Disco
    FROM traccia t
	JOIN etichetta e ON e.id=t.id_etichetta
    JOIN disco d ON d.id=t.id_disco
    WHERE t.id_disco=id_disco
    ORDER BY t.id ASC;

END$
DELIMITER ;