
-- 1. Create the log table (log_sme_follow_approach)
SELECT * FROM `log_sme_follow_approach`;

DROP TABLE IF EXISTS `log_sme_follow_approach`;


CREATE TABLE IF NOT EXISTS `log_sme_follow_approach` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`updated_table` VARCHAR(255) NOT NULL DEFAULT 'tabSME_Approach_list' COMMENT 'Source table',
	`updated_id` BIGINT(20) NOT NULL COMMENT 'Record ID',
	`modified_by` VARCHAR(140) DEFAULT NULL COMMENT 'User who modified',
	`changed_column` VARCHAR(255) NOT NULL COMMENT 'Column that changed',
	`old_value` VARCHAR(255) DEFAULT NULL COMMENT 'Previous value',
	`new_value` VARCHAR(255) DEFAULT NULL COMMENT 'Updated value',
	`now_status` VARCHAR(255) DEFAULT NULL,
	`visit_or_not` VARCHAR(255) DEFAULT NULL,
	`visit_date` DATE DEFAULT NULL,	
	`disbursement_date` DATE DEFAULT NULL,	
	`negotiation_comment` VARCHAR(255) DEFAULT NULL,
	`date_created` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Change timestamp',
	PRIMARY KEY (`id`),
	KEY `idx_updated_id` (`updated_id`),
	KEY `idx_modified_by` (`modified_by`),
	KEY `idx_visit_or_not` (`visit_or_not`),
	KEY `idx_visit_date` (`visit_date`),
	KEY `idx_date_created` (`date_created`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


alter table log_sme_follow_approach add `negotiation_comment` VARCHAR(255) DEFAULT NULL;

-- 2. Create an AFTER UPDATE Trigger
DROP TRIGGER IF EXISTS `log_sme_follow_approach`;

DELIMITER $$

CREATE TRIGGER `log_sme_follow_approach`
AFTER UPDATE ON `tabSME_Approach_list`
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

	-- Log changes for `modified_by`
	IF IFNULL(OLD.modified_by, '') <> IFNULL(NEW.modified_by, '') THEN
		INSERT INTO `log_sme_follow_approach` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'modified_by', OLD.modified_by, NEW.modified_by, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

	-- Log changes for `rank_update`
	IF IFNULL(OLD.rank_update, '') <> IFNULL(NEW.rank_update, '') THEN
		INSERT INTO `log_sme_follow_approach` 
		(`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
		VALUES 
		(NEW.name, NEW.modified_by, 'rank_update', OLD.rank_update, NEW.rank_update, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
	END IF;

    -- New condition for visit_date changes
    IF IFNULL(OLD.visit_date, '0000-00-00') <> IFNULL(NEW.visit_date, '0000-00-00') THEN
        INSERT INTO `log_sme_follow_approach` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
        VALUES 
        (NEW.name, NEW.modified_by, 'visit_date', OLD.visit_date, NEW.visit_date, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
    END IF;

    -- New condition for salesplan or disbursement_date changes
    IF IFNULL(OLD.disbursement_date_pay_date, '0000-00-00') <> IFNULL(NEW.disbursement_date_pay_date, '0000-00-00') THEN
        INSERT INTO `log_sme_follow_approach` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`)
        VALUES 
        (NEW.name, NEW.modified_by, 'sales_plan', OLD.visit_date, NEW.visit_date, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date);
    END IF;

    -- New condition for negotiation_with
    IF IFNULL(OLD.negotiation_with, '') <> IFNULL(NEW.negotiation_with, '') THEN
        INSERT INTO `log_sme_follow_approach` 
        (`updated_id`, `modified_by`, `changed_column`, `old_value`, `new_value`, `disbursement_date`, `now_status`, `visit_or_not`, `visit_date`, `negotiation_comment`)
        VALUES 
        (NEW.name, NEW.modified_by, 'negotiation_with', OLD.negotiation_with, NEW.negotiation_with, NEW.disbursement_date_pay_date, current_status, visit_status, NEW.visit_date, NEW.`negotiation_comment`);
    END IF;
   
END$$

DELIMITER ;




-- 3. Check the Tringer
SHOW TRIGGERS LIKE 'tabSME_Approach_list';

SHOW INDEX FROM log_sme_follow_approach;
CREATE INDEX idx_now_status ON log_sme_follow_approach(now_status);


-- 4. Check the Log Table (log_sme_follow_approach)
SELECT * FROM `log_sme_follow_approach`
ORDER BY `date_created` DESC;

SHOW TRIGGERS LIKE 'tabSME_Approach_list';

DESC `tabSME_Approach_list`;

SHOW WARNINGS;

-- 5. Update
SELECT * FROM tabUser tu 
WHERE username IN ('2233', '3627', '3694', '361', '2451', '1603', '2349', '3804')

INSERT INTO `log_sme_follow_approach`
SELECT
	NULL AS `id`,
	'tabSME_Approach_list' AS `updated_table` ,
	name AS `updated_id` ,
	`modified_by` ,
	'' AS `changed_column` ,
	'' AS `old_value` ,
	'' AS `new_value` ,
	CASE
		WHEN contract_status = 'Contracted' THEN 'Contracted'
		WHEN contract_status = 'Cancelled' THEN 'Cancelled'
		ELSE rank_update
	END AS `now_status` ,
	NULL AS `visit_or_not` ,
	NULL AS `visit_date`,	
	disbursement_date_pay_date AS `disbursement_date` ,	
	NOW() AS `date_created`
FROM tabSME_Approach_list 
WHERE modified_by IN ('anunh1603@lalco.la', 'paeng2233@lalco.la', 'phet2349@lalco.la', 'pupiew2451@lalco.la', 'kesone.t@lalco.la', 'ning3627@lalco.la', 'jen3694@lalco.la', 'noy3804@lalco.la')




UPDATE tabSME_Approach_list
SET rank_update = 
	CASE
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'X' THEN 'X ປ່ອຍກູ້ແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'S' THEN 'S ຢາກໄດ້ທິດນີ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'A' THEN 'A ຢາກໄດ້ທິດໜ້າ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'B' THEN 'B ຢາກໄດ້ພາຍໃນເດືອນນີ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'C' THEN 'C ຢາກໄດ້ໃນເດືອນໜ້າ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'F' THEN 'F ດຽວນີ້ບໍ່ຕ້ອງການໃນອານາຄົນຕ້ອງການ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FF1' THEN 'FF1 ໂທຕິດບໍ່ຮັບສາຍ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FF2' THEN 'FF2 ບໍ່ມີສັນຍານ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FF3' THEN 'FF3 ຄົນອື່ນຮັບສາຍທີ່ບໍ່ແມ່ນລູກຄ້າ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FFF' THEN 'FFF ເບີໂທບໍ່ໃດ້ໄຊ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'G' THEN 'G ຕ່າງແຂວງ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N1' THEN 'N1 ບໍ່ຕ້ອງການ - ລູກບໍ່ມັກ LALCO'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N2' THEN 'N2 ບໍ່ຕ້ອງການ - ຂາຍລົດແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N3' THEN 'N3 ບໍ່ຕ້ອງການ - ເອົານໍາບໍລິສັດຄູ່ແຂ່ງແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N4' THEN 'N4 ບໍ່ຕ້ອງການ - ບໍ່ມີຫລັກຊັບຄ້ຳປະກັນອີກແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N5' THEN 'N5 ບໍ່ຕ້ອງການ - ບໍ່ມີແຜນໃຊ້ເງິນດ່ວນເທື່ອ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'Z1' THEN 'Z1 ລູກຄ້າໜີ້ເສຍ・ລູກຄ້າຈ່າຍຊ້າ・ນໍາໜີ້ຢູ່'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'Z2' THEN 'Z2 ເຄດພົວພັນກັນບໍ່ສາມາດປ່ອຍກູ້ไດ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'Z3' THEN 'Z3 ເງື່ອນໄຂບໍ່ຜ່ານບໍລິສັດເຮົາ'
	END
;	




-- To Export Dormant list from lalco 18.140.117.112 to Frappe table tabSME_Approach_list
SELECT DISTINCT
    NOW() AS creation,
    'Administrator' AS owner,
    NULL AS staff_no,
    CONCAT(us.staff_no, ' - ', upper(us.nickname)) as `own_salesperson`,
    CASE WHEN c.status = 4 THEN 'Inc' else 'Dor' end AS type,
    c.contract_no AS contract_no,
    c.id AS 'contract_id',
	cu.id AS case_no,
    CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
    CASE 
	    WHEN LEFT (RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' 
			THEN CONCAT('903',RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8))
		WHEN length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 
			THEN CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
		ELSE CONCAT('9020', RIGHT(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	END AS `customer_tel`,
    cu.date_of_birth,
    CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name) AS address_province_and_city,
    CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) AS address_village,
    car.car_make AS maker, 
    CONVERT(CAST(CONVERT(car.car_model USING latin1) as binary) USING utf8) AS model, 
    av.collateral_year AS year,
    am.min_buying_price AS `car_buying_price`,
	CASE 
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Saysetha' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Samakkhixay' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Sanamxay' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Sanxay' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Phouvong' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Houay Xay' THEN 'Bokeo'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Ton Pheung' THEN 'Tonpherng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Meung' THEN 'Tonpherng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Pha Oudom' THEN 'Bokeo'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Pak Tha' THEN 'Bokeo'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Paksane' THEN 'Paksan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Thaphabat' THEN 'Paksan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Pakkading' THEN 'Pakkading'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Borikhane' THEN 'Paksan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Khamkeut' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Viengthong' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Xaychamphone' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Pak Se' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Sanasomboun' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Batiengchaleunsouk' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Paksong' THEN 'Paksxong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Pathouphone' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Phonthong' THEN 'Chongmeg'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Champassack' THEN 'Sukhuma'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Soukhoumma' THEN 'Sukhuma'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Mounlapamok' THEN 'Khong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Khong' THEN 'Khong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xam Neua' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xiengkho' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Muang Hiam' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Viengxay' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Houameuang' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Samtay' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Sop Bao' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Muang Et' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Kuane' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xone' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Thakhek' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Mahaxay' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Nong Bok' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Hineboune' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Yommalath' THEN 'Nhommalth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Boualapha' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Nakai' THEN 'Nhommalth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Sebangphay' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Saybouathong' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Kounkham' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Namtha' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Sing' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Long' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Viengphoukha' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Na Le' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Luang Prabang' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Xiengngeun' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Nane' THEN 'Nane'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Pak Ou' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Nam Bak' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Ngoy' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Pak Seng' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phonxay' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Chomphet' THEN 'Nane'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Viengkham' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phoukhoune' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phonthong' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Xay' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'La' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Na Mo' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Nga' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Beng' THEN 'Hoon'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Houne' THEN 'Hoon'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Pak Beng' THEN 'Hoon'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'May' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Khoua' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Samphanh' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Boun Neua' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Yot Ou' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Boun Tay' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Phongsaly' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Saravanh' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Ta Oy' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Toumlane' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Lakhonepheng' THEN 'Khongxedone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Vapy' THEN 'Khongxedone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Khongsedone' THEN 'Khongxedone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Lao Ngam' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Sa Mouay' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Kaysone Phomvihane' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Outhoumphone' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Atsaphangthong' THEN 'Atsaphangthong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Phine' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Seponh' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Nong' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Thapangthong' THEN 'Songkhone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Songkhone' THEN 'Songkhone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Champhone' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xayboury' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Viraboury' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Assaphone' THEN 'Atsaphangthong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xonnabouly' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Phalanxay' THEN 'Atsaphangthong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xayphouthong' THEN 'Songkhone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Chanthabuly' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sikhottabong' THEN 'Sikhottabong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Xaysetha' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sisattanak' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Naxaythong' THEN 'Naxaiythong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Xaythany' THEN 'Xaythany'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Hadxayfong' THEN 'Hadxaifong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sangthong' THEN 'Naxaiythong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Parkngum' THEN 'Mayparkngum'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Phonhong' THEN 'Vientiane province'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Thoulakhom' THEN 'Thoulakhom'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Keo Oudom' THEN 'Thoulakhom'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Kasy' THEN 'Vangvieng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Vangvieng' THEN 'Vangvieng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Feuang' THEN 'Feuang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Xanakharm' THEN 'Xanakharm'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Mad' THEN 'Xanakharm'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Hinhurp' THEN 'Vientiane province'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Viengkham' THEN 'Vientiane province'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Mune' THEN 'Feuang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xaiyabuly' THEN 'Xainyabuli'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Khop' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Hongsa' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Ngeun' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xienghone' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Phiang' THEN 'Xainyabuli'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Parklai' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Kenethao' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Botene' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Thongmyxay' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xaysathan' THEN 'Xainyabuli'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Anouvong' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Longchaeng' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Longxan' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Hom' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Thathom' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'La Mam' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Kaleum' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Dak Cheung' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Tha Teng' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Paek' THEN 'Xiengkhouang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Kham' THEN 'Kham'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Nong Het' THEN 'Kham'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Khoune' THEN 'Khoune'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Mok' THEN 'Khoune'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Phou Kout' THEN 'Xiengkhouang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Phaxay' THEN 'Xiengkhouang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = '' AND ci.city_name = '' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) IS NULL AND ci.city_name IS NULL THEN 'Head office'
		ELSE 'Head office'
	END AS `branch_name`, 
    'Dormant' AS approach_type,
    p.id AS approach_id,
    p.trading_currency AS currency,
    p.loan_amount /
            (CASE WHEN p.trading_currency = 'USD' THEN 1 
                    WHEN p.trading_currency = 'LAK' THEN cr.usd2lak 
                    WHEN p.trading_currency = 'THB' THEN cr.usd2thb
            end)
     AS `usd_loan_amount_old`,
	p.monthly_interest AS `monthly_interest_old`,
	p.no_of_payment AS `no_of_payment_old`,
	CASE 
		WHEN p.payment_schedule_type = 1 THEN 'Installment' 
		WHEN p.payment_schedule_type = 2 THEN 'One-time' 
		WHEN p.payment_schedule_type = 3 THEN 'Bullet-MOU'
	END AS `payment_schedule_type_old`,
	p.first_payment_date AS `first_payment_date_old`, 
    '' AS usd_now_amount,
    CONVERT(CAST(CONVERT(CONCAT(bt.code, ' ', bt.type) USING latin1) as binary) USING utf8) AS `business_type`,
    p.customer_monthly_income,
	-- Guarantor info
	CONVERT(CAST(CONVERT(
					CONCAT(g.guarantor_first_name_lo, ' ', g.guarantor_last_name_lo, ' ', g.guarantor_first_name_en, ' ', g.guarantor_last_name_en) 
				USING latin1) 
			AS binary) 
	USING utf8) AS `guarantor_name`,
    CASE 
	    WHEN LEFT (RIGHT (REPLACE ( g.guarantor_contact_no, ' ', '') ,8),1) = '0' 
			THEN CONCAT('903',RIGHT (REPLACE ( g.guarantor_contact_no, ' ', '') ,8))
		WHEN length (REPLACE ( g.guarantor_contact_no, ' ', '')) = 7 
			THEN CONCAT('9030',REPLACE ( g.guarantor_contact_no, ' ', ''))
		ELSE CONCAT('9020', RIGHT(REPLACE ( g.guarantor_contact_no, ' ', '') , 8))
	END AS `guarantor_tel`,
	CASE 
		WHEN g.guarantor_relationship = 1 THEN 'Father' 
		WHEN g.guarantor_relationship = 2 THEN 'Mother'
		WHEN g.guarantor_relationship = 3 THEN 'Husband' 
		WHEN g.guarantor_relationship = 4 THEN 'Wife'
		WHEN g.guarantor_relationship = 5 THEN 'Children' 
		WHEN g.guarantor_relationship = 6 THEN 'Older Brother'
		WHEN g.guarantor_relationship = 7 THEN 'Older Sister' 
		WHEN g.guarantor_relationship = 8 THEN 'Younger Brother'
		WHEN g.guarantor_relationship = 8 THEN 'Younger Sister' 
		WHEN g.guarantor_relationship = 10 THEN 'Uncle'
		WHEN g.guarantor_relationship = 11 THEN 'Aunt' 
		WHEN g.guarantor_relationship = 12 THEN 'Cousin'
		WHEN g.guarantor_relationship = 13 THEN 'Son' 
		WHEN g.guarantor_relationship = 14 THEN 'Daughter'
		ELSE 
			CONVERT(CAST(CONVERT( g.guarantor_relationship_others USING latin1) AS binary) USING utf8)
	END `guarantor_relationship`
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON cu.id = p.customer_id
LEFT JOIN tblguarantor g 
	ON g.id = (SELECT id FROM tblguarantor WHERE prospect_id = c.prospect_id ORDER BY id ASC LIMIT 0, 1)
LEFT JOIN tblvillage v ON cu.address_village_id = v.id
LEFT JOIN tblcity ci ON ci.id = cu.address_city
LEFT JOIN tblprovince pv ON pv.id = cu.address_province
LEFT JOIN (
		SELECT pa2.prospect_id, SUM(av2.min_buying_price) AS `min_buying_price` 
		FROM tblprospectasset pa2 
		LEFT JOIN tblassetvaluation av2 ON av2.id = pa2.assetvaluation_id
		GROUP BY pa2.prospect_id
	) AS am 
	ON p.id = am.prospect_id
LEFT JOIN tblprospectasset pa
	ON pa.prospect_id = p.id AND pa.assetvaluation_id = (SELECT assetvaluation_id 
								FROM tblprospectasset pa1 
								LEFT JOIN tblassetvaluation av1 ON av1.id = pa1.assetvaluation_id
								WHERE pa1.prospect_id = p.id 
								ORDER BY av1.min_buying_price DESC 
								LIMIT 0, 1 )
LEFT JOIN tblassetvaluation av ON av.id = pa.assetvaluation_id
LEFT JOIN tblcar car ON av.collateral_car_id = car.id
LEFT JOIN tblbusinesstype bt ON (bt.code = cu.business_type)
LEFT JOIN tblcurrencyrate cr ON (cr.date_for = date_format(now(), '%Y-%m-01'))
LEFT JOIN tbluser us ON (us.id = p.salesperson_id)
WHERE c.status IN (4, 6, 7)
	AND c.contract_no IN ();




-- To Export Existing list from lalco 18.140.117.112 to Frappe table tabSME_Approach_list
SELECT 
	NOW() AS creation,
	'Administrator' AS owner,
	NULL AS staff_no,
	CONCAT(us.staff_no, ' - ', upper(us.nickname)) as `own_salesperson`,
	CASE WHEN c.status = 4 THEN 'Inc' else 'Dor' end AS type,
	c.contract_no AS contract_no,
	c.id AS 'contract_id',
	cu.id AS case_no,
    CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
    CASE 
	    WHEN LEFT (RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' 
			THEN CONCAT('903',RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8))
		WHEN length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 
			THEN CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
		ELSE CONCAT('9020', RIGHT(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	END AS `customer_tel`,
    cu.date_of_birth,
    CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name) AS address_province_and_city,
    CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) AS address_village,
    car.car_make AS maker, 
    CONVERT(CAST(CONVERT(car.car_model USING latin1) as binary) USING utf8) AS model, 
    av.collateral_year AS year,
    am.min_buying_price AS `car_buying_price`,
CASE 
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Saysetha' THEN 'Attapue'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Samakkhixay' THEN 'Attapue'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Sanamxay' THEN 'Attapue'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Sanxay' THEN 'Attapue'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Phouvong' THEN 'Attapue'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Houay Xay' THEN 'Bokeo'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Ton Pheung' THEN 'Tonpherng'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Meung' THEN 'Tonpherng'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Pha Oudom' THEN 'Bokeo'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Pak Tha' THEN 'Bokeo'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Paksane' THEN 'Paksan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Thaphabat' THEN 'Paksan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Pakkading' THEN 'Pakkading'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Borikhane' THEN 'Paksan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Khamkeut' THEN 'Khamkeuth'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Viengthong' THEN 'Khamkeuth'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Xaychamphone' THEN 'Khamkeuth'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Pak Se' THEN 'Pakse'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Sanasomboun' THEN 'Pakse'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Batiengchaleunsouk' THEN 'Pakse'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Paksong' THEN 'Paksxong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Pathouphone' THEN 'Pakse'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Phonthong' THEN 'Chongmeg'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Champassack' THEN 'Sukhuma'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Soukhoumma' THEN 'Sukhuma'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Mounlapamok' THEN 'Khong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Khong' THEN 'Khong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xam Neua' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xiengkho' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Muang Hiam' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Viengxay' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Houameuang' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Samtay' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Sop Bao' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Muang Et' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Kuane' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xone' THEN 'Houaphan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Thakhek' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Mahaxay' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Nong Bok' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Hineboune' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Yommalath' THEN 'Nhommalth'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Boualapha' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Nakai' THEN 'Nhommalth'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Sebangphay' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Saybouathong' THEN 'Thakek'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Kounkham' THEN 'Khamkeuth'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Namtha' THEN 'Luangnamtha'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Sing' THEN 'Luangnamtha'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Long' THEN 'Luangnamtha'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Viengphoukha' THEN 'Luangnamtha'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Na Le' THEN 'Luangnamtha'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Luang Prabang' THEN 'Luangprabang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Xiengngeun' THEN 'Luangprabang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Nane' THEN 'Nane'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Pak Ou' THEN 'Luangprabang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Nam Bak' THEN 'Nambak'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Ngoy' THEN 'Nambak'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Pak Seng' THEN 'Luangprabang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phonxay' THEN 'Luangprabang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Chomphet' THEN 'Nane'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Viengkham' THEN 'Nambak'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phoukhoune' THEN 'Luangprabang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phonthong' THEN 'Nambak'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Xay' THEN 'Oudomxay'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'La' THEN 'Oudomxay'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Na Mo' THEN 'Oudomxay'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Nga' THEN 'Oudomxay'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Beng' THEN 'Hoon'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Houne' THEN 'Hoon'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Pak Beng' THEN 'Hoon'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'May' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Khoua' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Samphanh' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Boun Neua' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Yot Ou' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Boun Tay' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Phongsaly' THEN 'Phongsary'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Saravanh' THEN 'Salavan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Ta Oy' THEN 'Salavan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Toumlane' THEN 'Salavan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Lakhonepheng' THEN 'Khongxedone'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Vapy' THEN 'Khongxedone'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Khongsedone' THEN 'Khongxedone'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Lao Ngam' THEN 'Salavan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Sa Mouay' THEN 'Salavan'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Kaysone Phomvihane' THEN 'Savannakhet'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Outhoumphone' THEN 'Savannakhet'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Atsaphangthong' THEN 'Atsaphangthong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Phine' THEN 'Phine'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Seponh' THEN 'Phine'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Nong' THEN 'Phine'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Thapangthong' THEN 'Songkhone'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Songkhone' THEN 'Songkhone'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Champhone' THEN 'Savannakhet'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xayboury' THEN 'Savannakhet'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Viraboury' THEN 'Phine'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Assaphone' THEN 'Atsaphangthong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xonnabouly' THEN 'Savannakhet'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Phalanxay' THEN 'Atsaphangthong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xayphouthong' THEN 'Songkhone'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Chanthabuly' THEN 'Head office'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sikhottabong' THEN 'Sikhottabong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Xaysetha' THEN 'Head office'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sisattanak' THEN 'Head office'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Naxaythong' THEN 'Naxaiythong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Xaythany' THEN 'Xaythany'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Hadxayfong' THEN 'Hadxaifong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sangthong' THEN 'Naxaiythong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Parkngum' THEN 'Mayparkngum'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Phonhong' THEN 'Vientiane province'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Thoulakhom' THEN 'Thoulakhom'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Keo Oudom' THEN 'Thoulakhom'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Kasy' THEN 'Vangvieng'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Vangvieng' THEN 'Vangvieng'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Feuang' THEN 'Feuang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Xanakharm' THEN 'Xanakharm'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Mad' THEN 'Xanakharm'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Hinhurp' THEN 'Vientiane province'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Viengkham' THEN 'Vientiane province'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Mune' THEN 'Feuang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xaiyabuly' THEN 'Xainyabuli'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Khop' THEN 'Hongsa'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Hongsa' THEN 'Hongsa'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Ngeun' THEN 'Hongsa'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xienghone' THEN 'Hongsa'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Phiang' THEN 'Xainyabuli'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Parklai' THEN 'Parklai'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Kenethao' THEN 'Parklai'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Botene' THEN 'Parklai'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Thongmyxay' THEN 'Parklai'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xaysathan' THEN 'Xainyabuli'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Anouvong' THEN 'Xaisomboun'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Longchaeng' THEN 'Xaisomboun'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Longxan' THEN 'Xaisomboun'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Hom' THEN 'Xaisomboun'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Thathom' THEN 'Xaisomboun'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'La Mam' THEN 'Sekong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Kaleum' THEN 'Sekong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Dak Cheung' THEN 'Sekong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Tha Teng' THEN 'Sekong'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Paek' THEN 'Xiengkhouang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Kham' THEN 'Kham'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Nong Het' THEN 'Kham'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Khoune' THEN 'Khoune'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Mok' THEN 'Khoune'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Phou Kout' THEN 'Xiengkhouang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Phaxay' THEN 'Xiengkhouang'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = '' AND ci.city_name = '' THEN 'Head office'
	WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) IS NULL AND ci.city_name IS NULL THEN 'Head office'
	ELSE 'Head office'
