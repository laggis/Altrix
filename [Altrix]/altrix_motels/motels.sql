-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Serverversion:                10.1.35-MariaDB - mariadb.org binary distribution
-- Server-OS:                    Win32
-- HeidiSQL Version:             10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumpar databasstruktur för qalle
CREATE DATABASE IF NOT EXISTS `qalle` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `qalle`;

-- Dumpar struktur för tabell qalle.characters_motels
CREATE TABLE IF NOT EXISTS `characters_motels` (
  `characterId` varchar(50) NOT NULL,
  `motelNumber` int(100) NOT NULL,
  `motelOwnerName` varchar(50) NOT NULL,
  PRIMARY KEY (`characterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumpar data för tabell qalle.characters_motels: ~15 rows (ungefär)
/*!40000 ALTER TABLE `characters_motels` DISABLE KEYS */;
INSERT INTO `characters_motels` (`characterId`, `motelNumber`, `motelOwnerName`) VALUES
	('1989-09-29-6023', 12, 'CoffeHD ÄR COOL'),
	('1990-03-03-4296', 33, 'Wah wah wah'),
	('1991-01-01-4889', 4, 'Test Testsson'),
	('1992-01-01-5054', 5, 'Peder Punkt'),
	('1993-03-03-7197', 9, 'fdfds fdsfds'),
	('1993-06-16-5311', 2, 'Jonas Petterson'),
	('1993-06-16-5422', 3, 'John Moon'),
	('1993-06-16-8036', 8, 'Hen Tai'),
	('1993-09-23-9920', 1, 'Frasse Snorrefors'),
	('1995-03-12-5529', 13, 'Big doints Amish'),
	('1995-05-05-9507', 8, 'Karim Tonfisk'),
	('1996-11-02-7581', 32, 'Emelie Jansson'),
	('1998-03-03-8710', 11, 'Jafar Byn'),
	('1998-08-13-9111', 26, 'W W'),
	('2003-09-24-1591', 31, 'Fredde Larsen');
/*!40000 ALTER TABLE `characters_motels` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
