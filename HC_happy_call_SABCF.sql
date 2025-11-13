

-- Create table 
CREATE TABLE `temp_sme_pbx_BO` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`customer_tel` varchar(255) DEFAULT NULL,
	`pbx_status` varchar(255) DEFAULT NULL,
	`date` datetime DEFAULT NULL,
	`current_staff` varchar(255) DEFAULT NULL,
	`type` varchar(255) DEFAULT NULL,
	`month_type` int(11) DEFAULT NULL COMMENT '3=3 months or less, 6=6months or less, 9=9months or less, 12=12months or less',
	`usd_loan_amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
	`is_own` VARCHAR(255) DEFAULT NULL
	PRIMARY KEY (`id`),
	KEY idx_current_staff (current_staff),
	KEY idx_type (type),
	KEY idx_month_type (month_type),
	KEY idx_usd_loan_amount (usd_loan_amount),
	KEY idx_is_own (is_own)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



-- __________________________________________ Prepare new Month __________________________________________
-- 1) check and delete the customer who doesnn't like LALCO
select * from tabSME_BO_and_Plan where reason_of_credit = '18 ບໍ່ມັກ LALCO';
delete from tabSME_BO_and_Plan where reason_of_credit = '18 ບໍ່ມັກ LALCO';
delete from tabSME_BO_and_Plan_bk where reason_of_credit = '18 ບໍ່ມັກ LALCO';


-- 2) SABC update the list for next month
TRUNCATE temp_sme_pbx_BO ;


-- 3) insert and replace SABC rank from tabSME_BO_and_Plan to temp_sme_pbx_BO
SELECT * FROM temp_sme_pbx_BO;

replace into temp_sme_pbx_BO
select 
	bp.name `id`, 
	bp.customer_tel, 
	null `pbx_status`, 
	null `date`, 
	bp.staff_no `current_staff`, 
	case 
		when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update 
		else bp.rank1 
	end `type`, 
	case 
		when timestampdiff(month, bp.creation, date(now())) > 36 then 36 
		else timestampdiff(month, bp.creation, date(now())) 
	end `month_type`,
	bp.usd_loan_amount,
	case when sme.dept is null then 'Resigned' 
		when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`
from tabSME_BO_and_Plan bp 
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme2.staff_no)
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted');




-- 4) insert and replace F rank from tabSME_BO_and_Plan to temp_sme_pbx_BO
replace into temp_sme_pbx_BO
select 
	bp.name `id`, 
	bp.customer_tel, 
	null `pbx_status`, 
	null `date`, 
	bp.staff_no `current_staff`, 
	case 
		when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update 
		else bp.rank1 
	end `type`, 
	case 
		when timestampdiff(month, bp.creation, date(now())) > 36 then 36 
		else timestampdiff(month, bp.creation, date(now())) 
	end `month_type`,
	bp.usd_loan_amount,
	case when sme.dept is null then 'Resigned' 
		when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`
from tabSME_BO_and_Plan bp 
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme2.staff_no)
where ( (bp.rank1 in ('F') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('F') )
	and bp.name not in (select id from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted')
;


-- 5) insert and replace G rank from tabSME_BO_and_Plan to temp_sme_pbx_BO
replace into temp_sme_pbx_BO
select 
	bp.name `id`, 
	bp.customer_tel, 
	null `pbx_status`, 
	null `date`, 
	bp.staff_no `current_staff`, 
	'G' `type`, 
	case 
		when timestampdiff(month, bp.creation, date(now())) > 36 then 36 
		else timestampdiff(month, bp.creation, date(now())) 
	end `month_type`,
	bp.usd_loan_amount,
	case when sme.dept is null then 'Resigned' 
		when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`
from tabSME_BO_and_Plan bp 
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme2.staff_no)
where bp.contract_status != 'Contracted' and bp.address_province_and_city != '' 
	and (bp.contract_status != 'Contracted' and bp.rank_update in ('G ຕ່າງແຂວງ') )
;




-- UL >= 10,000
-- TL >= 5,000
-- Sales < 5,000

-- 6. Allocation the cases based on condition https://docs.google.com/spreadsheets/d/1K_5l_CWaIlt_tR45hhvoV1nSfPmc8BlX9RZfSpdOzr4/edit?gid=1905202920#gid=1905202920

-- __________________________________________ UL  __________________________________________
-- Assign to UL only the cases that lasted introducion within 3 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM temp_sme_pbx_BO tb
	 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(tb.current_staff, ' -', 1) = sme.staff_no
		WHERE `type` IN ('S', 'A', 'B', 'C')
			AND tb.usd_loan_amount >= 5000
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
		AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
;

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
	SELECT 
		tb.id AS case_name, 
		ROW_NUMBER() OVER (ORDER BY tb.id) AS row_num
	FROM temp_sme_pbx_BO tb
 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(tb.current_staff, ' -', 1) = sme.staff_no
	WHERE `type` IN ('S', 'A', 'B', 'C')
		AND tb.usd_loan_amount >= 5000
;


-- Step 4: Assign cases to staff fairly
UPDATE temp_sme_pbx_BO tb
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON tb.id = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET tb.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE IF EXISTS tmp_staff;
DROP TEMPORARY TABLE IF EXISTS tmp_cases;




-- __________________________________________ TL  __________________________________________
-- Assign to UL only the cases that lasted introducion within 3 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM temp_sme_pbx_BO tb
	 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(tb.current_staff, ' -', 1) = sme.staff_no
		WHERE `type` IN ('S', 'A', 'B', 'C')
			AND tb.usd_loan_amount >0 AND tb.usd_loan_amount < 5000
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
		AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
