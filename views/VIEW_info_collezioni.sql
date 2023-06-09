DROP VIEW IF EXISTS info_collezioni;
CREATE VIEW info_collezioni AS
SELECT c.id, c.nome, c.visibilita, ca.nickname, ca.email
	FROM collezione_di_dischi c
	JOIN collezionista ca ON ca.id=c.id_collezionista
ORDER BY c.id DESC;