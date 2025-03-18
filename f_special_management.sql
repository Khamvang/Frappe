

# YadSing list

SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management ;
SELECT * FROM temp_sme_pbx_BO_special_management ;

TRUNCATE TABLE temp_sme_pbx_BO_special_management;


-- 1. Existing for Yadsing
INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	CASE 
		WHEN sme.unit_no = 15 THEN '1868 - KEE'
		WHEN sme.unit_no = 21 THEN '806 - HONG'
		WHEN sme.unit_no = 24 THEN '3846 - SOUK'
		WHEN sme.unit_no = 26 THEN '1925 - SINH'
		WHEN sme.unit_no = 32 THEN '2081 - THA'
		WHEN sme.unit_no = 37 THEN '3196 - KHOUN'
		WHEN sme.unit_no = 43 THEN '1374 - MIK'
		WHEN sme.unit_no = 47 THEN '590 - BOU'
		WHEN sme.unit_no = 49 THEN '2529 - SENG'
		WHEN sme.unit_no = 51 THEN '1291 - FERN'
		WHEN sme.unit_no = 54 THEN '1395 - DITH'
		WHEN sme.unit_no = 59 THEN '3626 - PHOUN'
		WHEN sme.unit_no = 63 THEN '946 - TAY'
		WHEN sme.unit_no = 65 THEN '168 - LING'
		WHEN sme.unit_no = 22 THEN '1227 - ON'
		WHEN sme.unit_no = 27 THEN '430 - TOUN'
		WHEN sme.unit_no = 28 THEN '1332 - MOCK'
		WHEN sme.unit_no = 29 THEN '544 - PA'
		WHEN sme.unit_no = 33 THEN '4440 - LING'
		WHEN sme.unit_no = 41 THEN '577 - PHOUT'
		WHEN sme.unit_no = 55 THEN '4720 - NAR2'
	END AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') then apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 then 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.`usd_loan_amount`,
	'Existing-Yadsing' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
	AND sme.unit_no in (15, 21, 24, 26, 32, 37, 43, 47, 49, 51, 54, 59, 63, 65, 22, 27, 28, 29, 33, 41, 55)
;


-- 2. DOrmant for Yadsing
INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	apl.name as `bp_name`, 
	apl.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	CASE 
		WHEN sme.unit_no = 15 THEN '1868 - KEE'
		WHEN sme.unit_no = 21 THEN '806 - HONG'
		WHEN sme.unit_no = 24 THEN '3846 - SOUK'
		WHEN sme.unit_no = 26 THEN '1925 - SINH'
		WHEN sme.unit_no = 32 THEN '2081 - THA'
		WHEN sme.unit_no = 37 THEN '3196 - KHOUN'
		WHEN sme.unit_no = 43 THEN '1374 - MIK'
		WHEN sme.unit_no = 47 THEN '590 - BOU'
		WHEN sme.unit_no = 49 THEN '2529 - SENG'
		WHEN sme.unit_no = 51 THEN '1291 - FERN'
		WHEN sme.unit_no = 54 THEN '1395 - DITH'
		WHEN sme.unit_no = 59 THEN '3626 - PHOUN'
		WHEN sme.unit_no = 63 THEN '946 - TAY'
		WHEN sme.unit_no = 65 THEN '168 - LING'
		WHEN sme.unit_no = 22 THEN '1227 - ON'
		WHEN sme.unit_no = 27 THEN '430 - TOUN'
		WHEN sme.unit_no = 28 THEN '1332 - MOCK'
		WHEN sme.unit_no = 29 THEN '544 - PA'
		WHEN sme.unit_no = 33 THEN '4440 - LING'
		WHEN sme.unit_no = 41 THEN '577 - PHOUT'
		WHEN sme.unit_no = 55 THEN '4720 - NAR2'
	END AS `current_staff`, 
	CASE 
		WHEN apl.rank_update in ('S', 'A', 'B', 'C') then apl.rank_update 
		ELSE apl.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, apl.creation, date(now())) > 36 then 36 
		ELSE timestampdiff(month, apl.creation, date(now())) 
	END `month_type`,
	apl.`usd_loan_amount`,
	'Dormant-Yadsing' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
	AND sme.unit_no in (15, 21, 24, 26, 32, 37, 43, 47, 49, 51, 54, 59, 63, 65, 22, 27, 28, 29, 33, 41, 55)
