#Funzione che ritorna tutti i generi di un disco in un unica concatenazione da usare in altre query
drop function if exists generi_disco;
delimiter $
create function generi_disco(id_disco integer unsigned) returns varchar(200) deterministic
begin
	return (select group_concat(g.nome separator " ,") 
			from classificazione c
			join genere g on c.nome_genere = g.nome
			where c.id_disco = id_disco);
end$