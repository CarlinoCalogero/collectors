/* Numero dei brani (tracce di dischi) distinti di un certo autore (compositore, musicista) 
  presenti nelle collezioni pubbliche.
*/

DROP FUNCTION IF EXISTS conta_brani;

DELIMITER $

CREATE FUNCTION conta_brani(nome_darte varchar(200))
RETURNS integer unsigned DETERMINISTIC
BEGIN

	DECLARE numero_brani integer unsigned;
    
    SET numero_brani = (
		SELECT count(distinct t.id)
		FROM autore a
		JOIN produce p ON p.id_autore=a.id
		JOIN traccia t ON t.id=p.id_traccia
		JOIN disco d ON d.id=t.id_disco
		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
		WHERE c.visibilita=true 
		AND a.nome_darte LIKE nome_darte
		GROUP BY a.id);
	
    # Se numer_brani è null, ritorna 0, altrimenti il numero di brani
    IF(numero_brani is null) THEN
		RETURN 0;
	ELSE
		RETURN numero_brani;
	END IF;
    
END$

DELIMITER ;