

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



-- ______________________ 2025-03-26 Special negotiate for This month until Yesterday ________________________

-- 2.1 This month SABC
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
	'This month SABC pending' as `management_type`,
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
    (bp.rank1 IN ('S','A','B','C') OR bp.rank_update IN ('S','A','B','C'))
    AND bp.contract_status != 'Contracted'
    AND bp.contract_status != 'Cancelled'
    AND bp.`type` IN ('New', 'Dor', 'Inc')
    AND CASE
	        WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	        THEN sme.unit_no
	        ELSE smec.unit_no
    	END IS NOT NULL
    AND bp.creation BETWEEN '2025-03-01' AND '2025-03-25'
ORDER BY
    sme.id ASC;


-- export This month SABC pending
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
	case when bp.modified >= date_format(curdate(), '%Y-%m-26')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'This month SABC pending')
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- 2.2 Execution plan from 28th-Mar without This month SABC
DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'Execution plan from 28th-Mar without This month SABC';

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
	'Execution plan from 28th-Mar without This month SABC' as `management_type`,
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
    (bp.rank1 IN ('S','A','B','C','F') OR bp.rank_update IN ('S','A','B','C','F'))
    AND bp.contract_status != 'Contracted'
    AND bp.contract_status != 'Cancelled'
    AND bp.`type` IN ('New', 'Dor', 'Inc')
    AND CASE
	        WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	        THEN sme.unit_no
	        ELSE smec.unit_no
    	END IS NOT NULL
    AND bp.disbursement_date_pay_date >= '2025-03-28'
    AND bp.name NOT IN (SELECT bp_name FROM temp_sme_pbx_BO_special_management WHERE management_type = 'This month SABC pending' )
ORDER BY
    sme.id ASC;



-- export Execution plan from 28th-Mar without This month SABC
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
	case when bp.modified >= date_format(curdate(), '%Y-%m-26')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'Execution plan from 28th-Mar without This month SABC')
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;





-- ______________________ 2025-03-29 Special negotiate for This month until Yesterday ________________________

-- 2.1 This month SABC
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

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
	'SABC 3months' as `management_type`,
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
    (bp.rank1 IN ('S','A','B','C') OR bp.rank_update IN ('S','A','B','C'))
    AND bp.contract_status != 'Contracted'
    AND bp.contract_status != 'Cancelled'
    AND bp.`type` IN ('New', 'Dor', 'Inc')
    AND CASE
	        WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	        THEN sme.unit_no
	        ELSE smec.unit_no
    	END IS NOT NULL
    AND bp.creation BETWEEN '2025-01-01' AND '2025-03-29'
    AND bp.usd_loan_amount >= 5000
ORDER BY
    sme.id ASC;


-- export SABC 3 Months Over 10,000$
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-29')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 3months' and tspbsm.usd_loan_amount BETWEEN 10000 AND 19999 )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- export SABC 3 Months Over 5,000$
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-29')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 3months' and tspbsm.usd_loan_amount BETWEEN 5000 AND 9999 )
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
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








-- ______________________ 2025-04-01 Special negotiate for This month until Yesterday ________________________

-- 1 This month SABC
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

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
	'SABC 6months over $5,000' as `management_type`,
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
    (bp.rank1 IN ('S','A','B','C') OR bp.rank_update IN ('S','A','B','C'))
    AND bp.contract_status != 'Contracted'
    AND bp.contract_status != 'Cancelled'
    AND bp.`type` IN ('New', 'Dor', 'Inc')
    AND CASE
	        WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	        THEN sme.unit_no
	        ELSE smec.unit_no
    	END IS NOT NULL
    AND bp.creation BETWEEN '2024-10-01' AND '2025-03-31'
    AND bp.usd_loan_amount >= 5000
ORDER BY
    sme.id ASC
;


SELECT * FROM temp_sme_pbx_BO_special_management
WHERE management_type = 'SABC 6months over $5,000' 
	and usd_loan_amount >= 5000
;


-- export SABC 6 Months Over 5,000$
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
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
	null as `is_own`,
	bp.own_salesperson
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 6months over $5,000' and tspbsm.usd_loan_amount >= 5000 )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- 3. Dormant for Credit
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-over_$10,000';

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
	apl.`usd_loan_amount`,
	'Dormant-over_$10,000' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
	AND apl.usd_loan_amount_old >= 10000
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-over_$10,000';


-- Dormant-over_$10,000
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.name as `id`, 
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-over_$10,000') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- 4. Dormant for Sales
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-over_$10,000-Sales';

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
	'Dormant-over_$10,000-Sales' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant'
	AND apl.usd_loan_amount_old >= 10000
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-over_$10,000-Sales';


-- Dormant-over_$10,000-Sales
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.name as `id`, 
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
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-07')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-over_$10,000-Sales') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- ______________________ 2025-04-21 Special negotiate for This month until Yesterday ________________________

