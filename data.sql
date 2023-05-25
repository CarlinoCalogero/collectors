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
