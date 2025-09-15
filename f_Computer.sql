
-- Adjust Employees
SHOW CREATE TABLE tabsme_Employees ;
SHOW INDEX FROM tabsme_Employees;

CREATE INDEX idx_staff_no ON tabsme_Employees(staff_no);

SELECT * FROM tabsme_Employees
WHERE staff_no  '4913', ;

SELECT staff_no, name, staff_status FROM tabsme_Employees

ALTER TABLE tabsme_Employees ADD `datetime_update` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp();



-- Check duplicate
select * from ( 
		select `name`, staff_no, row_number() over (partition by `staff_no` order by `name` asc) as row_numbers	
		from tabsme_Employees
	) as t1
where row_numbers > 1 


-- check the details and delete
SELECT * FROM tabsme_Employees
WHERE staff_no IN ('4913', '897') ;


DELETE FROM tabsme_Employees
WHERE staff_no IN ('4913', '897') ;


-- Import new data to databases
https://docs.google.com/spreadsheets/d/1y_aoS_10n_FAqgWbbaURD9D79WN--wgR5Ih3QwLWTag/edit?gid=659979462#gid=659979462



-- Computer
SHOW CREATE TABLE tabIT_computers;
SHOW INDEX FROM tabIT_computers;

CREATE INDEX idx_it_equipment ON tabIT_computers(it_equipment);
CREATE INDEX idx_share_to_staff_id ON tabIT_computers(share_to_staff_id);

SELECT * FROM tabIT_computers ;



-- TO make 
SELECT name, computer_profile, maker, sn_id, cpu, ram , 
	null AS `user_name` , 
	share_to_staff_id, 
	CONCAT(computer_profile, ' - ', maker, ' - ', sn_id, ' - ', cpu ) AS `full_info`,
	office_branch , 
	it_equipment 
FROM tabIT_computers
WHERE name IN (992, 295, 1050, 1048, 1041, 1060, 942, 1021, 1011, 1007, 1053, 1000, 1001, 748, 727, 651, 1028, 1027, 1023, 1022)









-- To update
SELECT name, share_to_staff_id, staff_phone, NOW() AS `creation` , NOW() AS `modified`
FROM tabIT_computers
WHERE name IN (999, 998, 997, 1111, 1003, 1002, 1147, 990, 988, 987, 986, 1068, 981, 989, 980, 979, 978, 977, 1071, 985, 982, 984, 983, 1101, 1109, 1115, 1116, 1125, 1126, 1131, 1132, 1133, 1136, 1137, 1138, 1139, 1144, 1145, 1095, 1020, 1019, 1018, 1017, 1094, 1099, 1105, 1112, 1134, 1135, 1055, 1054, 1123, 1108, 1122, 1127, 1070, 1049, 1086, 1124, 1114, 1074, 1009, 1008, 1006, 1087, 1076, 1004, 1103, 1104, 1118, 1119, 1146, 1106, 1121, 1026, 1025, 1117, 1142, 1098, 1113, 1120, 1140, 1016, 1015, 1072, 1096, 1129, 1130, 1013, 1012, 1107, 1110, 1069, 1037, 1040, 1141, 1024, 1102, 1128, 1143
)


-- IT Equipment

-- Refer from NOP https://docs.google.com/spreadsheets/d/1AXTpqrnqvrINRRV3ViMhT9GVZR6pSPsKcmgr0ubRykM/edit?gid=0#gid=0
--  https://docs.google.com/spreadsheets/d/12THluNWI8lCqApBC5p2EJo1sUdNXPl_Ytcuy8h2CZ34/edit?gid=1997716490#gid=1997716490


SELECT * FROM tabIT_Equipment;

-- data set strutture to import
SELECT name, 
	equipment_type, 
	profile, 
	maker, 
	sn_id, 
	cpu, 
	ram,
	user_name ,
	'KHAM' AS owner ,
	refer_id
FROM tabIT_Equipment
-- WHERE user_name = 'LALCO-446'


-- Add Columns
ALTER TABLE tabIT_Equipment 
ADD COLUMN refer_id VARCHAR(255) NOT NULL DEFAULT '0' COMMENT 'key from source data';


-- index
SHOW INDEX FROM tabIT_Equipment;
CREATE INDEX idx_refer_id ON tabIT_Equipment(refer_id);
CREATE INDEX idx_user_name ON tabIT_Equipment(user_name);


-- Update data
SELECT * 
FROM tabIT_computers ic 
INNER JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
WHERE ic.it_equipment = '' OR ic.it_equipment IS NULL -- OR ic.name >= 1147;


UPDATE tabIT_computers ic
INNER JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = ie.name 
WHERE ic.it_equipment = '' OR ic.it_equipment IS NULL;


SELECT * FROM tabIT_Equipment where user_name in ('LALCO-447', 'LALCO-448', 'LALCO-449', 'LALCO-450', 'LALCO-451', 'LALCO-452', 'LALCO-453', 'LALCO-454', 'LALCO-455')

-- Update data, if have some data update, we need to update both tables as tabIT_Equipment & tabIT_computers


-- Branch Name
SELECT name, inada_name, lms_name, province_city, village FROM tabSME_Branchs 

-- update branch name
UPDATE tabIT_computers 
SET office_branch =
	CASE WHEN office_branch = '100 - Head Office' THEN 'Head Office'
		WHEN office_branch = '200 - Savannakhet' THEN 'Savannakhet'
		WHEN office_branch = '300 - Pakse - Champasack' THEN 'Pakse'
		WHEN office_branch = '400 - Luangprabang' THEN 'Luangprabang'
		WHEN office_branch = '500 - Oudomxay' THEN 'Oudomxay'
		WHEN office_branch = '110 - Vientiane province' THEN 'Vientiane province'
		WHEN office_branch = '210 - Xeno - Savanakhet' THEN ''
		WHEN office_branch = '310 - Sukhuma(PKS) - Champasack' THEN 'Sukhuma'
		WHEN office_branch = '600 - Xainyabuli' THEN 'Xainyabuli'
		WHEN office_branch = '700 - Houaphan' THEN 'Houaphan'
		WHEN office_branch = '900 - Xiengkhouang' THEN 'Xiengkhouang'
		WHEN office_branch = '800 - Paksan - Bolikhamxay' THEN 'Paksan'
		WHEN office_branch = '220 - Paksong - Savanakhet' THEN 'Paksxong'
		WHEN office_branch = '230 - Thakek - Khammuane' THEN 'Thakek'
		WHEN office_branch = '320 - Salavan' THEN 'Salavan'
		WHEN office_branch = '330 - Attapeu' THEN 'Attapue'
		WHEN office_branch = '910 - Kham - Xiengkhuang' THEN 'Kham'
		WHEN office_branch = '240 - Phin - Savanakhet' THEN 'Phine'
		WHEN office_branch = '999 - Other' THEN ''
		WHEN office_branch = '1000 - Luangnamtha' THEN 'Luangnamtha'
		WHEN office_branch = '120 - Dongdok - Vientiane Capital' THEN ''
		WHEN office_branch = '111 - Vangvieng - Vientiane province' THEN 'Vangvieng'
		WHEN office_branch = '1300 - Bokeo' THEN 'Bokeo'
		WHEN office_branch = '1100 - Phongsaly' THEN 'Phongsary'
		WHEN office_branch = '1200 - Sekong' THEN 'Sekong'
		WHEN office_branch = '1400 - Xaysomboun' THEN 'Xaisomboun'
		WHEN office_branch = '1500 - Hadxayfong - Vientiane Capital' THEN 'Hadxaifong'
		WHEN office_branch = '1600 - Naxaythong - Vientiane Capital' THEN 'Naxaiythong'
		WHEN office_branch = '1700 - Parkngum - Vientiane Capital' THEN 'Mayparkngum'
		WHEN office_branch = '1800 - Xaythany - Vientiane Capital' THEN 'Xaythany'
		WHEN office_branch = '1900 - Saysetha - Attapeu' THEN ''
		WHEN office_branch = '2000 - Khamkeut - Borikhamxay' THEN 'Khamkeuth'
		WHEN office_branch = '2100 - Paksong - Champasack' THEN ''
		WHEN office_branch = '2200 - Chongmeg - Champasack' THEN 'Chongmeg'
		WHEN office_branch = '2300 - Nam Bak - Luangprabang' THEN 'Nambak'
		WHEN office_branch = '2400 - Songkhone - Savanakhet' THEN 'Songkhone'
		WHEN office_branch = '2500 - Parklai - Xayaboury' THEN 'Parklai'
		WHEN office_branch = '2600 - Sikhottabong - Vientiane Capital' THEN 'Sikhottabong'
		WHEN office_branch = '2700 - Xanakharm(VTP) - Vientiane Province' THEN 'Xanakharm'
		WHEN office_branch = '2800 - Feuang(VTP) - Vientiane Province' THEN 'Feuang'
		WHEN office_branch = '2900 - Thoulakhom(VTP) - Vientiane Province' THEN 'Thoulakhom'
		WHEN office_branch = '3000 - Khoune(XKH) - Xienkhuang' THEN 'Khoune'
		WHEN office_branch = '3100 - Pakkading(PKN) - Borikhamxay' THEN 'Pakkading'
		WHEN office_branch = '3200 - Khong(PKS) - Champasack' THEN 'Khong'
		WHEN office_branch = '3300 - Khongxedone(SLV) - Saravane' THEN 'Khongxedone'
		WHEN office_branch = '3400 - Atsaphangthong(SVK) - Savanakhet' THEN 'Atsaphangthong'
		WHEN office_branch = '3500 - Nhommalth(TKK) - Khammuane' THEN 'Nhommalth'
		WHEN office_branch = '3600 - Nane(LPB) - Luangprabang' THEN 'Nane'
		WHEN office_branch = '3700 - Hoon(ODX) - Oudomxay' THEN 'Hoon'
		WHEN office_branch = '3800 - Hongsa(XYB) - Xayaboury' THEN 'Hongsa'
		WHEN office_branch = '3900 - Tonpherng(BKO) - Bokeo' THEN 'Tonpherng'
		ELSE office_branch
	END
;


