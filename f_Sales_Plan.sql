
-- 0. Monitoring and fix issue
SHOW processlist;

SHOW INDEX FROM sme_org;


-- 1. Related query 
-- https://github.com/Khamvang/Frappe/blob/main/Create%20daily%20report.sql


-- 2. Export to Google sheet -> https://docs.google.com/spreadsheets/d/1r1FGjbTPXwqz7kzfPKreChJNMRbD-Ms3sTG9BpGYwpQ/edit?gid=619388884#gid=619388884
-- Export Sales plan 
SELECT 
	bp.name,
	bp.staff_no ,
	bp.`type`,
	bp.customer_name ,
	bp.usd_loan_amount ,
	bp.normal_bullet ,
	bp.rank_update ,
	CASE 
		WHEN bp.contract_status = 'Contracted' THEN 'Contracted' 
		WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled' 
		ELSE bp.rank_update 
	END AS `now_result`,
	CASE 
		WHEN spdr.disbursement_date_pay_date >= CURDATE() THEN 'Yes'
		ELSE 'No'
	END AS `disbursement_date_old_status`,
	spdr.disbursement_date_pay_date AS `disbursement_date_old`,
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() AND spdr.disbursement_date_pay_date IS NULL THEN 'New'
		WHEN bp.disbursement_date_pay_date >= CURDATE() AND bp.disbursement_date_pay_date > spdr.disbursement_date_pay_date THEN 'Postpone'
		WHEN bp.disbursement_date_pay_date >= CURDATE() AND bp.disbursement_date_pay_date < spdr.disbursement_date_pay_date THEN 'Bargain faster'
		WHEN bp.disbursement_date_pay_date >= CURDATE() AND bp.disbursement_date_pay_date = spdr.disbursement_date_pay_date THEN 'Same'
		ELSE 'No'
	END AS `disbursement_date_new_status`,
	bp.disbursement_date_pay_date AS `disbursement_date_new`,
	CASE 
		WHEN bp.disbursement_date_pay_date >= CURDATE() AND spdr.disbursement_date_pay_date IS NULL THEN 0
		WHEN bp.disbursement_date_pay_date IS NULL AND spdr.disbursement_date_pay_date >= CURDATE() THEN 'pending'
		WHEN bp.rank_update IN ('S','A','B','C')
		    AND bp.contract_status != 'Contracted'
		    AND bp.contract_status != 'Cancelled'
		    AND bp.`type` IN ('New', 'Dor', 'Inc')
		    AND (sme.unit_no IS NOT NULL OR smec.unit_no IS NOT NULL )
	    THEN 'pending'
	    ELSE 0
	END AS `is_pending`
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_pre_daily_report spdr 
	ON spdr.id = (SELECT id FROM sme_pre_daily_report WHERE bp_name = bp.name ORDER BY id DESC LIMIT 1 ) 
LEFT JOIN sme_org sme
	ON (SUBSTRING_INDEX(bp.staff_no, ' -', 1) = sme.staff_no )
LEFT JOIN sme_org smec 
	ON (REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no)
WHERE 
	bp.disbursement_date_pay_date >= CURDATE()
 	OR spdr.disbursement_date_pay_date >= CURDATE()
 	OR (
 		bp.rank_update IN ('S','A','B','C')
	    AND bp.contract_status != 'Contracted'
	    AND bp.contract_status != 'Cancelled'
	    AND bp.`type` IN ('New', 'Dor', 'Inc')
	    AND CASE
	            WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	            THEN sme.unit_no
	            ELSE smec.unit_no
        	END IS NOT NULL
 	)
;












