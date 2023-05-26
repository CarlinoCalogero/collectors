drop view if exists formazioni_bands;
create view formazioni_bands as
select  ab.nome_darte as "nome band", 
		b.data_fondazione as "data fondazione",
        fond.nome as "fondatore",
        aas.nome_darte as "membro",
        a.nome as "nome membro"
from costituito comp
join band b on comp.id_band= b.id
join artista_singolo a on comp.id_artista = a.id
join artista_singolo fond on b.id_fondatore = fond.id
join autore ab on b.id_autore = ab.id
join autore aas on a.id_autore = aas.id
order by b.id, ab.nome_darte