-- _______________________________________________ Export to Google sheet _______________________________________________
-- https://docs.google.com/spreadsheets/d/106kXbAIlXDvOekvXWE6Q99LOge37RteU9zJD1DNgTNU/edit?gid=311956953#gid=311956953

-- 1. Export Computer's Data
SELECT ie.name, 
	ie.equipment_type, 
	ie.profile, 
	ie.maker, 
	ie.sn_id, 
	ie.cpu, 
	ie.ram,
	ie.user_name ,
	ic.headset, 
	CASE 
		WHEN sme.affiliation IS NOT NULL THEN sme.affiliation
		WHEN te.branch = 'Head Office' THEN 'HO'
		WHEN ic.office_branch = 'Head Office' THEN 'HO'
		ELSE 'BR'
	END AS `HO_BR`,
	CASE WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'HO' THEN 'Head Office'
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'BR' THEN sme.sec_branch
		WHEN sme.unit IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN te.branch 
		ELSE ic.office_branch 
	END AS `branch_name`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales'
		ELSE 'Non-Sales'
	END AS `is_sales`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN sme.dept 
		ELSE te.department 
	END AS `department`,
	sme.unit ,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.staff_no 
		ELSE te.staff_no
	END AS `staff_no`, 
	CASE
		WHEN sme.id IS NOT NULL THEN sme.staff_name
		ELSE UPPER(te.staff_name) 
	END AS `staff_name`,
	te.main_contact,
	NULL `hire_date`,
	CASE 
		WHEN sme.retirement_date IS NOT NULL THEN 'Resigned'
		ELSE te.staff_status
	END AS `staff_status`,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.retirement_date
		ELSE te.date_resigned
	END AS `retirement_date`,
	ic.name AS `refer_id`,
	ic.share_date ,
	ic.modified ,
	ic.share_comments ,
	CONCAT('http://13.250.153.252:8000/app/it_computers/', ic.name) AS `Edit`,
	-- Previous staff1
	ic2.share_to_staff_id AS `previous_staff1`,
	ic2.staff_phone AS `previous_staff1_tell`,
	te2.staff_status AS `previous_staff1_status`,
	CONCAT('http://13.250.153.252:8000/app/it_computers/', ic2.name) AS `previous_staff1_details`,
	-- Previous staff2
	ic3.share_to_staff_id AS `previous_staff2`,
	ic3.staff_phone AS `previous_staff2_tell`,
	te3.staff_status AS `previous_staff2_status`,
	CONCAT('http://13.250.153.252:8000/app/it_computers/', ic3.name) AS `previous_staff2_details`
FROM tabIT_Equipment ie 
LEFT JOIN tabIT_computers ic ON ic.name = (SELECT name FROM tabIT_computers WHERE it_equipment = ie.name ORDER BY modified DESC LIMIT 1)
LEFT JOIN tabsme_Employees te ON (ic.share_to_staff_id = te.name)
LEFT JOIN sme_org sme ON (te.staff_no = sme.staff_no)
-- Previous staff1
LEFT JOIN tabIT_computers ic2 ON ic2.name = (SELECT name FROM tabIT_computers WHERE it_equipment = ie.name ORDER BY modified DESC LIMIT 1 OFFSET 1)
LEFT JOIN tabsme_Employees te2 ON (ic2.share_to_staff_id = te2.name)
-- Previous staff2
LEFT JOIN tabIT_computers ic3 ON ic3.name = (SELECT name FROM tabIT_computers WHERE it_equipment = ie.name ORDER BY modified DESC LIMIT 1 OFFSET 2)
LEFT JOIN tabsme_Employees te3 ON (ic3.share_to_staff_id = te3.name)
WHERE ie.equipment_type = 'Computer'
ORDER BY 
	CASE WHEN sme.id IS NOT NULL THEN 1 ELSE 0 END DESC,
	sme.id ASC,
	CASE 
		WHEN sme.affiliation IS NOT NULL THEN sme.affiliation
		WHEN te.branch = 'Head Office' THEN 'HO'
		WHEN ic.office_branch = 'Head Office' THEN 'HO'
		ELSE 'BR'
	END DESC,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN sme.dept 
		ELSE te.department 
	END DESC
;



-- 2. PC of Salespeople
SELECT ie.name, 
	ie.equipment_type,
	CASE
		WHEN ie.profile IS NOT NULL THEN ie.profile
		ELSE ic.computer_profile
	END AS `profile`,
	CASE
		WHEN ie.maker IS NOT NULL THEN ie.maker
		ELSE ic.maker
	END AS `maker`,
	CASE
		WHEN ie.sn_id IS NOT NULL THEN ie.sn_id
		ELSE ic.sn_id
	END AS `sn_id`,
	CASE
		WHEN ie.cpu IS NOT NULL THEN ie.cpu
		ELSE ic.cpu
	END AS `cpu`,
	CASE
		WHEN ie.ram IS NOT NULL THEN ie.ram
		ELSE ic.ram
	END AS `ram`,
	ie.user_name ,
	ic.headset, 
	CASE 
		WHEN sme.affiliation IS NOT NULL THEN sme.affiliation
		WHEN te.branch = 'Head Office' THEN 'HO'
		WHEN ic.office_branch = 'Head Office' THEN 'HO'
		ELSE 'BR'
	END AS `HO_BR`,
	CASE WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'HO' THEN 'Head Office'
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'BR' THEN sme.sec_branch
		WHEN sme.unit IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN te.branch 
		ELSE ic.office_branch 
	END AS `branch_name`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales'
		ELSE 'Non-Sales'
	END AS `is_sales`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN sme.dept 
		ELSE te.department 
	END AS `department`,
	sme.unit ,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.staff_no 
		ELSE te.staff_no
	END AS `staff_no`, 
	CASE
		WHEN sme.id IS NOT NULL THEN sme.staff_name
		ELSE UPPER(te.staff_name) 
	END AS `staff_name`,
	te.main_contact,
	sme.hire_date,
	CASE 
		WHEN sme.retirement_date IS NOT NULL THEN 'Resigned'
		ELSE te.staff_status
	END AS `staff_status`,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.retirement_date
		ELSE te.date_resigned
	END AS `retirement_date`,
	ic.name AS `refer_id`,
	ic.share_date , 
	ic.modified ,
	ic.share_comments ,
	CONCAT('http://13.250.153.252:8000/app/it_computers/', ic.name) AS `Edit`
FROM sme_org sme 
LEFT JOIN tabIT_computers ic ON ic.name = (SELECT name FROM tabIT_computers WHERE SUBSTRING_INDEX(share_to_staff_id, ' -', 1) = sme.staff_no ORDER BY modified DESC LIMIT 1)
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
LEFT JOIN tabsme_Employees te ON (sme.staff_no = te.staff_no)
WHERE sme.id IS NOT NULL
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
ORDER BY 
	sme.id ASC 
;


SELECT 
	ic.name, ic.share_to_staff_id, ic.share_date,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.staff_no 
		ELSE te.staff_no
	END AS `staff_no`
FROM sme_org sme 
LEFT JOIN tabIT_computers ic ON ic.name = (SELECT name FROM tabIT_computers WHERE SUBSTRING_INDEX(share_to_staff_id, ' -', 1) = sme.staff_no ORDER BY modified DESC LIMIT 1)
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
LEFT JOIN tabsme_Employees te ON (sme.staff_no = te.staff_no)
WHERE sme.id IS NOT NULL
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
ORDER BY 
	sme.id ASC 
;


-- ______________________________________________ 100 PCs need to fix ______________________________________________
-- Refer: https://docs.google.com/spreadsheets/d/1AXTpqrnqvrINRRV3ViMhT9GVZR6pSPsKcmgr0ubRykM/edit?gid=1495896666#gid=1495896666
-- 1. Export Computer's Data
SELECT ie.name, 
	ie.equipment_type, 
	ie.profile, 
	ie.maker, 
	ie.sn_id, 
	ie.cpu, 
	ie.ram,
	ie.user_name ,
	CASE 
		WHEN sme.affiliation IS NOT NULL THEN sme.affiliation
		WHEN te.branch = 'Head Office' THEN 'HO'
		WHEN ic.office_branch = 'Head Office' THEN 'HO'
		ELSE 'BR'
	END AS `HO_BR`,
	CASE WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'HO' THEN 'Head Office'
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') AND sme.affiliation = 'BR' THEN sme.sec_branch
		WHEN sme.unit IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN te.branch 
		ELSE ic.office_branch 
	END AS `branch_name`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN 'Sales'
		ELSE 'Non-Sales'
	END AS `is_sales`,
	CASE 
		WHEN sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC') THEN sme.dept 
		ELSE te.department 
	END AS `department`,
	sme.unit ,
	te.staff_no, 
	CASE
		WHEN sme.id IS NOT NULL THEN sme.staff_name
		ELSE UPPER(te.staff_name) 
	END AS `staff_name`,
	te.main_contact,
	sme.hire_date,
	CASE 
		WHEN sme.retirement_date IS NOT NULL THEN 'Resigned'
		ELSE te.staff_status
	END AS `staff_status`,
	CASE 
		WHEN sme.id IS NOT NULL THEN sme.retirement_date
		ELSE te.date_resigned
	END AS `retirement_date`,
	ic.name AS `refer_id`,
	CONCAT('http://13.250.153.252:8000/app/it_computers/', ic.name) AS `Edit`
