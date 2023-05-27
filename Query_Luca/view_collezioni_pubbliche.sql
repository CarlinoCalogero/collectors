drop view if exists collezioni_pubbliche;
create view collezioni_pubbliche as
		select nome,visibilita
		from collezione_di_dischi
		where visibilita = true;