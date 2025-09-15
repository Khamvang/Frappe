
SHOW INDEX FROM tabSME_Approach_list;

CREATE INDEX idx_customer ON tabCIB_Information(customer);
CREATE INDEX idx_financial_institute ON tabCIB_Information(financial_institute);

CREATE INDEX idx_contract_no ON tabCIB_customer(contract_no);


SELECT * FROM `tabCIB_Information` tci 

SELECT *, SUBSTRING_INDEX(name, ' -', 1) FROM tabCIB_customer




-- import data Dormant customer from tabSME_Approach_list to tabCIB_customer
INSERT INTO tabCIB_customer 
	(`name`, `contract_no`, `full_name`, `tel_no`)
SELECT 
	CONCAT(approach_id, ' - ', customer_name, ' - ', customer_tel, ' - ', address_province_and_city, ' - ', address_village ) AS `name`,
	approach_id AS `contract_no`,
	customer_name AS `full_name`,
	customer_tel AS `tel_no`
FROM tabSME_Approach_list tsal 
WHERE approach_type = 'Dormant'
	AND approach_id NOT IN (SELECT contract_no FROM tabCIB_customer)
;



-- Get data from LMS to Frappe
SELECT 
	NULL AS `name`,
	FROM_UNIXTIME(p.credit_approved_datetime, '%Y-%m-%d' ) AS `creation`,
	dibdt.date_created AS `modified`,
	'Administrator' AS `modified_by`,
	'Administrator' AS `owner`,
	CONCAT(c.contract_no, ' - ',
		CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8), ' - ', 
		(CASE 
			WHEN LEFT (RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' 
				THEN CONCAT('903',RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8))
			WHEN length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 
				THEN CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
			ELSE CONCAT('9020', RIGHT(REPLACE ( cu.main_contact_no, ' ', '') , 8))
		END), ' - ', 
		CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name), ' - ', 
		CASE 
			WHEN v.village_name_lao IS NOT NULL 
				THEN CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) 
			ELSE ''
		END
	) AS `customer`,
	CASE
		WHEN cib.has_cib = 'Yes' THEN 'Yes - ມີ'
		WHEN cib.has_cib = 'No' THEN 'No - ບໍ່ມີ'
		ELSE 'No - ບໍ່ມີ'
	END AS `cib_result`,
	cib.`financial_institute`,
	cib.`contract_date`,
	cib.`currency`,
	cib.amount AS `loan_amount`,
	cib.`remaining_amount`,
	cib.`delay_days`,
	cib.`cib_ranks` AS `rank`,
	CASE
		WHEN cib.collateral_type = 1 THEN 'ຍານພາຫະນະ'
		WHEN cib.collateral_type = 2 THEN 'ອາຄານ, ອາຄານ ແລະ ທີ່ດິນ, ເຮືອນ, ເຮືອນ ແລະ ທີ່ດິນ, ທີ່ດິນ'
		WHEN cib.collateral_type = 3 THEN 'ອື່ນໆ'
	END AS `collateral_type`,
	CASE
		WHEN cib.collateral_type = 1 THEN cib.cib_valuation_amount
		WHEN cib.collateral_type = 2 THEN cib.real_estate_valuation_amount
		WHEN cib.collateral_type = 3 THEN 0
	END AS `valuation_amount`
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON cu.id = p.customer_id
LEFT JOIN tblvillage v ON cu.address_village_id = v.id
LEFT JOIN tblcity ci ON ci.id = cu.address_city
LEFT JOIN tblprovince pv ON pv.id = cu.address_province
LEFT JOIN tblcib cib ON cib.prospect_id = c.prospect_id
LEFT JOIN tblcibdetail dibdt ON dibdt.cib_id = cib.id
/*
WHERE c.status IN (4, 6, 7)
	AND FROM_UNIXTIME(p.credit_approved_datetime, '%Y-%m-%d') >= '2025-01-01' 
/*
WHERE c.status IN (4, 6, 7)
	AND c.contract_no IN (2041357, 2047996, 2047014, 2045775, 2046587, 2048874, 2050095, 2058190, 2059023, 2058776, 2060184, 2062288, 2062587, 2064660, 2069550, 2068996, 2065733, 2067705, 2067797, 2068421, 2069291, 2069687, 2070191, 2065359, 2072623, 2070747, 2071320, 2073475, 2073976, 2074078, 2074205, 2070910, 2077187, 2084583, 2087416, 2086152, 2086935, 2087606, 2089346, 2088319, 2091253, 2089068, 2090206, 2090836, 2093821, 2094014, 2096458, 2097095, 2097075, 2095770, 2097261, 2098555, 2098662, 2099476, 2098812, 2105782, 2103386, 2103016, 2103087, 2102895, 2105698, 2106478, 2106803, 2104209, 2108261, 2084709, 2103132, 2101897, 2107401, 2108940, 2109606, 2110184, 2093359, 2106088, 2108275, 2108417, 2096768, 2108053, 2103876, 2109985, 2111756, 2105384, 2110966, 2084078, 2107576, 2113220);
;
*/