FROM tabIT_Equipment ie 
LEFT JOIN tabIT_computers ic ON ic.name = (SELECT name FROM tabIT_computers WHERE it_equipment = ie.name ORDER BY modified DESC LIMIT 1)
LEFT JOIN tabsme_Employees te ON (ic.share_to_staff_id = te.name)
LEFT JOIN sme_org sme ON (te.staff_no = sme.staff_no)
WHERE user_name IN ('LALCO-82', 'LALCO-57', 'LALCO-65', 'LALCO-13', 'LALCO-14', 'LALCO-81', 'LALCO-92', 'LALCO-21', 'LALCO-41', 'LALCO-97', 'LALCO-68', 'LALCO-46', 'LALCO-90', 'LALCO-60', 'LALCO-07', 'LALCO-36', 'LALCO-08', 'LALCO-93', 'LALCO-64', 'LALCO-11', 'LALCO-100', 'LALCO-20', 'LALCO-24', 'LALCO-10', 'LALCO-91', 'LALCO-04', 'LALCO-53', 'LALCO-28', 'LALCO-52', 'LALCO-29', 'LALCO-70', 'LALCO-45', 'LALCO-43', 'LALCO-83', 'LALCO-50', 'LALCO-72', 'LALCO-48', 'LALCO-75', 'LALCO-56', 'LALCO-77', 'LALCO-47', 'LALCO-58', 'LALCO-59', 'LALCO-23', 'LALCO-62', 'LALCO-76', 'LALCO-22', 'LALCO-01', 'LALCO-02', 'LALCO-03', 'LALCO-05', 'LALCO-06', 'LALCO-09', 'LALCO-12', 'LALCO-15', 'LALCO-16', 'LALCO-17', 'LALCO-18', 'LALCO-19', 'LALCO-25', 'LALCO-26', 'LALCO-27', 'LALCO-30', 'LALCO-31', 'LALCO-32', 'LALCO-33', 'LALCO-34', 'LALCO-35', 'LALCO-37', 'LALCO-38', 'LALCO-39', 'LALCO-40', 'LALCO-42', 'LALCO-44', 'LALCO-49', 'LALCO-51', 'LALCO-54', 'LALCO-55', 'LALCO-61', 'LALCO-63', 'LALCO-66', 'LALCO-67', 'LALCO-69', 'LALCO-71', 'LALCO-73', 'LALCO-74', 'LALCO-78', 'LALCO-79', 'LALCO-80', 'LALCO-84', 'LALCO-85', 'LALCO-86', 'LALCO-87', 'LALCO-88', 'LALCO-89', 'LALCO-94', 'LALCO-95', 'LALCO-96', 'LALCO-98', 'LALCO-99'
);


-- 2. Format to import
SELECT 
	name,
	NOW() AS `creation`,
	NOW() AS `modified`,
	NULL AS `owner`,
	it_equipment, 
	share_date , 
	share_to_staff_id , 
	staff_phone , 
	office_branch , 
	'Sales - ການຕະຫຼາດ' AS `department`,
	'Yes' AS `charging_cable`,
	'Yes' AS `headset`,
	'Yes' AS mouse , 
	'Yes' AS keyboard 
FROM tabIT_computers ic
ORDER BY name DESC;


-- 3. Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabIT_computers);
    
    -- Step 2: Update the auto_increment value for tabIT_computers
    SET @alter_query = CONCAT('ALTER TABLE tabIT_computers AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into it_computers_id_seq
	insert into it_computers_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabIT_computers), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from it_computers_id_seq;







-- To fix
SELECT 
	name, 
	equipment_type, 
	profile, 
	maker, 
	sn_id, 
	cpu, 
	ram, 
	user_name, 
	owner, 
	refer_id
FROM tabIT_Equipment ie 
WHERE refer_id IN ('992', '1041', '1060', '942', '1011', '1007', '1000', '1001', '748', '651', '1023', '1022')
-- WHERE user_name IN ('LALCO-42', 'LALCO-32')


-- 
SELECT ic.name, ic.it_equipment , ie.name , ie.refer_id 
FROM tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
WHERE ic.name IN (1268, 1269, 1270, 1271, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279)


--  
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ie.refer_id = ic.name
WHERE ic.name IN (1268, 1269, 1270, 1271, 1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279)



-- Update the key or name of tabIT_Equipment
SELECT *, 
	CONCAT('Com - ', 
	CASE
		WHEN LEFT(profile, 3) = 'Not' THEN 'NB'
		WHEN LEFT(profile, 3) = 'Des' THEN 'DT'
		ELSE ''
	END
	,
	' - ',
	maker ,
	' - ',
	cpu ,
	' - ',
	sn_id ,
	' - ',
	user_name 
	) AS `name`
FROM tabIT_Equipment




## _______________________________________ Insert new data and correct it _______________________________________
-- 1. Insert new data to table tabIT_Equipment
-- https://docs.google.com/spreadsheets/d/106kXbAIlXDvOekvXWE6Q99LOge37RteU9zJD1DNgTNU/edit?gid=310468117#gid=310468117


-- Sheet [insert_db]
SELECT 
	NULL AS `name`,
	ic.it_equipment AS `equipment_type`,
	ic.computer_profile AS `profile`,
	ic.maker ,
	ic.sn_id , 
	ic.cpu ,
	ic.ram , 
	NULL AS `user_name`,
	'KHAM' AS `owner`,
	ic.name AS `refer_id`
FROM tabIT_computers ic
WHERE ic.name >= 1334 AND (ic.it_equipment IS NULL OR ic.it_equipment = '')
-- WHERE ic.it_equipment IS NULL 
ORDER BY ic.name ASC
;



-- Insert 
INSERT INTO tabIT_Equipment
	(name, equipment_type, profile, maker, sn_id, cpu, ram, user_name, owner, refer_id)
VALUES
('Com - NB - 0 - 0 - ໃຊ້ຄອມສວ່ນຕົວ - LALCO-703', 'Computer', 'Notebook - ຄອມໂນດບຸກ', '0', 'ໃຊ້ຄອມສວ່ນຕົວ', '0', '0', 'LALCO-703', 'KHAM', 0)
;



-- Intert
INSERT INTO tabIT_computers
	(creation , modified , modified_by , owner, it_equipment , share_date, share_to_staff_id, staff_phone, office_branch, charging_cable , headset , mouse , keyboard, share_comments)
VALUES
('2025-09-05 09:57:57', '2025-09-05 09:57:57', 'Administrator', 'Administrator', 'Com - DT - lenovo - core i5 - PC1ADJHF - LALCO-740', '2025-09-05', '5296 - DAY', '0', 'Sekong', 'Yes', 'Yes', 'Yes', 'Yes', 'Corrected'),
('2025-09-05 09:57:57', '2025-09-05 09:57:57', 'Administrator', 'Administrator', 'Com - DT - lenovo - core i5 - PC18MPAY - LALCO-730', '2025-09-05', '5441 - VI', '0', 'Xaythany', 'Yes', 'Yes', 'Yes', 'Yes', 'Corrected'),
('2025-09-05 09:57:57', '2025-09-05 09:57:57', 'Administrator', 'Administrator', 'Com - DT - lenovo - core i5 - PC19VS7S - LALCO-731', '2025-09-05', '5424 - KOOKKIK', '2093367080', 'Head Office', 'Yes', 'Yes', 'Yes', 'Yes', 'Corrected')




-- 3. Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabIT_computers);
    
    -- Step 2: Update the auto_increment value for tabIT_computers
    SET @alter_query = CONCAT('ALTER TABLE tabIT_computers AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into it_computers_id_seq
	insert into it_computers_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabIT_computers), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from it_computers_id_seq;



-- backup data
replace into tabIT_Equipment_bk
select * from tabIT_Equipment 

delete from tabIT_Equipment
where name = 'Com - DT - hp -  -  - LALCO-407'


insert into tabIT_Equipment
select * from tabIT_Equipment_bk
where name = 'Com - NB - hp - core i5 - 5CG9035Y0Y - LALCO-608'


select * from tabIT_computers where name = 1582


-- 2. Check 
SELECT ic.name, ic.it_equipment , ie.name , ie.refer_id 
FROM tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
WHERE ic.name IN (1377, 1378)
;



-- 3. Update
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = ie.name
WHERE ic.name IN (1377, 1378)



-- 4. Update tabIT_computers
-- 2. Check 
SELECT ic.name, ic.it_equipment , ie.name , ie.refer_id , ie.sn_id
FROM tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
WHERE ie.user_name = 'LALCO-533'
;















-- 2025-05-12 Update sn_id based on Tou request
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PC19S1LV - LALCO-97', 
	ie.name = 'Com - DT - lenovo - core i5 - PC19S1LV - LALCO-97',
	ie.sn_id = 'PC19S1LV'
WHERE ie.user_name = 'LALCO-97' 
	AND ie.name = 'Com - DT - lenovo - core i5 - PC1ADJCW - LALCO-97'
;


-- 2025-05-12 Update sn_id based on Tou request
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PC18MMA4 - LALCO-68', 
	ie.name = 'Com - DT - lenovo - core i5 - PC18MMA4 - LALCO-68',
	ie.sn_id = 'PC18MMA4'
WHERE ie.user_name = 'LALCO-68' 
	AND ie.name = 'Com - DT - lenovo - core i5 - PC18MPB7 - LALCO-68'
;


-- 2025-05-12 Update sn_id based on Tou request
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PCIAJSPZ - LALCO-32', 
	ie.name = 'Com - DT - lenovo - core i5 - PCIAJSPZ - LALCO-32',
	ie.sn_id = 'PCIAJSPZ'
WHERE ie.user_name = 'LALCO-32' 
	AND ie.name = 'Com - DT - lenovo - core i5 - PC1AJSPZ - LALCO-32'
;


-- 2025-05-15 Update sn_id based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXABNCN0021380CCB13400 - LALCO-309', 
	ie.name = 'Com - NB - acer - core i5 - NXABNCN0021380CCB13400 - LALCO-309',
	ie.sn_id = 'NXABNCN0021380CCB13400'
WHERE ie.user_name = 'LALCO-309' 
	AND ie.name = 'Com - NB - acer - core i5 - 123456 - LALCO-309'
;


-- 2025-05-15 Update sn_id based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - DT - hp - core i5 - 6CR4247TF9 - LALCO-399', 
	ie.name = 'Com - DT - hp - core i5 - 6CR4247TF9 - LALCO-399',
	ie.sn_id = '6CR4247TF9'
WHERE ie.user_name = 'LALCO-399' 
	AND ie.name = 'Com - DT - hp - core i5 -  - LALCO-399'
;


-- 2025-05-15 Update sn_id based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - NB - acer - core i7 - NXK7HST0032430CCF63400 - LALCO-423', 
	ie.name = 'Com - NB - acer - core i7 - NXK7HST0032430CCF63400 - LALCO-423',
	ie.sn_id = 'NXK7HST0032430CCF63400'
WHERE ie.user_name = 'LALCO-423' 
	AND ie.name = 'Com - NB - acer - core i3 - 93001319766 - LALCO-423'
