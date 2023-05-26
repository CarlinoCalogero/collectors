CREATE VIEW condivisione_collezioni as
SELECT cd.id, coll2.nickname as proprietario, cd.nome, c.nickname as condivisa_con 
	FROM collectors.condivisa con
	JOIN collezionista c on c.id=con.id_collezionista
    JOIN collezione_di_dischi cd on cd.id=con.id_collezione
    JOIN collezionista coll2 on coll2.id=cd.id_collezionista
ORDER BY CD.ID asc;