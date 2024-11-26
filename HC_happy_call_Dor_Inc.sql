
-- ______________________________________________________________________ Prepare list and import to table ______________________________________________________________________
-- 1) Dormant customer list TO Frappe: https://docs.google.com/spreadsheets/d/1iVswJM9II_feB_tOAG5HQjtMh8BtOs5i6p39TaBR9vE/edit?gid=0#gid=0

-- 2) Existing customer list TO Frappe: https://docs.google.com/spreadsheets/d/1d5FKQmqZSWNg_b2W4x4g14WGE6bp0vVS4APR3SzdUhg/edit?gid=0#gid=0


-- ______________________________________________________________________ Udpate call and visited result ______________________________________________________________________

-- 1) Create table temp_calldata_Dor_Inc on Frappe 13.250.153.252/_8abac9eed59bf169 and server 172.16.11.30/ sme_salesresult
create table `temp_sme_calldata_Dor_Inc` (
	`contract_no` int(11) not null auto_increment,
	`customer_neg_updated` date default null,
	`customer_visited` varchar(255) default null,
	`customer_rank` varchar(255) default null,
	`customer_nego_by` varchar(255) default null,
	`guarantor_neg_updated` date default null,
	`guarantor_visited` varchar(255) default null,
	`guarantor_rank` varchar(255) default null,
	`guarantor_nego_by` varchar(255) default null,
	`agent_contact_neg_updated` date default null,
	`agent_contact_visited` varchar(255) default null,
	`agent_contact_rank` varchar(255) default null,
	`agent_contact_nego_by` varchar(255) default null,
	primary key (`contract_no`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


-- 2) create temp table on 172.16.11.30/ sme_salesresult for reduce the data to updating
CREATE TABLE `temp_dormant_and_existing` (
	`id` int NOT NULL AUTO_INCREMENT,
	`contract_no` int NOT NULL,
	`neg_updated` date DEFAULT NULL,
	`neg_with` varchar(255) DEFAULT NULL,
	`visit_or_not` varchar(255) DEFAULT NULL,
	`rank_after_visited` varchar(255) DEFAULT NULL,
	`last_nego_staff_no` varchar(255) DEFAULT NULL,
	`last_nego_name` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `idx_contract_no` (`contract_no`),
	KEY `idx_neg_updated` (`neg_updated`),
	KEY `idx_neg_with` (`neg_with`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


-- 3) Insert data from table `tabSME_Approach_list` to `temp_sme_calldata_Dor_Inc`
replace into temp_sme_calldata_Dor_Inc (`contract_no`)
select approach_id `contract_no` from tabSME_Approach_list where approach_type in ('Dormant', 'Existing');


-- 4) Export data from Frappe 13.250.153.252/_8abac9eed59bf169/`temp_sme_calldata_Dor_Inc` to 172.16.11.30/ sme_salesresult/temp_sme_calldata_Dor_Inc
select * from temp_sme_calldata_Dor_Inc;


-- 5) insert data from dormant_and_existing to temp_dormant_and_existing in 172.16.11.30/ sme_salesresult
replace into temp_dormant_and_existing
SELECT id, contract_no, 
	neg_updated, neg_with,
	visit_or_not, rank_after_visited,
	last_nego_staff_no, last_nego_name
FROM dormant_and_existing
WHERE str_to_date(neg_updated, '%Y-%m-%d') >= date_format(now(), '%Y-%m-01');


-- 6) Check and update data in 172.16.11.30/ sme_salesresult
replace into temp_sme_calldata_Dor_Inc
select tsc.contract_no,
	-- customer result
	`decus`.neg_updated as `customer_neg_updated`,
	`decus`.visit_or_not as `customer_visited`,
	SUBSTRING_INDEX(`decus`.rank_after_visited, ' ', 1) as `customer_rank`,
	concat(`decus`.last_nego_staff_no, ' - ', `decus`.last_nego_name ) as `customer_nego_by`,
	-- guarantor result
	`degua`.neg_updated as `guarantor_neg_updated`,
	`degua`.visit_or_not as `guarantor_visited`,
	SUBSTRING_INDEX(`degua`.rank_after_visited, ' ', 1) as `guarantor_rank`,
	concat(`degua`.last_nego_staff_no, ' - ', `degua`.last_nego_name ) as `guarantor_nego_by`,
	-- agent contact result
	`deage`.neg_updated as `agent_contact_neg_updated`,
	`deage`.visit_or_not as `agent_contact_visited`,
	SUBSTRING_INDEX(`deage`.rank_after_visited, ' ', 1) as `agent_contact_rank`,
	concat(`deage`.last_nego_staff_no, ' - ', `deage`.last_nego_name ) as `agent_contact_nego_by`
