

-- ______________________________________________________ Satrt Do this every month ______________________________________________________

-- 1) create table temp_sme_Sales_partner
DROP TABLE IF EXISTS `temp_sme_Sales_partner`;


CREATE TABLE `temp_sme_Sales_partner` (
	`contract_no` int(140) NOT NULL AUTO_INCREMENT,
	`creation` datetime(6) DEFAULT NULL COMMENT 'disbursed date on lms',
	`modified` datetime(6) DEFAULT NULL,
	`owner` varchar(140) DEFAULT NULL,
	`current_staff` varchar(140) DEFAULT NULL,
	`owner_staff` varchar(140) DEFAULT NULL,
	`broker_type` varchar(140) DEFAULT NULL,
	`broker_name` varchar(140) DEFAULT NULL,
	`broker_tel` varchar(140) DEFAULT NULL,
	`address_province_and_city` varchar(140) DEFAULT NULL,
	`address_village` varchar(140) DEFAULT NULL,
	`broker_workplace` varchar(140) DEFAULT NULL,
	`business_type` varchar(140) DEFAULT NULL,
	`ever_introduced` varchar(140) DEFAULT NULL,
	`rank` varchar(140) DEFAULT NULL,
	`refer_id` int(11) NOT NULL DEFAULT 0,
	`broker_commission_USD` decimal(20,0) ,
	`refer_type` varchar(255) DEFAULT NULL,
	`contract_type` varchar(140) DEFAULT NULL,
	PRIMARY KEY (`contract_no`),
	KEY `odx_refer_type` (`refer_type`),
	KEY `odx_creation` (`creation`),
	KEY `odx_broker_tel` (`broker_tel`),
	KEY `idx_refer_id` (`refer_id`),
	KEY `idx_contract_type` (`idx_contract_type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;




-- Run on server: lalco 18.140.117.112
-- 2) export from LMS to Frappe on table name temp_sme_Sales_partner as TRUNCATE
select from_unixtime(c.disbursed_datetime, '%Y-%m-%d %H:%m:%s') `creation`, null `modified`, 'Administrator' `owner`, null `current_staff`, 
	upper(case when u2.nickname = 'Mee' then concat(u.staff_no, ' - ', u.nickname) 
		when u2.staff_no is not null then concat(u2.staff_no, ' - ', u2.nickname) else concat(u.staff_no, ' - ', u.nickname)
	end ) `owner_staff`, 
	'SP - ນາຍໜ້າໃນອາດີດ' `broker_type`, 
	convert(cast(convert(concat(b.first_name , " ",b.last_name) using latin1) as binary) using utf8) `broker_name`, 
	case when left (right (REPLACE ( b.contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( b.contact_no, ' ', '') ,8))
			when length (REPLACE ( b.contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( b.contact_no, ' ', ''))
			else CONCAT('9020', right(REPLACE ( b.contact_no, ' ', '') , 8))
	end `broker_tel`,
	concat(left(pr.province_name, locate('-', pr.province_name)-2), ' - ', ci.city_name) `address_province_and_city`, 
	convert(cast(convert(vi.village_name_lao using latin1) as binary) using utf8) `address_village`, null `broker_workplace`, 
	convert(cast(convert(concat(bt.code , " - ",bt.type) using latin1) as binary) using utf8) `business_type`, 'Yes - ເຄີຍແນະນຳມາແລ້ວ' `ever_introduced`, 
	c.contract_no, 
	'' as `rank`, 
	b.id `refer_id`, 
	p.broker_commission 
		/ (case
				p.trading_currency when 'USD' then 1
				when 'LAK' then br.usd2lak
				when 'THB' then br.usd2thb
			end) AS `broker_commission_USD` ,
	'LMS_Broker' `refer_type`,
	CASE
		WHEN p.contract_type = 1 THEN 'SME Car'
		WHEN p.contract_type = 2 THEN 'SME Bike'
		WHEN p.contract_type = 3 THEN 'Car Leasing'
		WHEN p.contract_type = 4 THEN 'Bike Leasing'
		WHEN p.contract_type = 5 THEN 'Real estate'
	END AS `contract_type`
from tblcontract c 
left join tblprospect p on (p.id = c.prospect_id)
left join tblbroker b on (b.id = p.broker_id)
left join tbluser u on (u.id = p.salesperson_id)
left join tbluser u2 on (u2.id = p.broker_acquire_salesperson_id)
left join tblbusinesstype bt on (bt.code = b.business_type)
left join tblprovince pr on (b.address_province = pr.id)
left join tblcity ci on (b.address_city = ci.id)
left join tblvillage vi on (b.address_village_id = vi.id)
LEFT JOIN tblbcelrates br ON (br.currency_date = CURDATE() - INTERVAL 1 DAY)
where c.status in (4,6,7) and p.broker_id <> 0
order by c.contract_no desc;



-- Run on server: frappe 13.250.153.252
-- 3) insert data to tabsme_Sales_partner from temp_sme_Sales_partner

insert into tabsme_Sales_partner 
	(contract_no, creation, modified, owner, current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, rank, refer_id, refer_type)
select contract_no, creation, modified, owner, current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, rank, refer_id, refer_type
from temp_sme_Sales_partner; 




-- 4) Remove duplicate on tabsme_Sales_partner

delete from tabsme_Sales_partner where name in (
select `name` from ( 
		select `name`, row_number() over (partition by `broker_tel`, `refer_type` order by field(`refer_type`, "LMS_Broker", "tabSME_BO_and_Plan", "5way"), 
			field(`broker_type`, "SP - ນາຍໜ້າໃນອາດີດ", "Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "5way - 5ສາຍພົວພັນ"), `name` asc) as row_numbers	
		from tabsme_Sales_partner
	) as t1
where row_numbers > 1 
);


-- 5) Update the next id key
/*
-- 1st method: to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner;
alter table tabsme_Sales_partner auto_increment= 553306 ; -- next id
insert into sme_sales_partner_id_seq select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;
*/

-- 2nd method: 
-- Step 1: Get the next AUTO_INCREMENT value
SET @next_id = (SELECT MAX(name) + 1 FROM tabsme_Sales_partner);

-- Step 2: Construct the ALTER TABLE query
SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);

-- Step 3: Prepare and execute the query
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 4: Event to Deallocate the Statement
INSERT INTO sme_sales_partner_id_seq 
select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_sales_partner_id_seq;


-- 6) __________________________________________________________ update sales partner type __________________________________________________________
select refer_type, broker_type, count(*) from tabsme_Sales_partner group by refer_type, broker_type ;
update tabsme_Sales_partner set refer_type = '5way', broker_type = '5way - 5ສາຍພົວພັນ' where refer_type is null or refer_type = '5way';
update tabsme_Sales_partner set broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ' where refer_type = 'tabSME_BO_and_Plan' and broker_type not in ('Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ'); 
select distinct refer_type, broker_type from tabsme_Sales_partner ;

/*
select * from tabsme_Sales_partner where send_wa = '' or send_wa is null;
update tabsme_Sales_partner set send_wa = 'No-ສົ່ງບໍໄດ້' where send_wa = '' or send_wa is null;
update tabsme_Sales_partner set wa_date = date_format(modified, '%Y-%m-%d') where send_wa != '' and modified >= '2024-07-01' ;
*/



-- 7) Assign person in charge for Sales partner of Resigned employees

-- 7.1 checking
/*
select sp.name `id`, sp.refer_id `lms_broker_id`,
	sme2.staff_no `lms_staff_no`, te2.name `lms_name`,
	sme.staff_no `current_staff_no`, te.name `current_name`,
	sme3.staff_no `modified_staff_no`, te3.name `modified_name`,
	case when sme2.staff_no is not null then te2.name -- Last person who acquired customer from the broker
		when sme.staff_no is not null then te.name -- Current person in charge on Frappe system
		when sme3.staff_no is not null then te3.name -- Last user who modified the sales partner on Frappe
		else sp.current_staff
	end `current_staff`
from tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join tabsme_Employees te on (te.staff_no = SUBSTRING_INDEX(sp.current_staff, ' -', 1) )
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join sme_org sme2 on (SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) = sme2.staff_no)
left join tabsme_Employees te2 on (te2.staff_no = SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) )
left join tabsme_Employees te3 on (te3.email = sp.modified_by)
left join sme_org sme3 on (sme3.staff_no = te3.staff_no)
where sp.refer_type = 'LMS_Broker';
*/


-- Update, if current staff is not resigned
SELECT sp.name, sp.current_staff , sp.owner_staff 
FROM tabsme_Sales_partner sp
LEFT JOIN sme_org sme2 on (SUBSTRING_INDEX(sp.owner_staff, ' -', 1) = sme2.staff_no)
WHERE sme2.id IS NOT NULL AND sme2.retirement_date IS NULL 
	AND SUBSTRING_INDEX(sp.current_staff, ' -', 1) != SUBSTRING_INDEX(sp.owner_staff, ' -', 1)
;



UPDATE tabsme_Sales_partner sp
LEFT JOIN sme_org sme2 on (SUBSTRING_INDEX(sp.owner_staff, ' -', 1) = sme2.staff_no)
SET sp.current_staff = sp.owner_staff 
WHERE sme2.id IS NOT NULL AND sme2.retirement_date IS NULL 
	AND SUBSTRING_INDEX(sp.current_staff, ' -', 1) != SUBSTRING_INDEX(sp.owner_staff, ' -', 1)
;



-- 7.2 update , this will take sometime to complete the query
update tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join tabsme_Employees te on (te.staff_no = SUBSTRING_INDEX(sp.current_staff, ' -', 1) )
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join sme_org sme2 on (SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) = sme2.staff_no)
left join tabsme_Employees te2 on (te2.staff_no = SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) )
left join tabsme_Employees te3 on (te3.email = sp.modified_by)
left join sme_org sme3 on (sme3.staff_no = te3.staff_no)
set sp.current_staff = 
	case when sme2.staff_no is not null then te2.name -- Last person who acquired customer from the broker
		when sme.staff_no is not null then te.name -- Current person in charge on Frappe system
		-- when sme3.staff_no is not null then te3.name -- Last user who modified the sales partner on Frappe
		else sp.current_staff
	end,
	sp.owner_staff = tmspd.owner_staff
where sp.refer_type = 'LMS_Broker'
;




-- 7.3 Update the case which is not active sales to assign again
-- Check how many cases
SELECT sp.name, 
	sp.current_staff AS `latest_staff`, 
	ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num,
	tmspd.creation,
	TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) AS `latest_month`,
	CASE 
		WHEN TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) <= 3 THEN 'UL'
		WHEN TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) <= 12 THEN 'TL'
		WHEN TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) > 12 THEN 'Sales+CC'
		ELSE NULL
	END AS `title_to_assign`
from tabsme_Sales_partner sp 
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
where sp.refer_type = 'LMS_Broker' and sme.id is null;


/*
This query does the following:

1. Calculates the total cases and eligible staff.
2. Prepares temporary tables for staff and cases, assigning row numbers for fair distribution.
3. Distributes cases fairly to staff using a round-robin approach with adjustments for extra cases.
4. Updates the current_staff field in tabsme_Sales_partner with the assigned staff.
5. Cleans up temporary tables.
*/

/*
-- Assign to UL for all the cases 
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM tabsme_Sales_partner sp
		LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
		WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
);

SET @num_staff = (
		SELECT COUNT(*)
		FROM sme_org sme
		LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
		WHERE sme.rank <= 49 
			AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
);

SET @base_cases_per_staff = FLOOR(@total_rows / @num_staff); -- Minimum cases each staff gets
SET @extra_cases = MOD(@total_rows, @num_staff); -- Remaining cases to distribute

-- Step 2: Create a temporary table with row numbers for staff
CREATE TEMPORARY TABLE tmp_staff AS
SELECT te.name AS staff_name, ROW_NUMBER() OVER (ORDER BY sme.id) AS row_num
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
WHERE sme.rank <= 49 
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
SELECT sp.name AS case_name, ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num
FROM tabsme_Sales_partner sp
LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL;

-- Step 4: Assign cases to staff fairly
UPDATE tabsme_Sales_partner sp
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON sp.name = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET sp.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE tmp_staff;
DROP TEMPORARY TABLE tmp_cases;
*/


-- __________________________________________ UL  __________________________________________
-- Assign to UL only the cases that lasted introducion within 3 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM tabsme_Sales_partner sp
	 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
	 	LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
	 	WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
			AND TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) <= 3
);

SET @num_staff = (
		SELECT COUNT(*)
		FROM sme_org sme
		LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
		WHERE sme.rank <= 49 
			AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
);

SET @base_cases_per_staff = FLOOR(@total_rows / @num_staff); -- Minimum cases each staff gets
SET @extra_cases = MOD(@total_rows, @num_staff); -- Remaining cases to distribute

-- Step 2: Create a temporary table with row numbers for staff
CREATE TEMPORARY TABLE tmp_staff AS
SELECT te.name AS staff_name, ROW_NUMBER() OVER (ORDER BY sme.id) AS row_num
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
WHERE sme.rank <= 49 
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
SELECT sp.name AS case_name, ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num
FROM tabsme_Sales_partner sp
LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
	AND TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) <= 3;



-- Step 4: Assign cases to staff fairly
UPDATE tabsme_Sales_partner sp
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON sp.name = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET sp.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE tmp_staff;
DROP TEMPORARY TABLE tmp_cases;


-- __________________________________________ TL  __________________________________________
-- Assign to TL only the cases that lasted introducion between 4 - 12 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM tabsme_Sales_partner sp
	 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
	 	LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
	 	WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
			AND TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) BETWEEN 4 AND 12
);

SET @num_staff = (
		SELECT COUNT(*)
		FROM sme_org sme
		LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
		WHERE sme.rank BETWEEN 50 AND 69
			AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
);

SET @base_cases_per_staff = FLOOR(@total_rows / @num_staff); -- Minimum cases each staff gets
SET @extra_cases = MOD(@total_rows, @num_staff); -- Remaining cases to distribute

-- Step 2: Create a temporary table with row numbers for staff
CREATE TEMPORARY TABLE tmp_staff AS
SELECT te.name AS staff_name, ROW_NUMBER() OVER (ORDER BY sme.id) AS row_num
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
WHERE sme.rank BETWEEN 50 AND 69
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
SELECT sp.name AS case_name, ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num
FROM tabsme_Sales_partner sp
LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
	AND TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) BETWEEN 4 AND 12;



-- Step 4: Assign cases to staff fairly
UPDATE tabsme_Sales_partner sp
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON sp.name = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET sp.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE tmp_staff;
DROP TEMPORARY TABLE tmp_cases;


-- ___________________________________ Sales+CC ___________________________________
-- Assign to Sales+CC only the cases that lasted introducion Over 12 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM tabsme_Sales_partner sp
	 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
	 	LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
	 	WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
			AND TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) > 12
);

SET @num_staff = (
		SELECT COUNT(*)
		FROM sme_org sme
		LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
		WHERE sme.rank >= 70
			AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
);

SET @base_cases_per_staff = FLOOR(@total_rows / @num_staff); -- Minimum cases each staff gets
SET @extra_cases = MOD(@total_rows, @num_staff); -- Remaining cases to distribute

-- Step 2: Create a temporary table with row numbers for staff
CREATE TEMPORARY TABLE tmp_staff AS
SELECT te.name AS staff_name, ROW_NUMBER() OVER (ORDER BY sme.id) AS row_num
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
WHERE sme.rank >= 70
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
SELECT sp.name AS case_name, ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num
FROM tabsme_Sales_partner sp
LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no	from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
WHERE sp.refer_type = 'LMS_Broker' AND sme.id IS NULL
	AND TIMESTAMPDIFF(MONTH, tmspd.creation, CURRENT_DATE()) > 12 ;



-- Step 4: Assign cases to staff fairly
UPDATE tabsme_Sales_partner sp
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON sp.name = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET sp.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE tmp_staff;
DROP TEMPORARY TABLE tmp_cases;


-- ___________________________________ End ___________________________________



-- 8) Prepare table temp_sme_pbx_sp, run this query on frappe server 13.250.153.252
delete from temp_sme_pbx_SP

replace into temp_sme_pbx_SP
select sp.name `id`, 
	sp.broker_tel, 
	null `pbx_status`, 
	null `date`, 
	sp.current_staff 
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
where sme.`unit_no` is not null;


-- if do in the midle of the month, we not need to remove all the data
select sp.name `id`, 
	sp.broker_tel, 
	sp.current_staff 
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
where sme.`unit_no` is not null;




-- 9) Check the number of introduce of Sales partner





-- 
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND refer_id = 8814
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
	group by
		refer_id


-- 10) To filter and fix owner_staff data so that only valid entries (e.g., containing both numbers and text) are retained or updated, you can use SQL conditions to identify and update rows where owner_staff contains only numbers.
select name, current_staff, owner_staff from tabsme_Sales_partner WHERE owner_staff REGEXP '^[0-9]+$';


-- 10.1) Update owner_staff, if current = owner
update tabsme_Sales_partner
set owner_staff = current_staff
WHERE owner_staff REGEXP '^[0-9]+$' 
	AND owner_staff = LEFT(current_staff, locate(' ', current_staff)-1)	;


-- 10.2) Update owner_staff, if owner = Staff_no in table tabsme_Employees
update tabsme_Sales_partner sp inner join tabsme_Employees te on (sp.owner_staff = te.staff_no)
set sp.owner_staff = te.name 
WHERE sp.owner_staff REGEXP '^[0-9]+$' ;



-- ______________________________________________________ End Do this every month ______________________________________________________













-- SP export to google sheet https://docs.google.com/spreadsheets/d/17coswPI_uF-E3aEXbqMpQD_en1FDKUFX95zXluT3dhs/edit#gid=564749378
-- SME_SP
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.credit, sp.rank_of_credit, sp.credit_remark, ts.pbx_status `LCC check`, 
	sp.relationship,
	sp.business_type, 
	(case when sp.currency = 'USD' then 1 when sp.currency = 'THB' then 1/35.10 when sp.currency = 'LAK' then 1/23480.00 end) * sp.amount `USD_amount`,
	case when left(sp.`rank`, locate(' -', sp.`rank`)-1) in ('X') then 'Contracted'
	when left(sp.`rank`, locate(' -', sp.`rank`)-1) in ('S', 'A', 'B', 'C') then 'SABC' else 'no' 
end `introduce status`,
	sp.send_wa, sp.wa_date, 
	case when sp.send_wa != '' and sp.wa_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') then 'Sent' else 'x' end `wa_send_status`,
	case when sp.modified >= DATE_FORMAT(CURDATE(), '%Y-%m-01')  then 'called' else 'x' end `call_ status`,
	timestampdiff(month,creation, now()) as `month_introduce`,
	shr.shr_prospect AS `shr_prospect`,
	shr.shr_will_contract AS `shr_will_contract`, 
	shr.shr_contracted AS `shr_contracted`
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
left join temp_sme_pbx_SP ts on (ts.id = sp.name)
LEFT JOIN (SELECT broker_tel, 
				SUM(CASE 
					WHEN COALESCE(contract_status, '') NOT IN ('Active', 'Closed', 'Refinance') 
					AND (DATE(disbursed_date) < CURRENT_DATE() OR disbursed_date IS NULL) 
					THEN 1 ELSE 0 
				END) AS `shr_prospect`,
				SUM(CASE 
					WHEN COALESCE(contract_status, '') NOT IN ('Active', 'Closed', 'Refinance') 
					AND DATE(disbursed_date) >= CURRENT_DATE() 
					THEN 1 ELSE 0 
				END) AS `shr_will_contract`,
				SUM(CASE 
					WHEN COALESCE(contract_status, '') IN ('Active', 'Closed', 'Refinance') 
					THEN 1 ELSE 0 
				END) AS `shr_contracted`
			FROM sme_hc_result 
			WHERE broker_tel IS NOT NULL 
			GROUP BY broker_tel) shr ON (sp.broker_tel = shr.broker_tel)
where sp.refer_type = 'LMS_Broker' 
order by sme.id ;




-- XYZ export to google sheet https://docs.google.com/spreadsheets/d/19IsoiG6JyB1CNodTyDLvLeb7HUM3CYnqHOs7XhjNErE/edit#gid=990597291
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.currency, sp.amount,
	ts.pbx_status `LCC check`
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'tabSME_BO_and_Plan' and sme.`unit_no` is not null -- if resigned staff no need
order by sme.id ;


-- 5way export to google sheet https://docs.google.com/spreadsheets/d/15wAmhxB0gDAHDwa6WSmY-PqPvAm6eOoIP5YKp48wTi4/edit#gid=722440269
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.currency, sp.amount,
	ts.pbx_status `LCC check`,
	sp.business_type
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.broker_type = '5way - 5ສາຍພົວພັນ' and sp.owner_staff = sp.current_staff and sme.`unit_no` is not null -- if resigned staff no need
order by sme.id ;



## _____________________________________________ Check the number of introduce _____________________________________________

-- 1) Sales partner
SELECT 
	sp.name AS `id`, 
	sp.refer_id AS `lms_broker_id` , 
	sp.broker_name ,
	sp.broker_tel ,
	sp.current_staff, 
	sme.staff_no, 
	sp.owner_staff `sp_owner_staff`, 
	tmspd.owner_staff `tmspd_owner_staff`,
	CASE
		WHEN sme2.id IS NOT NULL AND sme2.retirement_date IS NULL THEN 'Current'
		ELSE 'Resigned'
	END AS `is_owner`,
	tmsp.no_of_introduces AS `all_introduces`, 
	tmsp.broker_commission_USD AS `all_commission_USD`, 
	tmspin3.no_of_introduces AS `In_3months_introduces`,
	tmspin3.broker_commission_USD AS `In_3months_commission_USD`, 
	tmspout3.no_of_introduces AS `Out_3months_introduces`,
	tmspout3.broker_commission_USD AS `Out_3months_commission_USD`, 
	tmsp1.no_of_introduces AS `This_month_introduces`,
	tmsp1.broker_commission_USD AS `This_month_commission_USD`, 
	tmsp2.no_of_introduces AS `Last_month_introduces`,
	tmsp2.broker_commission_USD AS `Last_month_commission_USD`, 
	tmsp3.no_of_introduces AS `2months_before_introduces`,
	tmsp3.broker_commission_USD AS `2months_before_commission_USD`, 
	tmsp1year.no_of_introduces AS `This_year_introduces`,
	tmsp1year.broker_commission_USD AS `This_year_commission_USD`, 
	tmsp2years.no_of_introduces AS `Last_year_introduces`,
	tmsp2years.broker_commission_USD AS `Last_year_commission_USD`, 
	tmsp_before2years.no_of_introduces AS `Before_last_year_introduces`,
	tmsp_before2years.broker_commission_USD AS `Before_last_year_commission_USD`, 
	case 
		when tmspin3.no_of_introduces >= 10 then 'Diamond'
		when tmspin3.no_of_introduces >= 6 then 'Gold'
		when tmspin3.no_of_introduces >= 3 then 'Silver'
		when tmspin3.no_of_introduces >= 0 then 'Normal'
		else 'Normal'
	end `intro_rankings_3months`,
	case 
		when tmspin3.no_of_introduces >= 10 then '4%'
		when tmspin3.no_of_introduces >= 6 then '3.8%'
		when tmspin3.no_of_introduces >= 3 then '3.36%'
		when tmspin3.no_of_introduces >= 0 then '3.5%'
		else '3.5%'
	end `commission_rate_should_be`
from tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
LEFT JOIN sme_org sme2 on (SUBSTRING_INDEX(sp.owner_staff, ' -', 1) = sme2.staff_no)
left join temp_sme_Sales_partner tmspd on
	tmspd.contract_no = (
		select
			contract_no
		from temp_sme_Sales_partner
		where refer_id = sp.refer_id
		order by creation desc
		limit 1 )
-- all introduces count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
	group by 
		refer_id) tmsp on 
	sp.refer_id = tmsp.refer_id
-- wihtin 3 months introduces count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
	group by
		refer_id) tmspin3 on
	sp.refer_id = tmspin3.refer_id
-- wihtout 3 months introduces count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') < DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
	group by
		refer_id) tmspout3 on
	sp.refer_id = tmspout3.refer_id
-- This month introduces introduce count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)), INTERVAL 1 DAY)
	group by
		refer_id) tmsp1 on
	sp.refer_id = tmsp1.refer_id
-- Last month introduces introduce count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
	group by
		refer_id) tmsp2 on
	sp.refer_id = tmsp2.refer_id
-- 2 months before introduces introduce count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
	group by
		refer_id) tmsp3 on
	sp.refer_id = tmsp3.refer_id
-- This Year introduces introduce count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_FORMAT(CURDATE(), '%Y-01-01')
	group by
		refer_id) tmsp1year on
	sp.refer_id = tmsp1year.refer_id
-- Last Year introduces introduce count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN 
						DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- AS first_date_last_year,
						AND DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') -- AS last_date_last_year
	group by
		refer_id) tmsp2years on
	sp.refer_id = tmsp2years.refer_id
-- Before  Last year introduces introduce count are below:
left join (
	select
		refer_id,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- All Before last year
	group by
		refer_id) tmsp_before2years on
	sp.refer_id = tmsp_before2years.refer_id
where sp.refer_type = 'LMS_Broker'
;



-- 2) X, take much time to export
SELECT 
	sp.name AS `id`, 
	sp.refer_id AS `lms_broker_id` , 
	sp.broker_name ,
	sp.broker_tel ,
	tmsp.no_of_introduces AS `all_introduces`, 
	tmsp.broker_commission_USD AS `all_commission_USD`, 
	tmspin3.no_of_introduces AS `In_3months_introduces`,
	tmspin3.broker_commission_USD AS `In_3months_commission_USD`, 
	tmspout3.no_of_introduces AS `Out_3months_introduces`,
	tmspout3.broker_commission_USD AS `Out_3months_commission_USD`, 
	tmsp1.no_of_introduces AS `This_month_introduces`,
	tmsp1.broker_commission_USD AS `This_month_commission_USD`, 
	tmsp2.no_of_introduces AS `Last_month_introduces`,
	tmsp2.broker_commission_USD AS `Last_month_commission_USD`, 
	tmsp3.no_of_introduces AS `2months_before_introduces`,
	tmsp3.broker_commission_USD AS `2months_before_commission_USD`, 
	tmsp1year.no_of_introduces AS `This_year_introduces`,
	tmsp1year.broker_commission_USD AS `This_year_commission_USD`, 
	tmsp2years.no_of_introduces AS `Last_year_introduces`,
	tmsp2years.broker_commission_USD AS `Last_year_commission_USD`, 
	tmsp_before2years.no_of_introduces AS `Before_last_year_introduces`,
	tmsp_before2years.broker_commission_USD AS `Before_last_year_commission_USD`, 
	case when tmsp3.no_of_introduces >= 10 then 'Diamond'
		when tmsp3.no_of_introduces >= 6 then 'Gold'
		when tmsp3.no_of_introduces >= 3 then 'Silver'
		when tmsp3.no_of_introduces >= 0 then 'Normal'
		else 'Normal'
	end `intro_rankings_3months`,
	case when tmsp3.no_of_introduces >= 10 then '4%'
		when tmsp3.no_of_introduces >= 6 then '3.8%'
		when tmsp3.no_of_introduces >= 3 then '3.36%'
		when tmsp3.no_of_introduces >= 0 then '3.5%'
		else '3.5%'
	end `commission_rate_should_be`,
	sp.current_staff, 
	sme.staff_no, 
	sp.owner_staff `sp_owner_staff`, 
	tmspd.owner_staff `tmspd_owner_staff`,
	CASE
		WHEN sme2.id IS NOT NULL AND sme2.retirement_date IS NULL THEN 'Current'
		ELSE 'Resigned'
	END AS `is_owner`
FROM tabsme_Sales_partner sp
INNER JOIN sme_org sme ON (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
LEFT JOIN sme_org sme2 ON (SUBSTRING_INDEX(sp.owner_staff, ' -', 1) = sme2.staff_no)
LEFT JOIN temp_sme_Sales_partner tmspd on
	tmspd.contract_no = (
		select
			contract_no
		from temp_sme_Sales_partner
		where broker_tel = sp.broker_tel
		order by creation desc
		limit 1 )
-- all introduces count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
	group by 
		broker_tel) tmsp on 
	sp.broker_tel = tmsp.broker_tel
-- wihtin 3 months introduces count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
	group by
		broker_tel) tmspin3 on
	sp.broker_tel = tmspin3.broker_tel
-- wihtout 3 months introduces count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') < DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
	group by
		broker_tel) tmspout3 on
	sp.broker_tel = tmspout3.broker_tel
-- This month introduces introduce count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)), INTERVAL 1 DAY)
	group by
		broker_tel) tmsp1 on
	sp.broker_tel = tmsp1.broker_tel
-- Last month introduces introduce count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
	group by
		broker_tel) tmsp2 on
	sp.broker_tel = tmsp2.broker_tel
-- 2 months before introduces introduce count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
	group by
		broker_tel) tmsp3 on
	sp.broker_tel = tmsp3.broker_tel
-- This Year introduces introduce count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_FORMAT(CURDATE(), '%Y-01-01')
	group by
		broker_tel) tmsp1year on
	sp.broker_tel = tmsp1year.broker_tel
-- Last Year introduces introduce count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN 
						DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- AS first_date_last_year,
						AND DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') -- AS last_date_last_year
	group by
		broker_tel) tmsp2years on
	sp.broker_tel = tmsp2years.broker_tel
-- Before  Last year introduces introduce count are below:
left join (
	select
		broker_tel,
		count(*) as `no_of_introduces`,
		SUM(broker_commission_USD) AS `broker_commission_USD`
	from
		temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
		AND DATE_FORMAT(creation, '%Y-%m-%d') < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- All Before last year
	group by
		broker_tel) tmsp_before2years on
	sp.broker_tel = tmsp_before2years.broker_tel
WHERE 
	sp.refer_type = 'tabSME_BO_and_Plan'
	AND sp.broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
	AND sp.current_staff = sp.owner_staff
;





-- 2) X take much time to export
SELECT 
	sp.name AS `id`, 
	sp.refer_id AS `lms_broker_id`, 
	sp.broker_name,
	sp.broker_tel,
	tmsp_combined.total_introduces AS `all_introduces`, 
	tmsp_combined.total_commission_USD AS `all_commission_USD`, 
	tmsp_combined.in_3months_introduces AS `In_3months_introduces`,
	tmsp_combined.in_3months_commission_USD AS `In_3months_commission_USD`, 
	tmsp_combined.out_3months_introduces AS `Out_3months_introduces`,
	tmsp_combined.out_3months_commission_USD AS `Out_3months_commission_USD`, 
	tmsp_combined.this_month_introduces AS `This_month_introduces`,
	tmsp_combined.this_month_commission_USD AS `This_month_commission_USD`, 
	tmsp_combined.last_month_introduces AS `Last_month_introduces`,
	tmsp_combined.last_month_commission_USD AS `Last_month_commission_USD`, 
	tmsp_combined.two_months_before_introduces AS `2months_before_introduces`,
	tmsp_combined.two_months_before_commission_USD AS `2months_before_commission_USD`, 
	tmsp_combined.this_year_introduces AS `This_year_introduces`,
	tmsp_combined.this_year_commission_USD AS `This_year_commission_USD`, 
	tmsp_combined.last_year_introduces AS `Last_year_introduces`,
	tmsp_combined.last_year_commission_USD AS `Last_year_commission_USD`, 
	tmsp_combined.before_last_year_introduces AS `Before_last_year_introduces`,
	tmsp_combined.before_last_year_commission_USD AS `Before_last_year_commission_USD`, 
	CASE 
		WHEN tmsp_combined.two_months_before_introduces >= 10 THEN 'Diamond'
		WHEN tmsp_combined.two_months_before_introduces >= 6 THEN 'Gold'
		WHEN tmsp_combined.two_months_before_introduces >= 3 THEN 'Silver'
		WHEN tmsp_combined.two_months_before_introduces >= 0 THEN 'Normal'
		ELSE 'Normal'
	END AS `intro_rankings_3months`,
	CASE 
		WHEN tmsp_combined.two_months_before_introduces >= 10 THEN '4%'
		WHEN tmsp_combined.two_months_before_introduces >= 6 THEN '3.8%'
		WHEN tmsp_combined.two_months_before_introduces >= 3 THEN '3.36%'
		WHEN tmsp_combined.two_months_before_introduces >= 0 THEN '3.5%'
		ELSE '3.5%'
	END AS `commission_rate_should_be`,
	sp.current_staff, 
	sme.staff_no, 
	sp.owner_staff AS `sp_owner_staff`, 
	tmspd.owner_staff AS `tmspd_owner_staff`,
	CASE
		WHEN sme2.id IS NOT NULL AND sme2.retirement_date IS NULL THEN 'Current'
		ELSE 'Resigned'
	END AS `is_owner`
FROM tabsme_Sales_partner sp
INNER JOIN sme_org sme 
	ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
LEFT JOIN sme_org sme2 
	ON SUBSTRING_INDEX(sp.owner_staff, ' -', 1) = sme2.staff_no
LEFT JOIN temp_sme_Sales_partner tmspd 
	ON tmspd.contract_no = (
		SELECT contract_no
		FROM temp_sme_Sales_partner
		WHERE broker_tel = sp.broker_tel
		ORDER BY creation DESC
		LIMIT 1
	)
LEFT JOIN (
	-- Merged subquery for all time periods
	SELECT
		broker_tel,
	-- all introduces count are below:
		COUNT(*) AS total_introduces,
		SUM(broker_commission_USD) AS total_commission_USD,
	-- wihtin 3 months introduces count are below:
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
				THEN 1
				ELSE 0
			END) AS in_3months_introduces,
		SUM(CASE WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
				THEN broker_commission_USD 
				ELSE 0 
			END) AS in_3months_commission_USD,
	-- wihtout 3 months introduces count are below:
		SUM(CASE
				WHEN creation < DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) 
				THEN 1
				ELSE 0
			END) AS out_3months_introduces,
		SUM(CASE
				WHEN creation < DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) 
				THEN broker_commission_USD
				ELSE 0
			END) AS out_3months_commission_USD,
	-- This month introduces introduce count are below:
		SUM(
			CASE 
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)), INTERVAL 1 DAY) 
				THEN 1 
				ELSE 0 
			END) AS this_month_introduces,
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)), INTERVAL 1 DAY) 
				THEN broker_commission_USD
				ELSE 0
			END) AS this_month_commission_USD,
	-- Last month introduces introduce count are below:
		SUM(CASE 
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
				THEN 1 
				ELSE 0 
			END) AS last_month_introduces,
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
				THEN broker_commission_USD
				ELSE 0
			END) AS last_month_commission_USD,
	-- 2 months before introduces introduce count are below:
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
				THEN 1
				ELSE 0
			END) AS two_months_before_introduces,
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
					AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
				THEN broker_commission_USD
				ELSE 0
			END) AS two_months_before_commission_USD,
	-- This Year introduces introduce count are below:
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_FORMAT(CURDATE(), '%Y-01-01')
				THEN 1
				ELSE 0
			END) AS this_year_introduces,
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_FORMAT(CURDATE(), '%Y-01-01') 
				THEN broker_commission_USD
				ELSE 0
			END) AS this_year_commission_USD,
	-- Last Year introduces introduce count are below:
		SUM(CASE 
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN 
						DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- AS first_date_last_year,
					AND DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') -- AS last_date_last_year
				THEN 1 
				ELSE 0 
			END) AS last_year_introduces,
		SUM(CASE 
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN 
						DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- AS first_date_last_year,
					AND DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') -- AS last_date_last_year
				THEN broker_commission_USD 
				ELSE 0 
			END) AS last_year_commission_USD,
	-- Before  Last year introduces introduce count are below:
		SUM(CASE
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- All Before last year
				THEN 1
				ELSE 0
			END) AS before_last_year_introduces,
		SUM(CASE 
				WHEN DATE_FORMAT(creation, '%Y-%m-%d') < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- All Before last year
				THEN broker_commission_USD 
				ELSE 0 
			END) AS before_last_year_commission_USD
	FROM temp_sme_Sales_partner
	WHERE contract_type = 'SME Car'
	GROUP BY broker_tel
) tmsp_combined 
ON sp.broker_tel = tmsp_combined.broker_tel
WHERE 
	sp.refer_type = 'tabSME_BO_and_Plan'
	AND sp.broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
	AND sp.current_staff = sp.owner_staff
;



-- 2) X 
SELECT 
	sp.name AS `id`, 
	sp.refer_id AS `lms_broker_id` , 
	sp.broker_name ,
	sp.broker_tel ,
	sp.current_staff, 
	sme.staff_no, 
	sp.owner_staff `sp_owner_staff`, 
	tmspd.owner_staff `tmspd_owner_staff`,
	CASE
		WHEN sme2.id IS NOT NULL AND sme2.retirement_date IS NULL THEN 'Current'
		ELSE 'Resigned'
	END AS `is_owner`
from tabsme_Sales_partner sp
INNER JOIN sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
LEFT JOIN sme_org sme2 on (SUBSTRING_INDEX(sp.owner_staff, ' -', 1) = sme2.staff_no)
left join temp_sme_Sales_partner tmspd on
	tmspd.contract_no = (
		select
			contract_no
		from temp_sme_Sales_partner
		where refer_id = sp.refer_id
		order by creation desc
		limit 1 )
WHERE 
	sp.refer_type = 'tabSME_BO_and_Plan'
	AND sp.broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
	AND sp.current_staff = sp.owner_staff
;



-- 2.1 SP contracted result
SELECT
	refer_id,
	broker_tel,
 -- all introduces count are below:
	COUNT(*) AS total_introduces,
	SUM(broker_commission_USD) AS total_commission_USD,
 -- wihtin 3 months introduces count are below:
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
			THEN 1
			ELSE 0
		END) AS in_3months_introduces,
	SUM(CASE WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
			THEN broker_commission_USD 
			ELSE 0 
		END) AS in_3months_commission_USD,
 -- wihtout 3 months introduces count are below:
	SUM(CASE
			WHEN creation < DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) 
			THEN 1
			ELSE 0
		END) AS out_3months_introduces,
	SUM(CASE
			WHEN creation < DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) 
			THEN broker_commission_USD
			ELSE 0
		END) AS out_3months_commission_USD,
 -- This month introduces introduce count are below:
	SUM(
		CASE 
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)), INTERVAL 1 DAY) 
			THEN 1 
			ELSE 0 
		END) AS this_month_introduces,
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)), INTERVAL 1 DAY) 
			THEN broker_commission_USD
			ELSE 0
		END) AS this_month_commission_USD,
 -- Last month introduces introduce count are below:
	SUM(CASE 
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
				AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
			THEN 1 
			ELSE 0 
		END) AS last_month_introduces,
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
				AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
			THEN broker_commission_USD
			ELSE 0
		END) AS last_month_commission_USD,
 -- 2 months before introduces introduce count are below:
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
				AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
			THEN 1
			ELSE 0
		END) AS two_months_before_introduces,
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY)
				AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
			THEN broker_commission_USD
			ELSE 0
		END) AS two_months_before_commission_USD,
 -- This Year introduces introduce count are below:
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_FORMAT(CURDATE(), '%Y-01-01')
			THEN 1
			ELSE 0
		END) AS this_year_introduces,
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') >= DATE_FORMAT(CURDATE(), '%Y-01-01') 
			THEN broker_commission_USD
			ELSE 0
		END) AS this_year_commission_USD,
 -- Last Year introduces introduce count are below:
	SUM(CASE 
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN 
					DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- AS first_date_last_year,
				AND DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') -- AS last_date_last_year
			THEN 1 
			ELSE 0 
		END) AS last_year_introduces,
	SUM(CASE 
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') BETWEEN 
					DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- AS first_date_last_year,
				AND DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-12-31') -- AS last_date_last_year
			THEN broker_commission_USD 
			ELSE 0 
		END) AS last_year_commission_USD,
 -- Before  Last year introduces introduce count are below:
	SUM(CASE
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- All Before last year
			THEN 1
			ELSE 0
		END) AS before_last_year_introduces,
	SUM(CASE 
			WHEN DATE_FORMAT(creation, '%Y-%m-%d') < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-01-01') -- All Before last year
			THEN broker_commission_USD 
			ELSE 0 
		END) AS before_last_year_commission_USD
FROM temp_sme_Sales_partner
WHERE contract_type = 'SME Car'
GROUP BY broker_tel
;







show index from temp_sme_Sales_partner;
show index from tabsme_Sales_partner;



SELECT COUNT(*) 
FROM tabsme_Sales_partner sp
INNER JOIN sme_org sme ON (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
WHERE 
	sp.refer_type = 'tabSME_BO_and_Plan'
	AND sp.broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
	AND sp.current_staff = sp.owner_staff
;





-- Update HC

SELECT DISTINCT refer_type, broker_type FROM tabsme_Sales_partner

SELECT sp.name , sp.modified , sp.wa_date , sp.send_wa 
from tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
WHERE sme.id is not null
-- 	AND sp.name = 50
-- AND sme.staff_no IN (4440, 4509, 1925, 4720, 1709, 4027, 2672, 4704, 4177, 3699, 168, 4141, 430, 843, 3542, 590, 1291, 3373, 544, 2565, 558, 1459, 3196, 2984, 2845, 3637, 387, 1730, 1319, 3767, 2359, 1817, 2543, 2081, 1395, 2291, 1590, 2424, 1513, 1338, 1227, 2855, 1868, 1054)
	AND sp.wa_date is null
	AND sp.refer_type = 'tabSME_BO_and_Plan'


UPDATE tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
SET sp.modified = NOW(), sp.wa_date = CURRENT_DATE() , sp.send_wa = 'Yes-ສົ່ງໄດ້'
WHERE sme.id is not null
-- AND sme.staff_no IN (4440, 4509, 1925, 4720, 1709, 4027, 2672, 4704, 4177, 3699, 168, 4141, 430, 843, 3542, 590, 1291, 3373, 544, 2565, 558, 1459, 3196, 2984, 2845, 3637, 387, 1730, 1319, 3767, 2359, 1817, 2543, 2081, 1395, 2291, 1590, 2424, 1513, 1338, 1227, 2855, 1868, 1054)
	AND sp.wa_date < '2025-03-01'
	AND sp.refer_type = 'tabSME_BO_and_Plan'














