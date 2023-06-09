DROP TRIGGER IF EXISTS controlla_generi;
DROP TRIGGER IF EXISTS on_update_visibilita;
DROP TRIGGER IF EXISTS check_artista; 
DROP TRIGGER IF EXISTS check_band;
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

CREATE TRIGGER on_update_visibilita BEFORE UPDATE ON collezione_di_dischi FOR EACH ROW
BEGIN

	IF(old.visibilita = false AND new.visibilita = true) THEN
		DELETE FROM condivisa WHERE id_collezione = old.id;
  END IF;

END$

CREATE TRIGGER check_artista BEFORE INSERT ON artista_singolo FOR EACH ROW
BEGIN

  DECLARE tipo_autore boolean; 

  SET tipo_autore = (
      SELECT tipo
      FROM autore
      WHERE id = new.id_autore); 
      
      /* Controlla che il tipo dichiarato nell'inserimento dell artista combaci con quello
       dell'artista che si sta inserendo (artista singolo o band)*/
      IF(tipo_autore = true) THEN 
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il tipo dell'autore non combacia.";
      END IF; 
      
      /* Controllo sulla data di nascita affinchè non ecceda quella corrente*/
      IF(new.data_nascita > date(now())) THEN
        SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Errore nella data di nascita.";
      END IF; 
END$

CREATE TRIGGER check_band BEFORE INSERT ON band FOR EACH ROW
BEGIN

	DECLARE tipo_autore boolean;

  SET tipo_autore = (
      SELECT tipo 
      FROM autore 
      WHERE id = new.id_autore);

  /* Controlla che il tipo dichiarato nell'inserimento dell autore combaci con 
  quello dell'artista che si sta inserendo (artista singolo o band)*/
  IF(tipo_autore = false) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il tipo dell'autore non combacia";
  END IF;

  /* Controllo sulla data di nascita affinchè non ecceda quella corrente*/
  IF(new.data_fondazione > date(now())) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Errore nella data di nascita.";
  END IF;

END$

DELIMITER ;