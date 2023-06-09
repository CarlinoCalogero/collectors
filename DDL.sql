-- --------------------------------------------------------
-- Data Definitoin Language (DDL)
-- --------------------------------------------------------

--
-- Database initialization
--

drop database if exists collectors;
create database if not exists collectors;
use collectors;

--
-- Dropping database if existing
--

drop table if exists incide;
drop table if exists classificazione;
drop table if exists produce;
drop table if exists costituito;
drop table if exists condivisa;
drop table if exists band;
drop table if exists artista_singolo;
drop table if exists traccia;
drop table if exists immagine;
drop table if exists info_disco;
drop table if exists disco;
drop table if exists collezione_di_dischi;
drop table if exists collezionista;
drop table if exists autore;
drop table if exists etichetta;
drop table if exists tipologia;
drop table if exists stato;
drop table if exists ruolo;
drop table if exists formato;
drop table if exists genere;

--
-- Creating tables
--

create table genere(
nome varchar(50),
constraint NOME_genere primary key(nome)
);
create table formato(
nome varchar(50),
constraint NOME_formato primary key(nome)
);
create table ruolo(
nome varchar(50),
constraint NOME_ruolo primary key(nome)
);
create table stato(
nome varchar(50),
constraint NOME_stato primary key(nome)
);
create table tipologia(
nome varchar(50),
constraint NOME_tipologia primary key(nome)
);
create table etichetta(
id integer unsigned auto_increment,
nome varchar(200) not null,
partitaIVA varchar(11) not null,
constraint ID_etichetta primary key(id),
constraint unique_partitaIVA unique(partitaIVA)
);
create table autore(
id integer unsigned auto_increment,
nome_darte varchar(100) not null,
tipo boolean not null,
constraint ID_autore primary key(id),
constraint unique_autore unique(nome_darte)
);
create table collezionista(
id integer unsigned auto_increment,
nickname varchar(100) not null,
email varchar(200) not null,
constraint ID_collezionista primary key(id),
constraint unique_collezionista unique(nickname, email)
);
create table collezione_di_dischi(
id integer unsigned auto_increment,
nome varchar(200) not null,
visibilita boolean not null,
id_collezionista integer unsigned not null,
constraint ID_collezione primary key(id),
constraint collezione_collezionista foreign key(id_collezionista) references collezionista(id) on delete cascade,
constraint unique_collezione unique(id_collezionista,nome)
);
create table disco(
id integer unsigned auto_increment,
titolo varchar(50) not null,
anno_di_uscita date not null,
nome_formato varchar(50) not null,
nome_stato varchar(50) not null,
id_etichetta integer unsigned not null,
id_collezione_di_dischi integer unsigned not null,
constraint ID_disco primary key(id),
constraint disco_formato foreign key(nome_formato) references formato(nome) on delete restrict on update cascade,
constraint disco_etichetta foreign key(id_etichetta) references etichetta(id) on delete restrict,
constraint disco_stato foreign key(nome_stato) references stato(nome) on delete restrict on update cascade,
constraint disco_collezione foreign key(id_collezione_di_dischi) references collezione_di_dischi(id) on delete cascade,
constraint unique_disco unique(titolo,anno_di_uscita,nome_formato,nome_stato, id_etichetta,id_collezione_di_dischi)
);
create table info_disco(
id_disco integer unsigned,
barcode varchar(200),
note text,
numero_copie integer unsigned default 1,
constraint ID_info_disco primary key(id_disco),
constraint unique_barcode unique(barcode),
constraint info_disco_disco foreign key(id_disco) references disco(id) on delete cascade
);
create table immagine(
id integer unsigned auto_increment,
path varchar(100) not null, 
descrizione text,
id_disco integer unsigned not null,
nome_tipologia varchar(50) not null,
constraint ID_immagine primary key(id),
constraint unique_immagine unique(id_disco,path,nome_tipologia),
constraint immagine_disco foreign key(id_disco) references disco(id) on delete cascade,
constraint immagine_tipologia foreign key(nome_tipologia) references tipologia(nome) on delete restrict on update cascade
);
create table traccia(
id integer unsigned auto_increment,
titolo varchar(50) not null,
durata decimal(10,2) unsigned default 0.0,
id_etichetta integer unsigned not null,
id_disco integer unsigned not null,
constraint ID_traccia primary key(id),
constraint traccia_etichetta foreign key(id_etichetta) references etichetta(id) on delete restrict,
constraint traccia_disco foreign key(id_disco) references disco(id) on delete cascade,
constraint unique_traccia unique(titolo,id_etichetta,id_disco)
);
create table artista_singolo(
id integer unsigned auto_increment,
nome varchar(50) not null,
cognome varchar(50) not null,
data_nascita date not null,
luogo_nascita varchar(50) not null,
id_autore integer unsigned not null,
constraint ID_artista primary key(id),
constraint artista_singolo_autore foreign key(id_autore) references autore(id) on delete cascade,
constraint unique_artista_singolo unique(nome,cognome,data_nascita,luogo_nascita),
constraint unique_autore_artista_singolo unique(id_autore)
);
create table band(
id integer unsigned auto_increment,
id_fondatore integer unsigned not null,
data_fondazione date not null,
id_autore integer unsigned not null,
constraint ID_band primary key(id),
constraint band_artista_singolo foreign key(id_fondatore) references artista_singolo(id) on delete restrict,
constraint band_autore foreign key(id_autore) references autore(id) on delete cascade,
constraint unique_band unique(id_fondatore,data_fondazione),
constraint unique_autore_band unique(id_autore)
);
# Relazioni
create table condivisa(
id_collezionista integer unsigned not null,
id_collezione integer unsigned not null,
constraint primary_condivisione primary key(id_collezionista,id_collezione),
constraint condivisa_collezionista foreign key(id_collezionista) references collezionista(id) on delete cascade,
constraint condivisa_collezione foreign key(id_collezione) references collezione_di_dischi(id) on delete cascade
);
create table costituito(
 id_band integer unsigned not null,
 id_artista integer unsigned not null,
 constraint primary_costituito primary key(id_band,id_artista),
 constraint costituito_band foreign key(id_band) references band(id) on delete cascade,
 constraint costituito_artista_singolo foreign key(id_artista) references artista_singolo(id) on delete restrict
);
create table produce(
id_traccia integer unsigned not null,
id_autore integer unsigned not null,
nome_ruolo varchar(50) not null,
constraint primary_produce primary key(id_traccia,id_autore,nome_ruolo),
constraint produce_traccia foreign key(id_traccia) references traccia(id) on delete cascade,
constraint produce_autore foreign key(id_autore) references autore(id) on delete restrict,
constraint produce_ruolo foreign key(nome_ruolo) references ruolo(nome) on delete restrict on update cascade
);
create table classificazione(
nome_genere varchar(50) not null,
id_disco integer unsigned not null,
constraint primary_classificazione primary key(nome_genere,id_disco),
constraint classificazione_genere foreign key(nome_genere) references genere(nome) on delete restrict on update cascade,
constraint classificazione_disco foreign key(id_disco) references disco(id) on delete cascade
);
create table incide(
id_disco integer unsigned not null,
id_autore integer unsigned not null,
constraint primary_raggruppamento primary key(id_disco,id_autore),
constraint incide_disco foreign key(id_disco) references disco(id) on delete cascade,
constraint incide_autore foreign key(id_autore) references autore(id) on delete restrict
);

DROP USER IF EXISTS 'application'@'localhost';
CREATE USER 'application'@'localhost' IDENTIFIED BY "$app!";
GRANT select,insert,update,execute,delete,show view,create temporary tables ON collectors.* TO 'application'@'localhost';