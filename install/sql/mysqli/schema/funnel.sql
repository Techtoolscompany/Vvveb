DROP TABLE IF EXISTS `funnel`;
CREATE TABLE `funnel` (
  `funnel_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(191) NOT NULL DEFAULT '',
  `description` text,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `date_added` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  PRIMARY KEY (`funnel_id`),
  KEY `site_id` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `funnel_step`;
CREATE TABLE `funnel_step` (
  `step_id` int(11) NOT NULL AUTO_INCREMENT,
  `funnel_id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL DEFAULT '',
  `template_id` int(11) DEFAULT NULL,
  `content` longtext,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`step_id`),
  KEY `funnel_id` (`funnel_id`),
  KEY `template_id` (`template_id`),
  CONSTRAINT `funnel_step_ibfk_1` FOREIGN KEY (`funnel_id`) REFERENCES `funnel` (`funnel_id`) ON DELETE CASCADE,
  CONSTRAINT `funnel_step_ibfk_2` FOREIGN KEY (`template_id`) REFERENCES `template` (`template_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