;


-- delete because duplicate [LALCO-486 & LALCO-487]
DELETE FROM tabIT_Equipment
WHERE name = 'Com - DT - hp - core i5 - 6CR42487YR - LALCO-487'


-- 2025-05-30 Update sn_id based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXA0PST0050450BCEE3400 - LALCO-311', 
	ie.name = 'Com - NB - acer - core i3 - NXA0PST0050450BCEE3400 - LALCO-311',
	ie.sn_id = 'NXA0PST0050450BCEE3400'
WHERE ie.user_name = 'LALCO-311' 
	AND ie.name = 'Com - NB - acer - core i3 -  - LALCO-311'
;


-- delete because duplicate [LALCO-447 & LALCO-609]
DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - acer - core i5 - 40101778934 - LALCO-447'


-- delete because duplicate [LALCO-447 & LALCO-330]
DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - lenovo - Intel - MP1E60TZ - LALCO-330'


-- 2025-06-17 Update sn_id based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.name = ie.refer_id)
SET ic.it_equipment = 'Com - DT - hp - core i5 - PF1P652D - LALCO-404', 
	ie.name = 'Com - DT - hp - core i5 - PF1P652D - LALCO-404',
	ie.sn_id = 'PF1P652D'
WHERE ie.user_name = 'LALCO-404' 
	AND ie.name = 'Com - DT - hp - core i5 -  - LALCO-404'
;


-- 2025-06-17 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - hp - core i3 - 5CG9035YT8 - LALCO-412', 
	ie.name = 'Com - NB - hp - core i3 - 5CG9035YT8 - LALCO-412',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-412' 
	AND ie.name = 'Com - NB - hp - core i3 -  - LALCO-412'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - RADEON - NXEG9ST00404418B627600 - LALCO-532', 
	ie.name = 'Com - NB - acer - RADEON - NXEG9ST00404418B627600 - LALCO-532',
	ie.sn_id = 'NXEG9ST00404418B627600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-532' 
	AND ie.name = 'Com - NB - acer - RADEON - NXEG9ST004044188627600 - LALCO-532'
;

DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - acer - core i3 - 92901684966 - LALCO-192';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo -  - NXH6UST002929041D16600 - LALCO-393', 
	ie.name = 'Com - NB - lenovo -  - NXH6UST002929041D16600 - LALCO-393',
	ie.sn_id = 'NXH6UST002929041D16600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-393' 
	AND ie.name = 'Com - NB - lenovo -  -  - LALCO-393'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D5C52N00 - LALCO-164', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D5C52N00 - LALCO-164',
	ie.sn_id = 'NXEFTST0021030D5C52N00',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-164' 
	AND ie.name = 'Com - NB - acer - Intel - 103054725223 - LALCO-164'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXA5YCN002136137903400 - LALCO-115', 
	ie.name = 'Com - NB - acer - core i5 - NXA5YCN002136137903400 - LALCO-115',
	ie.sn_id = 'NXA5YCN002136137903400',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-115' 
	AND ie.name = 'Com - NB - acer - core i5 -  - LALCO-115'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - 5CG9035Y99 - LALCO-551', 
	ie.name = 'Com - NB - acer - 0 - 5CG9035Y99 - LALCO-551',
	ie.sn_id = '5CG9035Y99',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-551' 
	AND ie.name = 'Com - NB - acer - 0 - 5CG9035Y99  - LALCO-551'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - RADEON - NXGWYST00R051178F37600 - LALCO-547', 
	ie.name = 'Com - NB - acer - RADEON - NXGWYST00R051178F37600 - LALCO-547',
	ie.sn_id = 'NXGWYST00R051178F37600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-547' 
	AND ie.name = 'Com - NB - acer - RADEON - NXGWYST00R051178F37600 - LALCO-547'
;

DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - acer -  - 50109649976 - LALCO-183';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer -  - NXGVYST00R04738F317600 - LALCO-371', 
	ie.name = 'Com - NB - acer -  - NXGVYST00R04738F317600 - LALCO-371',
	ie.sn_id = 'NXGVYST00R04738F317600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-371' 
	AND ie.name = 'Com - NB - acer -  - NXGVYST00R04738F317600 - LALCO-371'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R05117A417600 - LALCO-151', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R05117A417600 - LALCO-151',
	ie.sn_id = 'NXGVYST00R05117A417600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-151' 
	AND ie.name = 'Com - NB - acer - Intel - 05109683376 - LALCO-151'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - lenovo - Intel - PF1P5ZF6 - LALCO-113', 
	ie.name = 'Com - DT - lenovo - Intel - PF1P5ZF6 - LALCO-113',
	ie.sn_id = 'PF1P5ZF6',
	ie.profile = 'Desktop - ຄອມຕັ້ງໂຕ'
WHERE ie.user_name = 'LALCO-113' 
	AND ie.name = 'Com - DT - lenovo - Intel - DESKTOP-​457LKOE - LALCO-113'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R05117AA37600 - LALCO-155', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R05117AA37600 - LALCO-155',
	ie.sn_id = 'NXGVYST00R05117AA37600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-155' 
	AND ie.name = 'Com - NB - acer - Intel - 05109693176 - LALCO-155'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - Intel - PF1PAKJP - LALCO-295', 
	ie.name = 'Com - NB - lenovo - Intel - PF1PAKJP - LALCO-295',
	ie.sn_id = 'PF1PAKJP',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-295' 
	AND ie.name = 'Com - NB - lenovo - Intel - 1234567 - LALCO-295'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D4462N00 - LALCO-327', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D4462N00 - LALCO-327',
	ie.sn_id = 'NXEFTST0021030D4462N00',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-327' 
	AND ie.name = 'Com - NB - acer - Intel - 103054342223 - LALCO-327'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - asus - core i3 - JBN0GR09R413486 - LALCO-321', 
	ie.name = 'Com - NB - asus - core i3 - JBN0GR09R413486 - LALCO-321',
	ie.sn_id = 'JBN0GR09R413486',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-321' 
	AND ie.name = 'Com - NB - asus - core i3 - X407UF-BV093T - LALCO-321'
;

DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - asus - 0 - JBNOGRO9R413486 - LALCO-573';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NT6NXGVYST00R4738E3F7600 - LALCO-123', 
	ie.name = 'Com - NB - acer - 0 - NT6NXGVYST00R4738E3F7600 - LALCO-123',
	ie.sn_id = 'NT6NXGVYST00R4738E3F7600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-123' 
	AND ie.name = 'Com - NB - acer -  - 04723302376 - LALCO-123'
;

DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - acer - 0 - NXGVYST00R04738E3F7600 - LALCO-570';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - hp - core i3 - 5CG9035Y8D - LALCO-225', 
	ie.name = 'Com - NB - hp - core i3 - 5CG9035Y8D - LALCO-225',
	ie.sn_id = '5CG9035Y8D',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-225' 
	AND ie.name = 'Com - NB - hp - core i3 - 54G9035Y8D - LALCO-225'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGVYT00R051179657600 - LALCO-584', 
	ie.name = 'Com - NB - acer - 0 - NXGVYT00R051179657600 - LALCO-584',
	ie.sn_id = 'NXGVYT00R051179657600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-584' 
	AND ie.name = 'Com - NB - acer - 0 - NXGVYST00R051179657600 - LALCO-584'
;

DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - acer -  - 05109661376 - LALCO-139';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R051179FC7600 - LALCO-149', 
	ie.name = 'Com - NB - acer - core i3 - NXGVYST00R051179FC7600 - LALCO-149',
	ie.sn_id = 'NXGVYST00R051179FC7600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-149' 
	AND ie.name = 'Com - NB - acer - core i3 - 05109676476 - LALCO-149'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - hp - 0 - 5CG9035YN0 - LALCO-585', 
	ie.name = 'Com - NB - hp - 0 - 5CG9035YN0 - LALCO-585',
	ie.sn_id = '5CG9035YN0',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-585' 
	AND ie.name = 'Com - NB - hp - 0 - 5CG9035YNO - LALCO-585'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R04738E037600 - LALCO-275', 
	ie.name = 'Com - NB - acer - core i3 - NXGVYST00R04738E037600 - LALCO-275',
	ie.sn_id = 'NXGVYST00R04738E037600',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-275' 
	AND ie.name = 'Com - NB - acer - core i3 - 04723296376 - LALCO-275'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXEFTST0021030D7722N00 - LALCO-419', 
	ie.name = 'Com - NB - acer - core i3 - NXEFTST0021030D7722N00 - LALCO-419',
	ie.sn_id = 'NXEFTST0021030D7722N00',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-419' 
	AND ie.name = 'Com - NB - acer - core i3 - 103055154223 - LALCO-419'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D5812N00 - LALCO-163', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D5812N00 - LALCO-163',
	ie.sn_id = 'NXEFTST0021030D5812N00',
	ie.profile = 'Notebook - ຄອມໂນດບຸກ'
WHERE ie.user_name = 'LALCO-163' 
	AND ie.name = 'Com - NB - acer - Intel - 103054657223 - LALCO-163'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - core i5 - PF9XB9505002 - LALCO-491', 
	ie.name = 'Com - DT - hp - core i5 - PF9XB9505002 - LALCO-491',
	ie.sn_id = 'PF9XB9505002'
WHERE ie.user_name = 'LALCO-491' 
	AND ie.name = 'Com - DT - hp - core i5 - 6CR4237HGL - LALCO-491'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - 0 - NXA5YCN002136161723400 - LALCO-418', 
	ie.name = 'Com - DT - hp - 0 - NXA5YCN002136161723400 - LALCO-418',
	ie.sn_id = 'NXA5YCN002136161723400'
WHERE ie.user_name = 'LALCO-418' 
	AND ie.name = 'Com - DT - hp -  - NXA5YCN002136161723400 - LALCO-418'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D5012N00 - LALCO-161', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D5012N00 - LALCO-161',
	ie.sn_id = 'NXEFTST0021030D5012N00'
WHERE ie.user_name = 'LALCO-161' 
	AND ie.name = 'Com - NB - acer - Intel - 103054529223 - LALCO-161'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXH4CST001929018716600 - LALCO-198', 
	ie.name = 'Com - NB - acer - core i3 - NXH4CST001929018716600 - LALCO-198',
	ie.sn_id = 'NXH4CST001929018716600'
