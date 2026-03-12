-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: RamadanDistributions
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `beneficiary_details`
--

DROP TABLE IF EXISTS `beneficiary_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beneficiary_details` (
  `beneficiary_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `family_members_count` tinyint unsigned NOT NULL DEFAULT '1',
  `poverty_score` tinyint unsigned NOT NULL,
  `last_received_date` date DEFAULT NULL,
  PRIMARY KEY (`beneficiary_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `idx_poverty_score` (`poverty_score`),
  KEY `idx_last_received` (`last_received_date`),
  CONSTRAINT `fk_beneficiary_user` FOREIGN KEY (`user_id`) REFERENCES `users_master` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `beneficiary_details_chk_1` CHECK ((`poverty_score` between 1 and 10))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beneficiary_details`
--

LOCK TABLES `beneficiary_details` WRITE;
/*!40000 ALTER TABLE `beneficiary_details` DISABLE KEYS */;
INSERT INTO `beneficiary_details` VALUES (1,4,5,9,'2026-02-19'),(2,5,3,7,'2026-03-01'),(3,8,6,9,'2026-02-23'),(4,9,4,8,'2026-03-06'),(5,1,4,8,'2026-03-01');
/*!40000 ALTER TABLE `beneficiary_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_15_day_rule` BEFORE UPDATE ON `beneficiary_details` FOR EACH ROW BEGIN

IF NEW.last_received_date < OLD.last_received_date + INTERVAL 15 DAY
THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'A family cannot receive another box within 15 days';

END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `donations_log`
--

DROP TABLE IF EXISTS `donations_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donations_log` (
  `donation_id` int NOT NULL AUTO_INCREMENT,
  `donor_name` varchar(100) NOT NULL,
  `amount_value` decimal(12,2) NOT NULL,
  `donation_type` enum('Cash','Food') NOT NULL,
  `org_type` enum('Individual','Company','NGO') NOT NULL,
  `donated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`donation_id`),
  CONSTRAINT `donations_log_chk_1` CHECK ((`amount_value` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donations_log`
--

LOCK TABLES `donations_log` WRITE;
/*!40000 ALTER TABLE `donations_log` DISABLE KEYS */;
INSERT INTO `donations_log` VALUES (1,'Al-Nour Company',50000.00,'Cash','Company','2026-03-10 22:13:48'),(2,'Ahmed Hassan',2000.00,'Cash','Individual','2026-03-10 22:13:48'),(3,'Relief NGO',30000.00,'Cash','NGO','2026-03-10 22:13:48'),(4,'Delta Corp',75000.00,'Cash','Company','2026-03-10 22:13:48'),(5,'Mohamed Ali',1500.00,'Cash','Individual','2026-03-10 22:13:48'),(6,'Sara Ibrahim',500.00,'Cash','Individual','2026-03-10 22:13:48'),(7,'Sharkia Charity',20000.00,'Cash','NGO','2026-03-10 22:13:48');
/*!40000 ALTER TABLE `donations_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `driver_training`
--

DROP TABLE IF EXISTS `driver_training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver_training` (
  `driver_id` int NOT NULL,
  `session_id` int NOT NULL,
  PRIMARY KEY (`driver_id`,`session_id`),
  KEY `idx_driver_training_session` (`session_id`),
  CONSTRAINT `fk_dt_driver` FOREIGN KEY (`driver_id`) REFERENCES `users_master` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dt_session` FOREIGN KEY (`session_id`) REFERENCES `training_sessions` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver_training`
--

LOCK TABLES `driver_training` WRITE;
/*!40000 ALTER TABLE `driver_training` DISABLE KEYS */;
INSERT INTO `driver_training` VALUES (2,1),(2,2),(6,2);
/*!40000 ALTER TABLE `driver_training` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_categories`
--

DROP TABLE IF EXISTS `food_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `storage_type` enum('Dry','Fresh','Cooked') NOT NULL,
  `required_storage_temperature` decimal(5,2) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_categories`
--

LOCK TABLES `food_categories` WRITE;
/*!40000 ALTER TABLE `food_categories` DISABLE KEYS */;
INSERT INTO `food_categories` VALUES (1,'Dry Goods','Dry',25.00),(2,'Fresh Produce','Fresh',4.00),(3,'Cooked Meals','Cooked',6.00);
/*!40000 ALTER TABLE `food_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items`
--

DROP TABLE IF EXISTS `inventory_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `quantity_kg` decimal(10,2) NOT NULL,
  `warehouse_id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `expiry_date` date NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `fk_item_category` (`category_id`),
  KEY `idx_item_expiry` (`expiry_date`),
  KEY `idx_item_warehouse_cat` (`warehouse_id`,`category_id`),
  CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `food_categories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_item_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`warehouse_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `inventory_items_chk_1` CHECK ((`quantity_kg` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items`
--

LOCK TABLES `inventory_items` WRITE;
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
INSERT INTO `inventory_items` VALUES (1,'Rice',5000.00,1,1,'2026-09-07'),(2,'Lentils',3000.00,1,1,'2027-03-11'),(3,'Fresh Tomatoes',800.00,1,2,'2026-03-12'),(4,'Fresh Cucumbers',600.00,1,2,'2026-03-13'),(5,'Chicken (Fresh)',1200.00,2,2,'2026-04-10'),(6,'Cooked Foul',400.00,2,3,'2026-03-13'),(7,'Sugar',2000.00,1,1,'2028-03-10'),(8,'Cooking Oil',1500.00,2,1,'2027-03-11'),(9,'Rice',5000.00,1,1,'2026-09-07'),(10,'Lentils',3000.00,1,1,'2027-03-11'),(11,'Fresh Tomatoes',800.00,1,2,'2026-03-12'),(12,'Fresh Cucumbers',600.00,1,2,'2026-03-13'),(13,'Chicken (Fresh)',1200.00,2,2,'2026-04-10'),(14,'Cooked Foul',400.00,2,3,'2026-03-13'),(15,'Sugar',2000.00,1,1,'2028-03-10'),(16,'Cooking Oil',1500.00,2,1,'2027-03-11');
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_drybox_expiry` BEFORE INSERT ON `inventory_items` FOR EACH ROW BEGIN

    DECLARE food_type VARCHAR(10);

    SELECT storage_type
    INTO food_type
    FROM food_categories
    WHERE category_id = NEW.category_id;

    IF food_type = 'Dry'
    AND NEW.expiry_date <= CURDATE() + INTERVAL 3 DAY
    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Items expiring within 3 days cannot be assigned to Dry Boxes';

    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills` (
  `skill_id` int NOT NULL AUTO_INCREMENT,
  `skill_type` enum('Cooking','Driving','Data Entry') NOT NULL,
  PRIMARY KEY (`skill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (1,'Cooking'),(2,'Driving'),(3,'Data Entry');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training_sessions`
--

DROP TABLE IF EXISTS `training_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training_sessions` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `session_name` varchar(100) NOT NULL,
  `trainer_name` varchar(100) NOT NULL,
  `session_date` date NOT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training_sessions`
--

LOCK TABLES `training_sessions` WRITE;
/*!40000 ALTER TABLE `training_sessions` DISABLE KEYS */;
INSERT INTO `training_sessions` VALUES (1,'Safety First','Eng. Kamal Reda','2026-03-01'),(2,'Food Handling','Dr. Heba Mostafa','2026-03-06'),(3,'Customer Service','Ms. Rana Tawfik','2026-03-11'),(4,'Safety First','Eng. Kamal Reda','2026-03-01'),(5,'Food Handling','Dr. Heba Mostafa','2026-03-06'),(6,'Customer Service','Ms. Rana Tawfik','2026-03-11');
/*!40000 ALTER TABLE `training_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_master`
--

DROP TABLE IF EXISTS `users_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_master` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `age` tinyint unsigned NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` enum('Admin','Volunteer','Driver','Beneficiary') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_beneficiary_address` (`address`(50)),
  CONSTRAINT `users_master_chk_1` CHECK ((`age` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_master`
--

LOCK TABLES `users_master` WRITE;
/*!40000 ALTER TABLE `users_master` DISABLE KEYS */;
INSERT INTO `users_master` VALUES (1,'Ahmed Hassan','Male',45,'01001234567','Zagazig, Sharkia','Admin','2026-03-10 22:13:39'),(2,'Mohamed Ali','Male',30,'01112345678','Zagazig, Sharkia','Driver','2026-03-10 22:13:39'),(3,'Sara Naguib','Female',28,'01223456789','Minya Al-Qamh, Sharkia','Volunteer','2026-03-10 22:13:39'),(4,'Jana Tamer','Female',35,'01334567890','Minya Al-Qamh, Sharkia','Beneficiary','2026-03-10 22:13:39'),(5,'Omar Sayed','Male',50,'01445678901','Belbeis, Sharkia','Beneficiary','2026-03-10 22:13:39'),(6,'Khalid Youssef','Male',33,'01556789012','Zagazig, Sharkia','Driver','2026-03-10 22:13:39'),(7,'Nour El-Din','Male',27,'01667890123','Minya Al-Qamh, Sharkia','Volunteer','2026-03-10 22:13:39'),(8,'Hana Adel','Female',40,'01778901234','Minya Al-Qamh, Sharkia','Beneficiary','2026-03-10 22:13:39'),(9,'Tarek Fawzy','Male',55,'01889012345','Zagazig, Sharkia','Beneficiary','2026-03-10 22:13:39'),(10,'Layla Nasser','Female',29,'01990123456','Belbeis, Sharkia','Volunteer','2026-03-10 22:13:39');
/*!40000 ALTER TABLE `users_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_assignments`
--

DROP TABLE IF EXISTS `vehicle_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_assignments` (
  `vehicle_id` int NOT NULL,
  `driver_id` int DEFAULT NULL,
  `assigned_date` date DEFAULT NULL,
  PRIMARY KEY (`vehicle_id`),
  KEY `driver_id` (`driver_id`),
  CONSTRAINT `vehicle_assignments_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `users_master` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_assignments`
--

LOCK TABLES `vehicle_assignments` WRITE;
/*!40000 ALTER TABLE `vehicle_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_assignments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_driver_training` BEFORE INSERT ON `vehicle_assignments` FOR EACH ROW BEGIN
    DECLARE trained INT;

    SELECT COUNT(*) INTO trained
    FROM driver_training dt
    JOIN training_sessions ts ON dt.session_id = ts.session_id
    WHERE dt.driver_id = NEW.driver_id
      AND ts.session_name = 'Safety First';

    IF trained = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Driver must complete "Safety First" training before assignment';
    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `volunteer_skills`
--

DROP TABLE IF EXISTS `volunteer_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteer_skills` (
  `volunteer_skill_id` int NOT NULL AUTO_INCREMENT,
  `volunteer_id` int NOT NULL,
  `skill_id` int NOT NULL,
  `years_of_experience` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`volunteer_skill_id`),
  UNIQUE KEY `uq_volunteer_skill` (`volunteer_id`,`skill_id`),
  KEY `fk_skill_id` (`skill_id`),
  CONSTRAINT `fk_skill_id` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_skill_volunteer` FOREIGN KEY (`volunteer_id`) REFERENCES `users_master` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteer_skills`
--

LOCK TABLES `volunteer_skills` WRITE;
/*!40000 ALTER TABLE `volunteer_skills` DISABLE KEYS */;
INSERT INTO `volunteer_skills` VALUES (13,3,1,3),(14,3,3,1),(15,7,2,5),(16,10,1,2);
/*!40000 ALTER TABLE `volunteer_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouses`
--

DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouses` (
  `warehouse_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL,
  `max_capacity` decimal(10,2) NOT NULL COMMENT 'Capacity in kg',
  `current_status` enum('Open','Full','Maintenance') NOT NULL DEFAULT 'Open',
  `supervisor_id` int DEFAULT NULL,
  PRIMARY KEY (`warehouse_id`),
  KEY `fk_warehouse_supervisor` (`supervisor_id`),
  CONSTRAINT `fk_warehouse_supervisor` FOREIGN KEY (`supervisor_id`) REFERENCES `users_master` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
INSERT INTO `warehouses` VALUES (1,'Zagazig Warehouse','Zagazig, Sharkia',50000.00,'Open',1),(2,'Minya Al-Qamh Store','Minya Al-Qamh, Sharkia',30000.00,'Open',1),(3,'Belbeis Cold Storage','Belbeis, Sharkia',20000.00,'Maintenance',1);
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-12 19:02:01
