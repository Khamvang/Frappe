



# 
DROP TABLE IF EXISTS `temp_sme_id_report`;

CREATE TABLE IF NOT EXISTS `temp_sme_id_report` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`bp_name` INT(11) NOT NULL DEFAULT 0,
	`type` VARCHAR(255) DEFAULT NULL,
	`datetime_report` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Change timestamp',
	PRIMARY KEY (`id`),
	KEY `idx_bp_name` (`bp_name`),
	KEY `idx_type` (`type`),
	KEY `idx_datetime_report` (`datetime_report`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



SELECT * FROM `temp_sme_id_report`;