-- 1 This month SABC
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management;



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
	'C pending' as `management_type`,
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
    bp.name IN (790728, 790284, 790548, 790411, 790121, 788693, 790374, 790108, 790338, 790529, 789528, 789232, 789823, 790463, 790726, 790507, 790336, 790151, 773793, 776232, 780803, 781261, 783992, 785406, 788236, 788546, 788552, 789079, 789340, 789479, 789695, 788551, 789472, 789693, 789935, 790144, 790480, 788242, 788553, 789694, 790344, 790499, 788240, 790488, 785864, 787648, 788249, 788981, 789478, 789716, 775111, 780702, 781385, 781735, 786905, 787655, 788556, 788935, 789596, 788690, 789714, 790280, 790500, 789444, 789814, 790048, 790316, 790628, 790098, 790492, 788093, 789642, 789997, 790293, 790506, 788746, 789193, 789493, 789699, 788510, 788845, 789294, 787880, 790464, 790465, 789019, 789578, 789842, 789867, 790633, 790511, 787046, 789666, 790125, 788058, 789639, 790045, 790393, 788402, 789117, 790412, 790634, 786873, 787597, 788179, 790636, 789648, 789901, 790102, 790418, 790681, 786738, 787166, 787420, 787838, 788692, 790632, 788745, 789315, 789659, 789897, 790520, 787877, 789027, 790428, 789476, 787740, 789879, 789938, 790262, 790612, 784507, 788784, 789876, 789940, 790263, 790505, 787497, 789233, 790084, 790409, 790567, 790440, 790729, 790695, 790095, 790417, 790696, 789518, 790259, 790619, 786537, 788775, 782607, 778078, 768049, 768644, 769085, 776100, 777346, 784109, 784547, 790424, 790402, 789160, 790032, 790299, 790522, 790502, 790708, 789245, 783798, 790252, 790360, 789176, 790348, 790694, 785291, 790080, 786272, 789311, 789598, 790063, 790701, 790023, 787214, 780206, 788234, 789575, 790320, 790335, 790462, 790566, 789754, 790086, 790438, 786543, 788750, 790087, 790309, 790697, 780715, 785474, 789330, 790353, 790515, 790148, 790490, 787642, 789931, 790533, 790577, 790576, 790559, 790624, 789925, 790715, 790631, 788555, 790613, 778046, 788800, 789947, 790498, 790185, 790605, 790655, 787493, 789219, 789838, 790070, 790356, 790714, 780974, 790278, 788332, 788847, 790110, 790245, 789268, 790290, 790666, 786129, 790295, 779680, 788767, 790279, 790537, 790659, 780073, 787784, 790617, 790604, 790051, 790606, 790602, 789584, 790614, 781749, 787286, 790286, 790444, 789967, 790367, 790446, 790392, 790545, 790077, 790683, 789291, 789605, 790443, 789922, 790126, 790400, 790685, 789295, 790111, 790405, 790621, 790702, 788873, 790466, 790623, 790704, 784257, 790276, 790558, 790380, 790568, 788776, 790554, 786939, 790366, 789707, 790384, 790543, 790139, 790386, 789157, 790382, 790720, 789996, 790323, 790378, 790705, 790315, 789606, 790359, 790723, 786565, 790661, 790277, 788817, 789204, 789815, 786382, 790341, 790364, 790645, 790677, 790627, 790447, 790671, 790690, 786410, 790247, 790646, 790680, 789276, 789645, 790362, 786411, 787903, 789325, 790638, 1240777, 1240781, 787343, 790230, 790532, 787714, 789365, 790629, 786847, 788137, 788447, 789843, 790385, 790622, 790618, 787360, 789825, 790081, 790620, 790615, 787546, 788071, 788896, 789280, 769262, 789531, 790371, 780387, 790426, 790710, 786938, 790141, 790713, 790717, 786923, 788283, 790719, 787272, 790711, 790718, 789607, 789688, 790035, 790596, 789912, 790069, 790691, 788270, 790097, 790494, 788923, 790461, 787107, 789945, 790551, 790585, 776860, 777583, 788206, 790257, 790635, 789247, 790233, 788208, 788798, 790261, 790678, 774486, 788799, 790228, 789822, 790282, 790692, 787018, 789286, 790172, 790647, 790593, 790523, 790592, 790616, 785184, 790664, 785142, 790518, 790652, 790527, 790589, 790347, 789717, 790513, 790509, 790521, 790213, 790510, 779746, 790517, 790166, 790501, 790519, 764995, 790218, 789954, 790670, 790046, 790583, 788373, 790597, 789972, 790640, 789984, 790599, 790210, 790598, 779795, 789060, 789217, 790675, 790317, 787524, 786699, 789839, 790413, 790430, 788125, 790094, 779459, 790722, 790372, 790721, 788698, 789210, 790333, 790573, 789380, 789709, 789953, 790216, 790530, 790541, 790028, 790549, 789751, 790181, 790453, 790684, 789475, 790253, 790586, 788297, 789934, 790540, 788669, 790188, 790682, 788984, 790493, 790565, 790313, 790575, 790637, 790508, 789197, 789350, 790085, 790288, 790679, 787680, 789146, 789468, 789794, 790067, 790220, 790570, 785039, 785432, 785599, 786217, 787619, 788753, 790534, 787667, 788665, 789711, 790231, 776094, 778405, 783402, 786716, 787283, 787426, 788924, 789333, 789689, 790208, 790504, 789144, 788977, 790156, 787074, 787436, 788184, 788576, 789374, 790376, 786822, 788860, 789893, 789216, 789809, 786724, 787089, 787994, 789264, 789336, 789891, 790451, 790639, 788738, 789044, 789889, 787432, 789187, 790307, 790699, 789570, 790553, 790564, 790013, 790535, 767285, 787080, 788995, 789770, 790555
)
;



