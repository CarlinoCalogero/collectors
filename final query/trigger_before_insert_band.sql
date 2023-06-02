DROP TRIGGER IF EXISTS check_band;

DELIMITER $

CREATE TRIGGER check_band BEFORE INSERT ON band FOR EACH ROW
BEGIN

	DECLARE tipo_autore boolean;

  SET tipo_autore = (
      SELECT tipo 
      FROM autore 
      WHERE id = new.id_autore);

  /* Controlla che il tipo dichiarato nell'inserimento dell autore combaci con 
  quello dell'artista che si sta inserendo (artista singolo o band)*/*/
  IF(tipo_autore = false) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il tipo dell'autore non combacia";
  END IF;

  /* Controllo sulla data di nascita affinchè non ecceda quella corrente*/
  IF(new.data_fondazione > date(now())) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Errore nella data di nascita.";
  END IF;

END$

DELIMITER ;