

/*
 To automatically update the data whenever the specified columns change, you can use a trigger in MySQL (or MariaDB) to apply this logic after an update on the table. Based on your manual query, you can create a BEFORE UPDATE or AFTER UPDATE trigger, depending on when you want the changes to happen.

Here’s an example of how to write a trigger that will automatically perform these updates when the columns in the tabSME_BO_and_Plan table are updated:

Example Trigger (AFTER UPDATE):
 */

-- 1. Manual run 
update tabSME_BO_and_Plan 
	set rank_S_date = case when rank_update = 'S' then date_format(modified, '%Y-%m-%d') else rank_S_date end,
	rank_A_date = case when rank_update = 'A' then date_format(modified, '%Y-%m-%d') else rank_A_date end,
	rank_B_date = case when rank_update = 'B' then date_format(modified, '%Y-%m-%d') else rank_B_date end,
	rank_C_date = case when rank_update = 'C' then date_format(modified, '%Y-%m-%d') else rank_C_date end,
	rank_update = case when contract_status = 'Contracted' then 'S' else rank_update end,
	ringi_status = case when contract_status = 'Contracted' then 'Approved' else ringi_status end,
	visit_or_not = case when contract_status = 'Contracted' then 'Yes - ຢ້ຽມຢາມແລ້ວ' when visit_date > date(now()) and visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' then 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' else visit_or_not end,
	rank1 = case when date_format(creation, '%Y-%m-%d') = date_format(modified, '%Y-%m-%d') then rank_update else rank1 end,
	`own_salesperson` = case when `own_salesperson` is not null then `own_salesperson` when callcenter_of_sales is null or callcenter_of_sales = '' then staff_no else regexp_replace(callcenter_of_sales  , '[^[:digit:]]', '') end,
	customer_tel = 
	case when customer_tel = '' then ''
		when (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(customer_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(customer_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8))
	end
;



-- 2. Auto run query 

#### 1. **Trigger for `BEFORE INSERT`**
-- This trigger will handle the logic for new records being inserted into the table.


DROP TRIGGER IF EXISTS `auto_insert_rank_and_status`;

DELIMITER $$

CREATE TRIGGER auto_insert_rank_and_status
BEFORE INSERT ON tabSME_BO_and_Plan
FOR EACH ROW
BEGIN
    -- Declare a variable for cleaned phone number
    DECLARE cleaned_tel VARCHAR(20);

    -- Update rank_S_date
    IF NEW.rank_update = 'S' THEN
        SET NEW.rank_S_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_A_date
    IF NEW.rank_update = 'A' THEN
        SET NEW.rank_A_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_B_date
    IF NEW.rank_update = 'B' THEN
        SET NEW.rank_B_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_C_date
    IF NEW.rank_update = 'C' THEN
        SET NEW.rank_C_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_update to 'S' if contract_status is 'Contracted'
    IF NEW.contract_status = 'Contracted' THEN
        SET NEW.rank_update = 'S';
    END IF;

    -- Update ringi_status to 'Approved' if contract_status is 'Contracted'
    IF NEW.contract_status = 'Contracted' THEN
        SET NEW.ringi_status = 'Approved';
    END IF;

    -- Update visit_or_not based on contract status and visit_date
    IF NEW.contract_status = 'Contracted' THEN
        SET NEW.visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ';
    ELSEIF NEW.visit_date > CURRENT_DATE() AND NEW.visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' THEN
        SET NEW.visit_or_not = 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ';
    END IF;

    -- Update rank1 based on creation and modified dates
    IF DATE_FORMAT(NEW.creation, '%Y-%m-%d') = DATE_FORMAT(NEW.modified, '%Y-%m-%d') THEN
        SET NEW.rank1 = NEW.rank_update;
    END IF;

    -- Update own_salesperson based on conditions
    IF NEW.own_salesperson IS NULL AND (NEW.callcenter_of_sales IS NULL OR NEW.callcenter_of_sales = '') THEN
        SET NEW.own_salesperson = NEW.staff_no;
    ELSEIF NEW.callcenter_of_sales IS NOT NULL THEN
        SET NEW.own_salesperson = NEW.callcenter_of_sales;
    END IF;

    -- Update customer_tel based on various conditions
    IF NEW.customer_tel = '' THEN
        SET NEW.customer_tel = '';
    ELSE
        -- Remove hyphens and non-numeric characters
        SET cleaned_tel = REPLACE(NEW.customer_tel, '-', '');  -- Remove hyphens
        SET cleaned_tel = REGEXP_REPLACE(cleaned_tel, '[^0-9]', '');  -- Remove non-numeric characters

        -- Handle specific phone number formats
        IF LENGTH(cleaned_tel) = 11 AND LEFT(cleaned_tel, 3) = '020' THEN
            SET NEW.customer_tel = CONCAT('9020', RIGHT(cleaned_tel, 8));
        ELSEIF LENGTH(cleaned_tel) = 10 AND LEFT(cleaned_tel, 3) = '030' THEN
            SET NEW.customer_tel = CONCAT('9030', RIGHT(cleaned_tel, 7));
        ELSE
            SET NEW.customer_tel = CONCAT('9020', RIGHT(cleaned_tel, 8));
        END IF;
    END IF;
END$$

DELIMITER ;


-- 

#### 2. **Trigger for `BEFORE UPDATE`**
-- This trigger remains largely unchanged but ensures that the logic is applied when an existing record is updated.

DROP TRIGGER IF EXISTS `auto_update_rank_and_status`;

DELIMITER $$

CREATE TRIGGER auto_update_rank_and_status
BEFORE UPDATE ON tabSME_BO_and_Plan
FOR EACH ROW
BEGIN
    -- Declare a variable for cleaned phone number
    DECLARE cleaned_tel VARCHAR(20);

    -- Update rank_S_date
    IF NEW.rank_update = 'S' AND OLD.rank_update <> 'S' THEN
        SET NEW.rank_S_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_A_date
    IF NEW.rank_update = 'A' AND OLD.rank_update <> 'A' THEN
        SET NEW.rank_A_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_B_date
    IF NEW.rank_update = 'B' AND OLD.rank_update <> 'B' THEN
        SET NEW.rank_B_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_C_date
    IF NEW.rank_update = 'C' AND OLD.rank_update <> 'C' THEN
        SET NEW.rank_C_date = DATE_FORMAT(NEW.modified, '%Y-%m-%d');
    END IF;

    -- Update rank_update to 'S' if contract_status is 'Contracted'
    IF NEW.contract_status = 'Contracted' AND OLD.contract_status <> 'Contracted' THEN
        SET NEW.rank_update = 'S';
    END IF;

    -- Update ringi_status to 'Approved' if contract_status is 'Contracted'
    IF NEW.contract_status = 'Contracted' AND OLD.contract_status <> 'Contracted' THEN
        SET NEW.ringi_status = 'Approved';
    END IF;

    -- Update visit_or_not based on contract status and visit_date
    IF NEW.contract_status = 'Contracted' AND OLD.contract_status <> 'Contracted' THEN
        SET NEW.visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ';
    ELSEIF NEW.visit_date > CURRENT_DATE() AND NEW.visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' THEN
        SET NEW.visit_or_not = 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ';
    END IF;

    -- Update rank1 based on creation and modified dates
    IF DATE_FORMAT(NEW.creation, '%Y-%m-%d') = DATE_FORMAT(NEW.modified, '%Y-%m-%d') THEN
        SET NEW.rank1 = NEW.rank_update;
    END IF;

    -- Update own_salesperson based on conditions
    IF NEW.own_salesperson IS NULL AND (NEW.callcenter_of_sales IS NULL OR NEW.callcenter_of_sales = '') THEN
        SET NEW.own_salesperson = NEW.staff_no;
    ELSEIF NEW.callcenter_of_sales IS NOT NULL THEN
        SET NEW.own_salesperson = NEW.callcenter_of_sales;
    END IF;

    -- Update customer_tel based on various conditions
    IF NEW.customer_tel = '' THEN
        SET NEW.customer_tel = '';
    ELSE
        -- Remove hyphens and non-numeric characters
        SET cleaned_tel = REPLACE(NEW.customer_tel, '-', '');  -- Remove hyphens
        SET cleaned_tel = REGEXP_REPLACE(cleaned_tel, '[^0-9]', '');  -- Remove non-numeric characters

        -- Handle specific phone number formats
        IF LENGTH(cleaned_tel) = 11 AND LEFT(cleaned_tel, 3) = '020' THEN
            SET NEW.customer_tel = CONCAT('9020', RIGHT(cleaned_tel, 8));
        ELSEIF LENGTH(cleaned_tel) = 10 AND LEFT(cleaned_tel, 3) = '030' THEN
            SET NEW.customer_tel = CONCAT('9030', RIGHT(cleaned_tel, 7));
        ELSE
            SET NEW.customer_tel = CONCAT('9020', RIGHT(cleaned_tel, 8));
        END IF;
    END IF;
END$$

DELIMITER ;




-- 3. Test
SHOW TRIGGERS LIKE 'tabSME_BO_and_Plan';


-- 4. Check
SELECT *  FROM tabSME_BO_and_Plan ORDER BY name DESC;





-- _____________________________________________ 1. Prospect customer from Sales partner ________________________________________ 

-- Insert
INSERT INTO tabSME_BO_and_Plan (
	`creation`,
	`owner`,
	`modified_by`,
	`refer_id`,
	`refer_type`,
	`staff_no`,
	`own_salesperson`,
	`customer_name` ,
	`customer_tel` ,
	`type` ,
	`is_sales_partner`,
	`approch_list`,
	`visit_or_not`,
	`usd_loan_amount` ,
	`normal_bullet` ,
	`disbursement_date_pay_date` ,
	`address_province_and_city` ,
	`village` ,
	`maker` ,
	`model` ,
	`rank1`,
	`rank_update`,
	`customer_card`,
	`ringi_status`,
	`ringi_comment`
	)

SELECT 
	CURRENT_TIMESTAMP AS `creation` ,
	sp.modified_by AS `owner`,
	sp.modified_by AS `modified_by`,
	sp.name AS `refer_id`, 
	'tabsme_Sales_partner' AS `refer_type`,
	sp.current_staff AS `staff_no` ,
	sp.current_staff AS `own_salesperson` ,
	sp.customer_name AS `customer_name` ,
	sp.customer_tel AS `customer_tel` ,
	sp.customer_type AS `type` ,
	'' AS `is_sales_partner`,
	CASE
		WHEN sp.refer_type = 'LMS_Broker' THEN '④ Sales partner ທີ່ເຄີຍແນະນຳໃນອາດີດ'
		WHEN sp.refer_type = 'tabSME_BO_and_Plan' AND SUBSTRING_INDEX(`broker_type`, ' ', 1) = 'X' THEN '③-3​ Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ສົນໃຈ​)'
		WHEN sp.refer_type = 'tabSME_BO_and_Plan' AND SUBSTRING_INDEX(`broker_type`, ' ', 1) = 'Y' THEN '③-2 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ເກົ່າ​)'
		WHEN sp.refer_type = 'tabSME_BO_and_Plan' AND SUBSTRING_INDEX(`broker_type`, ' ', 1) = 'Z' THEN '③-1 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ປັດຈຸບັນ​)'
		WHEN sp.refer_type = '5way' THEN '①-4 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູບ່ອນອື່ນໆ ນອກຈາກ 3ຂໍ້ເທິງ)'
		WHEN sp.refer_type = 'staff' THEN '⑥ Resigned Employees ພະນັກງານອອກວຽກ'
		ELSE NULL
	END AS `approch_list`,
	'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' AS `visit_or_not`,
	CEIL(
	    COALESCE(sp.amount, 0) * 
	    (CASE 
	        WHEN sp.currency = 'USD' THEN 1
	        WHEN sp.currency = 'THB' THEN 1 / 35.10
	        WHEN sp.currency = 'LAK' THEN 1 / 23480.00
	        ELSE 0
	    END)
	) AS `usd_loan_amount`,
	'' AS `normal_bullet` ,
	sp.disbursement_date_pay_date AS `disbursement_date_pay_date` ,
	'' AS `address_province_and_city` ,
	'' AS `village` ,
	sp.maker AS `maker` ,
	sp.model AS `model` ,
	sp.customer_rank AS `rank1`,
	sp.customer_rank AS `rank_update`,
	'No - ຍັງບໍ່ມີບັດ' AS `customer_card`,
	'Not Ringi' AS `ringi_status`,
	sp.remark AS `ringi_comment`
FROM tabsme_Sales_partner sp
WHERE sp.modified >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
	AND sp.customer_name IS NOT NULL 
	AND sp.customer_name != ''
	AND sp.customer_name != '0'
	AND sp.customer_tel IS NOT NULL
	AND sp.customer_tel != ''
	AND sp.customer_rank IS NOT NULL
	AND sp.customer_rank IN ('S','A','B','C')
	AND sp.name NOT IN (SELECT refer_id FROM tabSME_BO_and_Plan WHERE refer_type = 'tabsme_Sales_partner')
;



-- _____________________________________________ 2. Prospect customer from Approach list ________________________________________ 

-- Insert
INSERT INTO tabSME_BO_and_Plan (
	`creation`,
	`owner`,
	`modified_by`,
	`refer_id`,
	`refer_type`,
	`staff_no`,
	`own_salesperson`,
	`customer_name` ,
	`customer_tel` ,
	`type` ,
	`is_sales_partner`,
	`approch_list`,
	`visit_or_not`,
	`usd_loan_amount` ,
	`normal_bullet` ,
	`disbursement_date_pay_date` ,
	`address_province_and_city` ,
	`village` ,
	`maker` ,
	`model` ,
	`rank1`,
	`rank_update`,
	`customer_card`,
	`ringi_status`,
	`ringi_comment`
	)
SELECT 
	apl.modified AS `creation` ,
	apl.modified_by AS `owner`,
	apl.modified_by AS `modified_by`,
	apl.name AS `refer_id`, 
	'tabSME_Approach_list' AS `refer_type`,
	apl.staff_no AS `staff_no` ,
	apl.own_salesperson AS `own_salesperson` ,
	apl.customer_name AS `customer_name` ,
	apl.customer_tel AS `customer_tel` ,
	CASE
		WHEN apl.approach_type = 'Dormant' THEN 'Dor'
		WHEN apl.approach_type = 'Existing' THEN 'Inc'
		ELSE NULL
	END AS `type` ,
	'' AS `is_sales_partner`,
	CASE
		WHEN apl.approach_type = 'Dormant' THEN '⑧HC ລູກຄ້າເກົ່າ - ຜູ້ກູ້'
		WHEN apl.approach_type = 'Existing' THEN '⑨HC ລູກຄ້າປັດຈຸບັນ - ຜູ້ກູ້'
		ELSE NULL
	END AS `approch_list`,
	'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' AS `visit_or_not`,
	apl.usd_loan_amount AS `usd_loan_amount`,
	apl.normal_bullet AS `normal_bullet` ,
	apl.disbursement_date_pay_date AS `disbursement_date_pay_date` ,
	apl.address_province_and_city AS `address_province_and_city` ,
	apl.village AS `village` ,
	apl.maker AS `maker` ,
	apl.model AS `model` ,
	apl.rank_update AS `rank1`,
	apl.rank_update AS `rank_update`,
	apl.customer_card AS `customer_card`,
	apl.ringi_status AS `ringi_status`,
	apl.ringi_comment AS `ringi_comment`
FROM tabSME_Approach_list apl
WHERE apl.modified >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
	AND apl.name NOT IN (SELECT refer_id FROM tabSME_BO_and_Plan WHERE refer_type = 'tabSME_Approach_list')
	AND apl.rank_update IN ('S','A','B','C')
;






/*  -- Not need to do before will make the system have issue 
### Manual update the primary key

-- Step 1: Get the next AUTO_INCREMENT value
SET @next_id = (SELECT MAX(name) + 1 FROM tabSME_BO_and_Plan);

-- Step 2: Construct the ALTER TABLE query
SET @query = CONCAT('ALTER TABLE tabSME_BO_and_Plan AUTO_INCREMENT=', @next_id);

-- Step 3: Prepare and execute the query
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 4: Event to Deallocate the Statement
INSERT INTO sme_bo_and_plan_id_seq 
    SELECT 
        (SELECT MAX(name) + 1 FROM tabSME_BO_and_Plan) AS next_not_cached_value, 
        minimum_value, 
        maximum_value, 
        start_value, 
        increment, 
        cache_size, 
        cycle_option, 
        cycle_count 
    FROM sme_bo_and_plan_id_seq;
*/



-- data key by huaman
SELECT * FROM tabSME_BO_and_Plan WHERE name < 1000000 ORDER BY name DESC;


-- data key sync from someway
SELECT * FROM tabSME_BO_and_Plan WHERE name >= 1000000 ORDER BY name DESC;


