END AS `branch_name`, 
    'Existing' AS approach_type,
    p.id AS approach_id,
    p.trading_currency AS currency,
    p.loan_amount /
            (CASE WHEN p.trading_currency = 'USD' THEN 1 
                    WHEN p.trading_currency = 'LAK' THEN cr.usd2lak 
                    WHEN p.trading_currency = 'THB' THEN cr.usd2thb
            end)
     AS `usd_loan_amount_old`,
	p.monthly_interest AS `monthly_interest_old`,
	p.no_of_payment AS `no_of_payment_old`,
	CASE 
		WHEN p.payment_schedule_type = 1 THEN 'Installment' 
		WHEN p.payment_schedule_type = 2 THEN 'One-time' 
		WHEN p.payment_schedule_type = 3 THEN 'Bullet-MOU'
	END AS `payment_schedule_type_old`,
	p.first_payment_date AS `first_payment_date_old`, 
    '' AS usd_now_amount,
    CONVERT(CAST(CONVERT(CONCAT(bt.code, ' ', bt.type) USING latin1) as binary) USING utf8) AS `business_type`,
    p.customer_monthly_income,
	-- Guarantor info
	CONVERT(CAST(CONVERT(
					CONCAT(g.guarantor_first_name_lo, ' ', g.guarantor_last_name_lo, ' ', g.guarantor_first_name_en, ' ', g.guarantor_last_name_en) 
				USING latin1) 
			AS binary) 
	USING utf8) AS `guarantor_name`,
    CASE 
	    WHEN LEFT (RIGHT (REPLACE ( g.guarantor_contact_no, ' ', '') ,8),1) = '0' 
			THEN CONCAT('903',RIGHT (REPLACE ( g.guarantor_contact_no, ' ', '') ,8))
		WHEN length (REPLACE ( g.guarantor_contact_no, ' ', '')) = 7 
			THEN CONCAT('9030',REPLACE ( g.guarantor_contact_no, ' ', ''))
		ELSE CONCAT('9020', RIGHT(REPLACE ( g.guarantor_contact_no, ' ', '') , 8))
	END AS `guarantor_tel`,
	CASE 
		WHEN g.guarantor_relationship = 1 THEN 'Father' 
		WHEN g.guarantor_relationship = 2 THEN 'Mother'
		WHEN g.guarantor_relationship = 3 THEN 'Husband' 
		WHEN g.guarantor_relationship = 4 THEN 'Wife'
		WHEN g.guarantor_relationship = 5 THEN 'Children' 
		WHEN g.guarantor_relationship = 6 THEN 'Older Brother'
		WHEN g.guarantor_relationship = 7 THEN 'Older Sister' 
		WHEN g.guarantor_relationship = 8 THEN 'Younger Brother'
		WHEN g.guarantor_relationship = 8 THEN 'Younger Sister' 
		WHEN g.guarantor_relationship = 10 THEN 'Uncle'
		WHEN g.guarantor_relationship = 11 THEN 'Aunt' 
		WHEN g.guarantor_relationship = 12 THEN 'Cousin'
		WHEN g.guarantor_relationship = 13 THEN 'Son' 
		WHEN g.guarantor_relationship = 14 THEN 'Daughter'
		ELSE 
			CONVERT(CAST(CONVERT( g.guarantor_relationship_others USING latin1) AS binary) USING utf8)
	END `guarantor_relationship`
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON cu.id = p.customer_id
LEFT JOIN tblguarantor g 
	ON g.id = (SELECT id FROM tblguarantor WHERE prospect_id = c.prospect_id ORDER BY id ASC LIMIT 0, 1)