select id, credit_approved_datetime, FROM_UNIXTIME(p.credit_approved_datetime, '%Y-%m-%d') from tblprospect p where status = 3 order by id desc 




-- Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabCIB_Information);
    
    -- Step 2: Update the auto_increment value for tabCIB_Information
    SET @alter_query = CONCAT('ALTER TABLE tabCIB_Information AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into cib_information_id_seq
	insert into cib_information_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabCIB_Information), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from cib_information_id_seq;





-- Export
SELECT apl.approach_id AS `contract_no`,
	apl.customer_name AS `customer_name`,
	apl.customer_tel AS `customer_tel`,
	apl.date_of_birth,
	SUBSTRING_INDEX(apl.address_province_and_city, ' - ', 1) AS `province`,
	SUBSTRING_INDEX(apl.address_province_and_city, ' - ', -1) AS `district`,
	apl.address_village ,
	apl.usd_loan_amount_old,
	'http://13.250.153.252:8000/app/cib_information/new-cib_information-1' AS `add_CIB`,
	CASE 
		WHEN cicheck.cib_result = 'Yes - ມີ' THEN 'Yes'
		WHEN cicheck.cib_result = 'No - ບໍ່ມີ' THEN 'No'
		ELSE 'Not yet check'
	END AS `cib_result`,
	cihave.financial_institute AS `financial_institute`,
	bc.name_en `financial_name_en`,
	cihave.collateral_type AS `collateral_type`,
	CASE
		WHEN cihave.collateral_type = 'ອາຄານ, ອາຄານ ແລະ ທີ່ດິນ, ເຮືອນ, ເຮືອນ ແລະ ທີ່ດິນ, ທີ່ດິນ' THEN 'Real estate' 
		WHEN cihave.collateral_type = 'ເງິນໃນບັນຊີ ຫລື ເອກະສານມີຄ່າ' THEN 'Money in an account or valuable documents' 
		WHEN cihave.collateral_type = 'ເຄື່ອງຈັກ ຫລື ອຸປະກອນຕ່າງໆ' THEN 'Machinery or equipment' 
		WHEN cihave.collateral_type = 'ໂຄງການ' THEN 'Project program' 
		WHEN cihave.collateral_type = 'ຍານພາຫະນະ' THEN 'Vehicle' 
		WHEN cihave.collateral_type = 'ບຸກ​ຄົນຄ້ຳປະກັນ' THEN 'Guarantor' 
		WHEN cihave.collateral_type = 'ວັດຖຸມີຄ່າ' THEN 'Valuables' 
		WHEN cihave.collateral_type = 'ອື່ນໆ' THEN 'Others' 
	END AS `collateral_type_en`,
	ci1.cib_result AS `cib_result1`,
	ci1.financial_institute AS `financial_institute1`,
	ci1.collateral_type AS `collateral_type1`,
	ci2.cib_result AS `cib_result2`,
	ci2.financial_institute AS `financial_institute2`,
	ci2.collateral_type AS `collateral_type2`,
	ci3.cib_result AS `cib_result3`,
	ci3.financial_institute AS `financial_institute3`,
	ci3.collateral_type AS `collateral_type3`,
	ci4.cib_result AS `cib_result4`,
	ci4.financial_institute AS `financial_institute4`,
	ci4.collateral_type AS `collateral_type4`,
	ci5.cib_result AS `cib_result5`,
	ci5.financial_institute AS `financial_institute5`,
	ci5.collateral_type AS `collateral_type5`
FROM tabSME_Approach_list apl
LEFT JOIN tabCIB_Information cicheck 
	ON cicheck.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) AND cib_result IS NOT NULL ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_Information cihave 
	ON cihave.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) AND cib_result = 'Yes - ມີ' ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_bank_code bc 
	ON (bc.name = cihave.financial_institute )
