-- MySQL dump 10.19  Distrib 10.3.38-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: geotest
-- ------------------------------------------------------
-- Server version	10.3.38-MariaDB

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
-- Table structure for table `geo_tbl_tx`
--

DROP TABLE IF EXISTS `geo_tbl_tx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `geo_tbl_tx` (
  `st_astext(lng_lat_fir)` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geo_tbl_tx`
--

LOCK TABLES `geo_tbl_tx` WRITE;
/*!40000 ALTER TABLE `geo_tbl_tx` DISABLE KEYS */;
INSERT INTO `geo_tbl_tx` VALUES ('LINESTRING(0 0,1 0,2 3,0 -1)'),('POLYGON((1 2,3 4,-1 -6,-3 5,1 2))'),('LINESTRING(1 2,3 4,-1 -6,-3 5)'),('LINESTRING(0 0,1 2,1 0)'),('LINESTRING(0 0,1 1,2 2,1 0,0 0)'),('LINESTRING(0 0)'),('LINESTRING(0 0,0 0)'),('GEOMETRYCOLLECTION(POLYGON((0 1,1 0,1 2,0 1)),LINESTRING(2 -1,2 3),MULTIPOINT(1 1,2 2))'),('MULTIPOINT(0 0)'),('POLYGON((0 0,0 5,5 0,0 0),(1 1,1 3,3 1,1 1),(0.5 0.5,4 0.5,0.5 4,0.5 0.5))'),('MULTIPOINT(0 0,0.5 0.5,1 1)'),('POLYGON((0 0,1 1,2 2,1 0,0 0))'),('POLYGON((-1 -1,-1 -2,3 -1,-1 -1),(-3 -3,-5 -4,-6 -1,-3 -3),(1 2,3 4,-1 -6,-3 5,1 2))'),('POLYGON((1 2,3 4,-1 -6,-3 5,1 2),(-1 -1,-1 -2,3 -1,-1 -1),(-3 -3,-5 -4,-6 -1,-3 -3))'),('MULTILINESTRING((1 2,1 3,2 5),(-1 -2,-1 -3,-2 -5))'),('MULTILINESTRING((1 2,1 3,2 5,1 2),(-1 -2,-1 -3,-2 -5))'),('MULTILINESTRING((1 2,1 3,2 5,1 2),(-1 -2,-1 -3,-2 -5,-1 -2))');
/*!40000 ALTER TABLE `geo_tbl_tx` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-10  9:43:29