LEFT JOIN tblvillage v ON cu.address_village_id = v.id
LEFT JOIN tblcity ci ON ci.id = cu.address_city
LEFT JOIN tblprovince pv ON pv.id = cu.address_province
LEFT JOIN (
		SELECT pa2.prospect_id, SUM(av2.min_buying_price) AS `min_buying_price` 
		FROM tblprospectasset pa2 
		LEFT JOIN tblassetvaluation av2 ON av2.id = pa2.assetvaluation_id
		GROUP BY pa2.prospect_id
	) AS am 
	ON p.id = am.prospect_id
LEFT JOIN tblprospectasset pa
	ON pa.prospect_id = p.id AND pa.assetvaluation_id = (SELECT assetvaluation_id 
								FROM tblprospectasset pa1 
								LEFT JOIN tblassetvaluation av1 ON av1.id = pa1.assetvaluation_id
								WHERE pa1.prospect_id = p.id 
								ORDER BY av1.min_buying_price DESC 
								LIMIT 0, 1 )
LEFT JOIN tblassetvaluation av ON av.id = pa.assetvaluation_id
LEFT JOIN tblcar car ON av.collateral_car_id = car.id
LEFT JOIN tblbusinesstype bt ON (bt.code = cu.business_type)
LEFT JOIN tblcurrencyrate cr ON (cr.date_for = date_format(now(), '%Y-%m-01'))
LEFT JOIN tbluser us ON (us.id = p.salesperson_id)
WHERE c.status = 4 
;





