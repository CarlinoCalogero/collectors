DELIMITER $
CREATE PROCEDURE aggiungi_collezione(in nome_collezione varchar(200),in visibilita boolean,in nickname varchar(100), in email varchar(200))
BEGIN 
	DECLARE id_collezionista integer unsigned;
	# TODO: gestire la visibilità, viene creata una collezione inizialmente privata e poi cambiata
    # la visibilità a pubblica con un'altra procedura?
    # TODO: ricevere in input anche le informazioni dei dischi, delle tracce ecc. o permettere di creare 
    # una collezione vuota iniziale? (Preferirei la seconda per non fare multiparametrica la procedura,
    # altrimenti bisognerebbe fare in modo che un utente inserisca prima le tracce, poi i dischi e le immagini
	SET id_collezionista = (SELECT c.id FROM collectors.collezionista c WHERE c.email=email AND c.nickname=nickname);
	INSERT INTO collectors.collezione_di_dischi(`nome`,`visibilita`,`id_collezionista`) 
		VALUES (nome_collezione,visibilita,id_collezionista);
END$
DELIMITER ;	