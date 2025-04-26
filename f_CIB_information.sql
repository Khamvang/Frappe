

CREATE INDEX idx_customer ON tabCIB_Information(customer);
CREATE INDEX idx_financial_institute ON tabCIB_Information(financial_institute);

CREATE INDEX idx_contract_no ON tabCIB_customer(contract_no);

financial_institute


SELECT * FROM `tabCIB_Information` tci 

SELECT *, SUBSTRING_INDEX(name, ' -', 1) FROM tabCIB_customer


-- import data Dormant customer from tabSME_Approach_list to tabCIB_customer
INSERT INTO tabCIB_customer 
	(`name`, `contract_no`, `full_name`, `tel_no`)
SELECT 
	CONCAT(approach_id, ' - ', customer_name, ' - ', customer_tel, ' - ', address_province_and_city, ' - ', address_village  ) AS `name`,
	approach_id AS `contract_no`,
	customer_name AS `full_name`,
	customer_tel AS `tel_no`
FROM tabSME_Approach_list tsal 
WHERE approach_type = 'Dormant'
;


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



SELECT DISTINCT collateral_type
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