SHOW INDEX FROM tabSME_Approach_list;
CREATE INDEX idx_first_payment_date_old ON tabSME_Approach_list(first_payment_date_old);
CREATE INDEX idx_inada_status ON tabSME_Approach_list(inada_status);

SHOW INDEX FROM temp_sme_pbx_BO_special_management;
CREATE INDEX idx_date ON temp_sme_pbx_BO_special_management(date);

SELECT DISTINCT management_type from temp_sme_pbx_BO_special_management ;


-- 1.1 Dormant-HC1
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-HC1';

INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	apl.staff_no AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Dormant-HC1' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
;


-- Export Dormant-HC1
SELECT 
	date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	sme.`g-dept` as `G-DEPT`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.approach_id as `contract_no`, 
	bp.usd_loan_amount_old , 
	bp.monthly_interest_old,
	bp.no_of_payment_old,
	bp.payment_schedule_type_old,
	bp.customer_name ,
	bp.business_type, 
	bp.customer_monthly_income ,
	bp.guarantor_name,
	bp.guarantor_relationship, 
	NULL AS `closed_date`,
	NULL AS `S_at_5th`,
	NULL AS `A_at_10th`,
	NULL AS `B_at_20th`,
	NULL AS `C_at_31st`,
	NULL AS `F_after_1_month`,
	CONCAT('https://portal01.lalco.la:1901/print_loan_summary.php?contractid=', bp.`contract_id` ) as `Ringi(LMS)`,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case
		when bp.contract_status = 'Contracted' then 'Contracted'
		when bp.contract_status = 'Cancelled' then 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-01')  then 'called' else 'x' end as `call_ status`,
	CASE 
		WHEN (SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA')
			AND bp.visit_date IS NOT NULL AND bp.visit_date != '' AND bp.visit_date <= CURDATE()
		THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson,
	t1.`no_of_invalide_number`,
	t1.`Anti_LALCO`,
	bp.car_type as 'Car Type',
	bp.aditional_car as 'Additional Car',
	bp.estate_types as 'Estate Type',
	bp.have_or_not as 'Recievable'
FROM tabSME_Approach_list bp 
INNER JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-HC1') )
LEFT JOIN (
		SELECT updated_id,
			SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status , ' ', 1)) = 'FFF' THEN 1 ELSE 0 END) `no_of_invalide_number`,
			SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status, ' ', 1)) = 'N1' THEN 1 ELSE 0 END) `Anti_LALCO`
		FROM (
			SELECT `id`, `updated_id`, DATE_FORMAT(date_created, '%Y-%m-%d') AS `date_created`, `now_status` 
			FROM `log_sme_follow_approach`
			GROUP BY updated_id, DATE_FORMAT(date_created, '%Y-%m-%d'), now_status 
			) t
		GROUP BY updated_id 
		) t1 ON bp.name = t1.updated_id
