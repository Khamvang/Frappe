
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






select DISTINCT management_type from temp_sme_pbx_BO_special_management


-- 1. Dormant-HC1
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
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') then apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 then 36 
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
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
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
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-HC1') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- 1.2 Dormant-HC1
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
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') then apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 then 36 
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
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
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
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-HC2') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- 2. Existing-HC1
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
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') then apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 then 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.usd_loan_amount_old AS `usd_loan_amount`,
	'Existing-HC1' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
;


-- Export Dormant-HC1
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
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
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
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-HC1') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
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
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') then apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 then 36 
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
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
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
	case 
		WHEN tf.id IS NULL THEN 'x'
		when bp.modified >= date_format(curdate(), '%Y-%m-01')  then 'called' else 'x' 
	end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
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
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;
















