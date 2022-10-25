CREATE TABLE IF NOT EXISTS `storageunits` (
  `storageUnit` int(11) NOT NULL,
  `storageItems` longtext NOT NULL,
  `storageOwner` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;