LEFT JOIN sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
ORDER BY sme.id ASC;





-- 1.2 Dormant-HC2
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-HC2';

INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	apl.staff_no AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Dormant-HC2' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
;


-- Export Dormant-HC2
SELECT 
	date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	sme.`g-dept` as `G-DEPT`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.approach_id as `contract_no`, 
	bp.usd_loan_amount_old , 
	bp.monthly_interest_old,
	bp.no_of_payment_old,
	bp.payment_schedule_type_old,
	bp.customer_name ,
	bp.business_type, 
	bp.customer_monthly_income ,
	bp.guarantor_name,
	bp.guarantor_relationship, 
	NULL AS `closed_date`,
	NULL AS `S_at_5th`,
	NULL AS `A_at_10th`,
	NULL AS `B_at_20th`,
	NULL AS `C_at_31st`,
	NULL AS `F_after_1_month`,
	CONCAT('https://portal01.lalco.la:1901/print_loan_summary.php?contractid=', bp.`contract_id` ) as `Ringi(LMS)`,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case
		when bp.contract_status = 'Contracted' then 'Contracted'
		when bp.contract_status = 'Cancelled' then 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-16')  then 'called' else 'x' end as `call_ status`,
	CASE 
		WHEN (SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA')
			AND bp.visit_date IS NOT NULL AND bp.visit_date != '' AND bp.visit_date <= CURDATE()
		THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson,
	t1.`no_of_invalide_number`,
	t1.`Anti_LALCO`,
	bp.car_type as 'Car Type',
	bp.aditional_car as 'Additional Car',
	bp.estate_types as 'Estate Type',
	bp.have_or_not as 'Recievable'
FROM tabSME_Approach_list bp 
INNER JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-HC2') )
LEFT JOIN (
		SELECT updated_id,
			SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status , ' ', 1)) = 'FFF' THEN 1 ELSE 0 END) `no_of_invalide_number`,
			SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status, ' ', 1)) = 'N1' THEN 1 ELSE 0 END) `Anti_LALCO`
		FROM (
			SELECT `id`, `updated_id`, DATE_FORMAT(date_created, '%Y-%m-%d') AS `date_created`, `now_status` 
			FROM `log_sme_follow_approach`
			GROUP BY updated_id, DATE_FORMAT(date_created, '%Y-%m-%d'), now_status 
			) t
		GROUP BY updated_id 
		) t1 ON bp.name = t1.updated_id
