

-- 1. Create the log table (log_sme_follow_SABC)
DROP TABLE IF EXISTS `log_sme_follow_SABC`;


CREATE TABLE IF NOT EXISTS `log_sme_follow_SABC` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`updated_table` VARCHAR(255) NOT NULL DEFAULT 'tabSME_BO_and_Plan' COMMENT 'Source table',
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
	KEY `idx_date_created` (`date_created`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2. Create an AFTER UPDATE Trigger
DROP TRIGGER IF EXISTS `log_sme_follow_SABC`;

DELIMITER $$

CREATE TRIGGER `log_sme_follow_SABC`
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
		INSERT INTO `log_sme_follow_SABC` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'tl_name', OLD.tl_name, NEW.tl_name, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

	-- Log changes for `sec_manager`
	IF IFNULL(OLD.sec_manager, '') <> IFNULL(NEW.sec_manager, '') THEN
		INSERT INTO `log_sme_follow_SABC` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'sec_manager', OLD.sec_manager, NEW.sec_manager, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

	-- Log changes for `credit`
	IF IFNULL(OLD.credit, '') <> IFNULL(NEW.credit, '') THEN
		INSERT INTO `log_sme_follow_SABC` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'credit', OLD.credit, NEW.credit, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

    -- New condition for visit_date changes
    IF IFNULL(OLD.visit_date, '0000-00-00') <> IFNULL(NEW.visit_date, '0000-00-00') THEN
        INSERT INTO `log_sme_follow_SABC` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
        VALUES 
        (NEW.name, NEW.modified_by, 'visit_date', OLD.visit_date, NEW.visit_date, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
    END IF;

    -- New condition for salesplan or disbursement_date changes
    IF IFNULL(OLD.disbursement_date_pay_date, '0000-00-00') <> IFNULL(NEW.disbursement_date_pay_date, '0000-00-00') THEN
        INSERT INTO `log_sme_follow_SABC` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
        VALUES 
        (NEW.name, NEW.modified_by, 'sales_plan', OLD.visit_date, NEW.visit_date, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
    END IF;
   
END$$

DELIMITER ;





-- 3. Check the Tringer
SHOW TRIGGERS LIKE 'tabSME_BO_and_Plan';





-- 4. Check the Log Table (log_sme_follow_SABC)
SELECT * FROM `log_sme_follow_SABC`
ORDER BY `date_created` DESC;

SHOW TRIGGERS LIKE 'tabSME_BO_and_Plan';

DESC `tabSME_BO_and_Plan`;

SHOW WARNINGS;


-- 5. Update, if wrong data

UPDATE log_sme_follow_SABC ls INNER JOIN trg_log_sme_follow_SABC tls ON (ls.id = tls.id)
SET ls.visit_date = NULL 

UPDATE log_sme_follow_SABC ls INNER JOIN tabSME_BO_and_Plan bp ON (ls.id = bp.name)
SET ls.visit_or_not = SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) , ls.visit_date = bp.visit_date 
WHERE ls.id <= 238


-- 5. Test
SET SESSION sql_mode = '';

http://13.250.153.252:8000/app/sme_bo_and_plan/239409

DELETE FROM tabSME_BO_and_Plan WHERE name = 1234567;

INSERT INTO `tabSME_BO_and_Plan` (`name`, `tl_name`, `sec_manager`, `credit`, `contract_status`, `rank_update`, `modified_by`, `disbursement_date_pay_date`)
VALUES ('1234567', 'John Doe', 'Jane Smith', 50000, 'Pending', 'Rank A', 'admin', '2024-03-01');


UPDATE `tabSME_BO_and_Plan`
SET `tl_name` = 'Michael Scott',
	`sec_manager` = 'Pam Beesly',
	`credit` = 60000,
	`contract_status` = 'Contracted'
WHERE `name` = '1234567';


-- 6. check the data
SELECT bp.name ,
		-- Result from TL & UL above
	tftl.visit_or_not AS `visit_by_TL&UL` ,
	tftl.visit_date AS `visit_date_by_TL&UL` ,
	tftl.now_status AS `now_status_by_TL&UL` ,
	tftl.disbursement_date AS `disbursement_date_by_TL&UL` ,
		-- Result from Sec & Dept above
	tfse.visit_or_not AS `visit_by_Sec&Dept` ,
	tfse.visit_date AS `visit_date_by_Sec&Dept` ,
	tfse.now_status AS `now_status_by_Sec&Dept` ,
	tfse.disbursement_date AS `disbursement_date_by_Sec&Dept` ,
		-- Result from Sec & Dept above
	tfcr.visit_or_not AS `visit_by_Credit` ,
	tfcr.visit_date AS `visit_date_by_Credit` ,
	tfcr.now_status AS `now_status_by_Credit` ,
	tfcr.disbursement_date  AS `disbursement_date_by_Credit` 
FROM tabSME_BO_and_Plan bp
LEFT JOIN log_sme_follow_SABC tftl ON tftl.id = (SELECT id FROM log_sme_follow_SABC WHERE updated_id = bp.name AND changed_column = 'tl_name' ORDER BY id DESC LIMIT 1 )
LEFT JOIN log_sme_follow_SABC tfse ON tfse.id = (SELECT id FROM log_sme_follow_SABC WHERE updated_id = bp.name AND changed_column = 'sec_manager' ORDER BY id DESC LIMIT 1 )
LEFT JOIN log_sme_follow_SABC tfcr ON tfcr.id = (SELECT id FROM log_sme_follow_SABC WHERE updated_id = bp.name AND changed_column = 'credit' ORDER BY id DESC LIMIT 1 )
WHERE bp.name = 778642 ;



-- 1. Fresh beer strategy
SELECT sme.id `#`, 
	sme.`g-dept`, 
	sme.dept, 
	sme.sec_branch, 
	sme.unit_no, 
	sme.unit, 
	sme.staff_no, 
	sme.staff_name,
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.customer_name, 
	bp.rank_update, 
	case 
		when bp.contract_status = 'Contracted' then 'Have Ringi' 
		when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' 
		when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case 
		when bp.contract_status = 'Contracted' then 'Contracted' 
		when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' 
		when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() THEN 'Yes'
		ELSE 'No'
	END AS `disbursement_status`,
	bp.disbursement_date_pay_date AS `disbursement_date`,
	CASE 
		WHEN tftl.date_created >= bp.creation OR tfse.date_created >= bp.creation OR tfcr.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called`,
	CASE 
		WHEN (SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA')
			AND bp.visit_date IS NOT NULL AND bp.visit_date != '' AND bp.visit_date <= CURDATE()
		THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	-- Additional time grouping logic
	CASE 
		-- 
		WHEN bp.creation >= (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 0 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 0 HOUR
						END) 
		AND bp.creation < (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 17 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
						END)
		THEN 'Before 5 PM Yesterday'
		-- 		
		WHEN bp.creation > (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 17 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
						END) 
		AND bp.creation < CURDATE()
		THEN 'After 5 PM Yesterday'
		-- 
		WHEN bp.creation >= CURDATE()
		AND bp.creation <= CURDATE() + INTERVAL 13 HOUR 
		THEN 'Before 1 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 13 HOUR 
		AND bp.creation <= CURDATE() + INTERVAL 15 HOUR 
		THEN 'Before 3 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 15 HOUR 
		AND bp.creation <= CURDATE() + INTERVAL 17 HOUR 
		THEN 'Before 5 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 17 HOUR
		AND bp.creation <= CURDATE() + INTERVAL 23 HOUR 
		THEN 'After 5 PM Today'
		-- 
		ELSE 'Before Yesterday'
	END AS `Time_Created`,
	bp.creation,
	CONCAT('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) AS `Edit`,
		-- Result from TL & UL above
	CASE 
		WHEN tftl.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_TL&UL`,
	tftl.visit_or_not AS `visit_by_TL&UL` ,
	tftl.visit_date AS `visit_date_by_TL&UL` ,
	tftl.now_status AS `now_status_by_TL&UL` ,
	tftl.disbursement_date AS `disbursement_date_by_TL&UL` ,
		-- Result from Sec & Dept above
	CASE 
		WHEN tfse.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_Sec&Dept`,
	tfse.visit_or_not AS `visit_by_Sec&Dept` ,
	tfse.visit_date AS `visit_date_by_Sec&Dept` ,
	tfse.now_status AS `now_status_by_Sec&Dept` ,
	tfse.disbursement_date AS `disbursement_date_by_Sec&Dept` ,
		-- Result from Sec & Dept above
	CASE 
		WHEN tfcr.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_Credit`,
	tfcr.visit_or_not AS `visit_by_Credit` ,
	tfcr.visit_date AS `visit_date_by_Credit` ,
	tfcr.now_status AS `now_status_by_Credit` ,
	tfcr.disbursement_date  AS `disbursement_date_by_Credit` 
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
LEFT JOIN (
	SELECT updated_id, 
		   MAX(CASE WHEN changed_column = 'tl_name' THEN id END) AS tl_id,
		   MAX(CASE WHEN changed_column = 'sec_manager' THEN id END) AS sec_manager_id,
		   MAX(CASE WHEN changed_column = 'credit' THEN id END) AS credit_id
	FROM log_sme_follow_SABC
	GROUP BY updated_id
) latest_logs ON latest_logs.updated_id = bp.name
LEFT JOIN log_sme_follow_SABC tftl ON tftl.id = latest_logs.tl_id
LEFT JOIN log_sme_follow_SABC tfse ON tfse.id = latest_logs.sec_manager_id
LEFT JOIN log_sme_follow_SABC tfcr ON tfcr.id = latest_logs.credit_id
WHERE 
	-- Start time: Yesterday 5 PM (or Saturday if yesterday was Sunday)
	bp.creation > 
		(CASE 
		    WHEN CURDATE() = '2025-03-10'  -- If it's a holiday
		    	THEN DATE('2025-03-07') + INTERVAL 17 HOUR  -- Convert to DATE before adding INTERVAL
		    WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1  -- If yesterday is Sunday, go back to Saturday
		    	THEN CURDATE() - INTERVAL 2 DAY -- Return all the prospect from Saturday
		    ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
		END)
	-- End time: Today 5 PM
	AND bp.creation <= CURDATE() + INTERVAL 17 HOUR
	-- only SABCF rank
	AND bp.rank1 IN ('S', 'A', 'B', 'C')
ORDER BY sme.id ASC,
	bp.name ASC ;




-- 2. Visit This month
SELECT 	
	DATE_FORMAT(tf.date_created, '%Y-%m-%d') AS `Date_Created_Visit_Schedule`, 
	sme.`g-dept`, 
	sme.dept, 
	sme.sec_branch, 
	sme.unit_no, 
	sme.unit, 
	sme.staff_no, 
	sme.staff_name,
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.customer_name, 
	bp.rank_update, 
	case 
		when bp.contract_status = 'Contracted' then 'Have Ringi' 
		when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' 
		when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case 
		when bp.contract_status = 'Contracted' then 'Contracted' 
		when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' 
		when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() THEN 'Yes'
		WHEN bp.contract_status = 'Contracted' THEN 'Yes'
		ELSE 'No'
	END AS `disbursement_status`,
	bp.disbursement_date_pay_date AS `disbursement_date`,
	CASE 
		WHEN tf.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called`,
	CASE 
		WHEN SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA' THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	CONCAT('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) AS `Edit`
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
INNER JOIN log_sme_follow_SABC tf
	ON tf.id = (SELECT id FROM log_sme_follow_SABC 
				WHERE updated_id = bp.name 
					AND `visit_date` BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
				ORDER BY id ASC 
				LIMIT 1
					)
WHERE 
	sme.id IS NOT NULL 
ORDER BY
	sme.unit_no ASC,
	bp.visit_date DESC
;




-- 3. Fresh beer strategy Report
SELECT sme.id `#`, 
	sme.`g-dept`, 
	sme.dept, 
	sme.sec_branch, 
	sme.unit_no, 
	sme.unit, 
	sme.staff_no, 
	sme.staff_name,
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.customer_name, 
	CASE
		WHEN bp.approch_list = '①-1 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູ່ ບໍລິສັດການເງິນ ເຊັ່ນ: ທະນາຄານ, ບ/ສ ສິນເຊື່ອ...)' THEN '5way'
		WHEN bp.approch_list = '①-2 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູ່ ຮ້ານ​ຂາຍລົດ / ຮ້ານ​ສ້ອມ​ແປງລົດ​)' THEN '5way'
		WHEN bp.approch_list = '①-4 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູບ່ອນອື່ນໆ ນອກຈາກ 3ຂໍ້ເທິງ)' THEN '5way'
		WHEN bp.approch_list = '② ຈາກ Facebook' THEN 'Facebook'
		WHEN bp.approch_list = '③-1 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ປັດຈຸບັນ​)' THEN 'Z'
		WHEN bp.approch_list = '③-2 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ເກົ່າ​)' THEN 'Y'
		WHEN bp.approch_list = '③-3​ Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ສົນໃຈ​)' THEN 'X'
		WHEN bp.approch_list = '③-4​ ໄດ້ຈາກການໂທ ແລະ ຫາດ້ວຍຕົນເອງ' THEN 'Call'
		WHEN bp.approch_list = '④ Sales partner ທີ່ເຄີຍແນະນຳໃນອາດີດ' THEN 'SP'
		WHEN bp.approch_list = '④ Sales partner ຂອງພະນັກງານອອກວຽກ' THEN 'SP'
		WHEN bp.approch_list = '⑤ ຈາກການໂທ 200-3-3-1 ຂອງ CC ພາຍໃຕ້ຕົນເອງ' THEN 'Call'
		WHEN bp.approch_list = '⑥ ແນະນໍາຈາກ ພະແນກພາຍໃນ' THEN 'Non-sales'
		WHEN bp.approch_list = '⑥ Resigned Employees ພະນັກງານອອກວຽກ' THEN 'Resigned_Employees'
		WHEN bp.approch_list = '⑦ ປິດງວດຈາກບໍລິສັດຄູ່ແຂ່ງ' THEN 'Call'
		WHEN bp.approch_list = '⑧HC ລູກຄ້າເກົ່າ - ຜູ້ກູ້' THEN 'HC-Dor-Cus'
		WHEN bp.approch_list = '⑧HC ລູກຄ້າເກົ່າ - ຜູ້ຄ້ຳ' THEN 'HC-Dor-Gua'
		WHEN bp.approch_list = '⑧HC ລູກຄ້າເກົ່າ - ຄົນສຳຮອງ' THEN 'HC-Dor_Agt'
		WHEN bp.approch_list = '⑨HC ລູກຄ້າປັດຈຸບັນ - ຜູ້ກູ້' THEN 'HC-Inc-Cus'
		WHEN bp.approch_list = '⑨HC ລູກຄ້າປັດຈຸບັນ - ຜູ້ຄ້ຳ' THEN 'HC-Inc-Gua'
		WHEN bp.approch_list = '⑨HC ລູກຄ້າປັດຈຸບັນ - ຄົນສຳຮອງ' THEN 'HC-Inc_Agt'
	END AS `approach_type`,
	bp.rank_update, 
	case 
		when bp.contract_status = 'Contracted' then 'Have Ringi' 
		when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' 
		when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case 
		when bp.contract_status = 'Contracted' then 'Contracted' 
		when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' 
		when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() THEN 'Yes'
		WHEN bp.contract_status = 'Contracted' THEN 'Yes'
		ELSE 'No'
	END AS `disbursement_status`,
	bp.disbursement_date_pay_date AS `disbursement_date`,
	CASE 
		WHEN tftl.date_created >= bp.creation OR tfse.date_created >= bp.creation OR tfcr.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called`,
	CASE 
		WHEN (SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA')
			AND bp.visit_date IS NOT NULL AND bp.visit_date != '' AND bp.visit_date <= CURDATE()
		THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	-- Additional time grouping logic
	CASE 
		-- 
		WHEN bp.creation >= (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 0 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 0 HOUR
						END) 
		AND bp.creation < (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 17 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
						END)
		THEN 'Before 5 PM Yesterday'
		-- 		
		WHEN bp.creation > (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 17 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
						END) 
		AND bp.creation < CURDATE()
		THEN 'After 5 PM Yesterday'
		-- 
		WHEN bp.creation >= CURDATE()
		AND bp.creation <= CURDATE() + INTERVAL 13 HOUR 
		THEN 'Before 1 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 13 HOUR 
		AND bp.creation <= CURDATE() + INTERVAL 15 HOUR 
		THEN 'Before 3 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 15 HOUR 
		AND bp.creation <= CURDATE() + INTERVAL 17 HOUR 
		THEN 'Before 5 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 17 HOUR
		AND bp.creation <= CURDATE() + INTERVAL 23 HOUR 
		THEN 'After 5 PM Today'
		-- 
		ELSE 'Before Yesterday'
	END AS `Time_Created`,
	bp.creation,
	CONCAT('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) AS `Edit`,
		-- Result from TL & UL above
	CASE 
		WHEN tftl.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_TL&UL`,
	tftl.visit_or_not AS `visit_by_TL&UL` ,
	tftl.visit_date AS `visit_date_by_TL&UL` ,
	tftl.now_status AS `now_status_by_TL&UL` ,
	tftl.disbursement_date AS `disbursement_date_by_TL&UL` ,
		-- Result from Sec & Dept above
	CASE 
		WHEN tfse.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_Sec&Dept`,
	tfse.visit_or_not AS `visit_by_Sec&Dept` ,
	tfse.visit_date AS `visit_date_by_Sec&Dept` ,
	tfse.now_status AS `now_status_by_Sec&Dept` ,
	tfse.disbursement_date AS `disbursement_date_by_Sec&Dept` ,
		-- Result from Sec & Dept above
	CASE 
		WHEN tfcr.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_Credit`,
	tfcr.visit_or_not AS `visit_by_Credit` ,
	tfcr.visit_date AS `visit_date_by_Credit` ,
	tfcr.now_status AS `now_status_by_Credit` ,
	tfcr.disbursement_date  AS `disbursement_date_by_Credit` 
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
LEFT JOIN (
	SELECT updated_id, 
		   MAX(CASE WHEN changed_column = 'tl_name' THEN id END) AS tl_id,
		   MAX(CASE WHEN changed_column = 'sec_manager' THEN id END) AS sec_manager_id,
		   MAX(CASE WHEN changed_column = 'credit' THEN id END) AS credit_id
	FROM log_sme_follow_SABC
	GROUP BY updated_id
) latest_logs ON latest_logs.updated_id = bp.name
LEFT JOIN log_sme_follow_SABC tftl ON tftl.id = latest_logs.tl_id
LEFT JOIN log_sme_follow_SABC tfse ON tfse.id = latest_logs.sec_manager_id
LEFT JOIN log_sme_follow_SABC tfcr ON tfcr.id = latest_logs.credit_id
WHERE 
	sme.id IS NOT NULL
	AND bp.creation >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
	AND bp.rank1 IN ('S', 'A', 'B', 'C')
ORDER BY sme.unit_no ASC,
	bp.creation DESC
;





