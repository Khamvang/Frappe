

-- 1. G rank 
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
	CONCAT('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) AS `Edit`,
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
	bp.reason_of_credit AS `reason_of_Credit`,
	CASE
		WHEN bp.rank1 IN ('S', 'A', 'B', 'C') THEN 'SABC'
		WHEN bp.rank1 IN ('F') THEN 'F'
		WHEN SUBSTRING_INDEX(bp.rank1, ' ', 1) = 'G' 
				AND bp.address_province_and_city != ''
				AND bp.address_province_and_city IS NOT NULL
			THEN 'G1' 
			WHEN SUBSTRING_INDEX(bp.rank1, ' ', 1) = 'G' 
				AND bp.maker != ''
				AND bp.maker IS NOT NULL
			THEN 'G2' 
	END AS `g_rank`,
	bp.address_province_and_city,
	bp.maker
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_pre_daily_report spdr 
	ON spdr.id = (SELECT id FROM sme_pre_daily_report WHERE bp_name = bp.name ORDER BY id DESC LIMIT 1 ) 
LEFT JOIN sme_org sme 
	ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
LEFT JOIN sme_org smec 
	ON (REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no)
LEFT JOIN (
	SELECT updated_id, 
		   MAX(CASE WHEN changed_column = 'tl_name' THEN id END) AS tl_id,
		   MAX(CASE WHEN changed_column = 'sec_manager' THEN id END) AS sec_manager_id,
		   MAX(CASE WHEN changed_column = 'credit' THEN id END) AS credit_id
	FROM log_sme_follow_SABC
	GROUP BY updated_id
) latest_logs ON latest_logs.updated_id = bp.name
LEFT JOIN log_sme_follow_SABC tftl ON tftl.id = latest_logs.tl_id
LEFT JOIN log_sme_follow_SABC tfse ON tfse.id = latest_logs.sec_manager_id
LEFT JOIN log_sme_follow_SABC tfcr ON tfcr.id = latest_logs.credit_id
WHERE 
 	-- SABC created today
 	(
		-- created today
		bp.creation >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
		-- only SABCF rank
		AND bp.rank1 NOT IN ('S', 'A', 'B', 'C')
 	)
 	-- Unfollowed up to yesterday
 --	OR bp.name IN ()
ORDER BY sme.id ASC,
	bp.name ASC 
;



-- 2. This month SABCFG 
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
	bp.creation,
	bp.modified,
	CONCAT('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) AS `Edit`,
	CASE
		WHEN bp.rank1 IN ('S', 'A', 'B', 'C') THEN 'SABC'
		WHEN bp.rank1 IN ('F') THEN 'F'
		WHEN SUBSTRING_INDEX(bp.rank1, ' ', 1) = 'G' 
				AND bp.address_province_and_city != ''
				AND bp.address_province_and_city IS NOT NULL
			THEN 'G1' 
			WHEN SUBSTRING_INDEX(bp.rank1, ' ', 1) = 'G' 
				AND bp.maker != ''
				AND bp.maker IS NOT NULL
			THEN 'G2' 
	END AS `g_rank`,
	bp.address_province_and_city,
	bp.maker
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_org sme 
	ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
WHERE 
		bp.creation >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
ORDER BY sme.id ASC,
	bp.name ASC 
;















