DROP TRIGGER IF EXISTS controlla_generi;

DELIMITER $

CREATE TRIGGER controlla_generi BEFORE DELETE ON classificazione FOR EACH ROW
BEGIN

	DECLARE numero_generi integer;
	/* Controlla che un disco non rimanga mai con meno di 1 genere */
    
    SET numero_generi = (
		SELECT count(distinct c.nome_genere)
		FROM classificazione c
		WHERE c.id_disco=old.id_disco);
    
    IF(numero_generi <= 1) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Operazione vietata!";
	END IF;

END$

DELIMITER ;