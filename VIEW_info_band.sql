CREATE VIEW info_band as
SELECT b.id, ak.nome_darte, 
	b.data_fondazione,
    ars.nome as nome_fondatore,
    ars.cognome as cognome_fondatore, 
	a.nome_darte as nome_arte_fondatore,
    au.nome_darte as membro
    FROM band b 
	JOIN artista_singolo ars on b.id_fondatore=ars.id 
	JOIN autore a on ars.id_autore=a.id
	JOIN autore ak on ak.id=b.id_autore
	JOIN costituito c on c.id_band=b.id
    JOIN artista_singolo ars1 on ars1.id=c.id_artista
    JOIN autore au on au.id=ars1.id_autore
ORDER BY b.id ASC;