;

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
	SELECT 
		tb.id AS case_name, 
		ROW_NUMBER() OVER (ORDER BY tb.id) AS row_num
	FROM temp_sme_pbx_BO tb
 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(tb.current_staff, ' -', 1) = sme.staff_no
	WHERE `type` IN ('S', 'A', 'B', 'C')
		AND tb.usd_loan_amount >0 AND tb.usd_loan_amount < 5000
;


-- Step 4: Assign cases to staff fairly
UPDATE temp_sme_pbx_BO tb
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON tb.id = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET tb.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE IF EXISTS tmp_staff;
DROP TEMPORARY TABLE IF EXISTS tmp_cases;




-- __________________________________________ Sales  __________________________________________
-- Assign to UL only the cases that lasted introducion within 3 months
-- Step 1: Calculate total rows and fair distribution
SET @total_rows = (
		SELECT COUNT(*)
		FROM temp_sme_pbx_BO tb
	 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(tb.current_staff, ' -', 1) = sme.staff_no
		WHERE `type` IN ('S', 'A', 'B', 'C')
			AND tb.usd_loan_amount = 0
);

SET @num_staff = (
		SELECT COUNT(*)
		FROM sme_org sme
		LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
		WHERE sme.rank BETWEEN 70 AND 79
			AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
);

SET @base_cases_per_staff = FLOOR(@total_rows / @num_staff); -- Minimum cases each staff gets
SET @extra_cases = MOD(@total_rows, @num_staff); -- Remaining cases to distribute

-- Step 2: Create a temporary table with row numbers for staff
CREATE TEMPORARY TABLE tmp_staff AS
	SELECT te.name AS staff_name, ROW_NUMBER() OVER (ORDER BY sme.id) AS row_num
	FROM sme_org sme
	LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
	WHERE sme.rank BETWEEN 70 AND 79
		AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
;

-- Step 3: Create a temporary table with row numbers for cases
CREATE TEMPORARY TABLE tmp_cases AS
	SELECT 
		tb.id AS case_name, 
		ROW_NUMBER() OVER (ORDER BY tb.id) AS row_num
	FROM temp_sme_pbx_BO tb
 	LEFT JOIN sme_org sme ON SUBSTRING_INDEX(tb.current_staff, ' -', 1) = sme.staff_no
	WHERE `type` IN ('S', 'A', 'B', 'C')
		AND tb.usd_loan_amount = 0
;


-- Step 4: Assign cases to staff fairly
UPDATE temp_sme_pbx_BO tb
JOIN (
		SELECT c.case_name, 
					 CASE
							 WHEN MOD(c.row_num - 1, @num_staff) + 1 <= @extra_cases THEN 
									 MOD(c.row_num - 1, @num_staff) + 1
							 ELSE
									 MOD(c.row_num - 1, @num_staff) + 1
					 END AS staff_row
		FROM tmp_cases c
) case_assign ON tb.id = case_assign.case_name
JOIN tmp_staff s ON case_assign.staff_row = s.row_num
SET tb.current_staff = s.staff_name;

-- Step 5: Clean up temporary tables
DROP TEMPORARY TABLE IF EXISTS tmp_staff;
DROP TEMPORARY TABLE IF EXISTS tmp_cases;









-- 8) Import the current staff to temp_sme_pbx_BO
-- Need to please ON DUPLICATE UPDATE


-- 9) Update the current staff to tabSME_BO_and_Plan
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff ;

-- 10)
select * from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C');



-- SABC 1 Year
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.name as `id`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	sme.staff_no as `Staff No`, 
	sme.staff_name as `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.normal_bullet ,
	bp.customer_name ,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) as `Edit`,
	tb.`type` AS `rank_beginning`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
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
	case when sme.dept is null then 'Resigned' when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`,
	bp.own_salesperson
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
left join sme_org sme on (case when locate(' ', tb.current_staff) = 0 then tb.current_staff else left(tb.current_staff, locate(' ', tb.current_staff)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme2.staff_no)
where bp.name in (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type <= 12)
order by sme.id asc;



-- SABC Over 1 Year
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.name as `id`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	sme.staff_no as `Staff No`, 
	sme.staff_name as `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.normal_bullet ,
	bp.customer_name ,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) as `Edit`,
	tb.`type` AS `rank_beginning`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
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
	case when sme.dept is null then 'Resigned' when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`,
	bp.own_salesperson
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
left join sme_org sme on (case when locate(' ', tb.current_staff) = 0 then tb.current_staff else left(tb.current_staff, locate(' ', tb.current_staff)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme2.staff_no)
where bp.name in (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type > 12)
order by sme.id asc;



SELECT *
FROM temp_sme_pbx_BO tb
LEFT JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = tb.id)
WHERE tspbsm.management_type IN ('SABC 1year Over$10,000', 'SABC 1year Over$5,000', 'SABC Over 1year Over$10,000', 'SABC Over 1year Over$5,000')
;


UPDATE temp_sme_pbx_BO tb
LEFT JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = tb.id)
SET tb.current_staff = tspbsm.current_staff
WHERE tspbsm.management_type IN ('SABC 1year Over$10,000', 'SABC 1year Over$5,000', 'SABC Over 1year Over$10,000', 'SABC Over 1year Over$5,000')
;


UPDATE temp_sme_pbx_BO tb
SET tb.current_staff = NULL