;


-- 3. SABC for Yadsing
INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	bp.name as `bp_name`, 
	bp.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	CASE 
		WHEN sme.unit_no = 15 THEN '1868 - KEE'
		WHEN sme.unit_no = 21 THEN '806 - HONG'
		WHEN sme.unit_no = 24 THEN '3846 - SOUK'
		WHEN sme.unit_no = 26 THEN '1925 - SINH'
		WHEN sme.unit_no = 32 THEN '2081 - THA'
		WHEN sme.unit_no = 37 THEN '3196 - KHOUN'
		WHEN sme.unit_no = 43 THEN '1374 - MIK'
		WHEN sme.unit_no = 47 THEN '590 - BOU'
		WHEN sme.unit_no = 49 THEN '2529 - SENG'
		WHEN sme.unit_no = 51 THEN '1291 - FERN'
		WHEN sme.unit_no = 54 THEN '1395 - DITH'
		WHEN sme.unit_no = 59 THEN '3626 - PHOUN'
		WHEN sme.unit_no = 63 THEN '946 - TAY'
		WHEN sme.unit_no = 65 THEN '168 - LING'
		WHEN sme.unit_no = 22 THEN '1227 - ON'
		WHEN sme.unit_no = 27 THEN '430 - TOUN'
		WHEN sme.unit_no = 28 THEN '1332 - MOCK'
		WHEN sme.unit_no = 29 THEN '544 - PA'
		WHEN sme.unit_no = 33 THEN '4440 - LING'
		WHEN sme.unit_no = 41 THEN '577 - PHOUT'
		WHEN sme.unit_no = 55 THEN '4720 - NAR2'
	END AS `current_staff`, 
	CASE 
		WHEN bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update 
		ELSE bp.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, bp.creation, date(now())) > 36 then 36 
		ELSE timestampdiff(month, bp.creation, date(now())) 
	END `month_type`,
	bp.`usd_loan_amount`,
	'SABC_1year-Yadsing' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_BO_and_Plan bp 
LEFT JOIN sme_org sme on (SUBSTRING_INDEX(bp.staff_no, ' -', 1) = sme.staff_no )
INNER JOIN temp_sme_pbx_BO tb on (tb.id = bp.name)
WHERE bp.name IN (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type <= 12)
	AND sme.unit_no IN (15, 21, 24, 26, 32, 37, 43, 47, 49, 51, 54, 59, 63, 65, 22, 27, 28, 29, 33, 41, 55)
;


-- export SABC_1year-Yadsing
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
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-31')  then 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC_1year-Yadsing')
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- ______________________ 2nd HC ________________________
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management;
SELECT * FROM temp_sme_pbx_BO_special_management WHERE management_type IN ('Existing-HC2', 'Dormant-HC2');

-- 1. Existing for 2HC
DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'Existing-HC2';

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
	apl.`usd_loan_amount`,
	'Existing-HC2' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
;


-- 2. Dormant for 2HC
DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'Dormant-HC2';

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
	apl.`usd_loan_amount`,
	'Dormant-HC2' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
;


-- 3. Export to assign 
SELECT id,bp_name, current_staff, management_type FROM temp_sme_pbx_BO_special_management WHERE management_type IN ('Existing-HC2');
SELECT id, bp_name, current_staff, management_type FROM temp_sme_pbx_BO_special_management WHERE management_type IN ('Dormant-HC2');





