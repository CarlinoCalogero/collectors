-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)

CREATE DATABASE IF NOT EXISTS collectors;
USE collectors;
--
-- Host: localhost    Database: collectors
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `artista_singolo`
--

DROP TABLE IF EXISTS `artista_singolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artista_singolo` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `data_nascita` date NOT NULL,
  `luogo_nascita` varchar(50) NOT NULL,
  `id_autore` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_artista_singolo` (`nome`,`cognome`,`data_nascita`,`luogo_nascita`),
  UNIQUE KEY `unique_autore_artista_singolo` (`id_autore`),
  CONSTRAINT `artista_singolo_autore` FOREIGN KEY (`id_autore`) REFERENCES `autore` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artista_singolo`
--

LOCK TABLES `artista_singolo` WRITE;
/*!40000 ALTER TABLE `artista_singolo` DISABLE KEYS */;
INSERT INTO `artista_singolo` VALUES (1,'Fabio','Bartolo Rizzo','1979-05-22','Nicosia',2),(2,'Salvatore Antonio','Gaetano','1950-11-22','Crotone',3),(3,'Roger Keith','Barrett','1946-01-06','Cambridge',6),(4,'Chester Charles','Bennington','1976-03-20','Phoenix',7),(5,'Lewis Brian','Hopkin Jones','1942-02-28','Cheltenham',8),(6,'George Roger','Waters','1943-09-06','Great Bookham',9),(7,'Nicholas Berkeley','Mason','1944-01-27','Birmingham',10),(8,'David Jon','Gilmour','1946-03-06','Cambridge',11),(9,'Michael Kenji','Shinoda','1977-02-11','Los Angeles',12),(10,'Robert Gregory','Bourdon','1979-01-10','Calabasas',13),(11,'Joseph','Hahn','1977-03-15','Dallas',14),(12,'Michael Philip','Jagger','1943-07-26','Dartford',15),(13,'Ronald David','Wood','1947-06-01','Londra',16),(14,'Ricky','Fenson','1945-05-22','Chopwell',17),(15,'Alessandro','Pulga','1990-04-15','Cormano',18),(16,'Stefano','Tognini','1990-10-24','Sondrio',19);
/*!40000 ALTER TABLE `artista_singolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autore`
--

DROP TABLE IF EXISTS `autore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autore` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nome_darte` varchar(100) NOT NULL,
  `tipo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_autore` (`nome_darte`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autore`
--

LOCK TABLES `autore` WRITE;
/*!40000 ALTER TABLE `autore` DISABLE KEYS */;
INSERT INTO `autore` VALUES (1,'Pink Floyd',1),(2,'Marracash',0),(3,'Rino Gaetano',0),(4,'Linkin Park',1),(5,'The Rolling Stones',1),(6,'Syd',0),(7,'Chester Bennington',0),(8,'Brian Jones',0),(9,'George Waters',0),(10,'Nick Mason',0),(11,'David Gilmour',0),(12,'Mike Shinoda',0),(13,'Rob Bourdon',0),(14,'Mr.Hahn',0),(15,'Mick',0),(16,'Ronnie',0),(17,'Rick Brown',0),(18,'Marz',0),(19,'Zef',0);
/*!40000 ALTER TABLE `autore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `band`
--

DROP TABLE IF EXISTS `band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `band` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_fondatore` int unsigned NOT NULL,
  `data_fondazione` date NOT NULL,
  `id_autore` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_band` (`id_fondatore`,`data_fondazione`),
  UNIQUE KEY `unique_autore_band` (`id_autore`),
  CONSTRAINT `band_artista_singolo` FOREIGN KEY (`id_fondatore`) REFERENCES `artista_singolo` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `band_autore` FOREIGN KEY (`id_autore`) REFERENCES `autore` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `band`
--

LOCK TABLES `band` WRITE;
/*!40000 ALTER TABLE `band` DISABLE KEYS */;
INSERT INTO `band` VALUES (1,3,'1965-04-30',1),(2,4,'1996-05-18',4),(3,5,'1962-07-12',5);
/*!40000 ALTER TABLE `band` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classificazione`
--

DROP TABLE IF EXISTS `classificazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classificazione` (
  `nome_genere` varchar(50) NOT NULL,
  `id_disco` int unsigned NOT NULL,
  PRIMARY KEY (`nome_genere`,`id_disco`),
  KEY `classificazione_disco` (`id_disco`),
  CONSTRAINT `classificazione_disco` FOREIGN KEY (`id_disco`) REFERENCES `disco` (`id`) ON DELETE CASCADE,
  CONSTRAINT `classificazione_genere` FOREIGN KEY (`nome_genere`) REFERENCES `genere` (`nome`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classificazione`
--

LOCK TABLES `classificazione` WRITE;
/*!40000 ALTER TABLE `classificazione` DISABLE KEYS */;
INSERT INTO `classificazione` VALUES ('Rock',1),('Rap',2),('Cantautorato',3),('Pop',3),('Metal',4),('Rap',4),('Rock',4),('Rock',5);
/*!40000 ALTER TABLE `classificazione` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collezione_di_dischi`
--

DROP TABLE IF EXISTS `collezione_di_dischi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collezione_di_dischi` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL,
  `visibilita` tinyint(1) NOT NULL,
  `id_collezionista` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_collezione` (`id_collezionista`,`nome`),
  CONSTRAINT `collezione_collezionista` FOREIGN KEY (`id_collezionista`) REFERENCES `collezionista` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collezione_di_dischi`
--

LOCK TABLES `collezione_di_dischi` WRITE;
/*!40000 ALTER TABLE `collezione_di_dischi` DISABLE KEYS */;
INSERT INTO `collezione_di_dischi` VALUES (1,'Grandi successi mondiali',1,1),(2,'Migliori hit',1,2),(3,'Collezione personale',0,1),(4,'Mie vibes',1,3),(5,'Collezione segreta',0,2),(6,'PRIVATISSIMA',0,3);
/*!40000 ALTER TABLE `collezione_di_dischi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collezionista`
--

DROP TABLE IF EXISTS `collezionista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collezionista` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nickname` varchar(100) NOT NULL,
  `email` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_collezionista` (`nickname`,`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collezionista`
--

LOCK TABLES `collezionista` WRITE;
/*!40000 ALTER TABLE `collezionista` DISABLE KEYS */;
INSERT INTO `collezionista` VALUES (3,'Calogero','calogero.carlino@student.univaq.it'),(2,'Luca','lucafrancesco.macera@student.univaq.it'),(1,'Michael','michael.piccirilli@student.univaq.it');
/*!40000 ALTER TABLE `collezionista` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `condivisa`
--

DROP TABLE IF EXISTS `condivisa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `condivisa` (
  `id_collezionista` int unsigned NOT NULL,
  `id_collezione` int unsigned NOT NULL,
  PRIMARY KEY (`id_collezionista`,`id_collezione`),
  KEY `condivisa_collezione` (`id_collezione`),
  CONSTRAINT `condivisa_collezione` FOREIGN KEY (`id_collezione`) REFERENCES `collezione_di_dischi` (`id`) ON DELETE CASCADE,
  CONSTRAINT `condivisa_collezionista` FOREIGN KEY (`id_collezionista`) REFERENCES `collezionista` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `condivisa`
--

LOCK TABLES `condivisa` WRITE;
/*!40000 ALTER TABLE `condivisa` DISABLE KEYS */;
INSERT INTO `condivisa` VALUES (2,3),(1,5),(3,5);
/*!40000 ALTER TABLE `condivisa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `condivisione_collezioni`
--

DROP TABLE IF EXISTS `condivisione_collezioni`;
/*!50001 DROP VIEW IF EXISTS `condivisione_collezioni`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `condivisione_collezioni` AS SELECT 
 1 AS `id`,
 1 AS `proprietario`,
 1 AS `nome`,
 1 AS `condivisa_con`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `costituito`
--

DROP TABLE IF EXISTS `costituito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `costituito` (
  `id_band` int unsigned NOT NULL,
  `id_artista` int unsigned NOT NULL,
  PRIMARY KEY (`id_band`,`id_artista`),
  KEY `costituito_artista_singolo` (`id_artista`),
  CONSTRAINT `costituito_artista_singolo` FOREIGN KEY (`id_artista`) REFERENCES `artista_singolo` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `costituito_band` FOREIGN KEY (`id_band`) REFERENCES `band` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costituito`
--

LOCK TABLES `costituito` WRITE;
/*!40000 ALTER TABLE `costituito` DISABLE KEYS */;
INSERT INTO `costituito` VALUES (1,6),(1,7),(1,8),(2,9),(2,10),(2,11),(3,12),(3,13),(3,14);
/*!40000 ALTER TABLE `costituito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disco`
--

DROP TABLE IF EXISTS `disco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disco` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `titolo` varchar(50) NOT NULL,
  `anno_di_uscita` date NOT NULL,
  `nome_formato` varchar(50) NOT NULL,
  `nome_stato` varchar(50) NOT NULL,
  `id_etichetta` int unsigned NOT NULL,
  `id_collezione_di_dischi` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_disco` (`titolo`,`anno_di_uscita`,`nome_formato`,`nome_stato`,`id_etichetta`,`id_collezione_di_dischi`),
  KEY `disco_formato` (`nome_formato`),
  KEY `disco_etichetta` (`id_etichetta`),
  KEY `disco_stato` (`nome_stato`),
  KEY `disco_collezione` (`id_collezione_di_dischi`),
  CONSTRAINT `disco_collezione` FOREIGN KEY (`id_collezione_di_dischi`) REFERENCES `collezione_di_dischi` (`id`) ON DELETE CASCADE,
  CONSTRAINT `disco_etichetta` FOREIGN KEY (`id_etichetta`) REFERENCES `etichetta` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `disco_formato` FOREIGN KEY (`nome_formato`) REFERENCES `formato` (`nome`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `disco_stato` FOREIGN KEY (`nome_stato`) REFERENCES `stato` (`nome`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disco`
--

LOCK TABLES `disco` WRITE;
/*!40000 ALTER TABLE `disco` DISABLE KEYS */;
INSERT INTO `disco` VALUES (3,'Aida','1977-05-24','Vinile','Usurato',3,4),(4,'Meteora','2003-03-25','CD','Buono',4,5),(2,'Noi, loro, gli altri','2021-11-19','Digitale','Perfetto',1,3),(5,'Stripped','1995-11-13','CD','Molto Rovinato',5,2),(1,'The Dark Side Of The Moon','1973-03-01','Vinile','Perfetto',2,1);
/*!40000 ALTER TABLE `disco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etichetta`
--

DROP TABLE IF EXISTS `etichetta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etichetta` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL,
  `partitaIVA` varchar(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_partitaIVA` (`partitaIVA`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etichetta`
--

LOCK TABLES `etichetta` WRITE;
/*!40000 ALTER TABLE `etichetta` DISABLE KEYS */;
INSERT INTO `etichetta` VALUES (1,'Universal Music Italia','03802730154'),(2,'Capitol Records','08288100962'),(3,'Sony Music','08072811006'),(4,'Warner Music Italy','02079400152'),(5,'Virgin Records','11186180151');
/*!40000 ALTER TABLE `etichetta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formato`
--

DROP TABLE IF EXISTS `formato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formato` (
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formato`
--

LOCK TABLES `formato` WRITE;
/*!40000 ALTER TABLE `formato` DISABLE KEYS */;
INSERT INTO `formato` VALUES ('CD'),('Digitale'),('Vinile');
/*!40000 ALTER TABLE `formato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genere`
--

DROP TABLE IF EXISTS `genere`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genere` (
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genere`
--

LOCK TABLES `genere` WRITE;
/*!40000 ALTER TABLE `genere` DISABLE KEYS */;
INSERT INTO `genere` VALUES ('Cantautorato'),('Indie'),('Metal'),('Pop'),('Rap'),('Rock');
/*!40000 ALTER TABLE `genere` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `immagine`
--

DROP TABLE IF EXISTS `immagine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `immagine` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(100) NOT NULL,
  `descrizione` text,
  `id_disco` int unsigned NOT NULL,
  `nome_tipologia` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_immagine` (`id_disco`,`path`,`nome_tipologia`),
  KEY `immagine_tipologia` (`nome_tipologia`),
  CONSTRAINT `immagine_disco` FOREIGN KEY (`id_disco`) REFERENCES `disco` (`id`) ON DELETE CASCADE,
  CONSTRAINT `immagine_tipologia` FOREIGN KEY (`nome_tipologia`) REFERENCES `tipologia` (`nome`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `immagine`
--

LOCK TABLES `immagine` WRITE;
/*!40000 ALTER TABLE `immagine` DISABLE KEYS */;
INSERT INTO `immagine` VALUES (1,'TDSOTM_cover.jpeg','Copertina dell\'album The Dark Side Of The Moon',1,'Copertina'),(2,'TDSOTM_back.jpeg','Retro dell\'album The Dark Side Of The Moon',1,'Retro'),(3,'Noi_loro_gli_altri.png','Cover dell\'album \'Noi, loro, gli altri\'',2,'Copertina'),(4,'Aida_copertina.jpeg',NULL,3,'Copertina'),(5,'Meteora_cover.png','Copertina dell\'album Meteora',4,'Copertina'),(6,'Meteora_facciata1.png','Facciata interna sinistra dell\'album Meteora',4,'Facciata interna'),(7,'Meteora_facciata2.png','Facciata interna destra dell\'album Meteora',4,'Facciata interna'),(8,'Stripped.svg','Cover di Stripped by The Rolling Stones',5,'Copertina'),(9,'Stripped_lib.svg',NULL,5,'Libretto'),(10,'Stripped_lib2.svg',NULL,5,'Libretto');
/*!40000 ALTER TABLE `immagine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incide`
--

DROP TABLE IF EXISTS `incide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incide` (
  `id_disco` int unsigned NOT NULL,
  `id_autore` int unsigned NOT NULL,
  PRIMARY KEY (`id_disco`,`id_autore`),
  KEY `incide_autore` (`id_autore`),
  CONSTRAINT `incide_autore` FOREIGN KEY (`id_autore`) REFERENCES `autore` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `incide_disco` FOREIGN KEY (`id_disco`) REFERENCES `disco` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incide`
--

LOCK TABLES `incide` WRITE;
/*!40000 ALTER TABLE `incide` DISABLE KEYS */;
INSERT INTO `incide` VALUES (1,1),(2,2),(3,3),(4,4),(5,5);
/*!40000 ALTER TABLE `incide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `info_band`
--

DROP TABLE IF EXISTS `info_band`;
/*!50001 DROP VIEW IF EXISTS `info_band`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `info_band` AS SELECT 
 1 AS `id`,
 1 AS `nome_darte`,
 1 AS `data_fondazione`,
 1 AS `nome_fondatore`,
 1 AS `cognome_fondatore`,
 1 AS `nome_arte_fondatore`,
 1 AS `membro`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `info_collezioni`
--

DROP TABLE IF EXISTS `info_collezioni`;
/*!50001 DROP VIEW IF EXISTS `info_collezioni`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `info_collezioni` AS SELECT 
 1 AS `id`,
 1 AS `nome`,
 1 AS `visibilita`,
 1 AS `nickname`,
 1 AS `email`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `info_disco`
--

DROP TABLE IF EXISTS `info_disco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `info_disco` (
  `id_disco` int unsigned NOT NULL,
  `barcode` varchar(200) DEFAULT NULL,
  `note` text,
  `numero_copie` int unsigned DEFAULT '1',
  PRIMARY KEY (`id_disco`),
  UNIQUE KEY `unique_barcode` (`barcode`),
  CONSTRAINT `info_disco_disco` FOREIGN KEY (`id_disco`) REFERENCES `disco` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `info_disco`
--

LOCK TABLES `info_disco` WRITE;
/*!40000 ALTER TABLE `info_disco` DISABLE KEYS */;
INSERT INTO `info_disco` VALUES (1,'500902945325','Rappresenta uno dei dischi più belli della storia della musica',1),(2,NULL,'Un grande classico del rap italiano',1),(3,'900393283831',NULL,1),(4,'900384822842','Meteora rappresenta la storia del Metal e di una generazione crescita a cavallo degli anni 2000',1),(5,'688848392234',NULL,2);
/*!40000 ALTER TABLE `info_disco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produce`
--

DROP TABLE IF EXISTS `produce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produce` (
  `id_traccia` int unsigned NOT NULL,
  `id_autore` int unsigned NOT NULL,
  `nome_ruolo` varchar(50) NOT NULL,
  PRIMARY KEY (`id_traccia`,`id_autore`,`nome_ruolo`),
  KEY `produce_autore` (`id_autore`),
  KEY `produce_ruolo` (`nome_ruolo`),
  CONSTRAINT `produce_autore` FOREIGN KEY (`id_autore`) REFERENCES `autore` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `produce_ruolo` FOREIGN KEY (`nome_ruolo`) REFERENCES `ruolo` (`nome`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `produce_traccia` FOREIGN KEY (`id_traccia`) REFERENCES `traccia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produce`
--

LOCK TABLES `produce` WRITE;
/*!40000 ALTER TABLE `produce` DISABLE KEYS */;
INSERT INTO `produce` VALUES (1,1,'Cantante'),(1,1,'Musicista'),(1,1,'Proprietario'),(2,1,'Cantante'),(2,1,'Musicista'),(2,1,'Proprietario'),(3,2,'Cantante'),(3,2,'Proprietario'),(4,2,'Cantante'),(4,2,'Proprietario'),(5,2,'Cantante'),(5,2,'Proprietario'),(6,3,'Cantante'),(6,3,'Musicista'),(6,3,'Proprietario'),(7,3,'Cantante'),(7,3,'Musicista'),(7,3,'Proprietario'),(8,4,'Cantante'),(8,4,'Musicista'),(8,4,'Proprietario'),(9,4,'Cantante'),(9,4,'Musicista'),(9,4,'Proprietario'),(10,4,'Cantante'),(10,4,'Musicista'),(10,4,'Proprietario'),(11,5,'Cantante'),(11,5,'Musicista'),(11,5,'Proprietario'),(12,5,'Cantante'),(12,5,'Musicista'),(12,5,'Proprietario'),(3,15,'Musicista'),(4,15,'Musicista'),(5,15,'Musicista'),(3,16,'Proprietario'),(4,16,'Musicista'),(5,16,'Musicista');
/*!40000 ALTER TABLE `produce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruolo`
--

DROP TABLE IF EXISTS `ruolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ruolo` (
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruolo`
--

LOCK TABLES `ruolo` WRITE;
/*!40000 ALTER TABLE `ruolo` DISABLE KEYS */;
INSERT INTO `ruolo` VALUES ('Cantante'),('Featuring'),('Musicista'),('Proprietario');
/*!40000 ALTER TABLE `ruolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stato`
--

DROP TABLE IF EXISTS `stato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stato` (
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stato`
--

LOCK TABLES `stato` WRITE;
/*!40000 ALTER TABLE `stato` DISABLE KEYS */;
INSERT INTO `stato` VALUES ('Buono'),('Molto rovinato'),('Perfetto'),('Usurato');
/*!40000 ALTER TABLE `stato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipologia`
--

DROP TABLE IF EXISTS `tipologia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipologia` (
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipologia`
--

LOCK TABLES `tipologia` WRITE;
/*!40000 ALTER TABLE `tipologia` DISABLE KEYS */;
INSERT INTO `tipologia` VALUES ('Copertina'),('Facciata interna'),('Libretto'),('Retro');
/*!40000 ALTER TABLE `tipologia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `traccia`
--

DROP TABLE IF EXISTS `traccia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `traccia` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `titolo` varchar(50) NOT NULL,
  `durata` decimal(10,2) unsigned DEFAULT '0.00',
  `id_etichetta` int unsigned NOT NULL,
  `id_disco` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_traccia` (`titolo`,`id_etichetta`,`id_disco`),
  KEY `traccia_etichetta` (`id_etichetta`),
  KEY `traccia_disco` (`id_disco`),
  CONSTRAINT `traccia_disco` FOREIGN KEY (`id_disco`) REFERENCES `disco` (`id`) ON DELETE CASCADE,
  CONSTRAINT `traccia_etichetta` FOREIGN KEY (`id_etichetta`) REFERENCES `etichetta` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `traccia`
--

LOCK TABLES `traccia` WRITE;
/*!40000 ALTER TABLE `traccia` DISABLE KEYS */;
INSERT INTO `traccia` VALUES (1,'Breathe (In The Air)',2.49,2,1),(2,'Time',7.02,2,1),(3,'Dubbi',3.54,1,2),(4,'Importante',3.21,1,2),(5,'Crazy Love',3.12,1,2),(6,'Aida',4.25,3,3),(7,'Spendi Spandi Effendi',4.01,3,3),(8,'Numb',3.05,4,4),(9,'Faint',2.42,4,4),(10,'Breaking The Habit',3.16,4,4),(11,'Sweet Virgina',4.15,5,5),(12,'Like A Rolling Stones',5.38,5,5);
/*!40000 ALTER TABLE `traccia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'collectors'
--
/*!50003 DROP FUNCTION IF EXISTS `conta_brani` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `conta_brani`(nome_darte varchar(200)) RETURNS int unsigned
    DETERMINISTIC
BEGIN

	DECLARE numero_brani integer unsigned;
    
    SET numero_brani = (
		SELECT count(*)
		FROM (
			SELECT t.id
            FROM autore a
			JOIN produce p ON p.id_autore=a.id
			JOIN traccia t ON t.id=p.id_traccia
			JOIN disco d ON d.id=t.id_disco
			JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
			WHERE c.visibilita=true 
			AND a.nome_darte=nome_darte
			GROUP BY t.id) as brani_distinti);
	
    RETURN numero_brani;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `conta_collezioni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `conta_collezioni`(id_collezionista integer unsigned) RETURNS int unsigned
    DETERMINISTIC
BEGIN

	DECLARE numero_collezioni integer unsigned;
    
    SET numero_collezioni = (
			SELECT count(c.id)
            FROM collezione_di_dischi c 
            JOIN collezionista coll ON c.id_collezionista=coll.id
			WHERE coll.id=id_collezionista);

	RETURN numero_collezioni;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `conta_dischi_per_genere` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `conta_dischi_per_genere`(genere varchar(50)) RETURNS int unsigned
    DETERMINISTIC
BEGIN

	DECLARE genra varchar(50);
    DECLARE numero_dischi integer unsigned;
    
    SET genra = (
		SELECT g.nome
        FROM genere g
        WHERE g.nome=genere
    );

	IF(genra is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Il genere inserito non è valido o non esiste";
    END IF;
    
    SET numero_dischi = (
		SELECT count(d.id)
        FROM disco d
        JOIN classificazione cl ON d.id=cl.id_disco
        WHERE cl.nome_genere=genra
    );
    
    RETURN numero_dischi;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `conta_minuti_autore` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `conta_minuti_autore`(nome_darte varchar(100)) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN 

	DECLARE minutaggio_totale decimal(10,2);
	
    SET minutaggio_totale = (
		SELECT sum(brani_distinti.durata)
		FROM ( # Cerco le tracce di un autore
			SELECT t.id,t.durata
            FROM autore a
			JOIN produce p ON p.id_autore=a.id
			JOIN traccia t ON t.id=p.id_traccia
			JOIN disco d ON d.id=t.id_disco
			JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
			WHERE c.visibilita=true 
			AND a.nome_darte=nome_darte
			GROUP BY t.id) as brani_distinti);
            
	RETURN minutaggio_totale;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `verifica_visibilita` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `verifica_visibilita`(
	id_collezionista integer unsigned,
	id_collezione integer unsigned) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
	DECLARE visibile boolean;
    DECLARE personale boolean;
    DECLARE condivisa boolean;
    
    SET visibile = (
		SELECT c.visibilita 
        FROM collezione_di_dischi c 
        WHERE c.id=id_collezione);
        
	# 1. Verifico se la collezione è pubblica, se si restituisco true
    IF(visibile = true) THEN
		BEGIN
			RETURN true;
		END;
	END IF;
    
    # 2. Verifico se è una mia collezione
    SET personale = (SELECT EXISTS(
		SELECT * 
        FROM collezione_di_dischi c 
        WHERE c.id_collezionista=id_collezionista
        AND c.id=id_collezione)
    );
    
    IF(personale=true) THEN
		BEGIN
			RETURN true; #è una collezione del collezionista IN INPUT
		END;
    END IF;
    
    # 3. Controllo se è una collezione condivisa con me
    SET condivisa = (SELECT EXISTS(
		SELECT * 
        FROM collezione_di_dischi c
        JOIN condivisa cond ON cond.id_collezione=c.id
        JOIN collezionista coll ON coll.id=cond.id_collezionista
        WHERE coll.id=id_collezionista
        AND c.id=id_collezione)
    );
    
    IF(condivisa=true) THEN 
		BEGIN
			RETURN true; #è una collezione condivisa con il collezionista passato
		END;
    END IF;
		
	RETURN false; # La collezione non è nè pubblica, nè mia, nè condivisa con me
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `aggiungi_collezione` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggiungi_collezione`(
	in nome_collezione varchar(200),
    in nickname varchar(100),
    in email varchar(200),
    in visibilita boolean)
BEGIN 
	DECLARE id_collezionista integer unsigned;
    
	SET id_collezionista = (
		SELECT c.id 
		FROM collectors.collezionista c 
        WHERE c.email=email 
		AND c.nickname=nickname);
	
    IF (id_collezionista is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nome utente o email errate!";
    END IF;
    
	INSERT INTO collectors.collezione_di_dischi(`nome`,`visibilita`,`id_collezionista`) 
		VALUES (nome_collezione,visibilita,id_collezionista);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `aggiungi_condivisione` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggiungi_condivisione`(
	in nickname_from varchar(100),
	in email_from varchar(200),
	in nome_collezione varchar(200),
	in nickname_to varchar(100),
	in email_to varchar(200)
)
BEGIN 
	DECLARE id_collezionista_from integer unsigned;
    DECLARE id_collezionista_to integer unsigned;
    DECLARE id_collezione integer unsigned;
    DECLARE visibilita boolean;
    
    #Cerco l'utente che condivide
    SET id_collezionista_from = (
		SELECT c.id
        FROM collezionista c
        WHERE nickname_from=c.nickname
        AND email_from=c.email
    );
    
    IF(id_collezionista_from is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali dell'utente che condivide errate!";
	END IF;
    
    #Cerco la collezione da condividere
	SELECT c.id,c.visibilita
    INTO id_collezione,visibilita
    FROM collezione_di_dischi c
	WHERE c.nome=nome_collezione
	AND c.id_collezionista=id_collezionista;
    
    IF(id_collezione is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nessuna collezione trovata associata a questo utente!";
	END IF;
    
    #Cerco l'utente che riceverà la condivisone
    SET id_collezionista_to = (
		SELECT c.id
        FROM collezionista c
        WHERE nickname_to=c.nickname
        AND email_to=c.email
    );
    
    IF(id_collezionista_to is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali dell'utente con cui condividere errate!";
	END IF;

	#Verifico che la visibilità della collezione da convidere sia privata
    IF(visibilita is true) THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="La collezione è già pubblica!";
	END IF;
    
    INSERT condivisa(id_collezionista,id_collezione) VALUES (id_collezionista_to,id_collezione);
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `aggiungi_disco` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggiungi_disco`(
	in nickname varchar(100),
	in email varchar(200),
    in nome_collezione varchar(200),
	in titolo varchar(50),
	in anno_di_uscita date,
	in nome_formato varchar(50),
	in nome_stato varchar(50),
	in partitaIVA varchar(11),
	in barcode varchar(200),
	in note text,
	in numero_copie integer unsigned)
BEGIN
	DECLARE id integer unsigned;
    DECLARE id_etichetta integer unsigned;
    DECLARE id_collezione_di_dischi integer unsigned;
    
    SET id_etichetta = (
		SELECT e.id
		FROM etichetta e
		WHERE e.partitaIVA=partitaIVA
    );
    IF(id_etichetta is null) THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="La partita IVA specificata non esiste o è errata!";
	END IF;
    
    SET id_collezione_di_dischi = (
		SELECT c.id
        FROM collezione_di_dischi c
        JOIN collezionista coll ON c.id_collezionista=coll.id
        WHERE c.nome=nome_collezione
		AND coll.nickname=nickname
        AND coll.email=email
    );
    
    IF(id_collezione_di_dischi is null) THEN 
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali utente errate o inesistenti!"; 
	END IF;
    
    # Controllo che il disco non sia già presente
    SET id = (
		SELECT d.id
		FROM disco d
		WHERE d.titolo=titolo
		AND d.anno_di_uscita=anno_di_uscita 
		AND d.nome_formato=nome_formato 
		AND d.nome_stato=nome_stato
		AND d.id_etichetta=id_etichetta
		AND d.id_collezione_di_dischi=id_collezione_di_dischi);
		
    IF(id is null) THEN
		# Crea il disco
        START TRANSACTION; # Per evitare race condition con last_insert_id()
        INSERT INTO disco(`titolo`,`anno_di_uscita`,`nome_formato`,`nome_stato`,`id_etichetta`,`id_collezione_di_dischi`) 
        VALUES (titolo, anno_di_uscita, nome_formato, nome_stato, id_etichetta, id_collezione_di_dischi);
        INSERT INTO info_disco(`id_disco`,`barcode`, `note`,`numero_copie`) VALUES (last_insert_id(),barcode,note,numero_copie);
        COMMIT;
	ELSE
		#Il disco esiste con tutte le condizioni specificate sopra, incremento il numero di copie
        UPDATE info_disco info
        SET info.numero_copie=info.numero_copie+numero_copie
		WHERE info.id_disco=id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `aggiungi_traccia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggiungi_traccia`(
	in titolo varchar(50),
	in durata decimal(10,2),
	in partitaIVA varchar(11),
	in id_disco integer
)
BEGIN
    DECLARE ID_disc integer unsigned;
    DECLARE ID_etichett integer unsigned;
    DECLARE ID_traccia integer unsigned;
    
    # Controllo che il disco e l'etichetta esistano
    SET ID_disc = (
		SELECT d.id
        FROM disco d
		WHERE d.id=id_disco);
	SET ID_etichett = (
		SELECT e.id
        FROM etichetta e
		WHERE e.partitaIVA=partitaIVA
    );

    IF(ID_disc IS NOT NULL AND ID_etichett IS NOT NULL) THEN
		# Controllo che la traccia non appartenga già al disco
        SET ID_traccia = (
			SELECT t.id
            FROM traccia t
            WHERE t.titolo=titolo
            AND t.durata=durata
            AND t.id_etichetta=id_etichetta
            AND t.id_disco=id_disco
        );
        IF(ID_traccia IS NOT NULL) THEN
			#La traccia appartiene già a quel disco
            SIGNAL SQLSTATE "45000" set message_text = "La traccia appartiene già a questo disco!";
		ELSE 
			# La traccia non è stata trovata, quindi la aggiungo al disco
            INSERT INTO traccia(`titolo`, `durata`, `id_etichetta`, `id_disco`) 
            VALUES (titolo, durata, id_etichett, id_disco);
        END IF;
    ELSE 
		# Se l'id del disco o dell'etichetta sono errati o non esistono lancio una eccezione
		SIGNAL SQLSTATE "45000" set message_text = "L'ID del disco o dell'etichetta non sono validi!";
    END IF;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cambia_visibilita` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cambia_visibilita`(
	in nome varchar(200), 
    in nickname varchar(100),
	in email varchar(200)
)
BEGIN
	DECLARE id_utente integer unsigned;
    DECLARE id_collezione integer unsigned;
    DECLARE visibilita boolean;
    
	#Cerco l'utente
	SET id_utente = (
		SELECT c.id
        FROM collezionista c
        WHERE c.nickname=nickname
        AND c.email=email
    );
    IF(id_utente is null) THEN SIGNAL SQLSTATE "45000" 
		SET MESSAGE_TEXT = "Credenziali utente errate o inesistenti!";
	END IF;
    
    #Cerco la visibilità della collezione
	SELECT c.visibilita, c.id
    INTO visibilita, id_collezione
	FROM collezione_di_dischi c
	WHERE c.nome=nome
	AND c.id_collezionista=id_utente;
    
    # Se la collezione è privata devo metterla pubblica e cancellare i record di condivisione
    IF(visibilita=false) THEN
		UPDATE collezione_di_dischi c
        SET c.visibilita=true
		WHERE c.id=id_collezione;
        
        DELETE FROM condivisa cond
		WHERE cond.id_collezione=id_collezione;
	ELSE 
		#Se la collezione è pubblica devo metterla privata
        UPDATE collezione_di_dischi c
        SET c.visibilita=false
		WHERE c.id=id_collezione;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cerca_disco_con_autore` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cerca_disco_con_autore`(
	in id_collezionista integer unsigned,
    in nome_darte varchar(100))
BEGIN
	DECLARE id_coll integer unsigned;
    
    SET id_coll = (
		SELECT c.id
        FROM collezionista c
        WHERE c.id=id_collezionista
    );
    
    IF(id_coll is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="ID collezionista non trovato!";
    END IF;
    
	# Collezioni personali e private
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           a.nome_darte as "Autore"
    FROM disco d
    JOIN incide i ON d.id=i.id_disco
    JOIN autore a ON a.id=i.id_autore
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN collezionista cl ON cl.id = c.id_collezionista
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE a.nome_darte=nome_darte 
    AND cl.id=id_collezionista 
    AND c.visibilita=false
    
    UNION DISTINCT
    
    # Collezioni pubbliche
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
		   a.nome_darte as "Autore"
    FROM disco d
    JOIN incide i ON d.id=i.id_disco
    JOIN autore a ON a.id=i.id_autore
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE a.nome_darte=nome_darte
    AND c.visibilita=true
    
    UNION DISTINCT 
    # Collezioni private condivise con me
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
		   a.nome_darte as "Autore"
    FROM disco d
    JOIN incide i ON d.id=i.id_disco
    JOIN autore a ON a.id=i.id_autore
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN condivisa con ON con.id_collezione=c.id
    JOIN collezionista col ON col.id=con.id_collezionista
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE a.nome_darte=nome_darte
    AND col.id=id_collezionista
    AND c.visibilita=false; #Superfluo, le collezioni condivise sono per forza private

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cerca_disco_con_traccia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cerca_disco_con_traccia`(
	in id_collezionista integer unsigned,
    in id_traccia integer unsigned)
BEGIN
    
	# Collezioni personali e private
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           t.titolo as "Traccia"
    FROM disco d
    JOIN traccia t ON t.id_disco=d.id
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN collezionista cl ON cl.id = c.id_collezionista
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE t.id=id_traccia
    AND cl.id=id_collezionista 
    AND c.visibilita=false
    
    UNION DISTINCT
    
    # Collezioni pubbliche
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           t.titolo as "Traccia"
    FROM disco d
    JOIN traccia t ON t.id_disco=d.id
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE t.id=id_traccia
    AND c.visibilita=true
    
    UNION DISTINCT 
    # Collezioni private condivise con me
    SELECT d.id as "ID",
		   d.titolo as "Titolo",
           d.anno_di_uscita as "Anno di uscita",
           d.nome_formato as "Formato",
           d.nome_stato as "Stato",
           e.nome as "Etichetta",
           c.nome as "Collezione",
           c.visibilita as "Visibilità",
           t.titolo as "Traccia"
    FROM disco d
    JOIN traccia t ON t.id_disco=d.id
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
    JOIN condivisa con ON con.id_collezione=c.id
    JOIN collezionista col ON col.id=con.id_collezionista
    JOIN etichetta e ON e.id=d.id_etichetta
    WHERE t.id=id_traccia
    AND col.id=id_collezionista
    AND c.visibilita=false; #Superfluo, le collezioni condivise sono per forza private

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rimuovi_collezione` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rimuovi_collezione`(
	in id_collezionista integer unsigned,
    in nome_collezione varchar(200)
)
BEGIN

	DECLARE id_collezione integer unsigned;
    SET id_collezione = (
		SELECT c.id
        FROM collezione_di_dischi c
        WHERE c.nome=nome_collezione
        AND c.id_collezionista=id_collezionista
    );
    
    IF(id_collezione is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nessuna collezioni associata a tale utente!";
    END IF;
    
    DELETE FROM collezione_di_dischi c WHERE c.id=id_collezione;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rimuovi_disco` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rimuovi_disco`(
	in id_disco integer unsigned,
    in nome_collezione varchar(200),
    in nickname varchar(100),
	in email varchar(200)
)
BEGIN
	DECLARE id_collezionista integer unsigned;
    DECLARE id_collezione integer unsigned;
    
    #Cerco l'utente 
    SET id_collezionista = (
		SELECT c.id
        FROM collezionista c
        WHERE nickname=c.nickname
        AND email=c.email
    );
    
    IF(id_collezionista is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Credenziali dell'utente errate!";
	END IF;
    
    # Cerco la collezione 
	SET id_collezione = (
		SELECT c.id
		FROM collezione_di_dischi c
		WHERE c.nome=nome_collezione
		AND c.id_collezionista=id_collezionista);
    
    IF(id_collezione is null) THEN
		SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT="Nessuna collezione con quel nome trovata!";
	END IF;

	DELETE FROM disco d
    WHERE d.id=id_disco AND d.id_collezione_di_dischi=id_collezione;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `stampa_disco` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `stampa_disco`(
	in id_disco integer unsigned
)
BEGIN
	SELECT d.id AS ID,
		d.titolo AS Titolo,
		d.anno_di_uscita AS Anno,
        d.nome_formato AS Formato,
        d.nome_stato AS Stato,
        e.nome AS Etichetta,
        c.nome AS Collezione
    FROM disco d
    JOIN etichetta e ON e.id=d.id_etichetta
    JOIN collezione_di_dischi c ON c.id=d.id_collezione_di_dischi
	WHERE d.id=id_disco
    ORDER BY d.id ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `stampa_tracklist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `stampa_tracklist`(
	in id_disco integer unsigned
)
BEGIN

	SELECT t.id AS ID,
		   t.titolo AS Titolo,
           t.durata AS Durata,
           e.nome AS Etichetta,
           d.titolo AS Disco
    FROM traccia t
	JOIN etichetta e ON e.id=t.id_etichetta
    JOIN disco d ON d.id=t.id_disco
    WHERE t.id_disco=id_disco
    ORDER BY t.id ASC;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `condivisione_collezioni`
--

/*!50001 DROP VIEW IF EXISTS `condivisione_collezioni`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `condivisione_collezioni` AS select `cd`.`id` AS `id`,`coll2`.`nickname` AS `proprietario`,`cd`.`nome` AS `nome`,`c`.`nickname` AS `condivisa_con` from (((`condivisa` `con` join `collezionista` `c` on((`c`.`id` = `con`.`id_collezionista`))) join `collezione_di_dischi` `cd` on((`cd`.`id` = `con`.`id_collezione`))) join `collezionista` `coll2` on((`coll2`.`id` = `cd`.`id_collezionista`))) order by `cd`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `info_band`
--

/*!50001 DROP VIEW IF EXISTS `info_band`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `info_band` AS select `b`.`id` AS `id`,`ak`.`nome_darte` AS `nome_darte`,`b`.`data_fondazione` AS `data_fondazione`,`ars`.`nome` AS `nome_fondatore`,`ars`.`cognome` AS `cognome_fondatore`,`a`.`nome_darte` AS `nome_arte_fondatore`,`au`.`nome_darte` AS `membro` from ((((((`band` `b` join `artista_singolo` `ars` on((`b`.`id_fondatore` = `ars`.`id`))) join `autore` `a` on((`ars`.`id_autore` = `a`.`id`))) join `autore` `ak` on((`ak`.`id` = `b`.`id_autore`))) join `costituito` `c` on((`c`.`id_band` = `b`.`id`))) join `artista_singolo` `ars1` on((`ars1`.`id` = `c`.`id_artista`))) join `autore` `au` on((`au`.`id` = `ars1`.`id_autore`))) order by `b`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `info_collezioni`
--

/*!50001 DROP VIEW IF EXISTS `info_collezioni`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `info_collezioni` AS select `c`.`id` AS `id`,`c`.`nome` AS `nome`,`c`.`visibilita` AS `visibilita`,`ca`.`nickname` AS `nickname`,`ca`.`email` AS `email` from (`collezione_di_dischi` `c` join `collezionista` `ca` on((`ca`.`id` = `c`.`id_collezionista`))) order by `c`.`id` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-30 21:16:59
