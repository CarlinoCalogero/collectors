DROP TRIGGER IF EXISTS on_update_visibilita;

DELIMITER $

CREATE TRIGGER on_update_visibilita BEFORE UPDATE ON collezione_di_dischi FOR EACH ROW
BEGIN

	IF(old.visibilita = false AND new.visibilita = true) THEN
		DELETE FROM condivisa WHERE id_collezione = old.id;
  END IF;

END$

DELIMITER ;