DELIMITER $
DROP PROCEDURE IF EXISTS aggiungi_traccia;
#Aggiunta di tracce a un disco.
CREATE PROCEDURE aggiungi_traccia(
	in titolo varchar(50),
	in durata decimal(10,2),
	in partitaIVA varchar(11),
	in id_disco integer
)
    BEGIN
    DECLARE ID_disc integer unsigned;
    DECLARE ID_etichett integer unsigned;
    DECLARE ID_traccia integer unsigned;
    
    # Controllo che il disco e l'etichetta esistano
    SET ID_disc = (
		SELECT d.id
        FROM disco d
		WHERE d.id=id_disco);
	SET ID_etichett = (
		SELECT e.id
        FROM etichetta e
		WHERE e.partitaIVA=partitaIVA
    );

    IF(ID_disc IS NOT NULL AND ID_etichett IS NOT NULL) THEN
		# Controllo che la traccia non appartenga già al disco
        SET ID_traccia = (
			SELECT t.id
            FROM traccia t
            WHERE t.titolo=titolo
            AND t.durata=durata
            AND t.id_etichetta=id_etichetta
            AND t.id_disco=id_disco
        );
        IF(ID_traccia IS NOT NULL) THEN
			#La traccia appartiene già a quel disco
            SIGNAL SQLSTATE "45000" set message_text = "La traccia appartiene già a questo disco!";
		ELSE 
			# La traccia non è stata trovata, quindi la aggiungo al disco
            INSERT INTO traccia(`titolo`, `durata`, `id_etichetta`, `id_disco`) 
            VALUES (titolo, durata, id_etichett, id_disco);
        END IF;
    ELSE 
		# Se l'id del disco o dell'etichetta sono errati o non esistono lancio una eccezione
		SIGNAL SQLSTATE "45000" set message_text = "L'ID del disco o dell'etichetta non sono validi!";
    END IF;
    END$
DELIMITER ;