-- 1. export C pending
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-21')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'C pending')
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;


-- 2. Dormant Over $10,000

-- 3. This month and Last month delay to be INC


-- 4. Bargain to get it faster
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when bp.rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-21')  then 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
FROM tabSME_BO_and_Plan bp 
LEFT JOIN sme_pre_daily_report spdr on (spdr.bp_name = bp.name)
LEFT JOIN sme_org sme ON (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
WHERE 
    spdr.date_report = (SELECT MAX(date_report) FROM sme_pre_daily_report) 
    AND (
        spdr.disbursement_date_pay_date != CURDATE() 
        OR spdr.disbursement_date_pay_date IS NULL 
        OR spdr.disbursement_date_pay_date = ''
    )
    AND spdr.rank_update_SABC = '1';



-- 8. SABC 3 months Cancelled
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 3 months Cancelled';

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
	'SABC 3 months Cancelled' as `management_type`,
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
    (bp.rank1 IN ('S','A','B','C') OR bp.rank_update IN ('S','A','B','C'))
    AND bp.contract_status = 'Cancelled'
    AND bp.`type` IN ('New', 'Dor', 'Inc')
    AND bp.creation BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY
    sme.id ASC
;





-- SABC 3 months Cancelled Over 5,000$
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
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
	null as `is_own`,
	bp.own_salesperson
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 3 months Cancelled' and tspbsm.usd_loan_amount >= 10000 )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- ______________________ 2025-04-22 Special negotiate for This month until Yesterday ________________________
-- 1. SABC 1year Over$10,000 for UL
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 1year Over$10,000';

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
	'SABC 1year Over$10,000' as `management_type`,
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
	bp.name IN (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type <= 12)
	AND bp.`usd_loan_amount` >= 10000
ORDER BY
    sme.id ASC
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 1year Over$10,000' ;


-- SABC 1year Over$10,000 for UL
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-22')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 1year Over$10,000' )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- 2. SABC 1year Over$5,000 for TL
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 1year Over$5,000';

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
	'SABC 1year Over$5,000' as `management_type`,
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
	bp.name IN (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type <= 12)
	AND bp.`usd_loan_amount` >= 5000 AND bp.`usd_loan_amount` < 10000
ORDER BY
    sme.id ASC
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 1year Over$5,000' ;


-- SABC 1year Over$5,000 for TL
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-22')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 1year Over$5,000' )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;



-- 3. SABC 1year Less than$5,000 for TL
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 1year Less than$5,000';

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
	'SABC 1year Less than$5,000' as `management_type`,
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
	bp.name IN (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type <= 12)
	AND bp.`usd_loan_amount` >= 0 AND bp.`usd_loan_amount` < 5000
ORDER BY
    sme.id ASC
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC 1year Less than$5,000' ;


-- SABC 1year Less than$5,000 for TL
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-22')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC 1year Less than$5,000' )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- 4. SABC Over 1year Over$5,000 for CC
SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

DELETE FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC Over 1year Over Over$5,000';

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
	'SABC Over 1year Over$5,000' as `management_type`,
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
	bp.name IN (select id from temp_sme_pbx_BO where `type` in ('S', 'A', 'B', 'C') and month_type > 12)
	AND bp.`usd_loan_amount` >= 5000
ORDER BY
    sme.id ASC
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE management_type = 'SABC Over 1year Over$5,000' ;


-- SABC Over 1year Over $10,000 for CC
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
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-22')  then 'called' else 'x' end as `call_ status`,
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
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type = 'SABC Over 1year Over$5,000' )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;




-- 5. Existing-over_$5,000-Sales
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-over_$5,000-Sales';

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
	(apl.car_buying_price - apl.usd_now_amount) AS `usd_loan_amount`,
	'Existing-over_$5,000-Sales' as `management_type`,
	NOW() AS `datetime_create`
FROM tabSME_Approach_list apl 
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Existing'
	AND (apl.car_buying_price - apl.usd_now_amount) >= 5000
;


SELECT * FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-over_$5,000-Sales';


-- Existing-over_$5,000-Sales
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.name as `id`, 
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
	tspbsm.usd_loan_amount , 
	bp.normal_bullet ,
	bp.customer_name ,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', bp.name) as `Edit`,
	TRIM(SUBSTRING_INDEX(bp.rank_update, ' ', 1)) AS `rank_update`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= date_format(curdate(), '%Y-%m-25')  then 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() THEN 'Yes'
		ELSE 'No'
	END AS `disbursement_status`,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-over_$5,000-Sales') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;