LEFT JOIN sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
ORDER BY sme.id ASC;



-- -------------------------------------- Existing --------------------------------------

-- 2.1 Existing-HC1
SELECT COUNT(*) FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-HC1';

DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-HC1';


INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	apl.staff_no AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Existing-HC1' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing' 
	AND apl.first_payment_date_old <= DATE_FORMAT(CURDATE(), '%Y-%m-05')
	AND apl.inada_status IN ('Normal', 'Not pay last month')
;


-- Export Existing-HC1
SELECT 
	date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	sme.`g-dept` as `G-DEPT`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.approach_id as `contract_no`, 
	bp.usd_loan_amount_old , 
	bp.monthly_interest_old,
	bp.no_of_payment_old,
	bp.payment_schedule_type_old,
	bp.customer_name ,
	bp.business_type, 
	bp.customer_monthly_income ,
	bp.guarantor_name,
	bp.guarantor_relationship, 
	NULL AS `closed_date`,
	NULL AS `S_at_5th`,
	NULL AS `A_at_10th`,
	NULL AS `B_at_20th`,
	NULL AS `C_at_31st`,
	NULL AS `F_after_1_month`,
	CONCAT('https://portal01.lalco.la:1901/print_loan_summary.php?contractid=', bp.`contract_id` ) as `Ringi(LMS)`,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case
		when bp.contract_status = 'Contracted' then 'Contracted'
		when bp.contract_status = 'Cancelled' then 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-01')  then 'called' else 'x' end as `call_ status`,
	CASE 
		WHEN (SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA')
			AND bp.visit_date IS NOT NULL AND bp.visit_date != '' AND bp.visit_date <= CURDATE()
		THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson,
	t1.`no_of_invalide_number`,
	t1.`Anti_LALCO`
FROM tabSME_Approach_list bp 
INNER JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-HC1') )
LEFT JOIN (
		SELECT updated_id,
			SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status , ' ', 1)) = 'FFF' THEN 1 ELSE 0 END) `no_of_invalide_number`,
			SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status, ' ', 1)) = 'N1' THEN 1 ELSE 0 END) `Anti_LALCO`
		FROM (
			SELECT `id`, `updated_id`, DATE_FORMAT(date_created, '%Y-%m-%d') AS `date_created`, `now_status` 
			FROM `log_sme_follow_approach`
			GROUP BY updated_id, DATE_FORMAT(date_created, '%Y-%m-%d'), now_status 
			) t
		GROUP BY updated_id 
		) t1 ON bp.name = t1.updated_id
