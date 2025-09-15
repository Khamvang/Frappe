

SELECT DISTINCT management_type FROM temp_sme_pbx_BO_special_management

-- ---------------------------------- 2025-06-20 ----------------------------------
-- 1.1 Dormant-Yadsing
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Dormant-Yadsing';

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
	'Dormant-Yadsing' as `management_type`,
	NOW() AS `datetime_create`
from tabSME_Approach_list apl 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = apl.name and tspbsm.management_type in ('Dormant-HC1') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
WHERE 
	sme.unit_no IN (2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 20, 22, 23, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 40, 41, 43, 44, 46, 48, 50, 51, 53, 54, 56, 57, 58, 59, 60, 61, 62, 63, 65, 66, 68, 69, 70, 71, 72, 73, 74, 75)
;


-- export to assign
SELECT * FROM temp_sme_pbx_BO_special_management
WHERE `management_type` = 'Dormant-Yadsing' 

-- URL https://docs.google.com/spreadsheets/d/1al8pCun5ximn8ZN4hkpP0BH4nnwi1bLx3C_vgBwkhRA/edit?gid=1977332838#gid=1977332838
-- 1.2 Export Dormant-Yadsing
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
	CASE
		WHEN sme.unit_no = 2 THEN '3196 - KHOUN' 
		WHEN sme.unit_no = 3 THEN '3196 - KHOUN' 
		WHEN sme.unit_no = 5 THEN '3196 - KHOUN' 
		WHEN sme.unit_no = 6 THEN '3626 - PHOUN' 
		WHEN sme.unit_no = 7 THEN '3626 - PHOUN' 
		WHEN sme.unit_no = 8 THEN '3626 - PHOUN' 
		WHEN sme.unit_no = 9 THEN '544 - PA' 
		WHEN sme.unit_no = 10 THEN '544 - PA' 
		WHEN sme.unit_no = 11 THEN '544 - PA' 
		WHEN sme.unit_no = 12 THEN '558 - YUI' 
		WHEN sme.unit_no = 15 THEN '558 - YUI' 
		WHEN sme.unit_no = 16 THEN '558 - YUI' 
		WHEN sme.unit_no = 17 THEN '1454 - DAM' 
		WHEN sme.unit_no = 20 THEN '1454 - DAM' 
		WHEN sme.unit_no = 22 THEN '168 - LING' 
		WHEN sme.unit_no = 23 THEN '168 - LING' 
		WHEN sme.unit_no = 25 THEN '168 - LING' 
		WHEN sme.unit_no = 26 THEN '616 - TIP' 
		WHEN sme.unit_no = 27 THEN '616 - TIP' 
		WHEN sme.unit_no = 28 THEN '616 - TIP' 
		WHEN sme.unit_no = 30 THEN '4509 - BIE' 
		WHEN sme.unit_no = 31 THEN '4509 - BIE' 
		WHEN sme.unit_no = 32 THEN '4509 - BIE' 
		WHEN sme.unit_no = 33 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 34 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 35 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 36 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 37 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 38 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 40 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 41 THEN '4177 - NATHEE' 
		WHEN sme.unit_no = 43 THEN '1374 - MIK' 
		WHEN sme.unit_no = 44 THEN '1770 - PINMANY' 
		WHEN sme.unit_no = 46 THEN '1925 - SINH' 
		WHEN sme.unit_no = 48 THEN '1770 - PINMANY' 
		WHEN sme.unit_no = 50 THEN '2359 - NAR' 
		WHEN sme.unit_no = 51 THEN '2359 - NAR' 
		WHEN sme.unit_no = 53 THEN '1319 - FON' 
		WHEN sme.unit_no = 54 THEN '1319 - FON' 
		WHEN sme.unit_no = 56 THEN '1395 - DITH' 
		WHEN sme.unit_no = 57 THEN '1395 - DITH' 
		WHEN sme.unit_no = 58 THEN '1395 - DITH' 
		WHEN sme.unit_no = 59 THEN '1395 - DITH' 
		WHEN sme.unit_no = 60 THEN '1395 - DITH' 
		WHEN sme.unit_no = 61 THEN '1395 - DITH' 
		WHEN sme.unit_no = 62 THEN '1395 - DITH' 
		WHEN sme.unit_no = 63 THEN '1395 - DITH' 
		WHEN sme.unit_no = 65 THEN '1227 - ON' 
		WHEN sme.unit_no = 66 THEN '1227 - ON' 
		WHEN sme.unit_no = 68 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 69 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 70 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 71 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 72 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 73 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 74 THEN '3846 - SOUK' 
		WHEN sme.unit_no = 75 THEN '3846 - SOUK' 
	END AS `NyadXing by`,
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
	case when bp.modified >= date_format(curdate(), '%Y-%m-08')  then 'called' else 'x' end as `call_ status`,
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
INNER JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Dormant-Yadsing') )
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