from temp_sme_calldata_Dor_Inc tsc
left join temp_dormant_and_existing `decus` on `decus`.id = (select id from temp_dormant_and_existing where contract_no = tsc.contract_no and neg_updated >= date_format(now(), '%Y-%m-01') and SUBSTRING_INDEX(neg_with, ' -', 1) = 'Customer' order by id desc limit 1)
left join temp_dormant_and_existing `degua` on `degua`.id = (select id from temp_dormant_and_existing where contract_no = tsc.contract_no and neg_updated >= date_format(now(), '%Y-%m-01') and SUBSTRING_INDEX(neg_with, ' -', 1) = 'Guarantor' order by id desc limit 1)
left join temp_dormant_and_existing `deage` on `deage`.id = (select id from temp_dormant_and_existing where contract_no = tsc.contract_no and neg_updated >= date_format(now(), '%Y-%m-01') and SUBSTRING_INDEX(neg_with, ' -', 1) not in ('Customer', 'Guarantor') order by id desc limit 1)
;


-- 7) Export from 172.16.11.30/ sme_salesresult/temp_sme_calldata_Dor_Inc to 13.250.153.252/_8abac9eed59bf169/`temp_sme_calldata_Dor_Inc` 
select * from temp_sme_calldata_Dor_Inc;


-- 8) DOrmant export list https://docs.google.com/spreadsheets/d/1v0T5Sdwi5uQZAPgE0AoQ1H5uqDdm0cwDinxiWQUyjXc/edit?gid=1576431777#gid=1576431777
select apl.contract_no, 
	sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	apl.approach_type,
	apl.usd_loan_amount_old, apl.usd_now_amount ,
	apl.customer_name, 
	apl.address_province_and_city, apl.address_village,
	concat('https://portal01.lalco.la:1901/salesresultreport_v3_dormant_view.php?contractid=', contract_id) `edit`,
	tsc.customer_neg_updated, tsc.customer_visited, tsc.customer_rank, null as `customer_pbx`, null `customer_disburse_date`, tsc.customer_nego_by,
	tsc.guarantor_neg_updated, tsc.guarantor_visited, tsc.guarantor_rank, null as `customer_pbx`, null `guarantor_disburse_date`, tsc.guarantor_nego_by,
	tsc.agent_contact_neg_updated, tsc.agent_contact_visited, tsc.agent_contact_rank, null as `customer_pbx`, null `agent_contact_disburse_date`, tsc.agent_contact_nego_by 
from tabSME_Approach_list apl 
inner join temp_sme_calldata_Dor_Inc tsc on (apl.approach_id = tsc.contract_no)
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
where apl.approach_type = 'Dormant'
-- where apl.approach_type = 'Existing'
order by sme.id asc;