SELECT 
	sp.name `id`, 
	date_format(sp.modified, '%Y-%m-%d') `date_update`, 
	sme.`dept`, 
	sme.`sec_branch`, 
	sme.`unit_no`, 
	sme.unit, 
	sme.staff_no `staff_no` , 
	sme.staff_name, 
	sp.owner_staff 'owner',
	sp.broker_name ,
	sp.`4_approaches` 
FROM tabsme_Sales_partner sp
LEFT JOIN sme_org sme ON
	(case when locate(' ', sp.current_staff) = 0 then sp.current_staff
		else left(sp.current_staff, locate(' ', sp.current_staff)-1)
	end = sme.staff_no)
WHERE sp.`4_approaches` != '';


-- ______________________ Special negotiate for the sales plan from next week ________________________

-- 3. SABC for Yadsing
INSERT INTO temp_sme_pbx_BO_special_management
SELECT 
	NULL AS `id`,
	bp.name as `bp_name`, 
	bp.customer_tel, 
	NULL AS `pbx_status`, 
	NULL AS `date`, 
	bp.staff_no AS `current_staff`, 
	CASE 
		WHEN bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update 
		ELSE bp.rank1 
	END `type`, 
	CASE WHEN timestampdiff(month, bp.creation, date(now())) > 36 then 36 
		ELSE timestampdiff(month, bp.creation, date(now())) 
	END `month_type`,
	bp.`usd_loan_amount`,
	'Next week plan + SABC this month' as `management_type`,
	NULL AS `datetime_create`
FROM
    tabSME_BO_and_Plan bp
LEFT JOIN
    sme_org sme ON (CASE
        WHEN LOCATE(' ', bp.staff_no) = 0 THEN bp.staff_no
        ELSE LEFT(bp.staff_no, LOCATE(' ', bp.staff_no) - 1)
    END = sme.staff_no)
LEFT JOIN
    sme_org smec ON (REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no)
WHERE
    bp.rank_update IN ('S','A','B','C','F')
    AND bp.contract_status != 'Contracted'
    AND bp.contract_status != 'Cancelled'
    AND bp.`type` IN ('New', 'Dor', 'Inc')
    AND CASE
	        WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	        THEN sme.unit_no
	        ELSE smec.unit_no
    	END IS NOT NULL
    AND bp.disbursement_date_pay_date >= '2025-03-03'
    OR (bp.rank_update IN ('S','A','B','C') AND bp.creation >= '2025-02-01')
ORDER BY
    sme.id ASC;


-- export Next week plan + SABC this month
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
	bp.customer_tel,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) as `Edit`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-25')  then 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'Next week plan + SABC this month')
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- ______________________ Dormant and Existing for the 15 Units from Branches ________________________

-- 1. Existing for Yadsing
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
	apl.`usd_loan_amount`,
	'Existing-for-15units' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
;


-- 2. DOrmant for Yadsing
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
	apl.`usd_loan_amount`,
	'Dormant-for-15units' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
;


-- 3) Export the lis to do assign special staff
-- Dormant
SELECT
	id, 
	bp_name, 
	current_staff,
	management_type 
FROM temp_sme_pbx_BO_special_management
WHERE management_type = 'Existing-for-15units' ;

-- Existing
SELECT 
	id, 
	bp_name, 
	current_staff,
	management_type 
FROM temp_sme_pbx_BO_special_management
WHERE management_type = 'Dormant-for-15units' ;


-- 4) Improt by update on duplicate from CVS to table temp_sme_pbx_BO_special_management


-- 5) Export to Google sheet
-- URL: https://docs.google.com/spreadsheets/d/1e7ZUIZ1cFVdp5wxVV9aVYisYWXTcPDY6f6TtjVTYLGI/edit?gid=1659908448#gid=1659908448

-- Existing-for-15units
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
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-03')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-for-15units') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;


-- Dormant-for-15units
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
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-03')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-for-15units') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;











-- ______________________ Dormant and Existing Good people call the cases of bad people ________________________

