# Ricerca di dischi in base a nomi di autori/compositori/interpreti e/o titoli. Si potrà decidere
# di includere nella ricerca le collezioni di un certo collezionista e/o quelle condivise con lo
# stesso collezionista e/o quelle pubbliche. (Suggerimento: potete realizzare diverse query in
# base alle varie combinazioni di criteri di ricerca. Usate la UNION per unire i risultati delle
# ricerche effettuate sulle collezioni private, condivise e pubbliche)

# 1. Cercare nelle proprie collezioni dischi in base al nome della traccia
# 2. Cercare nelle collezioni condivise con me dischi in base al nome della traccia
# 3. Cercare nelle collezioni pubbliche dischi in base al nome della traccia
# Unire i risultati con UNION DISTINCT

DELIMITER $

DROP PROCEDURE IF EXISTS cerca_disco_con_traccia$

CREATE PROCEDURE cerca_disco_con_autore(
	in id_collezionista integer unsigned,
    in nome_darte varchar(100))
BEGIN
	DECLARE id_coll integer unsigned;
    
    SET id_coll = (
		SELECT c.id
        FROM collezionista c
        WHERE c.id=id_collezionista
    );
    
    IF(id_coll is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="ID collezionista non trovato!";
    END IF;
    
	# Collezioni personali e private
    SELECT d.*
    FROM disco d
    JOIN incide i ON d.id=i.id_disco
    JOIN autore a ON a.id=i.id_autore
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN collezionista cl ON cl.id = c.id_collezionista
    WHERE a.nome_darte=nome_darte 
    AND cl.id=id_collezionista 
    AND c.visibilita=false
    
    UNION DISTINCT
    
    # Collezioni pubbliche
    SELECT d.*
    FROM disco d
    JOIN incide i ON d.id=i.id_disco
    JOIN autore a ON a.id=i.id_autore
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    WHERE a.nome_darte=nome_darte
    AND c.visibilita=true
    
    UNION DISTINCT 
    # Collezioni private condivise con me
    SELECT d.*
    FROM disco d
    JOIN incide i ON d.id=i.id_disco
    JOIN autore a ON a.id=i.id_autore
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN condivisa con ON con.id_collezione=c.id
    JOIN collezionista col ON col.id=con.id_collezionista
    WHERE a.nome_darte=nome_darte
    AND col.id=id_collezionista
    AND c.visibilita=false; #Superfluo, le collezioni condivise sono per forza private

END$

DELIMITER ;