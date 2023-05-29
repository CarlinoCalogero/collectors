DELIMITER $

#Lista di tutti i dischi in una collezione.
DROP PROCEDURE IF EXISTS stampa_disco;
CREATE PROCEDURE stampa_disco(
	in id_disco integer unsigned
)
BEGIN
	SELECT d.id AS ID,
		d.titolo AS Titolo,
		d.anno_di_uscita AS Anno,
        d.nome_formato AS Formato,
        d.nome_stato AS Stato,
        e.nome AS Etichetta,
        c.nome AS Collezione
    FROM disco d
    JOIN etichetta e ON e.id=d.id_etichetta
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
	WHERE d.id=id_disco
    ORDER BY d.id ASC;
END$

DELIMITER ;