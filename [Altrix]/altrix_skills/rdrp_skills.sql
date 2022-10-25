-- Dumping structure for tabell qalle.characters_skills
CREATE TABLE IF NOT EXISTS `characters_skills` (
  `cid` varchar(50) NOT NULL,
  `skills` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumpar data för tabell qalle.characters_skills: ~12 rows (ungefär)
/*!40000 ALTER TABLE `characters_skills` DISABLE KEYS */;
INSERT INTO `characters_skills` (`cid`, `skills`) VALUES
	('1993-06-16-8036', '{"Picklock":0,"Gym":0,"Drugs":0}');
/*!40000 ALTER TABLE `characters_skills` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
