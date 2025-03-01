

-- ______________________________________________________ Satrt Do this every month ______________________________________________________

-- 1) create table temp_sme_Sales_partner
CREATE TABLE `temp_sme_Sales_partner` (
	`contract_no` int(140) NOT NULL AUTO_INCREMENT,
	`creation` datetime(6) DEFAULT NULL,
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
	`refer_type` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`contract_no`),
	KEY idx_creation (creation),
	KEY idx_refer_id (refer_id),
	KEY idx_refer_type (refer_type)
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
	convert(cast(convert(concat(bt.code , " - ",bt.type) using latin1) as binary) using utf8) `business_type`, 'Yes - ເຄີຍແນະນຳມາແລ້ວ' `ever_introduced`, c.contract_no, '' as `rank`, b.id `refer_id`, 'LMS_Broker' `refer_type`,
	CASE p.contract_type WHEN 1 THEN 'SME Car' WHEN 2 THEN 'SME Bike' WHEN 3 THEN 'Car Leasing' WHEN 4 THEN 'Bike Leasing' when 5 then 'Real estate' END `contract_type`
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblbroker b on (b.id = p.broker_id)
left join tbluser u on (u.id = p.salesperson_id)
left join tbluser u2 on (u2.id = p.broker_acquire_salesperson_id)
left join tblbusinesstype bt on (bt.code = b.business_type)
left join tblprovince pr on (b.address_province = pr.id)
left join tblcity ci on (b.address_city = ci.id)
left join tblvillage vi on (b.address_village_id = vi.id)
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
SET @next_id = (SELECT MAX(id) + 1 FROM tabsme_Sales_partner);

-- Step 2: Construct the ALTER TABLE query
SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);

-- Step 3: Prepare and execute the query
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


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
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join sme_org sme2 on (SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) = sme2.staff_no)
left join tabsme_Employees te2 on (te2.staff_no = SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) )
left join tabsme_Employees te3 on (te3.email = sp.modified_by)
left join sme_org sme3 on (sme3.staff_no = te3.staff_no)
where sp.refer_type = 'LMS_Broker';
*/

-- 7.2 update , this will take sometime to complete the query
update tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join tabsme_Employees te on (te.staff_no = SUBSTRING_INDEX(sp.current_staff, ' -', 1) )
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join sme_org sme2 on (SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) = sme2.staff_no)
left join tabsme_Employees te2 on (te2.staff_no = SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) )
left join tabsme_Employees te3 on (te3.email = sp.modified_by)
left join sme_org sme3 on (sme3.staff_no = te3.staff_no)
set sp.current_staff = 
	case when sme2.staff_no is not null then te2.name -- Last person who acquired customer from the broker
		when sme.staff_no is not null then te.name -- Current person in charge on Frappe system
		when sme3.staff_no is not null then te3.name -- Last user who modified the sales partner on Frappe
		else sp.current_staff
	end,
	sp.owner_staff = tmspd.owner_staff
where sp.refer_type = 'LMS_Broker';




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
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
where sp.refer_type = 'LMS_Broker' and sme.id is null;


/*
This query does the following:

1. Calculates the total cases and eligible staff.
2. Prepares temporary tables for staff and cases, assigning row numbers for fair distribution.
3. Distributes cases fairly to staff using a round-robin approach with adjustments for extra cases.
4. Updates the current_staff field in tabsme_Sales_partner with the assigned staff.
5. Cleans up temporary tables.
*/

-- __________________________________________ UL
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


-- __________________________________________ TL
-- Assign to UL only the cases that lasted introducion within 3 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
    SELECT COUNT(*)
    FROM tabsme_Sales_partner sp
   	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
   	LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
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
LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
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


-- __________________________________________ Sales+CC
-- Assign to TL only the cases that lasted introducion between 4 - 12 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
    SELECT COUNT(*)
    FROM tabsme_Sales_partner sp
   	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
   	LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
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
LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
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


-- ___________________________________
-- Assign to Sales+CC only the cases that lasted introducion Over 12 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
    SELECT COUNT(*)
    FROM tabsme_Sales_partner sp
   	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
   	LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
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
LEFT JOIN temp_sme_Sales_partner tmspd ON tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
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






-- 8) Prepare table temp_sme_pbx_sp, run this query on frappe server 13.250.153.252
delete from temp_sme_pbx_SP

replace into temp_sme_pbx_SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff 
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
where sme.`unit_no` is not null;




