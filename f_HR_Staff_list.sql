
-- make auto increment number for col name
ALTER TABLE tabHR_Staff_list MODIFY COLUMN name bigint(20) AUTO_INCREMENT NOT NULL;

-- check and create index 
SHOW INDEX FROM tabHR_Staff_list;

CREATE INDEX idx_staff_no ON tabHR_Staff_list (staff_no);


-- 1) Export this data to tabHR_SME_Address
-- Run in lalco server 18.140.117.112
select 
	CONCAT(
		left(pr.province_name, locate('-', pr.province_name)-2),
		' - ',
		ci.city_name,
		' - ',
		vi.village_name,
		' - ',
		vi.pvd_id
	) AS `name`,
	pr.id AS `province_id`, 
	left(pr.province_name, locate('-', pr.province_name)-2) AS `province_name_en`,
	replace(convert(cast(convert(pr.province_name using latin1) as binary) using utf8), left(pr.province_name, locate('-', pr.province_name)+1), '') AS `province_name_lo`, 
	ci.id AS `city_id`, 
	ci.city_name AS `city_name_en`,
	convert(cast(convert(ci.city_name_lao using latin1) as binary) using utf8) AS `city_name_lo`,
	vi.id AS `village_id`, 
	vi.village_name AS `village_name_en`, 
	convert(cast(convert(vi.village_name_lao using latin1) as binary) using utf8) AS `village_name_lo`,
	vi.pvd_id , 
	pr.bol_province_id , 
	ci.bol_city_id , 
	vi.bol_village_id 
from tblprovince pr left join tblcity ci on (ci.province_id = pr.id)
left join tblvillage vi on (vi.city_id = ci.id)
order by pr.id, ci.id, vi.id;



-- 2) Check
SELECT name, pvd_id FROM tabHR_SME_Address ;


-- 3) 
SELECT * FROM tabHR_Staff_list ;



-- 4. Update the primary ID 
-- Step 1: Get the next AUTO_INCREMENT value
SET @next_id = (SELECT MAX(name) + 1 FROM tabHR_Staff_list);

-- Step 2: Construct the ALTER TABLE query
SET @query = CONCAT('ALTER TABLE tabHR_Staff_list AUTO_INCREMENT=', @next_id);

-- Step 3: Prepare and execute the query
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 4: Event to Deallocate the Statement
INSERT INTO hr_staff_list_id_seq 
select (select max(name)+1 `next_not_cached_value` from tabHR_Staff_list), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from hr_staff_list_id_seq;




select * from tabsme_Employees where staff_no = '1003'


-- ____________________________________

SELECT * 
FROM tabHR_Staff_list stl
WHERE stl.staff_no = '1003'


ALTER TABLE tabHR_Staff_list
CHANGE COLUMN birth_province birth_province_and_city_and_village_text VARCHAR(255);


ALTER TABLE tabHR_Staff_list
DROP COLUMN birth_city,
DROP COLUMN birth_village;


ALTER TABLE tabHR_Staff_list
CHANGE COLUMN live_province live_province_and_city_and_village_text VARCHAR(255);


ALTER TABLE tabHR_Staff_list
DROP COLUMN live_city,
DROP COLUMN live_village;


UPDATE tabHR_Staff_list
SET gender = 'Male'
WHERE gender = 'M'


UPDATE tabHR_Staff_list
SET gender = 'Female'
WHERE gender = 'F'

UPDATE tabHR_Staff_list
SET cv_file = NULL
WHERE staff_no != '1003'


ALTER TABLE tabHR_Staff_list
CHANGE COLUMN cv cv_file text;
ALTER TABLE tabHR_Staff_list
CHANGE COLUMN contract contract_file text;
ALTER TABLE tabHR_Staff_list
CHANGE COLUMN guarantee guarantee_file text;



