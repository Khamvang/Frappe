

-- 1. Create table
-- Run on server frappe 13.250.153.252
DROP TABLE IF EXISTS `sme_hc_result`;

CREATE TABLE `sme_hc_result` (
	id INT(11) NOT NULL AUTO_INCREMENT,
	contract_no INT(11) DEFAULT NULL,
	customer_id INT(11) DEFAULT NULL,
	pre_contract_no INT(11) DEFAULT NULL,
	`contract_type` VARCHAR(255) DEFAULT NULL,
	`customer_type` VARCHAR(255) DEFAULT NULL,
	customer_name VARCHAR(255) DEFAULT NULL,
	main_contact_no VARCHAR(255) DEFAULT NULL,
	sec_contact_no VARCHAR(255) DEFAULT NULL,
	disbursed_date DATE DEFAULT NULL,
	ringi_status VARCHAR(255) DEFAULT NULL,
	contract_status VARCHAR(255) DEFAULT NULL,
	`usd_loan_amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
	`monthly_interest` DECIMAL(20,2) NOT NULL DEFAULT 0,
	`usd_fee` DECIMAL(20,2) NOT NULL DEFAULT 0,
	`no_of_payment` TINYINT(4) NOT NULL DEFAULT 0,
	`min_repayment_period` TINYINT(4) NOT NULL DEFAULT 0,
	`usd_refinance_amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
	`usd_net_payment_amount` DECIMAL(20,2) NOT NULL DEFAULT 0,
	approach_en VARCHAR(255) DEFAULT NULL,
	approach_la VARCHAR(255) DEFAULT NULL,
	broker_id INT(11) DEFAULT NULL,
	broker_name VARCHAR(255) DEFAULT NULL,
	broker_tel VARCHAR(255) DEFAULT NULL,
	acquire_by VARCHAR(255) DEFAULT NULL,
	salesperson VARCHAR(255) DEFAULT NULL,
	callcenter_of_sales VARCHAR(255) DEFAULT NULL,
	double_count VARCHAR(255) DEFAULT NULL,
	non_sales VARCHAR(255) DEFAULT NULL,
	date_created DATETIME DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (id),
	KEY `idx_customer_id` (`customer_id`),
	KEY `idx_main_contact_no` (`main_contact_no`),
	KEY `idx_sec_contact_no` (`sec_contact_no`),
	KEY `idx_disbursed_date` (`disbursed_date`),
	KEY `idx_contract_status` (`contract_status`),
	KEY `idx_broker_tel` (`broker_tel`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
;


-- 2. HC Contracted from LMS
-- Run on server lalco 18.140.117.112
SELECT p.id AS `contract_no` ,
	cu.id AS `customer_id`,
	cpre.contract_no AS `pre_contract_no`,
    CASE
		p.contract_type 
		WHEN 1 THEN 'SME Car'
		WHEN 2 THEN 'SME Bike'
		WHEN 3 THEN 'Car Leasing'
		WHEN 4 THEN 'Bike Leasing'
		WHEN 5 THEN 'Real estate'
		ELSE NULL
	END `contract_type`,
	CASE
		p.customer_profile 
		WHEN 1 THEN 'New'
		WHEN 2 THEN 'Current'
		WHEN 3 THEN 'Dormant'
	END `customer_type`,
	CONVERT( CAST( CONVERT( CONCAT( cu.customer_first_name_lo, ' ', cu.customer_last_name_lo, ' / ', 
							cu.customer_first_name_en, ' ', cu.customer_last_name_en
			) USING latin1) AS BINARY) USING utf8) 
	AS `customer_name`,
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
		when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
    	else CONCAT('9020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	end `main_contact_no`,
	case when left (right (REPLACE ( cu.sec_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.sec_contact_no, ' ', '') ,8))
		when length (REPLACE ( cu.sec_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.sec_contact_no, ' ', ''))
    	else CONCAT('9020', right(REPLACE ( cu.sec_contact_no, ' ', '') , 8))
	end `sec_contact_no`,
	CASE 
		WHEN c.status IN (4,6,7) THEN FROM_UNIXTIME(c.disbursed_datetime, '%Y-%m-%d')
		ELSE p.initial_date
	END AS `disbursed_date`,
	CASE 
		WHEN p.status = 0 THEN 'Draft'
		WHEN p.status = 1 THEN 'Pending approval'
		WHEN p.status = 2 THEN 'Pending approval'
		WHEN p.status = 3 THEN 'Approved'
		WHEN p.status = 4 THEN 'Cancelled'
		ELSE NULL
	END `ringi_status`,
	CASE 
		WHEN c.status = 0 THEN 'Pending'
		WHEN c.status = 1 THEN 'Pending Approval'
		WHEN c.status = 2 THEN 'Pending Disbursement'
		WHEN c.status = 3 THEN 'Disbursement Approval'
		WHEN c.status = 4 THEN 'Active'
		WHEN c.status = 5 THEN 'Cancelled'
		WHEN c.status = 6 THEN 'Refinance'
		WHEN c.status = 7 THEN 'Closed'
		ELSE NULL
	END `contract_status`,
	CEIL(p.loan_amount /
		CASE
			p.trading_currency 
			WHEN 'USD' THEN 1
			WHEN 'LAK' THEN cr.usd2lak
			WHEN 'THB' THEN cr.usd2thb
		END
	) AS `usd_loan_amount`, 
	p.monthly_interest , 
	CEIL(p.fee /
		CASE
			p.trading_currency 
			WHEN 'USD' THEN 1
			WHEN 'LAK' THEN cr.usd2lak
			WHEN 'THB' THEN cr.usd2thb
		END
	) AS `usd_fee`,
	p.no_of_payment , 
	p.min_repayment_period ,
	CEIL(p.refinance_amount /
		CASE
			p.trading_currency 
			WHEN 'USD' THEN 1
			WHEN 'LAK' THEN cr.usd2lak
			WHEN 'THB' THEN cr.usd2thb
		END
	) AS `usd_refinance_amount`,
	CEIL(p.net_payment_amount /
		CASE
			p.trading_currency 
			WHEN 'USD' THEN 1
			WHEN 'LAK' THEN cr.usd2lak
			WHEN 'THB' THEN cr.usd2thb
		END
	) AS `usd_net_payment_amount`,
	CASE 
		WHEN p.customer_intro_approach = 1 THEN '①-1 5way (Finance company),'
		WHEN p.customer_intro_approach = 2 THEN '①-2 5way (Vehicle dealer/repair shop),'
		WHEN p.customer_intro_approach = 3 THEN '①-4 5way (Others),'
		WHEN p.customer_intro_approach = 4 THEN '② Facebook,'
		WHEN p.customer_intro_approach = 5 THEN '③-1 Sales partner (from existing customer),'
		WHEN p.customer_intro_approach = 6 THEN '③-2 Sales partner (from dormant customer),'
		WHEN p.customer_intro_approach = 7 THEN '③-3 Sales partner (from prospect customer),'
		WHEN p.customer_intro_approach = 8 THEN '③-4 Contact number of own calls,'
		WHEN p.customer_intro_approach = 9 THEN '④ Sales partner with past referral history,'
		WHEN p.customer_intro_approach = 10 THEN '⑤ Approach of subordinate CC of unit leader and above,'
		WHEN p.customer_intro_approach = 11 THEN '⑥ Introduced by employees in indirect departments,'
		WHEN p.customer_intro_approach = 12 THEN '⑦ Refinancing from competitors'
	END AS `approach_en`,
	CASE 
		WHEN p.customer_intro_approach = 1 THEN '①-1 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູ່ ບໍລິສັດການເງິນ ເຊັ່ນ: ທະນາຄານ, ບ/ສ ສິນເຊື່ອ...),'
		WHEN p.customer_intro_approach = 2 THEN '①-2 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູ່ ຮ້ານ​ຂາຍລົດ / ຮ້ານ​ສ້ອມ​ແປງລົດ​),'
		WHEN p.customer_intro_approach = 3 THEN '①-4 5ສາຍພົວພັນ (ທີ່ເຮັດວຽກຢູບ່ອນອື່ນໆ ນອກຈາກ 3ຂໍ້ເທິງ),'
		WHEN p.customer_intro_approach = 4 THEN '② ຈາກ Facebook,'
		WHEN p.customer_intro_approach = 5 THEN '③-1 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ປັດຈຸບັນ​),'
		WHEN p.customer_intro_approach = 6 THEN '③-2 Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ເກົ່າ​),'
		WHEN p.customer_intro_approach = 7 THEN '③-3​ Sales partner (ທີ່ເປັນລູກ​ຄ້າ​ສົນໃຈ​),'
		WHEN p.customer_intro_approach = 8 THEN '③-4​ ໄດ້ຈາກການໂທ ແລະ ຫາດ້ວຍຕົນເອງ,'
		WHEN p.customer_intro_approach = 9 THEN '④ Sales partner ທີ່ເຄີຍແນະນຳໃນອາດີດ,'
		WHEN p.customer_intro_approach = 10 THEN '⑤ ຈາກການໂທ 200-3-3-1 ຂອງ CC ພາຍໃຕ້ຕົນເອງ,'
		WHEN p.customer_intro_approach = 11 THEN '⑥ ແນະນໍາຈາກ ພະແນກພາຍໃນ,'
		WHEN p.customer_intro_approach = 12 THEN '⑦ ປິດງວດຈາກບໍລິສັດຄູ່ແຂ່ງ'
	END AS `approach_la`,
    p.broker_id ,
	CONVERT(CAST(CONVERT(CONCAT( b.first_name , " ",b.last_name ) USING latin1) AS BINARY) USING utf8) `broker_name`, 
	CASE WHEN LEFT (RIGHT (REPLACE ( b.contact_no, ' ', '') ,8),1) = '0' THEN CONCAT('903',RIGHT (REPLACE ( b.contact_no, ' ', '') ,8))
	    WHEN LENGTH (REPLACE ( b.contact_no, ' ', '')) = 7 THEN CONCAT('9030',REPLACE ( b.contact_no, ' ', ''))
	    ELSE CONCAT('9020', right(REPLACE ( b.contact_no, ' ', '') , 8))
	END `broker_tel`,
	UPPER(
		CASE 
			WHEN p.broker_id = 0 THEN NULL
			WHEN us2.nickname = 'Mee' THEN CONCAT(us.staff_no, ' - ', us.nickname) 
			WHEN us2.staff_no IS NOT NULL THEN CONCAT(us2.staff_no, ' - ', us2.nickname) ELSE CONCAT(us.staff_no, ' - ', us.nickname)
		END 
		) AS `acquire_by`, 
	CONCAT(us.staff_no, ' - ', UPPER(us.nickname)) AS `salesperson`,
	CONCAT(ucc.staff_no, ' - ', UPPER(ucc.nickname)) AS `callcenter_of_sales`,
	CONCAT(udc.staff_no, ' - ', UPPER(udc.nickname)) AS `double_count` ,
	CONCAT(uns.staff_no, ' - ', UPPER(uns.nickname)) AS `non_sales`
FROM tblcontract c 
RIGHT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblcustomer cu ON (cu.id = p.customer_id)
LEFT JOIN tblcontract cpre ON (cpre.id = p.refinance_id)
left join tblcurrencyrate cr on (cr.date_for = DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01') )
LEFT JOIN tbluser us ON (us.id = p.salesperson_id)
LEFT JOIN tbluser ucc ON (ucc.id = p.cc_salesperson_id)
LEFT JOIN tbluser udc ON (udc.id = p.double_count_person_id)
LEFT JOIN tbluser uns ON (uns.id = p.non_salesperson_id)
LEFT JOIN tbluser us2 ON (us2.id = p.broker_acquire_salesperson_id)
LEFT JOIN tblbroker b ON (b.id = p.broker_id)
WHERE 
		( c.status IN (4, 6, 7)
		AND FROM_UNIXTIME(c.disbursed_datetime, '%Y-%m-%d') >= DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')
		)
	OR 
		( p.initial_date >= DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01') 
		)
;






-- 3. HC Execution plan from Frappe
-- Run on server frappe 13.250.153.252
TRUNCATE sme_hc_result; 

INSERT INTO sme_hc_result
SELECT 
	NULL AS `id`,
	bp.contract_no AS `contract_no` ,
	NULL AS `customer_id`,
	bp.customer_name AS `customer_name`,
	bp.customer_tel AS `main_contact_no`,
	NULL `sec_contact_no`,
	bp.disbursement_date_pay_date AS `disbursed_date`,
	bp.ringi_status AS `ringi_status`,
	bp.contract_status AS `contract_status`,
	NULL AS `approach_en`,
	bp.approch_list `approach_la`,
	NULL AS `broker_id` ,
	NULL `broker_name`, 
	NULL `broker_tel`,
	NULL `acquire_by`, 
	bp.staff_no `salesperson`,
	CURRENT_TIMESTAMP() AS `date_created` 
FROM tabSME_BO_and_Plan bp 
WHERE bp.disbursement_date_pay_date >= DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')
;


SELECT * FROM sme_hc_result;

-- 4. Remove duplicate
DELETE
FROM
	sme_hc_result
WHERE
	id IN (
	SELECT
		id
	FROM
		(
		SELECT
			id ,
			ROW_NUMBER() OVER (PARTITION BY main_contact_no, contract_no
		ORDER BY id ASC,
			FIELD(`contract_status`, "Active", "Closed", "Refinance", "Contracted", "Pending disbursement", "Will contract", "Cancelled")
			) AS row_numbers
		FROM
			sme_hc_result 
			) AS t1
	WHERE
		row_numbers > 1
);



-- check the result by Broker (SUM data)
SELECT broker_tel, 
    SUM(CASE 
        WHEN COALESCE(contract_status, '') NOT IN ('Active', 'Closed', 'Refinance') 
        AND (DATE(disbursed_date) < CURRENT_DATE() OR disbursed_date IS NULL) 
        THEN 1 ELSE 0 
    END) AS `shr_prospect`,
    SUM(CASE 
        WHEN COALESCE(contract_status, '') NOT IN ('Active', 'Closed', 'Refinance') 
        AND DATE(disbursed_date) >= CURRENT_DATE() 
        THEN 1 ELSE 0 
    END) AS `shr_will_contract`,
    SUM(CASE 
        WHEN COALESCE(contract_status, '') IN ('Active', 'Closed', 'Refinance') 
        THEN 1 ELSE 0 
    END) AS `shr_contracted`
FROM sme_hc_result 
WHERE broker_tel IS NOT NULL 
GROUP BY broker_tel ; 


-- check the result by Broker (ROW DATA)
SELECT broker_tel, disbursed_date , ringi_status , contract_status 
FROM sme_hc_result 
WHERE broker_tel = '902099965547';




-- SME_SP
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.credit, sp.rank_of_credit, sp.credit_remark, ts.pbx_status `LCC check`, 
	sp.relationship,
	sp.business_type, 
	(case when sp.currency = 'USD' then 1 when sp.currency = 'THB' then 1/35.10 when sp.currency = 'LAK' then 1/23480.00 end) * sp.amount `USD_amount`,
	case when left(sp.`rank`, locate(' -', sp.`rank`)-1) in ('X') then 'Contracted'
	when left(sp.`rank`, locate(' -', sp.`rank`)-1) in ('S', 'A', 'B', 'C') then 'SABC' else 'no' 
end `introduce status`,
	sp.send_wa, sp.wa_date, 
	case when sp.send_wa != '' and sp.wa_date >= '2025-02-01' then 'Sent' else 'x' end `wa_send_status`,
	case when sp.modified >= '2025-02-01'  then 'called' else 'x' end `call_ status`,
	timestampdiff(month,creation, now()) as `month_introduce`,
	shr.shr_prospect AS `shr_prospect`,
	shr.shr_will_contract AS `shr_will_contract`, 
	shr.shr_contracted AS `shr_contracted`
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
left join temp_sme_pbx_SP ts on (ts.id = sp.name)
LEFT JOIN (SELECT broker_tel, 
                SUM(CASE 
                    WHEN COALESCE(contract_status, '') NOT IN ('Active', 'Closed', 'Refinance') 
                    AND (DATE(disbursed_date) < CURRENT_DATE() OR disbursed_date IS NULL) 
                    THEN 1 ELSE 0 
                END) AS `shr_prospect`,
                SUM(CASE 
                    WHEN COALESCE(contract_status, '') NOT IN ('Active', 'Closed', 'Refinance') 
                    AND DATE(disbursed_date) >= CURRENT_DATE() 
                    THEN 1 ELSE 0 
                END) AS `shr_will_contract`,
                SUM(CASE 
                    WHEN COALESCE(contract_status, '') IN ('Active', 'Closed', 'Refinance') 
                    THEN 1 ELSE 0 
                END) AS `shr_contracted`
            FROM sme_hc_result 
            WHERE broker_tel IS NOT NULL 
            GROUP BY broker_tel) shr ON (sp.broker_tel = shr.broker_tel)
where sp.refer_type = 'LMS_Broker' 
order by sme.id limit 10;


-- 5. Export Existing and Dormant 
-- To https://docs.google.com/spreadsheets/d/1v0T5Sdwi5uQZAPgE0AoQ1H5uqDdm0cwDinxiWQUyjXc/edit?gid=441719071#gid=441719071
select apl.contract_no, 
	sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	apl.approach_type,
	apl.usd_loan_amount_old, apl.usd_now_amount ,
	apl.customer_name, 
	apl.address_province_and_city, apl.address_village,
	-- concat('https://portal01.lalco.la:1901/salesresultreport_v3_dormant_view.php?contractid=', contract_id) `edit`,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', apl.name) as `edit`,
	-- customer
	/*tsc.customer_neg_updated, tsc.customer_visited, tsc.customer_rank, tsdi.pbx_status `customer_pbx`, null `customer_disburse_date`, tsc.customer_nego_by, */
	date_format(apl.modified, '%Y-%m-%d') as `customer_neg_updated`, left(apl.visit_or_not, locate('-', apl.visit_or_not)-2) as `customer_visited`, apl.rank_update as `customer_rank`, tsdi.pbx_status `customer_pbx`, apl.disbursement_date_pay_date as `customer_disburse_date`, apl.modified_by as customer_nego_by,
	-- gurantor
	tsc.guarantor_neg_updated, tsc.guarantor_visited, tsc.guarantor_rank, null as `guarantor_pbx`, null `guarantor_disburse_date`, tsc.guarantor_nego_by,
	-- agent contact
	tsc.agent_contact_neg_updated, tsc.agent_contact_visited, tsc.agent_contact_rank, null as `agent_contact_pbx`, null `agent_contact_disburse_date`, tsc.agent_contact_nego_by,
	contract_id, 
	apl.car_buying_price - apl.usd_now_amount as `usd_Inc_amount`,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', apl.name) `Frappe_edit`,
	apl.car_type, concat(apl.maker, ' - ', apl.model) as `car`, apl.usd_loan_amount, 
	case when apl.is_sales_partner = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ' then 'Yes'
		when apl.is_sales_partner = 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ' then 'Yes'
		when apl.is_sales_partner = 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ' then 'Yes'
		else 'No'
	end as `is_sales_partner`,
	apl.send_wa,
	shr.disbursed_date AS `shr_disbursed_date`,
	shr.ringi_status as `shr_ringi_status`,
	shr.contract_status as `shr_contract_status`
from tabSME_Approach_list apl 
inner join temp_sme_calldata_Dor_Inc tsc on (apl.approach_id = tsc.contract_no)
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
left join temp_sme_dor_inc tsdi on (apl.approach_id = tsdi.contract_no)
LEFT JOIN sme_hc_result shr ON (apl.customer_tel = shr.main_contact_no )
where apl.approach_type = 'Dormant' -- 'Existing'
order by sme.id asc;



































