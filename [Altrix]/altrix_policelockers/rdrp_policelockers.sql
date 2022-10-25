CREATE TABLE IF NOT EXISTS `world_police_lockers` (
  `lockerOwner` varchar(50) NOT NULL,
  `lockerDisplay` varchar(150) NOT NULL,
  `lockerCreator` varchar(50) NOT NULL,
  `lockerCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`lockerOwner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
