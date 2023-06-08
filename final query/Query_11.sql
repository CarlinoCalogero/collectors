/* Minuti totali di musica riferibili a un certo autore (compositore, musicista) memorizzati nelle
 collezioni pubbliche.
*/

DROP FUNCTION IF EXISTS conta_minuti_autore;

DELIMITER $

CREATE FUNCTION conta_minuti_autore(nome_darte varchar(100))
RETURNS decimal(10,2) DETERMINISTIC
BEGIN 

	DECLARE minutaggio_totale decimal(10,2);
	
    SET minutaggio_totale = (
		SELECT sum(distinct t.durata)
		FROM autore a
		JOIN produce p ON p.id_autore=a.id
		JOIN traccia t ON t.id=p.id_traccia
		JOIN disco d ON d.id=t.id_disco
		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
		WHERE c.visibilita=true 
		AND a.nome_darte=nome_darte
		GROUP BY a.id);
            
	RETURN minutaggio_totale;

END$

DELIMITER ;