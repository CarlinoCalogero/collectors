USE collectors;
DELETE FROM genere;
INSERT INTO genere(nome) VALUES ("Rock");
INSERT INTO genere(nome) VALUES ("Pop");
INSERT INTO genere(nome) VALUES ("Rap");
INSERT INTO genere(nome) VALUES ("Indie");
INSERT INTO genere(nome) VALUES ("Metal");
INSERT INTO genere(nome) VALUES ("Cantautorato");

DELETE FROM formato;
INSERT INTO formato(nome) VALUES ("Vinile");
INSERT INTO formato(nome) VALUES ("CD");
INSERT INTO formato(nome) VALUES ("Digitale");

DELETE FROM ruolo;
#Una persona potrebbe avere più di un ruolo? (es. cantante, musicista e proprietario)
INSERT INTO ruolo(nome) VALUES ("Cantante");
INSERT INTO ruolo(nome) VALUES ("Featuring");
INSERT INTO ruolo(nome) VALUES ("Musicista");
INSERT INTO ruolo(nome) VALUES ("Proprietario");

DELETE FROM stato;
INSERT INTO stato(nome) VALUES ("Perfetto");
INSERT INTO stato(nome) VALUES ("Buono");
INSERT INTO stato(nome) VALUES ("Usurato");
INSERT INTO stato(nome) VALUES ("Molto rovinato");

DELETE FROM tipologia;
INSERT INTO tipologia(nome) VALUES ("Copertina");
INSERT INTO tipologia(nome) VALUES ("Retro");
INSERT INTO tipologia(nome) VALUES ("Facciata interna");
INSERT INTO tipologia(nome) VALUES ("Libretto");

DELETE FROM etichetta;
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Universal Music Italia", "03802730154");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Capitol Records", "08288100962");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Sony Music", "08072811006");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Warner Music Italy", "02079400152");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Virgin Records", "11186180151");

DELETE FROM autore;
INSERT INTO autore(nome_darte, tipo) VALUES ("Pink Floyd", true); #capitol
INSERT INTO autore(nome_darte, tipo) VALUES ("Marracash", false); #universal
INSERT INTO autore(nome_darte, tipo) VALUES ("Rino Gaetano", false); #sony
INSERT INTO autore(nome_darte, tipo) VALUES ("Linkin Park", true); #warner
INSERT INTO autore(nome_darte, tipo) VALUES ("The Rolling Stones", true); #virgin
INSERT INTO autore(nome_darte, tipo) VALUES ("Syd", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Chester Bennington",false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Brian Jones",false);

DELETE FROM collezionista;
INSERT INTO collezionista(nickname, email) VALUES ("Michael","michael.piccirilli@student.univaq.it");
INSERT INTO collezionista(nickname, email) VALUES ("Luca", "lucafrancesco.macera@student.univaq.it");
INSERT INTO collezionista(nickname, email) VALUES ("Calogero","calogero.carlino@student.univaq.it");

# visibilità true->pubblica false->privata
DELETE FROM collezione_di_dischi;
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Grandi successi mondiali",1,1);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Migliori hit",1,2);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Collezione personale",0,1);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Mie vibes",1,3);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Collezione segreta",0,2);

DELETE FROM disco;
# date format YYYY-MM-DD
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("The Dark Side Of The Moon","1973-03-01","Vinile", "Perfetto", 2, 1);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Noi, loro, gli altri", "2021-11-19","Digitale","Perfetto",1,3);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Aida","1977-05-24","Vinile","Usurato",3,4);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Meteora","2003-03-25","CD","Buono",4,5);
INSERT INTO disco(titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi) 
	VALUES ("Stripped","1995-11-13","CD","Molto Rovinato",5,2);
    
DELETE FROM info_disco;
INSERT INTO info_disco(id_disco, barcode, note) 
	VALUES (1, "500902945325", "Rappresenta uno dei dischi più belli della storia della musica");
INSERT INTO info_disco(id_disco, barcode) 
	VALUES (3, "900393283831");
INSERT INTO info_disco(id_disco, note) 
	VALUES (2,"Un grande classico del rap italiano");
INSERT INTO info_disco(id_disco, barcode, note) 
	VALUES (4, "900384822842", "Meteora rappresenta la storia del Metal e di una generazione crescita a cavallo degli anni 2000");
INSERT INTO info_disco(id_disco, barcode, numero_copie) 
	VALUES (5, "688848392234",2);
    
DELETE FROM immagine;
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("TDSOTM_cover.jpeg","Copertina dell'album The Dark Side Of The Moon",1,"Copertina");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("TDSOTM_back.jpeg","Retro dell'album The Dark Side Of The Moon",1,"Retro");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Noi_loro_gli_altri.png","Cover dell'album 'Noi, loro, gli altri'",2,"Copertina");
INSERT INTO immagine(path, id_disco, nome_tipologia) 
	VALUES ("Aida_copertina.jpeg",3,"Copertina");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Meteora_cover.png","Copertina dell'album Meteora",4,"Copertina");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Meteora_facciata1.png","Facciata interna sinistra dell'album Meteora",4,"Facciata interna");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Meteora_facciata2.png","Facciata interna destra dell'album Meteora",4,"Facciata interna");
INSERT INTO immagine(path, descrizione, id_disco, nome_tipologia) 
	VALUES ("Stripped.svg","Cover di Stripped by The Rolling Stones",5,"Copertina");
INSERT INTO immagine(path, id_disco, nome_tipologia) 
	VALUES ("Stripped_lib.svg",5,"Libretto");
INSERT INTO immagine(path, id_disco, nome_tipologia) 
	VALUES ("Stripped_lib2.svg",5,"Libretto");
    
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Breathe (In The Air)",2.49, 2, 1);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Time",7.02, 2, 1);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Dubbi", 3.54, 1, 2);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Importante",3.21,1,2);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Crazy Love",3.12,1,2);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Aida",4.25,3,3);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Spendi Spandi Effendi",4.01,3,3);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Numb",3.05,4,4);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Faint",2.42,4,4);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Breaking The Habit",3.16,4,4);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Sweet Virgina",4.15,5,5);
INSERT INTO traccia(titolo, durata, id_etichetta, id_disco) 
	VALUES ("Like A Rolling Stones",5.38,5,5);
    
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Fabio","Bartolo Rizzo", "1979-05-22","Nicosia",2);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Salvatore Antonio","Gaetano", "1950-11-22","Crotone",3);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Roger Keith","Barrett", "1946-01-06","Cambridge",6);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Chester Charles","Bennington", "1976-03-20","Phoenix",7);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Lewis Brian","Hopkin Jones", "1942-02-28","Cheltenham",8);

	
    
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(3,"1965-04-30",1);
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(4,"1996-05-18",4);
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(5,"1962-07-12",5);