LEFT JOIN tabCIB_Information ci1 
	ON ci1.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_Information ci2 
	ON ci2.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci3
	ON ci3.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci4
	ON ci4.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci5
	ON ci5.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
WHERE 
	apl.approach_type = 'Dormant'
	AND apl.usd_loan_amount_old >= 10000
;




-- Export only LING-F (own_salesperson = '168 - LING')
SELECT apl.approach_id AS `contract_no`,
	apl.customer_name AS `customer_name`,
	apl.customer_tel AS `customer_tel`,
	apl.date_of_birth,
	SUBSTRING_INDEX(apl.address_province_and_city, ' - ', 1) AS `province`,
	SUBSTRING_INDEX(apl.address_province_and_city, ' - ', -1) AS `district`,
	apl.address_village ,
	apl.usd_loan_amount_old,
	'http://13.250.153.252:8000/app/cib_information/new-cib_information-1' AS `add_CIB`,
	CASE 
		WHEN cicheck.cib_result = 'Yes - ມີ' THEN 'Yes'
		WHEN cicheck.cib_result = 'No - ບໍ່ມີ' THEN 'No'
		ELSE 'Not yet check'
	END AS `cib_result`,
	cihave.financial_institute AS `financial_institute`,
	bc.name_en `financial_name_en`,
	cihave.collateral_type AS `collateral_type`,
	CASE
		WHEN cihave.collateral_type = 'ອາຄານ, ອາຄານ ແລະ ທີ່ດິນ, ເຮືອນ, ເຮືອນ ແລະ ທີ່ດິນ, ທີ່ດິນ' THEN 'Real estate' 
		WHEN cihave.collateral_type = 'ເງິນໃນບັນຊີ ຫລື ເອກະສານມີຄ່າ' THEN 'Money in an account or valuable documents' 
		WHEN cihave.collateral_type = 'ເຄື່ອງຈັກ ຫລື ອຸປະກອນຕ່າງໆ' THEN 'Machinery or equipment' 
		WHEN cihave.collateral_type = 'ໂຄງການ' THEN 'Project program' 
		WHEN cihave.collateral_type = 'ຍານພາຫະນະ' THEN 'Vehicle' 
		WHEN cihave.collateral_type = 'ບຸກ​ຄົນຄ້ຳປະກັນ' THEN 'Guarantor' 
		WHEN cihave.collateral_type = 'ວັດຖຸມີຄ່າ' THEN 'Valuables' 
		WHEN cihave.collateral_type = 'ອື່ນໆ' THEN 'Others' 
	END AS `collateral_type_en`,
	ci1.cib_result AS `cib_result1`,
	ci1.financial_institute AS `financial_institute1`,
	ci1.collateral_type AS `collateral_type1`,
	ci2.cib_result AS `cib_result2`,
	ci2.financial_institute AS `financial_institute2`,
	ci2.collateral_type AS `collateral_type2`,
	ci3.cib_result AS `cib_result3`,
	ci3.financial_institute AS `financial_institute3`,
	ci3.collateral_type AS `collateral_type3`,
	ci4.cib_result AS `cib_result4`,
	ci4.financial_institute AS `financial_institute4`,
	ci4.collateral_type AS `collateral_type4`,
	ci5.cib_result AS `cib_result5`,
	ci5.financial_institute AS `financial_institute5`,
	ci5.collateral_type AS `collateral_type5`,
	apl.own_salesperson,
	-- 
	-- For checking which case check by Credit and which from LMS
	apl.first_payment_date_old,
	cicheck.modified,
	cicheck.modified_by -- IF [Administrator] = from [LMS] ELSE from credit
FROM tabSME_Approach_list apl
LEFT JOIN tabCIB_Information cicheck 
	ON cicheck.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) AND cib_result IS NOT NULL ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_Information cihave 
	ON cihave.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) AND cib_result = 'Yes - ມີ' ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_bank_code bc 
	ON (bc.name = cihave.financial_institute )
LEFT JOIN tabCIB_Information ci1 
	ON ci1.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_Information ci2 
	ON ci2.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci3
	ON ci3.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci4
	ON ci4.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci5
	ON ci5.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
WHERE 
	apl.approach_type = 'Dormant'
	AND apl.own_salesperson = '168 - LING'
;



select * from tabCIB_Information
where SUBSTRING_INDEX(customer, ' -', 1) IN (2046587, 2058190, 2062587, 2069550, 2068996, 2072623, 2070747, 2074078, 2074205, 2086152, 2086935, 2089346, 2091253, 2093821, 2096458, 2097095, 2103016, 2106803, 2103132, 2108940, 2108417, 2105384, 2110966, 2084078)
	and financial_institute != ''