-- 9) Check the number of introduce
select sp.name `id`, sp.refer_id `lms_broker_id` , tmsp.no_of_introduces `all_introduces`, tmsp3.no_of_introduces `3months_introduces`,
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
	sp.current_staff, sme.staff_no, sp.owner_staff `sp_owner_staff`, tmspd.owner_staff `tmspd_owner_staff`
from tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join (select refer_id, count(*) as `no_of_introduces` from temp_sme_Sales_partner group by refer_id) tmsp on sp.refer_id = tmsp.refer_id
left join (select refer_id, count(*) as `no_of_introduces` from temp_sme_Sales_partner where creation > DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) group by refer_id) tmsp3 on sp.refer_id = tmsp3.refer_id
where sp.refer_type = 'LMS_Broker';



-- 10) To filter and fix owner_staff data so that only valid entries (e.g., containing both numbers and text) are retained or updated, you can use SQL conditions to identify and update rows where owner_staff contains only numbers.
select name, current_staff, owner_staff from tabsme_Sales_partner WHERE owner_staff REGEXP '^[0-9]+$';


-- 10.1) Update owner_staff, if current = owner
update tabsme_Sales_partner
set owner_staff = current_staff
WHERE owner_staff REGEXP '^[0-9]+$' and owner_staff = left(current_staff, locate(' ', current_staff)-1)  ;


-- 10.2) Update owner_staff, if owner = Staff_no in table tabsme_Employees
update tabsme_Sales_partner sp inner join tabsme_Employees te on (sp.owner_staff = te.staff_no)
set sp.owner_staff = te.name 
WHERE sp.owner_staff REGEXP '^[0-9]+$' ;



-- ______________________________________________________ End Do this every month ______________________________________________________



-- ______________________________________________________ update resigned employee ______________________________________________________

-- export from tblsme_employee and import to tabsme_sales_partner
select from_unixtime(ep.creation, '%Y-%m-%d %H:%m:%s') `creation`, null `modified`, 'Administrator' `owner`, null `current_staff`, 
	null as `owner_staff`, 
	CONCAT(UCASE(LEFT(ep.staff_status, 1)), LCASE(SUBSTRING(ep.staff_status, 2))," - Staff") as `broker_type`, 
	CONCAT(ep.name," (" ,ep.first_name_lo," ", ep.last_name_lo, " - ", ep.first_name_en," ",ep.last_name_en,")") as `broker_name`, 
	case when left (right (REPLACE ( ep.main_contact, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( ep.main_contact, ' ', '') ,8))
	    when length (REPLACE ( ep.main_contact, ' ', '')) = 7 then CONCAT('9030',REPLACE ( ep.main_contact, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( ep.main_contact, ' ', '') , 8))
	end `broker_tel`,
	null as `address_province_and_city`, 
	null as `address_village`, null `broker_workplace`, 
	null as `business_type`, 
	null as `ever_introduced`, 
	null as `contract_no`, '' as `rank`, ep.staff_no `refer_id`, 'staff' `refer_type`
FROM tabsme_Employees ep
 WHERE ep.staff_status  is not null

-- remove duplicate 
delete from tabsme_Sales_partner where name in (
select `name` from ( 
		select `name`, 
			row_number() over (partition by `broker_tel` ORDER by broker_tel desc, broker_type ASC, refer_id desc) as row_numbers  
		from tabsme_Sales_partner where `refer_type` = 'staff'
	) as t1
where row_numbers > 1 
);


-- Step 1: Get the next AUTO_INCREMENT value
SET @next_id = (SELECT MAX(id) + 1 FROM tabsme_Sales_partner);

-- Step 2: Construct the ALTER TABLE query
SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);

-- Step 3: Prepare and execute the query
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 7.2 update
update tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join tabsme_Employees te on (te.staff_no = SUBSTRING_INDEX(sp.current_staff, ' -', 1) )
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join sme_org sme2 on (SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) = sme2.staff_no)
left join tabsme_Employees te2 on (te2.staff_no = SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) )
left join tabsme_Employees te3 on (te3.email = sp.modified_by)
left join sme_org sme3 on (sme3.staff_no = te3.staff_no)
set sp.current_staff = 
	case when sme2.staff_no is not null then te2.name -- Last person who acquired customer from the broker
		when sme.staff_no is not null then te.name -- Current person in charge on Frappe system
		when sme3.staff_no is not null then te3.name -- Last user who modified the sales partner on Frappe
		else sp.current_staff
	end,
	sp.owner_staff = tmspd.owner_staff
where sp.broker_type = 'Resigned - Staff';


-- 7.3 Update the case which is not active sales to assign again
-- Check how many cases
SELECT sp.name, sp.current_staff, ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num
from tabsme_Sales_partner sp 
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
where sp.broker_type = 'Resigned - Staff' and sme.id is null;

