

ALTER TABLE `_8abac9eed59bf169`.tabHR_Staff_list MODIFY COLUMN name bigint(20) auto_increment NOT NULL;



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














