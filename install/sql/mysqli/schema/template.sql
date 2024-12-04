DROP TABLE IF EXISTS `template`;
CREATE TABLE `template` (
  `template_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(191) NOT NULL DEFAULT '',
  `description` text,
  `content` longtext,
  `type` varchar(50) NOT NULL DEFAULT 'page', -- page, section, component
  `category` varchar(191) DEFAULT NULL, -- landing, sales, checkout, thank-you, etc
  `thumb` varchar(191) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `date_added` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  PRIMARY KEY (`template_id`),
  KEY `site_id` (`site_id`),
  KEY `type` (`type`),
  KEY `category` (`category`),
  CONSTRAINT `template_ibfk_1` FOREIGN KEY (`site_id`) REFERENCES `site` (`site_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- Template categories for organization
DROP TABLE IF EXISTS `template_category`;
CREATE TABLE `template_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(191) NOT NULL DEFAULT '',
  `slug` varchar(191) NOT NULL DEFAULT '',
  `description` text,
  `parent_id` int(11) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`category_id`),
  KEY `site_id` (`site_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `template_category_ibfk_1` FOREIGN KEY (`site_id`) REFERENCES `site` (`site_id`) ON DELETE CASCADE,
  CONSTRAINT `template_category_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `template_category` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- Template tags for easier searching/filtering
DROP TABLE IF EXISTS `template_tag`;
CREATE TABLE `template_tag` (
  `template_id` int(11) NOT NULL,
  `tag` varchar(191) NOT NULL,
  PRIMARY KEY (`template_id`,`tag`),
  CONSTRAINT `template_tag_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `template` (`template_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
