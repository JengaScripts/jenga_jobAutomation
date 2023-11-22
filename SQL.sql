CREATE TABLE IF NOT EXISTS `jenga_jobautomation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discordId` varchar(255) NOT NULL,
  `job` varchar(255) DEFAULT NULL,
  `grade` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;