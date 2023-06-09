# 6.Lista di tutti i dischi in una collezione

DROP PROCEDURE IF EXISTS dischi_in_collezione;
DROP FUNCTION IF EXISTS generi_disco;

DELIMITER $

CREATE PROCEDURE dischi_in_collezione(in id_collezione integer unsigned)
BEGIN
	SELECT d.id as "ID",
		   d.titolo as "Titolo",
		   d.anno_di_uscita as "Anno di uscita",
		   d.nome_stato as "Stato",
		   d.nome_formato as "Formato",
		   e.nome as "Etichetta",
           generi_disco(d.id) as "Generi", # Funzione per ricavare tutti i generi in un unica riga
           inf.barcode as "Barcode",
           inf.note as "Note",
           inf.numero_copie as "Copie"
	from disco d
    join etichetta e on d.id_etichetta = e.id
    join info_disco inf on inf.id_disco = d.id
    where d.id_collezione_di_dischi = id_collezione;
END$

#Funzione che ritorna tutti i generi di un disco in un unica concatenazione da usare in altre query
CREATE FUNCTION generi_disco(id_disco integer unsigned) 
RETURNS varchar(200) DETERMINISTIC
BEGIN
	RETURN (SELECT group_concat(g.nome separator ", ") 
			FROM classificazione c
			JOIN genere g ON c.nome_genere = g.nome
			WHERE c.id_disco = id_disco);
END$

DELIMITER ;