-- Export All Satff list
SELECT 
	CASE 
		WHEN stl.photo = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.photo, '/private', ''))
	END AS `staff_photo`,
	stl.staff_no, 
	CASE
		WHEN sme.id IS NOT NULL THEN sme.staff_name
		ELSE UPPER(stl.nickname) 
	END AS `staff_name`,
	CASE 
		WHEN sme.affiliation IS NOT NULL THEN sme.affiliation
		WHEN te.branch = 'Head Office' THEN 'HO'
		WHEN stl.branch = 'Head Office' THEN 'HO'
		ELSE 'BR'
	END AS `HO_BR`,
	CASE WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'HO' THEN 'Head Office'
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'BR' THEN sme.sec_branch
		WHEN sme.unit IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN te.branch 
		ELSE stl.branch 
	END AS `branch_name`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales'
		ELSE 'Non-Sales'
	END AS `is_sales`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales' 
		ELSE stl.department 
	END AS `department`,
	CASE 
		WHEN sme.unit IS NOT NULL THEN sme.unit
		ELSE stl.unit
	END `unit`,
	stl.`position` ,
	LEFT(stl.gender, 1) AS `gender`,
	stl.first_name_en,
	stl.last_name_en ,
	stl.first_name_lo,
	stl.last_name_lo ,
	stl.main_contact_no,
	stl.date_of_birth ,
	stl.hire_date,
	stl.graduated_from_school_en,
	stl.company_name AS `previous_work`,
	CASE 
		WHEN sme.retirement_date IS NOT NULL THEN 'Resigned'
		WHEN stl.status = 'Resigned' THEN 'Resigned'
		WHEN stl.status = 'Active' THEN 'Active'
		ELSE te.staff_status
	END AS `staff_status`,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.retirement_date
		ELSE te.date_resigned
	END AS `retirement_date`,
	stl.approach_type,
	stl.acquire_by,
	CASE 
		WHEN stl.cv_file = '' THEN 'No'
		WHEN stl.cv_file IS NULL THEN 'No'
		ELSE 'Yes'
	END AS `has_cv_file`,
	CASE 
		WHEN stl.cv_file = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.cv_file, '/private', ''))
	END AS `cv_file`,
	CASE 
		WHEN stl.contract_file = '' THEN 'No'
		WHEN stl.contract_file IS NULL THEN 'No'
		ELSE 'Yes'
	END AS `has_contract_file`,
	CASE 
		WHEN stl.contract_file = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.contract_file, '/private', ''))
	END AS `contract_file`,
	CASE 
		WHEN stl.guarantee_file = '' THEN 'No'
		WHEN stl.guarantee_file IS NULL THEN 'No'
		ELSE 'Yes'
	END AS `has_guarantee_file`,
	CASE 
		WHEN stl.guarantee_file = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.guarantee_file, '/private', ''))
	END AS `guarantee_file`,
	CONCAT('http://13.250.153.252:8000/app/hr_staff_list/', stl.name) `Edit`
FROM tabHR_Staff_list stl
LEFT JOIN tabsme_Employees te ON (te.staff_no = stl.staff_no)
LEFT JOIN sme_org sme ON (sme.staff_no = stl.staff_no)
WHERE stl.staff_no != '' 
	AND stl.staff_no IS NOT NULL
	-- AND stl.status = 'Active'
ORDER BY CAST(stl.staff_no AS UNSIGNED) ASC
;





-- Export Active Satff list
SELECT 
	CASE 
		WHEN stl.photo = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.photo, '/private', ''))
	END AS `staff_photo`,
	stl.staff_no, 
	CASE
		WHEN sme.id IS NOT NULL THEN sme.staff_name
		ELSE UPPER(stl.nickname) 
	END AS `staff_name`,
	CASE 
		WHEN sme.affiliation IS NOT NULL THEN sme.affiliation
		WHEN te.branch = 'Head Office' THEN 'HO'
		WHEN stl.branch = 'Head Office' THEN 'HO'
		ELSE 'BR'
	END AS `HO_BR`,
	CASE WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'HO' THEN 'Head Office'
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'BR' THEN sme.sec_branch
		WHEN sme.unit IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN te.branch 
		ELSE stl.branch 
	END AS `branch_name`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales'
		ELSE 'Non-Sales'
	END AS `is_sales`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales' 
		ELSE stl.department 
	END AS `department`,
	CASE 
		WHEN sme.unit IS NOT NULL THEN sme.unit
		ELSE stl.unit
	END `unit`,
	stl.`position` ,
	LEFT(stl.gender, 1) AS `gender`,
	stl.first_name_en,
	stl.last_name_en ,
	stl.first_name_lo,
	stl.last_name_lo ,
	stl.main_contact_no,
	stl.date_of_birth ,
	stl.hire_date,
	stl.graduated_from_school_en,
	stl.company_name AS `previous_work`,
	CASE 
		WHEN sme.retirement_date IS NOT NULL THEN 'Resigned'
		WHEN stl.status = 'Resigned' THEN 'Resigned'
		WHEN stl.status = 'Active' THEN 'Active'
		ELSE te.staff_status
	END AS `staff_status`,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.retirement_date
		ELSE te.date_resigned
	END AS `retirement_date`,
	stl.approach_type,
	stl.acquire_by,
	CASE 
		WHEN stl.cv_file = '' THEN 'No'
		WHEN stl.cv_file IS NULL THEN 'No'
		ELSE 'Yes'
	END AS `has_cv_file`,
	CASE 
		WHEN stl.cv_file = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.cv_file, '/private', ''))
	END AS `cv_file`,
	CASE 
		WHEN stl.contract_file = '' THEN 'No'
		WHEN stl.contract_file IS NULL THEN 'No'
		ELSE 'Yes'
	END AS `has_contract_file`,
	CASE 
		WHEN stl.contract_file = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.contract_file, '/private', ''))
	END AS `contract_file`,
	CASE 
		WHEN stl.guarantee_file = '' THEN 'No'
		WHEN stl.guarantee_file IS NULL THEN 'No'
		ELSE 'Yes'
	END AS `has_guarantee_file`,
	CASE 
		WHEN stl.guarantee_file = '' THEN NULL
		ELSE CONCAT('http://13.250.153.252:8000', REPLACE(stl.guarantee_file, '/private', ''))
	END AS `guarantee_file`,
	CONCAT('http://13.250.153.252:8000/app/hr_staff_list/', stl.name) `Edit`
