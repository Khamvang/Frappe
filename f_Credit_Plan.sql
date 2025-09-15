

-- 1. Compare the position of columns
-- 1st table
SELECT COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = '_8abac9eed59bf169'
  AND TABLE_NAME = 'tabSME_BO_and_Plan'
ORDER BY ORDINAL_POSITION;

-- 2nd table
SELECT COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = '_8abac9eed59bf169'
  AND TABLE_NAME = 'tabSME_BO_and_Plan_Credit'
ORDER BY ORDINAL_POSITION;


-- 2. Insert all pending SABC from SME_BO_and_Plan to SME_BO_and_Plan_Credit
INSERT INTO tabSME_BO_and_Plan_Credit (
    `name`, `creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`,
    `staff_no`, `callcenter_of_sales`, `double_count`, `non_sales`, `type`,
    `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`,
    `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`,
    `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`,
    `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`,
    `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`,
    `address_village`, `rank1`, `rank_update`, `customer_card`,
    `attach_customer_card`, `send_wa`, `wa_date`, `wa_evidence`,
    `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`,
    `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`,
    `real_estate_province_and_city`, `village`, `owner_first_name`,
    `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`,
    `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`,
    `rank_update_sp_cc`, `reason_of_sp_cc`, `sp_cc_remark`, `tl_name`,
    `rank_of_tl`, `reason_of_tl`, `tl_remark`, `sec_manager`, `rank_of_sec`,
    `reason_of_sec`, `sec_remark`, `credit`, `rank_of_credit`, `sale_plan_rate`,
    `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`,
    `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`,
    `rank_S_date`, `rank_A_date`, `rank_B_date`, `rank_C_date`, `list_type`,
    `old_contract_no`, `owner_staff_no`, `usd_loan_amount_of_old_contract`,
    `usd_principal_outstanding_amount_of_old_contract`, `usd_asset_value_amount_of_old_contract`,
    `business_type`, `custtbl_id`, `own_salesperson`, `refer_id`, `refer_type`
)
SELECT
    bp.`name`, bp.`creation`, bp.`modified`, bp.`modified_by`, bp.`owner`, bp.`docstatus`, bp.`idx`,
    bp.`staff_no`,
    -- These are the reordered columns for tabSME_BO_and_Plan_Credit's structure:
    -- Based on tabSME_BO_and_Plan_Credit's columns 9-16
    bp.`callcenter_of_sales`, -- Target Position 9
    bp.`double_count`,        -- Target Position 10
    bp.`non_sales`,           -- Target Position 11
    bp.`type`,                -- Target Position 12
    bp.`is_sales_partner`,    -- Target Position 13
    bp.`approch_list`,        -- Target Position 14
    bp.`visit_or_not`,        -- Target Position 15
    bp.`reason_of_visit`,     -- Target Position 16
    -- visit_date is correctly mapped to its position in tabSME_BO_and_Plan_Credit
    bp.`visit_date`,          -- Target Position 17
    bp.`details_of_visit_reason`, bp.`priority_to_visit`, bp.`visit_location_url`,
    bp.`visit_time`, bp.`evidence`, bp.`disbursement_date_pay_date`, bp.`usd_loan_amount`,
    bp.`usd_fee_amount`, bp.`monthly_interest_rate`, bp.`normal_bullet`, bp.`contract_no`,
    bp.`case_no`, bp.`customer_name`, bp.`customer_tel`, bp.`address_province_and_city`,
    bp.`address_village`, bp.`rank1`, bp.`rank_update`, bp.`customer_card`,
    bp.`attach_customer_card`, bp.`send_wa`, bp.`wa_date`, bp.`wa_evidence`,
    bp.`ringi_status`, bp.`ringi_comment`, bp.`contract_status`, bp.`contract_comment`,
    bp.`maker`, bp.`model`, bp.`year`, bp.`usd_value`, bp.`estate_types`, bp.`land_area`,
    bp.`real_estate_province_and_city`, bp.`village`, bp.`owner_first_name`,
    bp.`owner_last_name`, bp.`who_is_it`, bp.`usd_value_of_real_estate`, bp.`have_or_not`,
    bp.`from_whom`, bp.`date`, bp.`usd_value_of_receivable`, bp.`remark`, bp.`sp_cc`,
    bp.`rank_update_sp_cc`, bp.`reason_of_sp_cc`, bp.`sp_cc_remark`, bp.`tl_name`,
    bp.`rank_of_tl`, bp.`reason_of_tl`, bp.`tl_remark`, bp.`sec_manager`, bp.`rank_of_sec`,
    bp.`reason_of_sec`, bp.`sec_remark`, bp.`credit`, bp.`rank_of_credit`, bp.`sale_plan_rate`,
    bp.`reason_of_credit`, bp.`credit_remark`, bp.`visit_checker`, bp.`actual_visit_or_not`,
    bp.`comment_by_visit_checker`, bp.`_user_tags`, bp.`_comments`, bp.`_assign`, bp.`_liked_by`,
    bp.`rank_S_date`, bp.`rank_A_date`, bp.`rank_B_date`, bp.`rank_C_date`, bp.`list_type`,
    bp.`old_contract_no`, bp.`owner_staff_no`, bp.`usd_loan_amount_of_old_contract`,
    bp.`usd_principal_outstanding_amount_of_old_contract`, bp.`usd_asset_value_amount_of_old_contract`,
    bp.`business_type`, bp.`custtbl_id`, bp.`own_salesperson`, bp.`refer_id`, bp.`refer_type`
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_pre_daily_report_Credit spdr
	ON spdr.id = (SELECT id FROM sme_pre_daily_report_Credit WHERE bp_name = bp.name ORDER BY id DESC LIMIT 1 )
