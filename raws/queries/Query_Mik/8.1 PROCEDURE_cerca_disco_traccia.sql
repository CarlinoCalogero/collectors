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

CREATE PROCEDURE cerca_disco_con_traccia(
	in id_collezionista integer unsigned,
    in id_traccia integer unsigned)
BEGIN
    
	# Collezioni personali e private
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           t.titolo as "Traccia"
    FROM disco d
    JOIN traccia t ON t.id_disco=d.id
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN collezionista cl ON cl.id = c.id_collezionista
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE t.id=id_traccia
    AND cl.id=id_collezionista 
    AND c.visibilita=false
    
    UNION DISTINCT
    
    # Collezioni pubbliche
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           t.titolo as "Traccia"
    FROM disco d
    JOIN traccia t ON t.id_disco=d.id
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE t.id=id_traccia
    AND c.visibilita=true
    
    UNION DISTINCT 
    # Collezioni private condivise con me
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           t.titolo as "Traccia"
    FROM disco d
    JOIN traccia t ON t.id_disco=d.id
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN condivisa con ON con.id_collezione=c.id
    JOIN collezionista col ON col.id=con.id_collezionista
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE t.id=id_traccia
    AND col.id=id_collezionista
    AND c.visibilita=false; #Superfluo, le collezioni condivise sono per forza private

END$

DELIMITER ;