SELECT *
FROM tabCIB_Information

SELECT * FROM tabCIB_bank_code 
WHERE name_en = ' DGB LEASING COMPANY'


UPDATE tabCIB_bank_code
SET short_name = name ;



-- Create Triger to update the key
DELIMITER $$

CREATE TRIGGER trg_update_name_before_insert
BEFORE INSERT ON tabCIB_bank_code
FOR EACH ROW
BEGIN
    SET NEW.name = NEW.short_name;
END$$

DELIMITER ;




-- ----------------------- COO want to check the CIB for -----------------------


-- To Export Dormant list from lalco 18.140.117.112 to Frappe table tabSME_Approach_list
SELECT DISTINCT
    NOW() AS creation,
    'Administrator' AS owner,
    NULL AS staff_no,
    CONCAT(us.staff_no, ' - ', upper(us.nickname)) as `own_salesperson`,
    CASE WHEN c.status = 4 THEN 'Inc' else 'Dor' end AS type,
    c.contract_no AS contract_no,
    c.id AS 'contract_id',
	cu.id AS case_no,
    CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
    CASE 
	    WHEN LEFT (RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' 
			THEN CONCAT('903',RIGHT (REPLACE ( cu.main_contact_no, ' ', '') ,8))
		WHEN length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 
			THEN CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
		ELSE CONCAT('9020', RIGHT(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	END AS `customer_tel`,
    cu.date_of_birth,
    CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name) AS address_province_and_city,
    CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) AS address_village,
    car.car_make AS maker, 
    CONVERT(CAST(CONVERT(car.car_model USING latin1) as binary) USING utf8) AS model, 
    av.collateral_year AS year,
    am.min_buying_price AS `car_buying_price`,
	CASE 
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Saysetha' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Samakkhixay' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Sanamxay' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Sanxay' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Attapeu' AND ci.city_name = 'Phouvong' THEN 'Attapue'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Houay Xay' THEN 'Bokeo'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Ton Pheung' THEN 'Tonpherng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Meung' THEN 'Tonpherng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Pha Oudom' THEN 'Bokeo'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Bokeo' AND ci.city_name = 'Pak Tha' THEN 'Bokeo'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Paksane' THEN 'Paksan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Thaphabat' THEN 'Paksan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Pakkading' THEN 'Pakkading'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Borikhane' THEN 'Paksan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Khamkeut' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Viengthong' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Borikhamxay' AND ci.city_name = 'Xaychamphone' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Pak Se' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Sanasomboun' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Batiengchaleunsouk' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Paksong' THEN 'Paksxong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Pathouphone' THEN 'Pakse'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Phonthong' THEN 'Chongmeg'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Champassack' THEN 'Sukhuma'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Soukhoumma' THEN 'Sukhuma'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Mounlapamok' THEN 'Khong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Champasack' AND ci.city_name = 'Khong' THEN 'Khong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xam Neua' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xiengkho' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Muang Hiam' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Viengxay' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Houameuang' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Samtay' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Sop Bao' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Muang Et' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Kuane' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Huaphanh' AND ci.city_name = 'Xone' THEN 'Houaphan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Thakhek' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Mahaxay' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Nong Bok' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Hineboune' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Yommalath' THEN 'Nhommalth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Boualapha' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Nakai' THEN 'Nhommalth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Sebangphay' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Saybouathong' THEN 'Thakek'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Khammuane' AND ci.city_name = 'Kounkham' THEN 'Khamkeuth'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Namtha' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Sing' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Long' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Viengphoukha' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangnamtha' AND ci.city_name = 'Na Le' THEN 'Luangnamtha'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Luang Prabang' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Xiengngeun' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Nane' THEN 'Nane'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Pak Ou' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Nam Bak' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Ngoy' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Pak Seng' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phonxay' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Chomphet' THEN 'Nane'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Viengkham' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phoukhoune' THEN 'Luangprabang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Luangprabang' AND ci.city_name = 'Phonthong' THEN 'Nambak'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Xay' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'La' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Na Mo' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Nga' THEN 'Oudomxay'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Beng' THEN 'Hoon'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Houne' THEN 'Hoon'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Oudomxay' AND ci.city_name = 'Pak Beng' THEN 'Hoon'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'May' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Khoua' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Samphanh' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Boun Neua' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Yot Ou' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Boun Tay' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Phongsaly' AND ci.city_name = 'Phongsaly' THEN 'Phongsary'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Saravanh' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Ta Oy' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Toumlane' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Lakhonepheng' THEN 'Khongxedone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Vapy' THEN 'Khongxedone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Khongsedone' THEN 'Khongxedone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Lao Ngam' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Saravane' AND ci.city_name = 'Sa Mouay' THEN 'Salavan'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Kaysone Phomvihane' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Outhoumphone' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Atsaphangthong' THEN 'Atsaphangthong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Phine' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Seponh' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Nong' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Thapangthong' THEN 'Songkhone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Songkhone' THEN 'Songkhone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Champhone' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xayboury' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Viraboury' THEN 'Phine'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Assaphone' THEN 'Atsaphangthong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xonnabouly' THEN 'Savannakhet'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Phalanxay' THEN 'Atsaphangthong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Savanakhet' AND ci.city_name = 'Xayphouthong' THEN 'Songkhone'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Chanthabuly' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sikhottabong' THEN 'Sikhottabong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Xaysetha' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sisattanak' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Naxaythong' THEN 'Naxaiythong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Xaythany' THEN 'Xaythany'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Hadxayfong' THEN 'Hadxaifong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Sangthong' THEN 'Naxaiythong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Capital' AND ci.city_name = 'Parkngum' THEN 'Mayparkngum'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Phonhong' THEN 'Vientiane province'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Thoulakhom' THEN 'Thoulakhom'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Keo Oudom' THEN 'Thoulakhom'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Kasy' THEN 'Vangvieng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Vangvieng' THEN 'Vangvieng'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Feuang' THEN 'Feuang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Xanakharm' THEN 'Xanakharm'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Mad' THEN 'Xanakharm'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Hinhurp' THEN 'Vientiane province'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Viengkham' THEN 'Vientiane province'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Vientiane Province' AND ci.city_name = 'Mune' THEN 'Feuang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xaiyabuly' THEN 'Xainyabuli'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Khop' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Hongsa' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Ngeun' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xienghone' THEN 'Hongsa'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Phiang' THEN 'Xainyabuli'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Parklai' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Kenethao' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Botene' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Thongmyxay' THEN 'Parklai'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xayaboury' AND ci.city_name = 'Xaysathan' THEN 'Xainyabuli'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Anouvong' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Longchaeng' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Longxan' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Hom' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xaysomboune' AND ci.city_name = 'Thathom' THEN 'Xaisomboun'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'La Mam' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Kaleum' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Dak Cheung' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Sekong' AND ci.city_name = 'Tha Teng' THEN 'Sekong'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Paek' THEN 'Xiengkhouang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Kham' THEN 'Kham'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Nong Het' THEN 'Kham'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Khoune' THEN 'Khoune'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Mok' THEN 'Khoune'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Phou Kout' THEN 'Xiengkhouang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = 'Xiengkhuang' AND ci.city_name = 'Phaxay' THEN 'Xiengkhouang'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) = '' AND ci.city_name = '' THEN 'Head office'
		WHEN LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2) IS NULL AND ci.city_name IS NULL THEN 'Head office'
		ELSE 'Head office'
	END AS `branch_name`, 
    'Early_closed' AS approach_type,
    p.id AS approach_id,
    p.trading_currency AS currency,
    p.loan_amount /
            (CASE WHEN p.trading_currency = 'USD' THEN 1 
                    WHEN p.trading_currency = 'LAK' THEN cr.usd2lak 
                    WHEN p.trading_currency = 'THB' THEN cr.usd2thb
            end)
     AS `usd_loan_amount_old`,
	p.monthly_interest AS `monthly_interest_old`,
	p.no_of_payment AS `no_of_payment_old`,
	CASE 
		WHEN p.payment_schedule_type = 1 THEN 'Installment' 
		WHEN p.payment_schedule_type = 2 THEN 'One-time' 
		WHEN p.payment_schedule_type = 3 THEN 'Bullet-MOU'
	END AS `payment_schedule_type_old`,
	p.first_payment_date AS `first_payment_date_old`, 
    '' AS usd_now_amount,
    CONVERT(CAST(CONVERT(CONCAT(bt.code, ' ', bt.type) USING latin1) as binary) USING utf8) AS `business_type`,
    p.customer_monthly_income,
	-- Guarantor info
	CONVERT(CAST(CONVERT(
					CONCAT(g.guarantor_first_name_lo, ' ', g.guarantor_last_name_lo, ' ', g.guarantor_first_name_en, ' ', g.guarantor_last_name_en) 
				USING latin1) 
			AS binary) 
	USING utf8) AS `guarantor_name`,
    CASE 
	    WHEN LEFT (RIGHT (REPLACE ( g.guarantor_contact_no, ' ', '') ,8),1) = '0' 
			THEN CONCAT('903',RIGHT (REPLACE ( g.guarantor_contact_no, ' ', '') ,8))
		WHEN length (REPLACE ( g.guarantor_contact_no, ' ', '')) = 7 
			THEN CONCAT('9030',REPLACE ( g.guarantor_contact_no, ' ', ''))
		ELSE CONCAT('9020', RIGHT(REPLACE ( g.guarantor_contact_no, ' ', '') , 8))
	END AS `guarantor_tel`,
	CASE 
		WHEN g.guarantor_relationship = 1 THEN 'Father' 
		WHEN g.guarantor_relationship = 2 THEN 'Mother'
		WHEN g.guarantor_relationship = 3 THEN 'Husband' 
		WHEN g.guarantor_relationship = 4 THEN 'Wife'
		WHEN g.guarantor_relationship = 5 THEN 'Children' 
		WHEN g.guarantor_relationship = 6 THEN 'Older Brother'
		WHEN g.guarantor_relationship = 7 THEN 'Older Sister' 
		WHEN g.guarantor_relationship = 8 THEN 'Younger Brother'
		WHEN g.guarantor_relationship = 8 THEN 'Younger Sister' 
		WHEN g.guarantor_relationship = 10 THEN 'Uncle'
		WHEN g.guarantor_relationship = 11 THEN 'Aunt' 
		WHEN g.guarantor_relationship = 12 THEN 'Cousin'
		WHEN g.guarantor_relationship = 13 THEN 'Son' 
		WHEN g.guarantor_relationship = 14 THEN 'Daughter'
		ELSE 
			CONVERT(CAST(CONVERT( g.guarantor_relationship_others USING latin1) AS binary) USING utf8)
	END `guarantor_relationship`
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON cu.id = p.customer_id
LEFT JOIN tblguarantor g 
	ON g.id = (SELECT id FROM tblguarantor WHERE prospect_id = c.prospect_id ORDER BY id ASC LIMIT 0, 1)
