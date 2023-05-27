select coll.id_collezionista, coll.*, cls.nickname
from condivisa cond
join collezione_di_dischi coll on cond.id_collezione = coll.id
join collezionista cls on cond.id_collezionista = cls.id