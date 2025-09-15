


SHOW processlist;


SELECT *, visit_date  FROM tabSME_BO_and_Plan 
WHERE creation >= '2025-04-19'
	AND SUBSTRING_INDEX(staff_no, ' ', 1)


select substring_index('1003 - KHAM', ' -', 1)




select * from sme_org




SHOW TRIGGERS LIKE 'tabsme_Sales_partner';



select * from tabsme_Sales_partner order by name desc;

where current_staff like '3196%' and owner_staff like '3196%'
	and (refer_type = '5way' or refer_type is null)
	AND SUBSTRING_INDEX(broker_type, ' -', 1) = '5way'
order by name desc;


UPDATE tabsme_Sales_partner
SET refer_type = '5way'
WHERE (refer_type IS NULL OR refer_type = '')
	AND SUBSTRING_INDEX(broker_type, ' -', 1) = '5way';



where sp.refer_type = '5way' and sme.`unit_no` is not null -- if resigned staff no need
      and sp.`rank` not in ('Block - ຕ້ອງການໃຫ້ບຼ໋ອກ' , 'Not interest - ບໍ່ສົນໃຈ ເປັນນາຍໜ້າ')
      AND sp.owner_staff = sp.current_staff
order by sme.id ;


select * from tabsme_Sales_partner
where current_staff like '3196%' and owner_staff like '3196%'
	and `rank` in ('Block - ຕ້ອງການໃຫ້ບຼ໋ອກ' , 'Not interest - ບໍ່ສົນໃຈ ເປັນນາຍໜ້າ')
;





SELECT * FROM tabUser tu 



UPDATE tabSME_Approach_list
SET rank_update = 
	CASE
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'X' THEN 'X ປ່ອຍກູ້ແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'S' THEN 'S ຢາກໄດ້ທິດນີ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'A' THEN 'A ຢາກໄດ້ທິດໜ້າ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'B' THEN 'B ຢາກໄດ້ພາຍໃນເດືອນນີ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'C' THEN 'C ຢາກໄດ້ໃນເດືອນໜ້າ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'F' THEN 'F ດຽວນີ້ບໍ່ຕ້ອງການໃນອານາຄົນຕ້ອງການ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FF1' THEN 'FF1 ໂທຕິດບໍ່ຮັບສາຍ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FF2' THEN 'FF2 ບໍ່ມີສັນຍານ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FF3' THEN 'FF3 ຄົນອື່ນຮັບສາຍທີ່ບໍ່ແມ່ນລູກຄ້າ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'FFF' THEN 'FFF ເບີໂທບໍ່ໃດ້ໄຊ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'G' THEN 'G ຕ່າງແຂວງ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N1' THEN 'N1 ບໍ່ຕ້ອງການ - ລູກບໍ່ມັກ LALCO'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N2' THEN 'N2 ບໍ່ຕ້ອງການ - ຂາຍລົດແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N3' THEN 'N3 ບໍ່ຕ້ອງການ - ເອົານໍາບໍລິສັດຄູ່ແຂ່ງແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N4' THEN 'N4 ບໍ່ຕ້ອງການ - ບໍ່ມີຫລັກຊັບຄ້ຳປະກັນອີກແລ້ວ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'N5' THEN 'N5 ບໍ່ຕ້ອງການ - ບໍ່ມີແຜນໃຊ້ເງິນດ່ວນເທື່ອ'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'Z1' THEN 'Z1 ລູກຄ້າໜີ້ເສຍ・ລູກຄ້າຈ່າຍຊ້າ・ນໍາໜີ້ຢູ່'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'Z2' THEN 'Z2 ເຄດພົວພັນກັນບໍ່ສາມາດປ່ອຍກູ້ไດ້'
		WHEN TRIM(SUBSTRING_INDEX(rank_update, ' ', 1)) = 'Z3' THEN 'Z3 ເງື່ອນໄຂບໍ່ຜ່ານບໍລິສັດເຮົາ'
	END
;	


SELECT * FROM `log_sme_follow_approach`
ORDER BY `date_created` DESC;

SELECT *, DATE_FORMAT(date_created, '%Y-%m-%d')
FROM `log_sme_follow_approach`
WHERE updated_id IN (308512)



SELECT updated_id,
	SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status , ' ', 1)) = 'FFF' THEN 1 ELSE 0 END) `no_of_invalide_number`,
	SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status, ' ', 1)) = 'N1' THEN 1 ELSE 0 END) `Anti_LALCO`
FROM (
	SELECT `id`, `updated_id`, DATE_FORMAT(date_created, '%Y-%m-%d') AS `date_created`, `now_status` 
	FROM `log_sme_follow_approach`
	GROUP BY updated_id, DATE_FORMAT(date_created, '%Y-%m-%d'), now_status ) t
WHERE updated_id IN (302282, 310586, 301881)
GROUP BY updated_id



SELECT updated_id,  DATE_FORMAT(date_created, '%Y-%m-%d'),
	SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status , ' ', 1)) = 'FFF' THEN 1 ELSE 0 END) `no_of_invalide_number`,
	SUM(CASE WHEN TRIM(SUBSTRING_INDEX(now_status, ' ', 1)) = 'N1' THEN 1 ELSE 0 END) `Anti_LALCO`
FROM `log_sme_follow_approach`
WHERE updated_id IN (302282, 310586, 301881)
GROUP BY updated_id, DATE_FORMAT(date_created, '%Y-%m-%d')


SHOW INDEX FROM log_sme_follow_approach



SELECT
    user,
    host,
    plugin
FROM
    mysql.user
WHERE
    user = 'kham';