LEFT JOIN sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
ORDER BY sme.id ASC;




-- 2.2 Existing-HC2
SELECT COUNT(*) FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-HC2';

DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-HC2';


INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	apl.staff_no AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Existing-HC2' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing' 
	AND apl.first_payment_date_old <= DATE_FORMAT(CURDATE(), '%Y-%m-05')
	AND apl.inada_status IN ('Normal', 'Not pay last month')
;


-- Export-HC2
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.approach_id as `contract_no`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount_old , 
	bp.normal_bullet ,
	bp.customer_name ,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	CASE
		WHEN bp.contract_status = 'Contracted' THEN 'Contracted'
		WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	CASE WHEN bp.rank1 in ('S','A','B','C') THEN 1 else 0 end as `rank1_SABC`,
	CASE WHEN rank_update in ('S','A','B','C') THEN 1 else 0 end as `SABC`, 
	CASE WHEN bp.modified >= DATE_FORMAT(CURDATE(), '%Y-%m-01')  THEN 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	CASE WHEN bp.credit_remark is not null THEN bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson,
	CASE WHEN bp.car_buying_price - bp.usd_now_amount <= 0 THEN 0 
		ELSE bp.car_buying_price - bp.usd_now_amount 
	END AS `usd_Inc_amount`
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-HC2') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;







-- 3. Existing-CCC
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-CCC';

INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	NULL AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Existing-CCC' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
;


-- to assigned 
SELECT tspbsm.id, tspbsm.bp_name, tspbsm.current_staff, bp.approach_id FROM temp_sme_pbx_BO_special_management tspbsm 
LEFT JOIN tabSME_Approach_list bp ON (tspbsm.bp_name = bp.name)
WHERE management_type = 'Existing-CCC'
	AND bp.approach_id IN (2116179, 2111814, 2106424, 2117132)
