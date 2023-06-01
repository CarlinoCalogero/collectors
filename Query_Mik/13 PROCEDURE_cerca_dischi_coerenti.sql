# Opzionalmente, dati un numero di barcode, un titolo e il nome di un autore, 
# individuare tutti i dischi presenti nelle collezioni che sono più coerenti 
# con questi dati (funzionalità utile, ad esempio, per individuare un disco 
# già presente nel sistema prima di inserirne un doppione). L'idea è che il 
# barcode è univoco, quindi i dischi con lo stesso barcode sono senz'altro molto coerenti, 
# dopodichè è possibile cercare dischi con titolo simile e/o con l'autore dato, 
# assegnando maggior punteggio di somiglianza a quelli che hanno più corrispondenze. 
# Questa operazione può essere svolta con una stored procedure o implementata nell'interfaccia Java/PHP.

# Logica della query
# 1. Cerco un disco nelle collezioni pubbliche (per semplicità) in base al barcode
# 2. Se il barcode è null, faccio una ricerca in base al titolo del disco, questo non essendo univoco 
# tornerà una tabella di dischi
# 3. Se il barcode è null, faccio una ricerca in base all'autore del disco, questo non essendo univoco
# tornerà una tabella
# 4. Unisco, eventualmente, tutti i risultati ordinati secondo un certo criterio di coerenza
# es. order by barcode, disco.titolo, autore.nome_darte 

DELIMITER $

DROP PROCEDURE IF EXISTS cerca_disco$

CREATE PROCEDURE cerca_disco(
	in barcode varchar(200),
    in titolo varchar(50),
    in nome_autore varchar(100)
)
BEGIN
	IF(barcode is not null) THEN
    
		# Ricerca di un disco in base al barcode
		SELECT d.*
		FROM disco d
		JOIN info_disco i ON i.id_disco=d.id
		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
		WHERE c.visibilita=true AND i.barcode=barcode;
        
	ELSE 
		# Cerco i dischi in base alla titolo
		SELECT d.*
		FROM disco d
		JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
		WHERE t.id=id_traccia
		AND c.visibilita=true;
    END IF;

END$

DELIMITER ;