-- ______________________________________________________________________ Export list for Non-sales ______________________________________________________________________
-- Dormant list for Non-sales
select apl.creation,
	apl.staff_no,
	apl.customer_name ,
	apl.customer_tel ,
	apl.address_province_and_city ,
	apl.address_village ,
	apl.maker ,
	apl.model ,
	apl.year ,
	apl.approach_id ,
	apl.currency ,
	apl.usd_loan_amount_old ,
	apl.usd_now_amount ,
	sme.unit_no, sme.unit ,
	case 
		when sme.unit_no = 1 then '1003 - KHAM'
		when sme.unit_no = 2 then '623 - TOU'
		when sme.unit_no = 3 then '3197 - KOUNG'
		when sme.unit_no = 4 then '3306 - JING'
		when sme.unit_no = 5 then '317 - TA'
		when sme.unit_no = 6 then '317 - TA'
		when sme.unit_no = 7 then '4380 - BO'
		when sme.unit_no = 8 then '4380 - BO'
		when sme.unit_no = 9 then '1168 - THIP'
		when sme.unit_no = 10 then '303 - PHIK'
		when sme.unit_no = 11 then '303 - PHIK'
		when sme.unit_no = 12 then '3434 - NAMFON'
		when sme.unit_no = 13 then '2233 - PAENG'
		when sme.unit_no = 14 then '2904 - KOUNG'
		when sme.unit_no = 15 then '2904 - KOUNG'
		when sme.unit_no = 16 then '763 - MOS'
		when sme.unit_no = 17 then '4416 - DETH'
		when sme.unit_no = 18 then '4416 - DETH'
		when sme.unit_no = 19 then '3005 - LAY'
		when sme.unit_no = 20 then '4242 - NOP'
		when sme.unit_no = 21 then '4242 - NOP'
		when sme.unit_no = 22 then '2349 - PHET'
		when sme.unit_no = 23 then '2349 - PHET'
		when sme.unit_no = 24 then '4483 - NOY'
		when sme.unit_no = 25 then '2451 - PUPIEW'
		when sme.unit_no = 26 then '2451 - PUPIEW'
		when sme.unit_no = 27 then '361 - HONEY'
		when sme.unit_no = 28 then '361 - HONEY'
		when sme.unit_no = 29 then '3694 - JEN'
		when sme.unit_no = 30 then '1603 - NUN'
		when sme.unit_no = 31 then '3628 - MEE'
		when sme.unit_no = 32 then '3628 - MEE'
		when sme.unit_no = 33 then '1328 - PARN'
		when sme.unit_no = 34 then '1328 - PARN'
		when sme.unit_no = 35 then '3415 - NOUK'
		when sme.unit_no = 36 then '3415 - NOUK'
		when sme.unit_no = 37 then '3701 - AONG'
		when sme.unit_no = 38 then '3736 - AIRNOY'
		when sme.unit_no = 39 then '1289 - ALEX'
		when sme.unit_no = 40 then '1289 - ALEX'
		when sme.unit_no = 41 then '3305 - MAY'
		when sme.unit_no = 42 then '3305 - MAY'
		when sme.unit_no = 43 then '3099 - JIJY'
		when sme.unit_no = 44 then '3099 - JIJY'
		when sme.unit_no = 45 then '284 - AM'
		when sme.unit_no = 46 then '284 - AM'
		when sme.unit_no = 47 then '1152 - NOY'
		when sme.unit_no = 48 then '1563 - MON'
		when sme.unit_no = 49 then '1353 - NOUT'
		when sme.unit_no = 50 then '1465 - NOUK'
		when sme.unit_no = 51 then '1465 - NOUK'
		when sme.unit_no = 52 then '469 - SANG'
		when sme.unit_no = 53 then '469 - SANG'
		when sme.unit_no = 54 then '273 - PHONE'
		when sme.unit_no = 55 then '273 - PHONE'
		when sme.unit_no = 56 then '3444 - TANOY'
		when sme.unit_no = 57 then '3444 - TANOY'
		when sme.unit_no = 58 then '1065 - KAB'
		when sme.unit_no = 59 then '1072 - BO'
		when sme.unit_no = 60 then '1072 - BO'
		when sme.unit_no = 61 then '419 - KER'
		when sme.unit_no = 62 then '419 - KER'
		when sme.unit_no = 63 then '2053 - KOUNGKING'
		when sme.unit_no = 64 then '2053 - KOUNGKING'
		when sme.unit_no = 65 then '3932 - NAKHAO'
		when sme.unit_no = 66 then '3932 - NAKHAO'
		when sme.unit_no = 67 then '515 - MIENG'
		when sme.unit_no = 68 then '520 - MUA'
		when sme.unit_no = 69 then '1854 - AMUAY'
		when sme.unit_no = 70 then '4417 - MIT'
		when sme.unit_no = 71 then '3632 - ZAI'
		when sme.unit_no = 72 then '3662 - DEUAN'
		when sme.unit_no = 73 then '4458 - TAR'
		when sme.unit_no = 74 then '4457 - DY'
		when sme.unit_no = 75 then '3479 - KHARN'
		when sme.unit_no = 76 then '4463 - LAXAENG'
		when sme.unit_no = 77 then '4464 - MYNO'
		when sme.unit_no = 78 then '4100 - SANUN'
	end 'Non-sales',
	concat('http://13.250.153.252:8000/app/sme_approach_list/', apl.name) as `Edit`,
	apl.rank_update, 
	apl.rank_of_credit,
	apl.reason_of_credit ,
	apl.disbursement_date_pay_date 
from tabSME_Approach_list apl
left join tabsme_Employees emp on (apl.staff_no = emp.name)
left join sme_org sme on (emp.staff_no = sme.staff_no)
where apl.approach_type = 'Dormant'
;