WHERE ie.user_name = 'LALCO-198' 
	AND ie.name = 'Com - NB - acer - core i3 - HLZ29560NG - LALCO-198'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXEFTST0021030D66A2N00 - LALCO-169', 
	ie.name = 'Com - NB - acer - core i3 - NXEFTST0021030D66A2N00 - LALCO-169',
	ie.sn_id = 'NXEFTST0021030D66A2N00'
WHERE ie.user_name = 'LALCO-169' 
	AND ie.name = 'Com - NB - acer - core i3 - 103054890223 - LALCO-169'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D5DB2N00 - LALCO-165', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D5DB2N00 - LALCO-165',
	ie.sn_id = 'NXEFTST0021030D5DB2N00'
WHERE ie.user_name = 'LALCO-165' 
	AND ie.name = 'Com - NB - acer - Intel - 103054747223 - LALCO-165'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo -  - PF1P5ZHN - LALCO-247', 
	ie.name = 'Com - NB - lenovo -  - PF1P5ZHN - LALCO-247',
	ie.sn_id = 'PF1P5ZHN'
WHERE ie.user_name = 'LALCO-247' 
	AND ie.name = 'Com - NB - lenovo -  - PF1P5ZHZ MTM81D5007MTA - LALCO-247'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - AMD A6 - PF1P9T41 - LALCO-239', 
	ie.name = 'Com - NB - lenovo - AMD A6 - PF1P9T41 - LALCO-239',
	ie.sn_id = 'PF1P9T41'
WHERE ie.user_name = 'LALCO-239' 
	AND ie.name = 'Com - NB - lenovo - AMD A6 - 330-14AST - LALCO-239'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R04738FBC7600 - LALCO-318', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R04738FBC7600 - LALCO-318',
	ie.sn_id = 'NXGVYST00R04738FBC7600'
WHERE ie.user_name = 'LALCO-318' 
	AND ie.name = 'Com - NB - acer - Intel - 04723340476 - LALCO-318'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGXTST00181902E856600 - LALCO-271', 
	ie.name = 'Com - NB - acer - 0 - NXGXTST00181902E856600 - LALCO-271',
	ie.sn_id = 'NXGXTST00181902E856600'
WHERE ie.user_name = 'LALCO-271' 
	AND ie.name = 'Com - NB - acer -  -  - LALCO-271'
;


DELETE FROM tabIT_Equipment
WHERE name = 'Com - NB - lenovo - 0 - PF1PA5T2 - LALCO-544';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PC1ADMJ1 - LALCO-45', 
	ie.name = 'Com - DT - lenovo - core i5 - PC1ADMJ1 - LALCO-45',
	ie.sn_id = 'PC1ADMJ1'
WHERE ie.user_name = 'LALCO-45' 
	AND ie.name = 'Com - DT - lenovo - core i5 - PC19VSMC - LALCO-45'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PC1AJSPZ - LALCO-32', 
	ie.name = 'Com - DT - lenovo - core i5 - PC1AJSPZ - LALCO-32',
	ie.sn_id = 'PC1AJSPZ'
WHERE ie.user_name = 'LALCO-32' 
	AND ie.name = 'Com - DT - lenovo - core i5 - PCIAJSPZ - LALCO-32'
;

DELETE FROM tabIT_Equipment
WHERE name = 'Com - DT - hp - core i5 - 6CR42487ZL - LALCO-542';


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - asus - 0 - JBN0GR09R908480 - LALCO-572', 
	ie.name = 'Com - NB - asus - 0 - JBN0GR09R908480 - LALCO-572',
	ie.sn_id = 'JBN0GR09R908480'
WHERE ie.user_name = 'LALCO-572' 
	AND ie.name = 'Com - NB - asus - 0 - JBNOGRO9R908480 - LALCO-572'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo -  - PF1PAMW8 - LALCO-256', 
	ie.name = 'Com - NB - lenovo -  - PF1PAMW8 - LALCO-256',
	ie.sn_id = 'PF1PAMW8'
WHERE ie.user_name = 'LALCO-256' 
	AND ie.name = 'Com - NB - lenovo -  - PF1PAMWB - LALCO-256'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - PF1P69DD - LALCO-293', 
	ie.name = 'Com - NB - lenovo - 0 - PF1P69DD - LALCO-293',
	ie.sn_id = 'PF1P69DD'
WHERE ie.user_name = 'LALCO-293' 
	AND ie.name = 'Com - NB - lenovo -  -  - LALCO-293'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - AMD A6 - PF1P9T41 - LALCO-239', 
	ie.name = 'Com - NB - lenovo - AMD A6 - PF1P9T41 - LALCO-239',
	ie.sn_id = 'PF1P9T41'
WHERE ie.user_name = 'LALCO-239' 
	AND ie.name = 'Com - NB - lenovo - AMD A6 - 330-14AST - LALCO-239'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - PF1PA9Z3 - LALCO-147', 
	ie.name = 'Com - NB - acer - core i3 - PF1PA9Z3 - LALCO-147',
	ie.sn_id = 'PF1PA9Z3'
WHERE ie.user_name = 'LALCO-147' 
	AND ie.name = 'Com - NB - acer - core i3 - 05109672676 - LALCO-147'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - MICB1096030817AE01A2 - LALCO-217', 
	ie.name = 'Com - NB - acer - Intel - MICB1096030817AE01A2 - LALCO-217',
	ie.sn_id = 'MICB1096030817AE01A2'
WHERE ie.user_name = 'LALCO-217' 
	AND ie.name = 'Com - NB - acer - Intel - ບໍ່ມີ - LALCO-217'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXEFTST0021030D4142N00 - LALCO-156', 
	ie.name = 'Com - NB - acer - core i5 - NXEFTST0021030D4142N00 - LALCO-156',
	ie.sn_id = 'NXEFTST0021030D4142N00'
WHERE ie.user_name = 'LALCO-156' 
	AND ie.name = 'Com - NB - acer - core i5 - 103054292223 - LALCO-156'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R051179137600 - LALCO-133', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R051179137600 - LALCO-133',
	ie.sn_id = 'NXGVYST00R051179137600'
WHERE ie.user_name = 'LALCO-133' 
	AND ie.name = 'Com - NB - acer - Intel - 05109653176 - LALCO-133'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D59F2N00 - LALCO-297', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D59F2N00 - LALCO-297',
	ie.sn_id = 'NXEFTST0021030D59F2N00'
WHERE ie.user_name = 'LALCO-297' 
	AND ie.name = 'Com - NB - acer - Intel - 103054687223 - LALCO-297'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - AMD A6 - PF1PAGZT - LALCO-274', 
	ie.name = 'Com - NB - lenovo - AMD A6 - PF1PAGZT - LALCO-274',
	ie.sn_id = 'PF1PAGZT'
WHERE ie.user_name = 'LALCO-274' 
	AND ie.name = 'Com - NB - lenovo - AMD A6 -  - LALCO-274'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - 0 - 0 - NXEFTST0021030D4862N00 - LALCO-409', 
	ie.name = 'Com - NB - 0 - 0 - NXEFTST0021030D4862N00 - LALCO-409',
	ie.sn_id = 'NXEFTST0021030D4862N00'
WHERE ie.user_name = 'LALCO-409' 
	AND ie.name = 'Com - NB - 0 - 0 - NXEFGTST0021030D4862N00 - LALCO-409'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXEFTST0021030D4CB2N00 - LALCO-160', 
	ie.name = 'Com - NB - acer - core i3 - NXEFTST0021030D4CB2N00 - LALCO-160',
	ie.sn_id = 'NXEFTST0021030D4CB2N00'
WHERE ie.user_name = 'LALCO-160' 
	AND ie.name = 'Com - NB - acer - core i3 - 103054475223 - LALCO-160'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - 0 - 0 - PF1PAFCR - LALCO-408', 
	ie.name = 'Com - DT - 0 - 0 - PF1PAFCR - LALCO-408',
	ie.sn_id = 'PF1PAFCR'
WHERE ie.user_name = 'LALCO-408' 
	AND ie.name = 'Com - DT -  -  -  - LALCO-408'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - core i5 - NXGVYST00R04738E647600 - LALCO-399', 
	ie.name = 'Com - DT - hp - core i5 - NXGVYST00R04738E647600 - LALCO-399',
	ie.sn_id = 'NXGVYST00R04738E647600'
WHERE ie.user_name = 'LALCO-399' 
	AND ie.name = 'Com - DT - hp - core i5 - 6CR4247TF9 - LALCO-399'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - PF1P6158 - LALCO-241', 
	ie.name = 'Com - NB - lenovo - 0 - PF1P6158 - LALCO-241',
	ie.sn_id = 'PF1P6158'
WHERE ie.user_name = 'LALCO-241' 
	AND ie.name = 'Com - NB - lenovo -  - JVHFC1 - LALCO-241'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D6F82N00 - LALCO-171', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D6F82N00 - LALCO-171',
	ie.sn_id = 'NXEFTST0021030D6F82N00'
WHERE ie.user_name = 'LALCO-171' 
	AND ie.name = 'Com - NB - acer - Intel - 103055032223 - LALCO-171'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - hp - core i5 - CND9090WSD - LALCO-385', 
	ie.name = 'Com - NB - hp - core i5 - CND9090WSD - LALCO-385',
	ie.sn_id = 'CND9090WSD'
WHERE ie.user_name = 'LALCO-385' 
	AND ie.name = 'Com - NB - hp - core i5 -  - LALCO-385'
;


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXH6UST002930033A06600 - LALCO-305', 
	ie.name = 'Com - NB - acer - core i3 - NXH6UST002930033A06600 - LALCO-305',
	ie.sn_id = 'NXH6UST002930033A06600'
WHERE ie.user_name = 'LALCO-305' 
	AND ie.name = 'Com - NB - acer - core i3 - 123 - LALCO-305'
;


SELECT * FROM tabIT_Equipment
WHERE name = 'Com - NB - hp - core i5 - CND9090WSD - LALCO-385'