WHERE 
	(
		-- SABC pending up to yesterday
		(
			spdr.date_report = (select max(date_report) from sme_pre_daily_report_Credit)
			AND (spdr.rank_update_SABC = 1
			OR spdr.disbursement_date_pay_date BETWEEN CURDATE() AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH)) )
		)
		 -- SABC created today
	 	OR (
			bp.creation >= CURDATE()
			AND bp.rank1 IN ('S', 'A', 'B', 'C')
	 	)
 	)
 	AND 
 	bp.name NOT IN (SELECT name FROM tabSME_BO_and_Plan_Credit)
;






-- 3. All Poiku plan
SELECT sme.id `#`, 
	sme.`g-dept`, 
	sme.dept, 
	sme.sec_branch, 
	sme.unit_no, 
	sme.unit, 
	sme.staff_no, 
	sme.staff_name,
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.customer_name, 
	CASE
		WHEN bp.approch_list = '①-1 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູ່ ບໍລິສັດການເງິນ ເຊັ່ນ: ທະນາຄານ, ບ/ສ ສິນເຊື່ອ...)' THEN '5way'
		WHEN bp.approch_list = '①-2 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູ່ ຮ້ານ​ຂາຍລົດ / ຮ້ານ​ສ້ອມ​ແປງລົດ​)' THEN '5way'
		WHEN bp.approch_list = '①-4 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູບ່ອນອື່ນໆ ນອກຈາກ 3ຂໍ້ເທິງ)' THEN '5way'
		WHEN bp.approch_list = '② ຈາກ Facebook' THEN 'Facebook'
		WHEN bp.approch_list = '③-1 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ປັດຈຸບັນ​)' THEN 'Z'
		WHEN bp.approch_list = '③-2 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ເກົ່າ​)' THEN 'Y'
		WHEN bp.approch_list = '③-3​ Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ສົນໃຈ​)' THEN 'X'
		WHEN bp.approch_list = '③-4​ ໄດ້ຈາກການໂທ ແລະ ຫາດ້ວຍຕົນເອງ' THEN 'Call'
		WHEN bp.approch_list = '④ Sales partner ທີ່ເຄີຍແນະນຳໃນອາດີດ' THEN 'SP'
		WHEN bp.approch_list = '④ Sales partner ຂອງພະນັກງານອອກວຽກ' THEN 'SP'
		WHEN bp.approch_list = '⑤ ຈາກການໂທ 200-3-3-1 ຂອງ CC ພາຍໃຕ້ຕົນເອງ' THEN 'Call'
		WHEN bp.approch_list = '⑥ ແນະນໍາຈາກ ພະແນກພາຍໃນ' THEN 'Non-sales'
		WHEN bp.approch_list = '⑥ Resigned Employees ພະນັກງານອອກວຽກ' THEN 'Resigned_Employees'
		WHEN bp.approch_list = '⑦ ປິດງວດຈາກບໍລິສັດຄູ່ແຂ່ງ' THEN 'Call'
		WHEN bp.approch_list = '⑧HC ລູກຄ້າເກົ່າ - ຜູ້ກູ້' THEN 'HC-Dor-Cus'
		WHEN bp.approch_list = '⑧HC ລູກຄ້າເກົ່າ - ຜູ້ຄ້ຳ' THEN 'HC-Dor-Gua'
		WHEN bp.approch_list = '⑧HC ລູກຄ້າເກົ່າ - ຄົນສຳຮອງ' THEN 'HC-Dor_Agt'
		WHEN bp.approch_list = '⑨HC ລູກຄ້າປັດຈຸບັນ - ຜູ້ກູ້' THEN 'HC-Inc-Cus'
		WHEN bp.approch_list = '⑨HC ລູກຄ້າປັດຈຸບັນ - ຜູ້ຄ້ຳ' THEN 'HC-Inc-Gua'
		WHEN bp.approch_list = '⑨HC ລູກຄ້າປັດຈຸບັນ - ຄົນສຳຮອງ' THEN 'HC-Inc_Agt'
	END AS `approach_type`,
	bp.rank_update, 
	case 
		when bp.contract_status = 'Contracted' then 'Have Ringi' 
		when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' 
		when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case 
		when bp.contract_status = 'Contracted' then 'Contracted' 
		when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' 
		when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' 
		when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.sale_plan_rate,
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() THEN 'Yes'
		ELSE 'No'
	END AS `disbursement_status`,
	bp.disbursement_date_pay_date AS `disbursement_date`,
	CASE 
		WHEN tftl.date_created >= bp.creation OR tfse.date_created >= bp.creation OR tfcr.date_created >= bp.creation THEN 'Called'
		WHEN bp.modified > bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called`,
	CASE 
		WHEN (SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'Yes' OR SUBSTRING_INDEX(bp.visit_or_not , ' - ', 1) = 'WA')
			AND bp.visit_date IS NOT NULL AND bp.visit_date != '' AND bp.visit_date <= CURDATE()
		THEN 'Yes'
		ELSE 'No'
	END AS `visit_status`, 
	bp.visit_date AS `visit_date`,
	-- 
	CASE
	    WHEN bp.contract_status = 'Contracted' THEN 'Contracted' 
	    WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled' 
		-- 
	    WHEN bp.ringi_status IN ('Approved') 
	         AND bp.disbursement_date_pay_date >= CURDATE() THEN 'Ringi completed' 
		-- 
	        WHEN SUBSTRING_INDEX(
             COALESCE(
                 NULLIF(bp.reason_of_credit, ''),
                 NULLIF(bp.reason_of_sec, ''),
                 NULLIF(bp.reason_of_tl, ''),
                 ''
             ), '.', 1
         ) = '1' THEN 'Condition mismatch'
		-- 
	    WHEN SUBSTRING_INDEX(
	             COALESCE(
	                 NULLIF(bp.reason_of_credit, ''),
	                 NULLIF(bp.reason_of_sec, ''),
	                 NULLIF(bp.reason_of_tl, ''),
	                 ''
	             ), '.', 1
	         ) = '2' THEN 'waiting for information'
		-- 
	    WHEN SUBSTRING_INDEX(
	             COALESCE(
	                 NULLIF(bp.reason_of_credit, ''),
	                 NULLIF(bp.reason_of_sec, ''),
	                 NULLIF(bp.reason_of_tl, ''),
	                 ''
	             ), '.', 1
	         ) = '3' THEN 'family consultations'
		-- 
	    ELSE 'pending'
	END AS `final_status`,
	-- 
	CASE
		WHEN bp.reason_of_credit IS NOT NULL AND bp.reason_of_credit != '' THEN bp.reason_of_credit
		WHEN bp.reason_of_sec IS NOT NULL AND bp.reason_of_sec != '' THEN bp.reason_of_sec
		WHEN bp.reason_of_tl IS NOT NULL AND bp.reason_of_tl != '' THEN bp.reason_of_tl
		ELSE ''
	END AS `final_reason` ,
	-- 
	CASE
		WHEN bp.credit_remark  IS NOT NULL AND bp.credit_remark != '' THEN bp.credit_remark
		WHEN bp.sec_remark IS NOT NULL AND bp.sec_remark != '' THEN bp.sec_remark
		WHEN bp.tl_remark IS NOT NULL AND bp.tl_remark != '' THEN bp.tl_remark
		ELSE ''
	END AS `final_comments` ,
	-- Additional time grouping logic
	CASE 
		-- 
		WHEN bp.creation >= (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 0 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 0 HOUR
						END) 
		AND bp.creation < (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 17 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
						END)
		THEN 'Before 5 PM Yesterday'
		-- 		
		WHEN bp.creation > (CASE 
							WHEN DAYOFWEEK(CURDATE() - INTERVAL 1 DAY) = 1 
							THEN CURDATE() - INTERVAL 2 DAY + INTERVAL 17 HOUR
							ELSE CURDATE() - INTERVAL 1 DAY + INTERVAL 17 HOUR
						END) 
		AND bp.creation < CURDATE()
		THEN 'After 5 PM Yesterday'
		-- 
		WHEN bp.creation >= CURDATE()
		AND bp.creation <= CURDATE() + INTERVAL 13 HOUR 
		THEN 'Before 1 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 13 HOUR 
		AND bp.creation <= CURDATE() + INTERVAL 17 HOUR 
		THEN 'Before 5 PM Today'
		-- 
		WHEN bp.creation > CURDATE() + INTERVAL 17 HOUR
		AND bp.creation <= CURDATE() + INTERVAL 23 HOUR 
		THEN 'After 5 PM Today'
		-- 
		ELSE 'Before Yesterday'
	END AS `Time_Created`,
	bp.creation,
	bp.modified,
	CONCAT('http://13.250.153.252:8000/app/sme_bo_and_plan_credit/', bp.name) AS `Edit`,
		-- Result from TL & UL above
	CASE 
		WHEN tftl.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_TL&UL`,
	tftl.visit_or_not AS `visit_by_TL&UL` ,
	tftl.visit_date AS `visit_date_by_TL&UL` ,
	tftl.now_status AS `now_status_by_TL&UL` ,
	tftl.disbursement_date AS `disbursement_date_by_TL&UL` ,
	bp.reason_of_tl AS `reason_of_TL&UL`,
		-- Result from Sec & Dept above
	CASE 
		WHEN tfse.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_Sec&Dept`,
	tfse.visit_or_not AS `visit_by_Sec&Dept` ,
	tfse.visit_date AS `visit_date_by_Sec&Dept` ,
	tfse.now_status AS `now_status_by_Sec&Dept` ,
	tfse.disbursement_date AS `disbursement_date_by_Sec&Dept` ,
	bp.reason_of_sec AS `reason_of_Sec&Dept`,
		-- Result from Sec & Dept above
	CASE 
		WHEN tfcr.date_created >= bp.creation THEN 'Called'
		ELSE 'x'
	END AS `is_called_by_Credit`,
	tfcr.visit_or_not AS `visit_by_Credit` ,
	tfcr.visit_date AS `visit_date_by_Credit` ,
	tfcr.now_status AS `now_status_by_Credit` ,
	tfcr.disbursement_date  AS `disbursement_date_by_Credit` ,
	bp.reason_of_credit AS `reason_of_Credit`
FROM tabSME_BO_and_Plan_Credit bp
LEFT JOIN sme_pre_daily_report_Credit spdr 
	ON spdr.id = (SELECT id FROM sme_pre_daily_report_Credit WHERE bp_name = bp.name ORDER BY id DESC LIMIT 1 ) 
LEFT JOIN sme_org sme 
	ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
LEFT JOIN sme_org smec 
	ON (REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no)
LEFT JOIN (
	SELECT updated_id, 
		   MAX(CASE WHEN changed_column = 'tl_name' THEN id END) AS tl_id,
		   MAX(CASE WHEN changed_column = 'sec_manager' THEN id END) AS sec_manager_id,
		   MAX(CASE WHEN changed_column = 'credit' THEN id END) AS credit_id
	FROM log_sme_follow_SABC_Credit
	GROUP BY updated_id
) latest_logs ON latest_logs.updated_id = bp.name
LEFT JOIN log_sme_follow_SABC_Credit tftl ON tftl.id = latest_logs.tl_id
LEFT JOIN log_sme_follow_SABC_Credit tfse ON tfse.id = latest_logs.sec_manager_id
LEFT JOIN log_sme_follow_SABC_Credit tfcr ON tfcr.id = latest_logs.credit_id
WHERE 
	-- lasted Poiku plan
	(
	spdr.date_report = (select max(date_report) from sme_pre_daily_report_Credit)
	AND (spdr.rank_update_SABC = 1
	OR spdr.disbursement_date_pay_date between CURDATE() and LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH)) )
	)
 	-- SABC created today
 	OR (
		-- created today
		bp.creation >= CURDATE()
		-- only SABCF rank
		AND bp.rank1 IN ('S', 'A', 'B', 'C')
 	)
 	-- Unfollowed up to yesterday
 --	OR bp.name IN ()
ORDER BY sme.id ASC,
	bp.name ASC 
;


select * from sme_pre_daily_report_Credit




















