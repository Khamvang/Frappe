
-- Adjust Employees
SHOW CREATE TABLE tabsme_Employees ;
SHOW INDEX FROM tabsme_Employees;

CREATE INDEX idx_staff_no ON tabsme_Employees(staff_no);

SELECT * FROM tabsme_Employees
-- WHERE creation IS NOT NULL;

SELECT staff_no, name, staff_status FROM tabsme_Employees

ALTER TABLE tabsme_Employees ADD `datetime_update` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp();


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


-- Export Computer's Data
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




SELECT * FROM tabIT_computers WHERE share_to_staff_id LIKE '1003%';

SELECT * FROM tabIT_computers WHERE it_equipment = 'Com - NB - acer - core i7 - NHQ59ST023933020703400 - Lalco_Admin'

SELECT * FROM tabIT_Equipment WHERE refer_id = '1091'

SELECT * FROM tabIT_computers WHERE name = 1152

UPDATE tabIT_computers SET creation = CURRENT_DATE() 
WHERE creation is null


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



-- ______________________________________________ Sales ______________________________________________

SELECT computer_profile, maker, sn_id, cpu, ram FROM tabIT_computers tic 

-- PC of Salespeople
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
FROM sme_org sme 
LEFT JOIN tabIT_computers ic ON ic.name = (SELECT name FROM tabIT_computers WHERE SUBSTRING_INDEX(share_to_staff_id, ' -', 1) = sme.staff_no ORDER BY modified DESC LIMIT 1)
LEFT JOIN tabIT_Equipment ie ON (ic.it_equipment = ie.name)
LEFT JOIN tabsme_Employees te ON (sme.staff_no = te.staff_no)
WHERE sme.id IS NOT NULL
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
ORDER BY 
	sme.id ASC ;



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




SELECT * FROM tabIT_computers tic 
WHERE tic.share_to_staff_id LIKE '4873%'




