-- 2025-07-07 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - 5CG8345YQM - LALCO-357', 
	ie.name = 'Com - NB - acer - core i3 - 5CG8345YQM - LALCO-357',
	ie.sn_id = '5CG8345YQM'
WHERE ie.user_name = 'LALCO-357' 
	AND ie.name = 'Com - NB - acer - core i3 -  - LALCO-357'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R05117AA67600 - LALCO-369', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R05117AA67600 - LALCO-369',
	ie.sn_id = 'NXGVYST00R05117AA67600'
WHERE ie.user_name = 'LALCO-369' 
	AND ie.name = 'Com - NB - acer - Intel -  - LALCO-369'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - NXEFTS0021030D6CE2N00 - LALCO-620', 
	ie.name = 'Com - NB - lenovo - 0 - NXEFTS0021030D6CE2N00 - LALCO-620',
	ie.sn_id = 'NXEFTS0021030D6CE2N00'
WHERE ie.user_name = 'LALCO-620' 
	AND ie.name = 'Com - NB - lenovo - 0 - PF1PAS42 - LALCO-620'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXEFTST0021030D7B82N00 - LALCO-621', 
	ie.name = 'Com - NB - acer - 0 - NXEFTST0021030D7B82N00 - LALCO-621',
	ie.sn_id = 'NXEFTST0021030D7B82N00'
WHERE ie.user_name = 'LALCO-621' 
	AND ie.name = 'Com - NB - acer - 0 - NXEFTST0021030D6CE2N00 - LALCO-621'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R051179307600 - LALCO-136', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R051179307600 - LALCO-136',
	ie.sn_id = 'NXGVYST00R051179307600'
WHERE ie.user_name = 'LALCO-136' 
	AND ie.name = 'Com - NB - acer - Intel - 05109656076 - LALCO-136'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXH6UST0029300313B6600 - LALCO-193', 
	ie.name = 'Com - NB - acer - core i3 - NXH6UST0029300313B6600 - LALCO-193',
	ie.sn_id = 'NXH6UST0029300313B6600'
WHERE ie.user_name = 'LALCO-193' 
	AND ie.name = 'Com - NB - acer - core i3 - 93001260366 - LALCO-193'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - PF1P9LW8 - LALCO-320', 
	ie.name = 'Com - NB - lenovo - 0 - PF1P9LW8 - LALCO-320',
	ie.sn_id = 'PF1P9LW8'
WHERE ie.user_name = 'LALCO-320' 
	AND ie.name = 'Com - NB - lenovo -  - ບໍ່ມີ - LALCO-320'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXA5YCN0021361719E3400 - LALCO-273', 
	ie.name = 'Com - NB - acer - core i5 - NXA5YCN0021361719E3400 - LALCO-273',
	ie.sn_id = 'NXA5YCN0021361719E3400'
WHERE ie.user_name = 'LALCO-273' 
	AND ie.name = 'Com - NB - acer - core i5 - 123456 - LALCO-273'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGVYST00R05117A757600 - LALCO-292', 
	ie.name = 'Com - NB - acer - 0 - NXGVYST00R05117A757600 - LALCO-292',
	ie.sn_id = 'NXGVYST00R05117A757600'
WHERE ie.user_name = 'LALCO-292' 
	AND ie.name = 'Com - NB - acer -  - 05109688576 - LALCO-292'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D4CD2N00 - LALCO-284', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D4CD2N00 - LALCO-284',
	ie.sn_id = 'NXEFTST0021030D4CD2N00'
WHERE ie.user_name = 'LALCO-284' 
	AND ie.name = 'Com - NB - acer - Intel - 103054477223 - LALCO-284'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - S2N0CV027216064 - LALCO-281', 
	ie.name = 'Com - NB - acer - Intel - S2N0CV027216064 - LALCO-281',
	ie.sn_id = 'S2N0CV027216064'
WHERE ie.user_name = 'LALCO-281' 
	AND ie.name = 'Com - NB - acer - Intel - NXGVYST00R04738E2D7600 - LALCO-281'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer -  - NXGVYST00R04738E357600 - LALCO-122', 
	ie.name = 'Com - NB - acer -  - NXGVYST00R04738E357600 - LALCO-122',
	ie.sn_id = 'NXGVYST00R04738E357600'
WHERE ie.user_name = 'LALCO-122' 
	AND ie.name = 'Com - NB - acer -  - 04723301376 - LALCO-122'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - PF1PAJQV - LALCO-324', 
	ie.name = 'Com - NB - lenovo - 0 - PF1PAJQV - LALCO-324',
	ie.sn_id = 'PF1PAJQV'
WHERE ie.user_name = 'LALCO-324' 
	AND ie.name = 'Com - NB - lenovo -  - ບໍ່ມີ - LALCO-324'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R051179897600 - LALCO-141', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R051179897600 - LALCO-141',
	ie.sn_id = 'NXGVYST00R051179897600'
WHERE ie.user_name = 'LALCO-141' 
	AND ie.name = 'Com - NB - acer - Intel - 05109664976 - LALCO-141'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXA5YCN002136169EB3400 - LALCO-176', 
	ie.name = 'Com - NB - acer - core i5 - NXA5YCN002136169EB3400 - LALCO-176',
	ie.sn_id = 'NXA5YCN002136169EB3400'
WHERE ie.user_name = 'LALCO-176' 
	AND ie.name = 'Com - NB - acer - core i5 - 13609265134 - LALCO-176'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R04738EA57600 - LALCO-126', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R04738EA57600 - LALCO-126',
	ie.sn_id = 'NXGVYST00R04738EA57600'
WHERE ie.user_name = 'LALCO-126' 
	AND ie.name = 'Com - NB - acer - Intel - 04723312576 - LALCO-126'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PC19VSAS - LALCO-17', 
	ie.name = 'Com - DT - lenovo - core i5 - PC19VSAS - LALCO-17',
	ie.sn_id = 'PC19VSAS'
WHERE ie.user_name = 'LALCO-17' 
	AND ie.name = 'Com - DT - lenovo - core i5 - PC19VSGJ - LALCO-17'
;


-- 2025-07-08 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGVYST00R051179D07600 - LALCO-581', 
	ie.name = 'Com - NB - acer - 0 - NXGVYST00R051179D07600 - LALCO-581',
	ie.sn_id = 'NXGVYST00R051179D07600'
WHERE ie.user_name = 'LALCO-581' 
	AND ie.name = 'Com - NB - acer - 0 - NXGVYSTOOR051179D07600 - LALCO-581'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - asus - core i3 - JBN0GR09R926489 - LALCO-435', 
	ie.name = 'Com - NB - asus - core i3 - JBN0GR09R926489 - LALCO-435',
	ie.sn_id = 'JBN0GR09R926489'
WHERE ie.user_name = 'LALCO-435' 
	AND ie.name = 'Com - NB - asus - core i3 - PPD-QCNFA335 - LALCO-435'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i7 - NXA6SAA0010470AC652N00 - LALCO-213', 
	ie.name = 'Com - NB - acer - core i7 - NXA6SAA0010470AC652N00 - LALCO-213',
	ie.sn_id = 'NXA6SAA0010470AC652N00'
WHERE ie.user_name = 'LALCO-213' 
	AND ie.name = 'Com - NB - acer - core i7 - S/N:NXA6SAA0010470AC652N00 - LALCO-213'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGFSST001714172A97600 - LALCO-185', 
	ie.name = 'Com - NB - acer - core i3 - NXGFSST001714172A97600 - LALCO-185',
	ie.sn_id = 'NXGFSST001714172A97600'
WHERE ie.user_name = 'LALCO-185' 
	AND ie.name = 'Com - NB - acer - core i3 - 71409488976 - LALCO-185'
;


-- 2025-07-09Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R05117A7E7600 - LALCO-285', 
	ie.name = 'Com - NB - acer - core i3 - NXGVYST00R05117A7E7600 - LALCO-285',
	ie.sn_id = 'NXGVYST00R05117A7E7600'
WHERE ie.user_name = 'LALCO-285' 
	AND ie.name = 'Com - NB - acer - core i3 - 05109689476 - LALCO-285'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - Intel - PF1PAKJH - LALCO-337', 
	ie.name = 'Com - NB - lenovo - Intel - PF1PAKJH - LALCO-337',
	ie.sn_id = 'PF1PAKJH'
WHERE ie.user_name = 'LALCO-337' 
	AND ie.name = 'Com - NB - lenovo - Intel - JVHFC1 - LALCO-337'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXMN7ST0055031EF717600 - LALCO-184', 
	ie.name = 'Com - NB - acer - Intel - NXMN7ST0055031EF717600 - LALCO-184',
	ie.sn_id = 'NXMN7ST0055031EF717600'
WHERE ie.user_name = 'LALCO-184' 
	AND ie.name = 'Com - NB - acer - Intel - 50312683376 - LALCO-184'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - 0 - 0 - NXA77ST005210015032N00 - LALCO-299', 
	ie.name = 'Com - NB - 0 - 0 - NXA77ST005210015032N00 - LALCO-299',
	ie.sn_id = 'NXA77ST005210015032N00'
WHERE ie.user_name = 'LALCO-299' 
	AND ie.name = 'Com - NB -  -  - ບໍ່ມີຄອມໃຊ້ ໃຊ້ຄອມສ່ວນຕົວ - LALCO-299'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - core i3 - PF1P5ZHV - LALCO-261', 
	ie.name = 'Com - NB - lenovo - core i3 - PF1P5ZHV - LALCO-261',
	ie.sn_id = 'PF1P5ZHV'
WHERE ie.user_name = 'LALCO-261' 
	AND ie.name = 'Com - NB - lenovo - core i3 - SN:PF1P5ZHV - LALCO-261'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXA7BST0031050CC452N00 - LALCO-426', 
	ie.name = 'Com - NB - acer - core i3 - NXA7BST0031050CC452N00 - LALCO-426',
	ie.sn_id = 'NXA7BST0031050CC452N00'
WHERE ie.user_name = 'LALCO-426' 
	AND ie.name = 'Com - NB - acer - core i3 - HLZAX201NG - LALCO-426'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - core i3 - PF2P5LH5 - LALCO-258', 
	ie.name = 'Com - NB - lenovo - core i3 - PF2P5LH5 - LALCO-258',
	ie.sn_id = 'PF2P5LH5'