-- 1. Existing for Yadsing
DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'Existing-for-Good people' ;

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
	apl.`usd_loan_amount`,
	'Existing-for-Good people' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
	AND sme.staff_no IN (4440, 1119, 4840, 1925, 1004, 4720, 1472, 2009, 4388, 1709, 4103, 3904, 4027, 4402, 2672, 3750, 4092, 2709, 1180, 990, 4236, 4177, 3699, 168, 3355, 3768, 4719, 4141, 430, 1971, 3845, 3896, 3234, 4201, 4125, 4193, 843, 3542, 577, 3611, 3126, 3939, 590, 4352, 1291, 3462, 3121, 4439, 1453, 3759, 3373, 4083, 2712, 2316, 2435, 2565, 408, 2520, 2213, 3636, 3733, 1151, 3905, 3196, 4196, 3606, 2984, 3604, 4050, 4528, 3637, 3687, 4307, 387, 3163, 4423, 1374, 3579, 4215, 1730, 1454, 1319, 3778, 3767, 2359, 4325, 3129, 1817, 2543, 3708, 4490, 2539, 3822, 1395, 4364, 1755, 2971, 3823, 1139, 2291, 1590, 2424, 1552, 1513, 3772, 2080, 1338, 4441, 4722, 3686, 1227, 2855, 3796, 806, 3846, 3745, 4842, 1382, 1336, 3526, 3963
)
;


-- 2. DOrmant for Yadsing
DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'Dormant-for-Good people' ;

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
	apl.`usd_loan_amount`,
	'Dormant-for-Good people' as `management_type`,
	NULL AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
	AND sme.staff_no IN (4440, 4509, 4840, 1925, 1004, 4720, 1472, 2009, 4103, 3626, 3904, 4027, 4402, 2672, 3750, 4092, 2709, 1180, 990, 4236, 4177, 4151, 3355, 3768, 4719, 1955, 4141, 1971, 3845, 3896, 3234, 4201, 4125, 4193, 3611, 527, 3126, 3939, 4352, 3462, 3121, 4439, 1453, 3759, 3373, 4083, 2712, 2316, 2435, 2565, 558, 1306, 408, 2520, 2213, 3636, 3733, 1151, 3905, 1459, 4196, 3606, 2984, 3604, 4050, 4528, 3637, 3687, 4307, 387, 3163, 4423, 1374, 3579, 4215, 4086, 487, 1454, 1319, 1770, 3778, 3767, 4325, 3129, 1817, 2543, 3708, 4490, 2539, 3822, 1395, 4364, 1755, 2971, 3823, 1139, 2291, 1590, 2424, 1552, 1513, 3772, 2529, 4441, 4722, 3686, 3936, 2855, 1868, 3796, 1054, 3745, 1382, 1336, 2656, 1094, 3526, 3963
)
;


-- 3) Export the lis to do assign special staff
-- Existing
SELECT
	id, 
	bp_name, 
	current_staff,
	management_type 
FROM temp_sme_pbx_BO_special_management
WHERE management_type = 'Existing-for-Good people' ;

-- Dormant
SELECT 
	id, 
	bp_name, 
	current_staff,
	management_type 
FROM temp_sme_pbx_BO_special_management
WHERE management_type = 'Dormant-for-Good people' ;


-- 4) Improt by update on duplicate from CVS to table temp_sme_pbx_BO_special_management


-- 5) Export to Google sheet
-- URL: https://docs.google.com/spreadsheets/d/1e7ZUIZ1cFVdp5wxVV9aVYisYWXTcPDY6f6TtjVTYLGI/edit?gid=1659908448#gid=1659908448

-- Existing-for-Good people
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
	bp.usd_loan_amount_old AS `usd_loan_amount`, 
	bp.normal_bullet ,
	bp.customer_name ,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-03')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-for-Good people') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;


-- Dormant-for-Good people
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
	bp.usd_loan_amount_old AS `usd_loan_amount`, 
	bp.normal_bullet ,
	bp.customer_name ,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-03')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-for-Good people') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;
