LEFT JOIN tblvillage v ON cu.address_village_id = v.id
LEFT JOIN tblcity ci ON ci.id = cu.address_city
LEFT JOIN tblprovince pv ON pv.id = cu.address_province
LEFT JOIN (
		SELECT pa2.prospect_id, SUM(av2.min_buying_price) AS `min_buying_price` 
		FROM tblprospectasset pa2 
		LEFT JOIN tblassetvaluation av2 ON av2.id = pa2.assetvaluation_id
		GROUP BY pa2.prospect_id
	) AS am 
	ON p.id = am.prospect_id
LEFT JOIN tblprospectasset pa
	ON pa.prospect_id = p.id AND pa.assetvaluation_id = (SELECT assetvaluation_id 
								FROM tblprospectasset pa1 
								LEFT JOIN tblassetvaluation av1 ON av1.id = pa1.assetvaluation_id
								WHERE pa1.prospect_id = p.id 
								ORDER BY av1.min_buying_price DESC 
								LIMIT 0, 1 )
LEFT JOIN tblassetvaluation av ON av.id = pa.assetvaluation_id
LEFT JOIN tblcar car ON av.collateral_car_id = car.id
LEFT JOIN tblbusinesstype bt ON (bt.code = cu.business_type)
LEFT JOIN tblcurrencyrate cr ON (cr.date_for = date_format(now(), '%Y-%m-01'))
LEFT JOIN tbluser us ON (us.id = p.salesperson_id)
WHERE c.status IN (4, 6, 7)
	AND c.contract_no IN (2074937, 2076828, 2077693, 2080752, 2081225, 2082056, 2082180, 2082810, 2084713, 2087248, 2087579, 2087669, 2088087, 2089053, 2090315, 2090727, 2093010, 2093498, 2093711, 2095222, 2095711, 2096122, 2096168, 2096699, 2096891, 2097631, 2097720, 2098401, 2099444, 2099540, 2099889, 2100255, 2100531, 2100907, 2100987, 2101207, 2101341, 2101435, 2101522, 2101840, 2102033, 2102061, 2102922, 2102924, 2103011, 2103692, 2104135, 2104983, 2105217, 2105358, 2105524, 2105599, 2105858, 2106095, 2106326, 2106468, 2106661, 2106830, 2107157, 2107229, 2107699, 2108044, 2108121, 2108153, 2108175, 2108192, 2108256, 2108769, 2109034, 2109089, 2109548, 2109695, 2109731, 2109738, 2110161, 2110212, 2110306, 2110328, 2110476, 2110740, 2110900, 2111050, 2111126, 2111163, 2111277, 2111426, 2111744, 2111892, 2112022, 2112037, 2112097, 2112180, 2112251, 2112314, 2112417, 2112433, 2112580, 2112688, 2112743, 2112857, 2112926, 2112933, 2112946, 2112987, 2113051, 2113190, 2113209, 2113221, 2113268, 2113286, 2113297, 2113509, 2113555, 2113614, 2113811, 2113875, 2114077, 2114105, 2114176, 2114212, 2114219, 2114295, 2114315, 2114410, 2114441, 2114463, 2114664, 2114680, 2114732, 2114800, 2114825, 2115040, 2115048, 2115068, 2115290, 2115308, 2115371, 2115381, 2115498, 2115565, 2115566, 2115602, 2115620, 2115645, 2115680, 2115700, 2115720, 2115741, 2115772, 2115784, 2115914, 2115965, 2116081, 2116209, 2116226, 2116262, 2116372, 2116387, 2116428, 2116432, 2116433, 2116470, 2116539, 2116550, 2116557, 2116560, 2116563, 2116601, 2116721, 2116935, 2116968, 2116997, 2116999, 2117002, 2117031, 2117127, 2117272, 2117437, 2117451, 2117674, 2117726, 2117766, 2117779, 2117808, 2117955, 2118005, 2118006, 2118022, 2118128, 2118156, 2118164, 2118184, 2118344, 2118430, 2118448, 2118467, 2118477, 2118684, 2118796, 2118916, 2118950, 2119040, 2119042, 2119080, 2119149, 2119165, 2119200, 2119208, 2119215, 2119239, 2119246, 2119253, 2119282, 2119290, 2119301, 2119348, 2119359, 2119432, 2119450, 2119475, 2120279, 2120294, 2120804, 2120823, 2120969, 2121036, 2121117, 2121750, 2122098
);  -- use query below here to get the contract no