/*
This query does the following:

1. Calculates the total cases and eligible staff.
2. Prepares temporary tables for staff and cases, assigning row numbers for fair distribution.
3. Distributes cases fairly to staff using a round-robin approach with adjustments for extra cases.
4. Updates the current_staff field in tabsme_Sales_partner with the assigned staff.
5. Cleans up temporary tables.
*/


-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
    SELECT COUNT(*)
    FROM tabsme_Sales_partner sp
    LEFT JOIN sme_org sme ON SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no
    WHERE sp.broker_type = 'Resigned - Staff' AND sme.id IS NULL
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
WHERE sp.broker_type = 'Resigned - Staff' AND sme.id IS NULL;

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




-- 8) Prepare table temp_sme_pbx_sp, run this query on frappe server 13.250.153.252
delete from temp_sme_pbx_SP

replace into temp_sme_pbx_SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff 
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
where sme.`unit_no` is not null;


SELECT * FROM tabsme_Sales_partner sp
WHERE sp.broker_type = 'Resigned - Staff'
and current_staff is not null


-- Export for sales follow






-- form for import data from csv to frappe 
select current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, contract_no, `rank`, refer_id  
from tabsme_Sales_partner 

-- add column
alter table tabsme_Sales_partner add column refer_id int(11) not null default 0;


-- to make your form can add new record after you import data by cvs
alter table tabsme_Sales_partner auto_increment=94768; -- next id
insert into sme_sales_partner_id_seq select 94768, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_sales_partner_id_seq;

update tabsme_Sales_partner set modified = date(now()); -- creation = date(now()),


-- export to google sheet
select sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no, sme.staff_name, sp.broker_type, sp.broker_name, sp.`rank`, sp.date_for_introduction, sp.customer_name,
	sp.modified `date_update`, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`, sp.name `id`
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = 'SP -  ນາຍໜ້າໃນອາດີດ';


-- temp update current_staff
create table temp_sme_sales_partner (
	id int(11) not null auto_increment,
	current_staff varchar(255) ,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;



-- update contact_no
update tabsme_Sales_partner set broker_tel = 
	case when broker_tel = '' then ''
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
	end
;


-- SP export to google sheet https://docs.google.com/spreadsheets/d/17coswPI_uF-E3aEXbqMpQD_en1FDKUFX95zXluT3dhs/edit#gid=564749378
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.credit, sp.rank_of_credit, sp.credit_remark, ts.pbx_status `LCC check`, 
	case when sp.modified < date(now()) then '-' else left(sp.`rank`, locate(' ',sp.`rank`)-1) end `rank of call today`,
	sp.business_type
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'LMS_Broker' order by sme.id ;


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


-- export to check pbx
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp inner join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = '5way - 5ສາຍພົວພັນ' and sp.owner_staff = sp.current_staff 
	and sp.name not in (select refer_id from tabsme_Sales_partner where refer_type = '5way - 5ສາຍພົວພັນ')
order by sme.id ;

-- _____________________________________________________________ update current staff for tabsme_Sales_partner _____________________________________________________________
-- export current data
select name `id`, current_staff , refer_id 
from tabsme_Sales_partner where broker_type = 'SP - ນາຍໜ້າໃນອາດີດ';

-- update 
update tabsme_Sales_partner sp inner join temp_sme_pbx_SP tsp on (sp.name = tsp.id)
set sp.current_staff = tsp.current_staff where  sp.broker_type = 'SP - ນາຍໜ້າໃນອາດີດ';


-- _____________________________________________________________ update Sales partner _____________________________________________________________
-- SP
update tabsme_Sales_partner set broker_type = 'SP - ນາຍໜ້າໃນອາດີດ', refer_type = 'LMS_Broker' where name between 1 and 5677;

-- 5way
update tabsme_Sales_partner set broker_type = '5way - 5ສາຍພົວພັນ', refer_type = '5way' where name between 5678 and 94767;



-- check
select * from temp_sme_pbx_SP ; -- 43,283

select sp.name, sp.current_staff, ts.current_staff from tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.current_staff != ts.current_staff ;

-- update 
update tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
set ts.current_staff = sp.current_staff;

-- export to check pbx SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'LMS_Broker' -- SP
	or (sp.refer_type = 'tabSME_BO_and_Plan' and sme.`unit_no` is not null) -- XYZ
	or (sp.refer_type = '5way' and sp.owner_staff = sp.current_staff and sme.`unit_no` is not null) -- 5way
order by sme.id ;