FROM tabHR_Staff_list stl
LEFT JOIN tabsme_Employees te ON (te.staff_no = stl.staff_no)
LEFT JOIN sme_org sme ON (sme.staff_no = stl.staff_no)
WHERE stl.staff_no != '' 
	AND stl.staff_no IS NOT NULL
	-- AND stl.status = 'Active'
ORDER BY CAST(stl.staff_no AS UNSIGNED) ASC
;





update tabHR_Staff_list 
	set main_contact_no = 
	case when main_contact_no = '' then ''
		when (length (regexp_replace(main_contact_no , '[^[:digit:]]', '')) = 11 and left (regexp_replace(main_contact_no , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(main_contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(main_contact_no , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(main_contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(main_contact_no , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(main_contact_no , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(main_contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(main_contact_no , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(main_contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(main_contact_no , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(main_contact_no , '[^[:digit:]]', '')) = 7 and left (regexp_replace(main_contact_no , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(main_contact_no , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(main_contact_no , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(main_contact_no , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(main_contact_no , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(main_contact_no , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(main_contact_no , '[^[:digit:]]', ''),8))
	end
;




-- 1. Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabHR_Staff_list);
    
    -- Step 2: Update the auto_increment value for tabHR_Staff_list
    SET @alter_query = CONCAT('ALTER TABLE tabHR_Staff_list AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into hr_staff_list_id_seq
	insert into hr_staff_list_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabHR_Staff_list), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from hr_staff_list_id_seq
;


-- ALTER TABLE tabHR_Staff_Status_Log AUTO_INCREMENT = 1;
-- 2. Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabHR_Staff_Status_Log);
    
    -- Step 2: Update the auto_increment value for tabHR_Staff_Status_Log
    SET @alter_query = CONCAT('ALTER TABLE tabHR_Staff_Status_Log AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into hr_staff_status_log_id_seq
	insert into hr_staff_status_log_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabHR_Staff_Status_Log), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from hr_staff_status_log_id_seq
;



-- ALTER TABLE tabHR_Staff_Department_Position_History AUTO_INCREMENT = 1;
-- 3. Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabHR_Staff_Department_Position_History);
    
    -- Step 2: Update the auto_increment value for tabHR_Staff_Department_Position_History
    SET @alter_query = CONCAT('ALTER TABLE tabHR_Staff_Department_Position_History AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into hr_staff_department_position_history_id_seq
	insert into hr_staff_department_position_history_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabHR_Staff_Department_Position_History), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from hr_staff_department_position_history_id_seq
;




select * from tabHR_Staff_Department_Position_History thsdph 
where staff_no = 5399




SELECT name, staff_no, approach_type, details_of_approach, previous_staff_no, acquire_by
FROM tabHR_Staff_list
WHERE staff_no = 1003




SELECT 
	CONVERT(staff_no, UNSIGNED) AS `staff_no`,
	name,
	staff_status
FROM tabsme_Employees 
ORDER BY CONVERT(staff_no, UNSIGNED) ASC
;




