delete from tabSME_Approach_list where approach_type = 'Early_closed' ;


-- get Early close contract no
SELECT 
    t1.contract_no,
    t1.contract_date,
    t.due_date AS last_due_date,
    t1.date_closed,
    t1.trading_currency,
    p.loan_amount,
    p.loan_amount /
            (CASE WHEN p.trading_currency = 'USD' THEN 1 
                    WHEN p.trading_currency = 'LAK' THEN cr.usd2lak 
                    WHEN p.trading_currency = 'THB' THEN cr.usd2thb
            end)
    AS `usd_loan_amount`,
    concat(t3.customer_first_name_en,' ',t3.customer_last_name_en),
    t3.main_contact_no
FROM tblpayment t
JOIN tblcontract t1 ON t1.id = t.contract_id
left join tblcustomer t3 on (t3.id = t1.customer_id)
LEFT JOIN tblprospect p ON (p.id = t1.prospect_id)
LEFT JOIN tblcurrencyrate cr ON (cr.date_for = date_format(now(), '%Y-%m-01'))
WHERE t1.status = 7
	AND t.void_amount > 0
	AND t.`type` IN ('interest', 'principal')
	AND t1.date_closed BETWEEN '2025-07-01' AND CURRENT_DATE()
	AND t1.date_closed < t.due_date
	AND NOT EXISTS (
      SELECT 1
      FROM tblpayment t2
      WHERE t2.contract_id = t.contract_id
        AND t2.void_amount > 0
        AND t2.`type` IN ('interest','principal')
        AND (
             t2.due_date > t.due_date
             OR (t2.due_date = t.due_date AND t2.id > t.id)
        )
  )
