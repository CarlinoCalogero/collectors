DROP TRIGGER IF EXISTS check_artista; 

DELIMITER $ 

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