;


-- Existing-CCC
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.approach_id as `contract_no`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount_old , 
	bp.normal_bullet ,
	bp.customer_name ,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	CASE
		WHEN bp.contract_status = 'Contracted' THEN 'Contracted'
		WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	CASE WHEN bp.rank1 in ('S','A','B','C') THEN 1 else 0 end as `rank1_SABC`,
	CASE WHEN rank_update in ('S','A','B','C') THEN 1 else 0 end as `SABC`, 
	CASE 
		WHEN tf.id IS NULL THEN 'x'
		WHEN bp.modified >= date_format(curdate(), '%Y-%m-01')  THEN 'called' else 'x' 
	end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	CASE WHEN bp.credit_remark is not null THEN bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-CCC') )
LEFT JOIN log_sme_follow_approach tf
	ON tf.id = (SELECT id FROM log_sme_follow_approach 
				WHERE updated_id = bp.name 
					AND modified_by IN ('anunh1603@lalco.la', 'paeng2233@lalco.la', 'phet2349@lalco.la', 'pupiew2451@lalco.la', 'kesone.t@lalco.la', 'ning3627@lalco.la', 'jen3694@lalco.la', 'noy3804@lalco.la')
				ORDER BY id ASC 
				LIMIT 1
					)
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- ---------------------------------- 2025-05-30 ----------------------------------
-- 2.1 Existing-HC1
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing_for_24_people';

INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	apl.staff_no AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	CASE WHEN apl.car_buying_price - apl.usd_now_amount <= 0 THEN 0 
		ELSE apl.car_buying_price - apl.usd_now_amount 
	END AS `usd_loan_amount`,
	'Existing_for_24_people' as `management_type`,
	NOW() AS `datetime_create`
from tabSME_Approach_list apl 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = apl.name and tspbsm.management_type in ('Existing-HC1') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
WHERE 
	sme.unit_no IN (8, 11, 21, 32, 40, 44, 53, 56, 58, 60, 61, 64, 65, 67, 70, 71, 72, 73, 77, 3, 18, 24, 26, 29, 34, 36, 37, 38, 41, 43, 45, 48, 50, 52, 59, 74, 10, 15, 19, 20, 30, 33, 35, 39, 46, 49, 54, 55, 57, 63, 68, 75, 76, 6, 12, 17, 47, 62)
	AND 
		CASE WHEN apl.car_buying_price - apl.usd_now_amount <= 0 THEN 0 
			ELSE apl.car_buying_price - apl.usd_now_amount 
		END > 0
;


-- export to assign
SELECT * FROM temp_sme_pbx_BO_special_management
WHERE `management_type` = 'Existing_for_24_people'


-- 2.2 Export Existing_for_24_people
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.approach_id as `contract_no`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount_old , 
	bp.normal_bullet ,
	bp.customer_name ,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	CASE
		WHEN bp.contract_status = 'Contracted' THEN 'Contracted'
		WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	CASE WHEN bp.rank1 in ('S','A','B','C') THEN 1 else 0 end as `rank1_SABC`,
	CASE WHEN rank_update in ('S','A','B','C') THEN 1 else 0 end as `SABC`, 
	CASE WHEN bp.modified >= date_format(curdate(), '%Y-%m-30')  THEN 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	CASE WHEN bp.credit_remark is not null THEN bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson,
	CASE WHEN bp.car_buying_price - bp.usd_now_amount <= 0 THEN 0 
		ELSE bp.car_buying_price - bp.usd_now_amount 
	END AS `usd_Inc_amount`
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing_for_24_people') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- ---------------------------------- 2025-05-30 ----------------------------------
-- 1.1 Dormant_for_24_people
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant_for_24_people';

INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	apl.staff_no AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') THEN apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 THEN 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Dormant_for_24_people' as `management_type`,
	NOW() AS `datetime_create`
from tabSME_Approach_list apl 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = apl.name and tspbsm.management_type in ('Dormant-HC1') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
WHERE 
	sme.unit_no IN (2, 8, 9, 13, 25, 31, 33, 43, 46, 47, 50, 58, 59, 63, 67, 68, 71, 72, 21, 23, 24, 36, 39, 44, 45, 52, 55, 65)
	AND 
		apl.usd_loan_amount_old >= 5000
;


-- export to assign
SELECT * FROM temp_sme_pbx_BO_special_management
WHERE `management_type` = 'Dormant_for_24_people'


-- 1.2 Export Dormant-HC1
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.approach_id as `contract_no`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	CASE 
		WHEN sme.staff_no IS NOT NULL THEN sme.staff_no
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', 1))
	END AS `Staff No`, 
	CASE 
		WHEN sme.staff_name IS NOT NULL THEN sme.staff_name
		ELSE TRIM(SUBSTRING_INDEX(current_staff, '-', -1))
	END AS `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount_old , 
	bp.normal_bullet ,
	bp.customer_name ,
	CONCAT('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	CASE
		WHEN bp.contract_status = 'Contracted' THEN 'Contracted'
		WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled'
		else bp.rank_update
	end `Now Result`,
	bp.negotiation_comment AS `negotiation_comments`,
	is_sales_partner as `SP_rank`,
	CASE WHEN bp.rank1 in ('S','A','B','C') THEN 1 else 0 end as `rank1_SABC`,
	CASE WHEN rank_update in ('S','A','B','C') THEN 1 else 0 end as `SABC`, 
	CASE WHEN bp.modified >= date_format(curdate(), '%Y-%m-30')  THEN 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	CASE WHEN bp.credit_remark is not null THEN bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson,
	CASE WHEN bp.car_buying_price - bp.usd_now_amount <= 0 THEN 0 
		ELSE bp.car_buying_price - bp.usd_now_amount 
	END AS `usd_Inc_amount`
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant_for_24_people') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;


