WHERE ie.user_name = 'LALCO-258' 
	AND ie.name = 'Com - NB - lenovo - core i3 - PF2P5LRS - LALCO-258'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - core i3 - PF2P5LH5 - LALCO-258', 
	ie.name = 'Com - NB - lenovo - core i3 - PF2P5LH5 - LALCO-258',
	ie.sn_id = 'PF2P5LH5'
WHERE ie.user_name = 'LALCO-258' 
	AND ie.name = 'Com - NB - lenovo - core i3 - PF2P5LRS - LALCO-258'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXGVYST00R051179D77600 - LALCO-353', 
	ie.name = 'Com - NB - acer - core i5 - NXGVYST00R051179D77600 - LALCO-353',
	ie.sn_id = 'NXGVYST00R051179D77600'
WHERE ie.user_name = 'LALCO-353' 
	AND ie.name = 'Com - NB - acer - core i5 -  - LALCO-353'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D5602N00 - LALCO-162', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D5602N00 - LALCO-162',
	ie.sn_id = 'NXEFTST0021030D5602N00'
WHERE ie.user_name = 'LALCO-162' 
	AND ie.name = 'Com - NB - acer - Intel - 103054624223 - LALCO-162'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
RIGHT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel Celeron - NXGVYST00R04738F807600 - LALCO-679', 
	ie.name = 'Com - NB - acer - Intel Celeron - NXGVYST00R04738F807600 - LALCO-679',
	ie.sn_id = 'NXGVYST00R04738F807600'
WHERE ie.user_name = 'LALCO-679' 
	AND ie.name = 'Com - NB - acer - Intel Celeron - NXGVYST00R05117AC27600 - LALCO-679'
;

select * from tabIT_Equipment where user_name = 'LALCO-679' 

-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - core i5 - CR4237HCF - LALCO-502', 
	ie.name = 'Com - DT - hp - core i5 - CR4237HCF - LALCO-502',
	ie.sn_id = 'CR4237HCF'
WHERE ie.user_name = 'LALCO-502' 
	AND ie.name = 'Com - DT - hp - core i5 - 6CR4237HCF - LALCO-502'
;


DELETE FROM tabIT_Equipment where name = 'Com - DT - hp - core i3 - CNC419P3BT - LALCO-384';

-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - Intel - PF360HKT - LALCO-237', 
	ie.name = 'Com - NB - lenovo - Intel - PF360HKT - LALCO-237',
	ie.sn_id = 'PF360HKT'
WHERE ie.user_name = 'LALCO-237' 
	AND ie.name = 'Com - NB - lenovo - Intel - 00330-80000-0000-AA547 - LALCO-237'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - PF1P6152 - LALCO-187', 
	ie.name = 'Com - NB - acer - Intel - PF1P6152 - LALCO-187',
	ie.sn_id = 'PF1P6152'
WHERE ie.user_name = 'LALCO-187' 
	AND ie.name = 'Com - NB - acer - Intel - 84802320466 - LALCO-187'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXKLT00E401045863400 - LALCO-211', 
	ie.name = 'Com - NB - acer - core i5 - NXKLT00E401045863400 - LALCO-211',
	ie.sn_id = 'NXKLT00E401045863400'
WHERE ie.user_name = 'LALCO-211' 
	AND ie.name = 'Com - NB - acer - core i5 - NXKLQST00E401045863400 - LALCO-211'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - PF1P8AZ0 - LALCO-308', 
	ie.name = 'Com - NB - lenovo - 0 - PF1P8AZ0 - LALCO-308',
	ie.sn_id = 'PF1P8AZ0'
WHERE ie.user_name = 'LALCO-308' 
	AND ie.name = 'Com - NB - lenovo -  - ບໍ່ມີ - LALCO-308'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 -  PF1P5TWL- LALCO-270', 
	ie.name = 'Com - NB - lenovo - 0 - PF1P5TWL - LALCO-270',
	ie.sn_id = 'PF1P5TWL'
WHERE ie.user_name = 'LALCO-270' 
	AND ie.name = 'Com - NB - lenovo -  -  - LALCO-270'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D6332N00 - LALCO-168', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D6332N00 - LALCO-168',
	ie.sn_id = 'NXEFTST0021030D6332N00'
WHERE ie.user_name = 'LALCO-168' 
	AND ie.name = 'Com - NB - acer - Intel - 103054835223 - LALCO-168'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D5C92N00 - LALCO-278', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D5C92N00 - LALCO-278',
	ie.sn_id = 'NXEFTST0021030D5C92N00'
WHERE ie.user_name = 'LALCO-278' 
	AND ie.name = 'Com - NB - acer - Intel - 103054729223 - LALCO-278'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - core i5 - JBN0GR09R90248A - LALCO-492', 
	ie.name = 'Com - DT - hp - core i5 - JBN0GR09R90248A - LALCO-492',
	ie.sn_id = 'JBN0GR09R90248A'
WHERE ie.user_name = 'LALCO-492' 
	AND ie.name = 'Com - DT - hp - core i5 - 6CR4247TG2 - LALCO-492'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R051179C47600 - LALCO-312', 
	ie.name = 'Com - NB - acer - Intel - NXGVYST00R051179C47600 - LALCO-312',
	ie.sn_id = 'NXGVYST00R051179C47600'
WHERE ie.user_name = 'LALCO-312' 
	AND ie.name = 'Com - NB - acer - Intel -  - LALCO-312'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D4C72N00 - LALCO-159', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D4C72N00 - LALCO-159',
	ie.sn_id = 'NXEFTST0021030D4C72N00'
WHERE ie.user_name = 'LALCO-159' 
	AND ie.name = 'Com - NB - acer - Intel - 103054471223 - LALCO-159'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - 05109666476 - LALCO-142', 
	ie.name = 'Com - NB - acer - core i3 - 05109666476 - LALCO-142',
	ie.sn_id = 'NXGVYST00R051179987600'
WHERE ie.user_name = 'LALCO-142' 
	AND ie.name = 'Com - NB - acer - core i3 - 05109666476 - LALCO-142'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXEG9ST00404418BC87600 - LALCO-119', 
	ie.name = 'Com - NB - acer - core i3 - NXEG9ST00404418BC87600 - LALCO-119',
	ie.sn_id = 'NXEG9ST00404418BC87600'
WHERE ie.user_name = 'LALCO-119' 
	AND ie.name = 'Com - NB - acer - core i3 - 04410132076 - LALCO-119'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - hp - core i5 - NXGVYST00R051179627600 - LALCO-608', 
	ie.name = 'Com - NB - hp - core i5 - NXGVYST00R051179627600 - LALCO-608',
	ie.sn_id = 'NXGVYST00R051179627600'
WHERE ie.user_name = 'LALCO-608' 
	AND ie.name = 'Com - NB - hp - core i5 - 5CG9035Y0Y - LALCO-608'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - PF1P9W3F - LALCO-378', 
	ie.name = 'Com - NB - lenovo - 0 - PF1P9W3F - LALCO-378',
	ie.sn_id = 'PF1P9W3F'
WHERE ie.user_name = 'LALCO-378' 
	AND ie.name = 'Com - NB - lenovo -  -  - LALCO-378'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXEFTST0021030D63A2N00 - LALCO-288', 
	ie.name = 'Com - NB - acer - Intel - NXEFTST0021030D63A2N00 - LALCO-288',
	ie.sn_id = 'NXEFTST0021030D63A2N00'
WHERE ie.user_name = 'LALCO-288' 
	AND ie.name = 'Com - NB - acer - Intel - 123456 - LALCO-288'
;


-- 2025-07-09 Update profile based on KHAN PCs
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXEFTST0021030D6512N00    - LALCO-351', 
	ie.name = 'Com - NB - acer - 0 - NXEFTST0021030D6512N00    - LALCO-351',
	ie.sn_id = 'NXEFTST0021030D6512N00   '
WHERE ie.user_name = 'LALCO-351' 
	AND ie.name = 'Com - NB - acer -  -  - LALCO-351'
;


-- 2025-07-11

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGVYST00R04738DFA7600 - LALCO-175', 
        ie.name = 'Com - NB - acer - 0 - NXGVYST00R04738DFA7600 - LALCO-175',
        ie.sn_id = 'NXGVYST00R04738DFA7600'
WHERE ie.user_name = 'LALCO-175' 
        AND ie.name = 'Com - NB - acer -  - 123456 - LALCO-175'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R051179AC7600 - LALCO-541', 
        ie.name = 'Com - NB - acer - core i3 - NXGVYST00R051179AC7600 - LALCO-541',
        ie.sn_id = 'NXGVYST00R051179AC7600'
WHERE ie.user_name = 'LALCO-541' 
        AND ie.name = 'Com - NB - acer - core i3 - NXMXJST047545030EB3400 - LALCO-541'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXABNCN0021380FBE83400 - LALCO-417', 
        ie.name = 'Com - NB - acer - core i5 - NXABNCN0021380FBE83400 - LALCO-417',
        ie.sn_id = 'NXABNCN0021380FBE83400'
WHERE ie.user_name = 'LALCO-417' 
        AND ie.name = 'Com - NB - acer - core i5 -  - LALCO-417'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R051179B87600 - LALCO-144', 
        ie.name = 'Com - NB - acer - core i3 - NXGVYST00R051179B87600 - LALCO-144',
        ie.sn_id = 'NXGVYST00R051179B87600'
WHERE ie.user_name = 'LALCO-144' 
        AND ie.name = 'Com - NB - acer - core i3 - 05109669676 - LALCO-144'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXABNCN0021380DBB63400 - LALCO-331', 
        ie.name = 'Com - NB - acer - 0 - NXABNCN0021380DBB63400 - LALCO-331',
        ie.sn_id = 'NXABNCN0021380DBB63400'
WHERE ie.user_name = 'LALCO-331' 
        AND ie.name = 'Com - NB - acer -  -  - LALCO-331'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGVYST00R05117ACD7600 - LALCO-279', 
        ie.name = 'Com - NB - acer - Intel - NXGVYST00R05117ACD7600 - LALCO-279',
        ie.sn_id = 'NXGVYST00R05117ACD7600'
