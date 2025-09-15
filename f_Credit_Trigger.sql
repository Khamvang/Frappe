

-- _______________________________________ 1. log_sme_follow_SABC_Credit _______________________________________
-- 1. Create the log table (log_sme_follow_SABC_Credit)
DROP TABLE IF EXISTS `log_sme_follow_SABC_Credit`;


CREATE TABLE IF NOT EXISTS `log_sme_follow_SABC_Credit` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`updated_table` VARCHAR(255) NOT NULL DEFAULT 'tabSME_BO_and_Plan_Credit' COMMENT 'Source table',
	`updated_id` BIGINT(20) NOT NULL COMMENT 'Record ID',
	`modified_by` VARCHAR(140) DEFAULT NULL COMMENT 'User who modified',
	`changed_column` VARCHAR(255) NOT NULL COMMENT 'Column that changed',
	`old_value` VARCHAR(255) DEFAULT NULL COMMENT 'Previous value',
	`new_value` VARCHAR(255) DEFAULT NULL COMMENT 'Updated value',
	`now_status` VARCHAR(255) DEFAULT NULL,
	`visit_or_not` VARCHAR(255) DEFAULT NULL,
	`visit_date` DATE DEFAULT NULL,	
	`disbursement_date` DATE DEFAULT NULL,	
	`date_created` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Change timestamp',
	PRIMARY KEY (`id`),
	KEY `idx_updated_id` (`updated_id`),
	KEY `idx_modified_by` (`modified_by`),
	KEY `idx_visit_or_not` (`visit_or_not`),
	KEY `idx_visit_date` (`visit_date`),
	KEY `idx_date_created` (`date_created`),
	KEY `idx_changed_column` (`changed_column`),
	KEY `idx_new_value` (`new_value`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2. Create an AFTER UPDATE Trigger
DROP TRIGGER IF EXISTS `log_sme_follow_SABC_Credit`;

DELIMITER $$

CREATE TRIGGER `log_sme_follow_SABC_Credit`
AFTER UPDATE ON `tabSME_BO_and_Plan`
FOR EACH ROW
BEGIN
	DECLARE current_status VARCHAR(255);
	DECLARE visit_status VARCHAR(255);

	-- Determine `now_status` based on contract_status and rank_update
	IF NEW.contract_status = 'Contracted' THEN
		SET current_status = 'Contracted';
	ELSEIF NEW.contract_status = 'Cancelled' THEN
		SET current_status = 'Cancelled';
	ELSE
		SET current_status = NEW.rank_update;
	END IF;
   
	-- Visit status
	IF NEW.visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' OR NEW.visit_or_not = 'WA - ປະຊຸມທາງວ໋ອດແອັບ' THEN 
		SET visit_status = 'Yes';
	ELSE
		SET visit_status = 'No';
	END IF;

	-- Log changes for `tl_name`
	IF IFNULL(OLD.tl_name, '') <> IFNULL(NEW.tl_name, '') THEN
		INSERT INTO `log_sme_follow_SABC_Credit` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'tl_name', OLD.tl_name, NEW.tl_name, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

	-- Log changes for `sec_manager`
	IF IFNULL(OLD.sec_manager, '') <> IFNULL(NEW.sec_manager, '') THEN
		INSERT INTO `log_sme_follow_SABC_Credit` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'sec_manager', OLD.sec_manager, NEW.sec_manager, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

	-- Log changes for `credit`
	IF IFNULL(OLD.credit, '') <> IFNULL(NEW.credit, '') THEN
		INSERT INTO `log_sme_follow_SABC_Credit` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'credit', OLD.credit, NEW.credit, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

    -- New condition for visit_date changes
    IF IFNULL(OLD.visit_date, '0000-00-00') <> IFNULL(NEW.visit_date, '0000-00-00') THEN
        INSERT INTO `log_sme_follow_SABC_Credit` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
        VALUES 
        (NEW.name, NEW.modified_by, 'visit_date', OLD.visit_date, NEW.visit_date, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
    END IF;

    -- New condition for salesplan or disbursement_date changes
    IF IFNULL(OLD.disbursement_date_pay_date, '0000-00-00') <> IFNULL(NEW.disbursement_date_pay_date, '0000-00-00') THEN
        INSERT INTO `log_sme_follow_SABC_Credit` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
        VALUES 
        (NEW.name, NEW.modified_by, 'sales_plan', OLD.visit_date, NEW.visit_date, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
    END IF;

	-- Ringi Log
	IF IFNULL(OLD.ringi_status, '') <> IFNULL(NEW.ringi_status, '') THEN
		INSERT INTO `log_sme_follow_SABC_Credit` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'ringi_status', OLD.ringi_status, NEW.ringi_status, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

	-- Just modify
	IF IFNULL(OLD.modified, '') <> IFNULL(NEW.modified, '') THEN
		INSERT INTO `log_sme_follow_SABC_Credit` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'modified', OLD.modified, NEW.modified, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;
	
END$$

DELIMITER ;




-- _______________________________________ 2. sme_pre_daily_report_Credit _______________________________________
-- 1. Create the log table (sme_pre_daily_report_Credit)
DROP TABLE IF EXISTS `sme_pre_daily_report_Credit`;

CREATE TABLE `sme_pre_daily_report_Credit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_report` date NOT NULL,
  `bp_name` int(11) NOT NULL,
  `rank_update` varchar(255) DEFAULT NULL,
  `now_result` varchar(255) DEFAULT NULL,
  `rank_update_SABC` int(11) NOT NULL DEFAULT 0,
  `visit_or_not` varchar(255) DEFAULT NULL,
  `ringi_status` varchar(255) DEFAULT NULL,
  `disbursement_date_pay_date` date DEFAULT NULL,
  `datetime_update` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `usd_loan_amount` decimal(21,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `idx_date_report` (`date_report`),
  KEY `idx_rank_update_SABC` (`rank_update_SABC`),
  KEY `idx_disbursement_date_pay_date` (`disbursement_date_pay_date`),
  KEY `idx_usd_loan_amount` (`usd_loan_amount`),
  KEY `idx_bp_name_id` (`bp_name`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



-- 2 create EVENT to insert data to the table sme_pre_daily_report_Credit
DROP EVENT IF EXISTS `refresh_sme_pre_daily_report_Credit`;

DELIMITER $$

CREATE EVENT refresh_sme_pre_daily_report_Credit
ON SCHEDULE EVERY 1 DAY
STARTS '2025-05-27 23:00:00'
DO
BEGIN
    -- Step 1: Delete old data for today's report
    DELETE FROM sme_pre_daily_report_Credit
    WHERE date_report = DATE(NOW());

    -- Step 2: Insert new data into the report table
    INSERT INTO `sme_pre_daily_report_Credit` (`date_report`, `bp_name`, `rank_update`, `now_result`, `rank_update_SABC`, `visit_or_not`, `ringi_status`, `disbursement_date_pay_date`, `usd_loan_amount`)
    SELECT
        DATE(NOW()) AS `date_report`,
        bp.name AS `bp_name`,
        bp.`rank_update`,
        CASE
            WHEN bp.contract_status = 'Contracted' THEN 'Contracted'
            WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled'
            ELSE bp.rank_update
        END AS `now_result`,
        CASE
            WHEN rank_update IN ('S','A','B','C') THEN 1
            ELSE 0
        END AS `rank_update_SABC`,
        bp.`visit_or_not`,
        bp.`ringi_status`,
        bp.`disbursement_date_pay_date`,
	bp.usd_loan_amount
    FROM
        tabSME_BO_and_Plan_Credit bp
    LEFT JOIN
        sme_org sme ON (CASE
            WHEN LOCATE(' ', bp.staff_no) = 0 THEN bp.staff_no
            ELSE LEFT(bp.staff_no, LOCATE(' ', bp.staff_no) - 1)
        END = sme.staff_no)
    LEFT JOIN
        sme_org smec ON (REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no)
    WHERE
        rank_update IN ('S','A','B','C','F')
        AND bp.contract_status != 'Contracted'
        AND bp.contract_status != 'Cancelled'
        AND bp.`type` IN ('New', 'Dor', 'Inc')
	        AND CASE
	            WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	            THEN sme.unit_no
	            ELSE smec.unit_no
        	END IS NOT NULL
    ORDER BY
        sme.id ASC;
END$$

DELIMITER ;






SELECT * FROM sme_pre_daily_report_Credit ORDER BY id DESC;


SELECT * FROM sme_pre_daily_report ORDER BY id DESC;




