-- ---------------------------------- 2025-06-20 ----------------------------------
-- 1.1 Existing-Yadsing
DELETE FROM temp_sme_pbx_BO_special_management WHERE `management_type` = 'Existing-Yadsing';

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
	'Existing-Yadsing' as `management_type`,
	NOW() AS `datetime_create`
from tabSME_Approach_list apl 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = apl.name and tspbsm.management_type in ('Existing-HC1') )
left join sme_org sme on (CASE WHEN locate(' ', tspbsm.current_staff) = 0 THEN tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
WHERE 
	sme.unit_no IN (5, 6, 8, 12, 13, 14, 16, 17, 18, 19, 20, 25, 26, 28, 30, 31, 44, 45, 46, 48, 49, 50, 51, 53, 54, 55, 57, 58, 59, 60, 61, 63, 64, 65, 66)
;


-- export to assign
SELECT * FROM temp_sme_pbx_BO_special_management
WHERE `management_type` = 'Existing-Yadsing'

-- URL https://docs.google.com/spreadsheets/d/1R7H_rCL0W78O7LRQSoptEKNzZBtgk1qG7EpA_dGsawc/edit?gid=1977332838#gid=1977332838
-- 1.2 Export Existing-Yadsing
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
	CASE
		WHEN sme.unit_no = 5 THEN '3196 - KHOUN' 
		WHEN sme.unit_no = 6 THEN '3462 - FON' 
		WHEN sme.unit_no = 8 THEN '527 - LAR' 
		WHEN sme.unit_no = 12 THEN '3626 - PHOUN' 
		WHEN sme.unit_no = 13 THEN '590 - BOU' 
		WHEN sme.unit_no = 14 THEN '946 - TAY' 
		WHEN sme.unit_no = 16 THEN '843 - NY' 
		WHEN sme.unit_no = 17 THEN '430 - TOUN' 
		WHEN sme.unit_no = 18 THEN '3636 - LINDA' 
		WHEN sme.unit_no = 19 THEN '168 - LING' 
		WHEN sme.unit_no = 20 THEN '1332 - MOCK' 
		WHEN sme.unit_no = 25 THEN '2539 - MEK' 
		WHEN sme.unit_no = 26 THEN '616 - TIP' 
		WHEN sme.unit_no = 28 THEN '408 - NO' 
		WHEN sme.unit_no = 30 THEN '4509 - BIE' 
		WHEN sme.unit_no = 31 THEN '1151 - SIN' 
		WHEN sme.unit_no = 44 THEN '1770 - PINMANY' 
		WHEN sme.unit_no = 45 THEN '1770 - PINMANY' 
		WHEN sme.unit_no = 46 THEN '1770 - PINMANY' 
		WHEN sme.unit_no = 48 THEN '1770 - PINMANY' 
		WHEN sme.unit_no = 49 THEN '1319 - FON' 
		WHEN sme.unit_no = 50 THEN '1319 - FON' 
		WHEN sme.unit_no = 51 THEN '1319 - FON' 
		WHEN sme.unit_no = 53 THEN '1319 - FON' 
		WHEN sme.unit_no = 54 THEN '1319 - FON' 
		WHEN sme.unit_no = 55 THEN '1755 - PHOUT' 
		WHEN sme.unit_no = 57 THEN '1755 - PHOUT' 
		WHEN sme.unit_no = 58 THEN '1755 - PHOUT' 
		WHEN sme.unit_no = 59 THEN '1755 - PHOUT' 
		WHEN sme.unit_no = 60 THEN '1136 - NOY' 
		WHEN sme.unit_no = 61 THEN '1136 - NOY' 
		WHEN sme.unit_no = 63 THEN '1136 - NOY' 
		WHEN sme.unit_no = 64 THEN '1136 - NOY' 
		WHEN sme.unit_no = 65 THEN '1136 - NOY' 
		WHEN sme.unit_no = 66 THEN '1136 - NOY'  
	END AS `NyadXing by`,
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
	case when bp.modified >= date_format(curdate(), '%Y-%m-08')  then 'called' else 'x' end as `call_ status`,
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
INNER JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Existing-Yadsing') )
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