ORDER BY t1.contract_no;



-- 

-- import data Early_closed customer from tabSME_Approach_list to tabCIB_customer
INSERT INTO tabCIB_customer 
	(`name`, `contract_no`, `full_name`, `tel_no`)
	SELECT 
	CONCAT(approach_id, ' - ', customer_name, ' - ', customer_tel, ' - ', address_province_and_city, ' - ', 
		CASE WHEN address_village IS NOT NULL THEN address_village ELSE '' END 
	) AS `name`,
	approach_id AS `contract_no`,
	customer_name AS `full_name`,
	customer_tel AS `tel_no`
FROM tabSME_Approach_list tsal 
WHERE approach_type = 'Early_closed'
	AND approach_id NOT IN (SELECT contract_no FROM tabCIB_customer)
;



-- Export only Early close
SELECT apl.approach_id AS `contract_no`,
	apl.customer_name AS `customer_name`,
	apl.customer_tel AS `customer_tel`,
	apl.date_of_birth,
	SUBSTRING_INDEX(apl.address_province_and_city, ' - ', 1) AS `province`,
	SUBSTRING_INDEX(apl.address_province_and_city, ' - ', -1) AS `district`,
	apl.address_village ,
	apl.usd_loan_amount_old,
	'http://13.250.153.252:8000/app/cib_information/new-cib_information-1' AS `add_CIB`,
	CASE 
		WHEN cicheck.cib_result = 'Yes - ມີ' THEN 'Yes'
		WHEN cicheck.cib_result = 'No - ບໍ່ມີ' THEN 'No'
		ELSE 'Not yet check'
	END AS `cib_result`,
	cihave.financial_institute AS `financial_institute`,
	bc.name_en `financial_name_en`,
	cihave.collateral_type AS `collateral_type`,
	CASE
		WHEN cihave.collateral_type = 'ອາຄານ, ອາຄານ ແລະ ທີ່ດິນ, ເຮືອນ, ເຮືອນ ແລະ ທີ່ດິນ, ທີ່ດິນ' THEN 'Real estate' 
		WHEN cihave.collateral_type = 'ເງິນໃນບັນຊີ ຫລື ເອກະສານມີຄ່າ' THEN 'Money in an account or valuable documents' 
		WHEN cihave.collateral_type = 'ເຄື່ອງຈັກ ຫລື ອຸປະກອນຕ່າງໆ' THEN 'Machinery or equipment' 
		WHEN cihave.collateral_type = 'ໂຄງການ' THEN 'Project program' 
		WHEN cihave.collateral_type = 'ຍານພາຫະນະ' THEN 'Vehicle' 
		WHEN cihave.collateral_type = 'ບຸກ​ຄົນຄ້ຳປະກັນ' THEN 'Guarantor' 
		WHEN cihave.collateral_type = 'ວັດຖຸມີຄ່າ' THEN 'Valuables' 
		WHEN cihave.collateral_type = 'ອື່ນໆ' THEN 'Others' 
	END AS `collateral_type_en`,
	ci1.cib_result AS `cib_result1`,
	ci1.financial_institute AS `financial_institute1`,
	ci1.collateral_type AS `collateral_type1`,
	ci2.cib_result AS `cib_result2`,
	ci2.financial_institute AS `financial_institute2`,
	ci2.collateral_type AS `collateral_type2`,
	ci3.cib_result AS `cib_result3`,
	ci3.financial_institute AS `financial_institute3`,
	ci3.collateral_type AS `collateral_type3`,
	ci4.cib_result AS `cib_result4`,
	ci4.financial_institute AS `financial_institute4`,
	ci4.collateral_type AS `collateral_type4`,
	ci5.cib_result AS `cib_result5`,
	ci5.financial_institute AS `financial_institute5`,
	ci5.collateral_type AS `collateral_type5`,
	apl.own_salesperson,
	-- 
	-- For checking which case check by Credit and which from LMS
	apl.first_payment_date_old,
	cicheck.modified,
	cicheck.modified_by -- IF [Administrator] = from [LMS] ELSE from credit
FROM tabSME_Approach_list apl
LEFT JOIN tabCIB_Information cicheck 
	ON cicheck.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) AND cib_result IS NOT NULL ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_Information cihave 
	ON cihave.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) AND cib_result = 'Yes - ມີ' ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_bank_code bc 
	ON (bc.name = cihave.financial_institute )
LEFT JOIN tabCIB_Information ci1 
	ON ci1.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 0 )
LEFT JOIN tabCIB_Information ci2 
	ON ci2.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci3
	ON ci3.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci4
	ON ci4.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
LEFT JOIN tabCIB_Information ci5
	ON ci5.name = (SELECT name FROM tabCIB_Information WHERE apl.approach_id = SUBSTRING_INDEX(customer, ' -', 1) ORDER BY modified DESC LIMIT 1 OFFSET 1 )
WHERE 
	apl.approach_type = 'Early_closed'
;




