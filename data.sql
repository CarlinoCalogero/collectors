USE collectors;

INSERT INTO genere(nome) VALUES ("Rock");
INSERT INTO genere(nome) VALUES ("Pop");
INSERT INTO genere(nome) VALUES ("Rap");
INSERT INTO genere(nome) VALUES ("Indie");
INSERT INTO genere(nome) VALUES ("Metal");
INSERT INTO genere(nome) VALUES ("Cantautorato");

INSERT INTO formato(nome) VALUES ("Vinile");
INSERT INTO formato(nome) VALUES ("CD");
INSERT INTO formato(nome) VALUES ("Digitale");

#Una persona potrebbe avere più di un ruolo? (es. cantante, musicista e proprietario)
INSERT INTO ruolo(nome) VALUES ("Cantante");
INSERT INTO ruolo(nome) VALUES ("Featuring");
INSERT INTO ruolo(nome) VALUES ("Musicista");
INSERT INTO ruolo(nome) VALUES ("Proprietario");

INSERT INTO stato(nome) VALUES ("Perfetto");
INSERT INTO stato(nome) VALUES ("Buono");
INSERT INTO stato(nome) VALUES ("Usurato");
INSERT INTO stato(nome) VALUES ("Molto rovinato");

INSERT INTO tipologia(nome) VALUES ("Copertina");
INSERT INTO tipologia(nome) VALUES ("Retro");
INSERT INTO tipologia(nome) VALUES ("Facciata interna");
INSERT INTO tipologia(nome) VALUES ("Libretto");

INSERT INTO etichetta(nome, partitaIVA) VALUES ("Universal Music Italia", "03802730154");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Capitol Records", "08288100962");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Sony Music", "08072811006");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Warner Music Italy", "02079400152");
INSERT INTO etichetta(nome, partitaIVA) VALUES ("Virgin Records", "11186180151");

INSERT INTO autore(nome_darte, tipo) VALUES ("Pink Floyd", true); #capitol
INSERT INTO autore(nome_darte, tipo) VALUES ("Marracash", false); #universal
INSERT INTO autore(nome_darte, tipo) VALUES ("Rino Gaetano", false); #sony
INSERT INTO autore(nome_darte, tipo) VALUES ("Linkin Park", true); #warner
INSERT INTO autore(nome_darte, tipo) VALUES ("The Rolling Stones", true); #virgin
INSERT INTO autore(nome_darte, tipo) VALUES ("Syd", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Chester Bennington",false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Brian Jones",false);
INSERT INTO autore(nome_darte,tipo) VALUES ("George Waters", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Nick Mason", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("David Gilmour", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Mike Shinoda", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Rob Bourdon", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Mr.Hahn", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Mick", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Ronnie", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Rick Brown", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Marz", false);
INSERT INTO autore(nome_darte,tipo) VALUES ("Zef", false);

INSERT INTO collezionista(nickname, email) VALUES ("Michael","michael.piccirilli@student.univaq.it");
INSERT INTO collezionista(nickname, email) VALUES ("Luca", "lucafrancesco.macera@student.univaq.it");
INSERT INTO collezionista(nickname, email) VALUES ("Calogero","calogero.carlino@student.univaq.it");

# visibilità true->pubblica false->privata
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Grandi successi mondiali",1,1);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Migliori hit",1,2);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Collezione personale",0,1);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Mie vibes",1,3);
INSERT INTO collezione_di_dischi(nome, visibilita, ID_collezionista) VALUES("Collezione segreta",0,2);

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
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("George Roger","Waters", "1943-09-06","Great Bookham",9);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Nicholas Berkeley","Mason", "1944-01-27","Birmingham",10);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("David Jon","Gilmour", "1946-03-06","Cambridge",11);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Michael Kenji","Shinoda", "1977-02-11","Los Angeles",12);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Robert Gregory","Bourdon", "1979-01-10","Calabasas",13);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Joseph","Hahn", "1977-03-15","Dallas",14);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Michael Philip","Jagger", "1943-07-26","Dartford",15);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Ronald David","Wood", "1947-06-01","Londra",16);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Ricky","Fenson", "1945-05-22","Chopwell",17);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Alessandro","Pulga", "1990-04-15","Cormano",18);
INSERT INTO artista_singolo(nome,cognome,data_nascita,luogo_nascita,id_autore) 
	VALUES ("Stefano","Tognini", "1990-10-24","Sondrio",19);

INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(3,"1965-04-30",1);
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(4,"1996-05-18",4);
INSERT INTO band(id_fondatore, data_fondazione, id_autore) 
	VALUES(5,"1962-07-12",5);
    
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (2,1);
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (3,1);
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (3,2);
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (1,4);
INSERT INTO condivisa(id_collezionista,id_collezione) VALUES (2,4);

#pink floyd
INSERT INTO costituito(id_band,id_artista) VALUES (1,6);
INSERT INTO costituito(id_band,id_artista) VALUES (1,7);
INSERT INTO costituito(id_band,id_artista) VALUES (1,8);

#linkin park
INSERT INTO costituito(id_band,id_artista) VALUES (2,9);
INSERT INTO costituito(id_band,id_artista) VALUES (2,10);
INSERT INTO costituito(id_band,id_artista) VALUES (2,11);

#the rolling stones
INSERT INTO costituito(id_band,id_artista) VALUES (3,12);
INSERT INTO costituito(id_band,id_artista) VALUES (3,13);
INSERT INTO costituito(id_band,id_artista) VALUES (3,14);

#pink floyd
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(1,1,"Proprietario"); #breathe
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(1,1,"Cantante"); #breathe
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(1,1,"Musicista"); #breathe
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(2,1,"Proprietario"); #time
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(2,1,"Cantante"); #time
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(2,1,"Musicista"); #time

#marracash
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,2,"Proprietario"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,2,"Cantante"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,15,"Musicista"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(3,16,"Proprietario"); #dubbi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,2,"Proprietario"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,2,"Cantante"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,15,"Musicista"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(4,16,"Musicista"); #importante
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,2,"Proprietario"); #crazy love
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,2,"Cantante"); #crazy love
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,15,"Musicista"); #crazy love
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(5,16,"Musicista"); #crazy love

#Rino Gaetano
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(6,3,"Proprietario"); #aida
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(6,3,"Cantante"); #aida
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(6,3,"Musicista"); #aida
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(7,3,"Proprietario"); #spendi spandi effendi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(7,3,"Cantante"); #spendi spandi effendi
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(7,3,"Musicista"); #spendi spandi effendi

#Linkin Park
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(8,4,"Proprietario"); #numb
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(8,4,"Cantante"); #numb
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(8,4,"Musicista"); #numb
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(9,4,"Proprietario"); #faint
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(9,4,"Cantante"); #faint
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(9,4,"Musicista"); #faint
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(10,4,"Proprietario"); #breaking the habit
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(10,4,"Cantante"); #breaking the habit
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(10,4,"Musicista"); #breaking the habit

#Rolling stones
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(11,5,"Proprietario"); #sweet virgina
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(11,5,"Cantante"); #sweet virgina
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(11,5,"Musicista"); #sweet virgina
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(12,5,"Proprietario"); #like a rolling stones
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(12,5,"Cantante"); #like a rolling stones
INSERT INTO produce(id_traccia, id_autore,nome_ruolo) VALUES(12,5,"Musicista"); #like a rolling stones

INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rock",1); #the dark side of the moon
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rap",2); #noi, loro, gli altri
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Pop",3); #aida
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Cantautorato",3); #aida
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Metal",4); #meteora
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rap",4); #meteora
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rock",4); #meteora
INSERT INTO classificazione(nome_genere,id_disco) VALUES ("Rock",5); #stripped

INSERT INTO incide(id_disco,id_autore) VALUES(1,1);
INSERT INTO incide(id_disco,id_autore) VALUES(2,2);
INSERT INTO incide(id_disco,id_autore) VALUES(3,3);
INSERT INTO incide(id_disco,id_autore) VALUES(4,4);
INSERT INTO incide(id_disco,id_autore) VALUES(5,5);