WHERE ie.user_name = 'LALCO-279' 
        AND ie.name = 'Com - NB - acer - Intel - 05109697376 - LALCO-279'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXABNCN0021380FD4A3400 - LALCO-415', 
        ie.name = 'Com - NB - acer - core i5 - NXABNCN0021380FD4A3400 - LALCO-415',
        ie.sn_id = 'NXABNCN0021380FD4A3400'
WHERE ie.user_name = 'LALCO-415' 
        AND ie.name = 'Com - NB - acer - core i5 - C - LALCO-415'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - core i5 - 6CR4247TF7 - LALCO-374', 
        ie.name = 'Com - DT - hp - core i5 - 6CR4247TF7 - LALCO-374',
        ie.sn_id = '6CR4247TF7'
WHERE ie.user_name = 'LALCO-374' 
        AND ie.name = 'Com - DT - hp - core i5 -  - LALCO-374'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R051179A67600 - LALCO-205', 
        ie.name = 'Com - NB - acer - core i3 - NXGVYST00R051179A67600 - LALCO-205',
        ie.sn_id = 'NXGVYST00R051179A67600'
WHERE ie.user_name = 'LALCO-205' 
        AND ie.name = 'Com - NB - acer - core i3 - NXGCVYST00R051179A67600 - LALCO-205'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - intel - NXGVYST00R05117AC27600 - LALCO-135', 
        ie.name = 'Com - NB - acer - intel - NXGVYST00R05117AC27600 - LALCO-135',
        ie.sn_id = 'NXGVYST00R05117AC27600'
WHERE ie.user_name = 'LALCO-135' 
        AND ie.name = 'Com - NB - acer - core i5 - 05109655976 - LALCO-135'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - 0 - core i3 - NXK7HST0032390F7AF3400 - LALCO-416', 
        ie.name = 'Com - NB - 0 - core i3 - NXK7HST0032390F7AF3400 - LALCO-416',
        ie.sn_id = 'NXK7HST0032390F7AF3400'
WHERE ie.user_name = 'LALCO-416' 
        AND ie.name = 'Com - NB -  - core i3 - 92901681366 - LALCO-416'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXABNCN0021380D7D73400 - LALCO-197', 
        ie.name = 'Com - NB - acer - core i5 - NXABNCN0021380D7D73400 - LALCO-197',
        ie.sn_id = 'NXABNCN0021380D7D73400'
WHERE ie.user_name = 'LALCO-197' 
        AND ie.name = 'Com - NB - acer - core i5 - B6977FBA-64A8-4DAD-9DEC-43A6C9FF6282 - LALCO-197'
;
#N/A
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXKLQST00E401045573400 - LALCO-143', 
        ie.name = 'Com - NB - acer - Intel - NXKLQST00E401045573400 - LALCO-143',
        ie.sn_id = 'NXKLQST00E401045573400'
WHERE ie.user_name = 'LALCO-143' 
        AND ie.name = 'Com - NB - acer - Intel - 05109668276 - LALCO-143'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - hp - core i3 - NXH6UST0029300338F6600 - LALCO-103', 
        ie.name = 'Com - DT - hp - core i3 - NXH6UST0029300338F6600 - LALCO-103',
        ie.sn_id = 'NXH6UST0029300338F6600'
WHERE ie.user_name = 'LALCO-103' 
        AND ie.name = 'Com - DT - hp - core i3 - 00331-10000-00001-AA811 - LALCO-103'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGVYST00R051179D47600 - LALCO-146', 
        ie.name = 'Com - NB - acer - 0 - NXGVYST00R051179D47600 - LALCO-146',
        ie.sn_id = 'NXGVYST00R051179D47600'
WHERE ie.user_name = 'LALCO-146' 
        AND ie.name = 'Com - NB - acer -  - 05109672476 - LALCO-146'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - acer - core i3 - NXGVYST00R051179BE7600 - LALCO-440', 
        ie.name = 'Com - DT - acer - core i3 - NXGVYST00R051179BE7600 - LALCO-440',
        ie.sn_id = 'NXGVYST00R051179BE7600'
WHERE ie.user_name = 'LALCO-440' 
        AND ie.name = 'Com - DT - acer - core i3 -  - LALCO-440'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R04738E2C7600 - LALCO-296', 
        ie.name = 'Com - NB - acer - core i3 - NXGVYST00R04738E2C7600 - LALCO-296',
        ie.sn_id = 'NXGVYST00R04738E2C7600'
WHERE ie.user_name = 'LALCO-296' 
        AND ie.name = 'Com - NB - acer - core i3 - 04723300476 - LALCO-296'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - Intel - PF1P9T5X - LALCO-425', 
        ie.name = 'Com - NB - lenovo - Intel - PF1P9T5X - LALCO-425',
        ie.sn_id = 'PF1P9T5X'
WHERE ie.user_name = 'LALCO-425' 
        AND ie.name = 'Com - NB - lenovo - Intel - SN:PF1P9T5X MTM:81D5007MTA - LALCO-425'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXK6SAA001302077383400 - LALCO-266', 
        ie.name = 'Com - NB - acer - 0 - NXK6SAA001302077383400 - LALCO-266',
        ie.sn_id = 'NXK6SAA001302077383400'
WHERE ie.user_name = 'LALCO-266' 
        AND ie.name = 'Com - NB - acer -  -  - LALCO-266'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - XH6UST0029300338A6600 - LALCO-306', 
        ie.name = 'Com - NB - acer - 0 - XH6UST0029300338A6600 - LALCO-306',
        ie.sn_id = 'XH6UST0029300338A6600'
WHERE ie.user_name = 'LALCO-306' 
        AND ie.name = 'Com - NB - acer -  -  - LALCO-306'
;
UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - hp - core i3 - 5CD82566D6 - LALCO-401', 
        ie.name = 'Com - NB - hp - core i3 - 5CD82566D6 - LALCO-401',
        ie.sn_id = '5CD82566D6'
WHERE ie.user_name = 'LALCO-401' 
        AND ie.name = 'Com - NB - hp - core i3 -  - LALCO-401'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i3 - NXGVYST00R0511792F7600 - LALCO-341', 
        ie.name = 'Com - NB - acer - core i3 - NXGVYST00R0511792F7600 - LALCO-341',
        ie.sn_id = 'NXGVYST00R0511792F7600'
WHERE ie.user_name = 'LALCO-341' 
        AND ie.name = 'Com - NB - acer - core i3 -  - LALCO-341'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - DT - lenovo - core i5 - PC18KPKA - LALCO-716', 
        ie.name = 'Com - DT - lenovo - core i5 - PC18KPKA - LALCO-716',
        ie.sn_id = 'PC18KPKA'
WHERE ie.user_name = 'LALCO-716' 
        AND ie.name = 'Com - DT - lenovo - core i5 - PC19VSDF - LALCO-716'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXEFTST0021030D6512N00 - LALCO-351', 
        ie.name = 'Com - NB - acer - 0 - NXEFTST0021030D6512N00 - LALCO-351',
        ie.sn_id = 'NXEFTST0021030D6512N00'
WHERE ie.user_name = 'LALCO-351' 
        AND ie.name = 'Com - NB - acer - 0 - NXEFTST0021030D6512N00    - LALCO-351'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - core i5 - NXKLQST00E401045863400 - LALCO-211', 
        ie.name = 'Com - NB - acer - core i5 - NXKLQST00E401045863400 - LALCO-211',
        ie.sn_id = 'NXKLQST00E401045863400'
WHERE ie.user_name = 'LALCO-211' 
        AND ie.name = 'Com - NB - acer - core i5 - NXKLT00E401045863400 - LALCO-211'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - asus - 0 - JBN0GR09R768483 - LALCO-696', 
        ie.name = 'Com - NB - asus - 0 - JBN0GR09R768483 - LALCO-696',
        ie.sn_id = 'JBN0GR09R768483'
WHERE ie.user_name = 'LALCO-696' 
        AND ie.name = 'Com - NB - asus - 0 - JBN0GR09R768384 - LALCO-696'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - Intel - NXGZPST0018380128C6600 - LALCO-217', 
        ie.name = 'Com - NB - acer - Intel - NXGZPST0018380128C6600 - LALCO-217',
        ie.sn_id = 'NXGZPST0018380128C6600'
WHERE ie.user_name = 'LALCO-217' 
        AND ie.name = 'Com - NB - acer - Intel - MICB1096030817AE01A2 - LALCO-217'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - lenovo - 0 - NXEFTST0021030D6CE2N00 - LALCO-620', 
        ie.name = 'Com - NB - lenovo - 0 - NXEFTST0021030D6CE2N00 - LALCO-620',
        ie.sn_id = 'NXEFTST0021030D6CE2N00'
WHERE ie.user_name = 'LALCO-620' 
        AND ie.name = 'Com - NB - lenovo - 0 - NXEFTS0021030D6CE2N00 - LALCO-620'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - NXGVYST00R051179657600 - LALCO-584', 
        ie.name = 'Com - NB - acer - 0 - NXGVYST00R051179657600 - LALCO-584',
        ie.sn_id = 'NXGVYST00R051179657600'
WHERE ie.user_name = 'LALCO-584' 
        AND ie.name = 'Com - NB - acer - 0 - NXGVYT00R051179657600 - LALCO-584'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB -  -  -  - LALCO-373', 
        ie.name = 'Com - NB - acer - 0 - JBN0GR09R981486 - LALCO-373',
        ie.sn_id = 'JBN0GR09R981486'
WHERE ie.user_name = 'LALCO-373' 
        AND ie.name = 'Com - NB -  -  -  - LALCO-373'
;

UPDATE tabIT_computers ic
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
SET ic.it_equipment = 'Com - NB - acer - 0 - ບໍມີີຂໍ້ມູນ SNID - LALCO-575', 
        ie.name = 'Com - NB - acer - 0 - ບໍມີີຂໍ້ມູນ SNID - LALCO-575',
        ie.sn_id = 'ບໍມີີຂໍ້ມູນ SNID'
WHERE ie.user_name = 'LALCO-575' 
        AND ie.name = 'Com - NB - acer - 0 - NXGVYST00R05117AC67600 - LALCO-575'
;