-- Existing list for Non-sales
select apl.creation,
	apl.staff_no,
	apl.customer_name ,
	apl.customer_tel ,
	apl.address_province_and_city ,
	apl.address_village ,
	apl.maker ,
	apl.model ,
	apl.year ,
	apl.approach_id ,
	apl.currency ,
	apl.usd_loan_amount_old ,
	apl.usd_now_amount ,
	sme.unit_no, sme.unit ,
	case 
		when sme.unit_no = 1 then '1003 - KHAM'
		when sme.unit_no = 2 then '623 - TOU'
		when sme.unit_no = 3 then '3197 - KOUNG'
		when sme.unit_no = 4 then '3306 - JING'
		when sme.unit_no = 5 then '317 - TA'
		when sme.unit_no = 6 then '317 - TA'
		when sme.unit_no = 7 then '4380 - BO'
		when sme.unit_no = 8 then '4380 - BO'
		when sme.unit_no = 9 then '1168 - THIP'
		when sme.unit_no = 10 then '303 - PHIK'
		when sme.unit_no = 11 then '303 - PHIK'
		when sme.unit_no = 12 then '3434 - NAMFON'
		when sme.unit_no = 13 then '2233 - PAENG'
		when sme.unit_no = 14 then '2904 - KOUNG'
		when sme.unit_no = 15 then '2904 - KOUNG'
		when sme.unit_no = 16 then '763 - MOS'
		when sme.unit_no = 17 then '4416 - DETH'
		when sme.unit_no = 18 then '4416 - DETH'
		when sme.unit_no = 19 then '3005 - LAY'
		when sme.unit_no = 20 then '4242 - NOP'
		when sme.unit_no = 21 then '4242 - NOP'
		when sme.unit_no = 22 then '2349 - PHET'
		when sme.unit_no = 23 then '2349 - PHET'
		when sme.unit_no = 24 then '4483 - NOY'
		when sme.unit_no = 25 then '2451 - PUPIEW'
		when sme.unit_no = 26 then '2451 - PUPIEW'
		when sme.unit_no = 27 then '361 - HONEY'
		when sme.unit_no = 28 then '361 - HONEY'
		when sme.unit_no = 29 then '3694 - JEN'
		when sme.unit_no = 30 then '1603 - NUN'
		when sme.unit_no = 31 then '3628 - MEE'
		when sme.unit_no = 32 then '3628 - MEE'
		when sme.unit_no = 33 then '1328 - PARN'
		when sme.unit_no = 34 then '1328 - PARN'
		when sme.unit_no = 35 then '3415 - NOUK'
		when sme.unit_no = 36 then '3415 - NOUK'
		when sme.unit_no = 37 then '3701 - AONG'
		when sme.unit_no = 38 then '3736 - AIRNOY'
		when sme.unit_no = 39 then '1289 - ALEX'
		when sme.unit_no = 40 then '1289 - ALEX'
		when sme.unit_no = 41 then '3305 - MAY'
		when sme.unit_no = 42 then '3305 - MAY'
		when sme.unit_no = 43 then '3099 - JIJY'
		when sme.unit_no = 44 then '3099 - JIJY'
		when sme.unit_no = 45 then '284 - AM'
		when sme.unit_no = 46 then '284 - AM'
		when sme.unit_no = 47 then '1152 - NOY'
		when sme.unit_no = 48 then '1563 - MON'
		when sme.unit_no = 49 then '1353 - NOUT'
		when sme.unit_no = 50 then '1465 - NOUK'
		when sme.unit_no = 51 then '1465 - NOUK'
		when sme.unit_no = 52 then '469 - SANG'
		when sme.unit_no = 53 then '469 - SANG'
		when sme.unit_no = 54 then '273 - PHONE'
		when sme.unit_no = 55 then '273 - PHONE'
		when sme.unit_no = 56 then '3444 - TANOY'
		when sme.unit_no = 57 then '3444 - TANOY'
		when sme.unit_no = 58 then '1065 - KAB'
		when sme.unit_no = 59 then '1072 - BO'
		when sme.unit_no = 60 then '1072 - BO'
		when sme.unit_no = 61 then '419 - KER'
		when sme.unit_no = 62 then '419 - KER'
		when sme.unit_no = 63 then '2053 - KOUNGKING'
		when sme.unit_no = 64 then '2053 - KOUNGKING'
		when sme.unit_no = 65 then '3932 - NAKHAO'
		when sme.unit_no = 66 then '3932 - NAKHAO'
		when sme.unit_no = 67 then '515 - MIENG'
		when sme.unit_no = 68 then '520 - MUA'
		when sme.unit_no = 69 then '1854 - AMUAY'
		when sme.unit_no = 70 then '4417 - MIT'
		when sme.unit_no = 71 then '3632 - ZAI'
		when sme.unit_no = 72 then '3662 - DEUAN'
		when sme.unit_no = 73 then '4458 - TAR'
		when sme.unit_no = 74 then '4457 - DY'
		when sme.unit_no = 75 then '3479 - KHARN'
		when sme.unit_no = 76 then '4463 - LAXAENG'
		when sme.unit_no = 77 then '4464 - MYNO'
		when sme.unit_no = 78 then '4100 - SANUN'
	end 'Non-sales',
	concat('http://13.250.153.252:8000/app/sme_approach_list/', apl.name) as `Edit`,
	apl.rank_update, 
	apl.rank_of_credit,
	apl.reason_of_credit ,
	apl.disbursement_date_pay_date 
from tabSME_Approach_list apl
left join tabsme_Employees emp on (apl.staff_no = emp.name)
left join sme_org sme on (emp.staff_no = sme.staff_no)
where apl.approach_type = 'Existing'
;




