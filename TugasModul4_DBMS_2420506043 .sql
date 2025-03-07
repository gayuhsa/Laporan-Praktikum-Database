-- MariaDB dump 10.19  Distrib 10.4.22-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: akademik
-- ------------------------------------------------------
-- Server version	10.4.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `jurusan`
--

DROP TABLE IF EXISTS `jurusan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jurusan` (
  `id` char(2) NOT NULL,
  `nama` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jurusan`
--

LOCK TABLES `jurusan` WRITE;
/*!40000 ALTER TABLE `jurusan` DISABLE KEYS */;
INSERT INTO `jurusan` VALUES ('1','S1 Teknologi Informasi'),('2','S1 Teknik Mekatronika'),('3','S1 Teknik Elektro'),('4','S1 Teknik Mesin');
/*!40000 ALTER TABLE `jurusan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khs`
--

DROP TABLE IF EXISTS `khs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `khs` (
  `id` int(11) NOT NULL,
  `NPM` char(10) NOT NULL,
  `id_mata_kuliah` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `NPM` (`NPM`),
  KEY `id_mata_kuliah` (`id_mata_kuliah`),
  CONSTRAINT `khs_ibfk_1` FOREIGN KEY (`NPM`) REFERENCES `mahasiswa` (`NPM`),
  CONSTRAINT `khs_ibfk_2` FOREIGN KEY (`id_mata_kuliah`) REFERENCES `mata_kuliah` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khs`
--

LOCK TABLES `khs` WRITE;
/*!40000 ALTER TABLE `khs` DISABLE KEYS */;
INSERT INTO `khs` VALUES (1,'0000000001',1),(2,'0000000001',2),(3,'0000000001',3),(4,'0000000002',1),(5,'0000000002',3),(6,'0000000003',4),(7,'0000000004',4),(8,'0000000005',5),(9,'0000000006',5);
/*!40000 ALTER TABLE `khs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mahasiswa`
--

DROP TABLE IF EXISTS `mahasiswa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mahasiswa` (
  `NPM` char(10) NOT NULL,
  `nama` varchar(30) NOT NULL,
  `id_jurusan` char(2) NOT NULL,
  PRIMARY KEY (`NPM`),
  KEY `id_jurusan` (`id_jurusan`),
  CONSTRAINT `mahasiswa_ibfk_1` FOREIGN KEY (`id_jurusan`) REFERENCES `jurusan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mahasiswa`
--

LOCK TABLES `mahasiswa` WRITE;
/*!40000 ALTER TABLE `mahasiswa` DISABLE KEYS */;
INSERT INTO `mahasiswa` VALUES ('0000000001','Nama 1','1'),('0000000002','Nama 2','1'),('0000000003','Nama 3','4'),('0000000004','Nama 4','3'),('0000000005','Nama 5','3'),('0000000006','Nama 6','2');
/*!40000 ALTER TABLE `mahasiswa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mata_kuliah`
--

DROP TABLE IF EXISTS `mata_kuliah`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mata_kuliah` (
  `id` int(11) NOT NULL,
  `nama` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mata_kuliah`
--

LOCK TABLES `mata_kuliah` WRITE;
/*!40000 ALTER TABLE `mata_kuliah` DISABLE KEYS */;
INSERT INTO `mata_kuliah` VALUES (1,'Basis Data'),(2,'Praktikum Basis Data'),(3,'Praktikum Struktur Data'),(4,'Pendidikan Kewarganegaraan'),(5,'Bahasa Inggris');
/*!40000 ALTER TABLE `mata_kuliah` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nilai`
--

DROP TABLE IF EXISTS `nilai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nilai` (
  `id` int(11) NOT NULL,
  `NPM` char(10) NOT NULL,
  `id_mata_kuliah` int(11) NOT NULL,
  `nilai` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `NPM` (`NPM`),
  KEY `id_mata_kuliah` (`id_mata_kuliah`),
  CONSTRAINT `nilai_ibfk_1` FOREIGN KEY (`NPM`) REFERENCES `mahasiswa` (`NPM`),
  CONSTRAINT `nilai_ibfk_2` FOREIGN KEY (`id_mata_kuliah`) REFERENCES `mata_kuliah` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nilai`
--

LOCK TABLES `nilai` WRITE;
/*!40000 ALTER TABLE `nilai` DISABLE KEYS */;
INSERT INTO `nilai` VALUES (1,'0000000001',1,100.00),(2,'0000000001',2,100.00),(3,'0000000001',3,100.00),(4,'0000000002',1,99.99),(5,'0000000002',3,89.99),(6,'0000000003',4,78.00),(7,'0000000004',4,83.00),(8,'0000000005',5,85.00),(9,'0000000006',5,90.00);
/*!40000 ALTER TABLE `nilai` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-07 16:58:35
