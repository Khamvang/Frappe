

SELECT *
FROM tabActivity_of_collection_3

-- 1. Export Collection activity by Sales
SELECT 
	taoc.contract_no, 
	DATE_FORMAT(taoc.`date`, '%Y-%m-%d') AS `date`,
	SUBSTRING_INDEX(taoc.collection_staff, ' -', 1) `from_staff`,
	SUBSTRING_INDEX(taoc.who, ' /', 1) AS `to_who`,
	CASE 
		WHEN taoc.collectioin_result = '１．ໂອນຈ່າຍແລ້ວ - 既に送金済' THEN 'paid'
		WHEN taoc.collectioin_result = '２．ຈ່າຍເງິນສົດແລ້ວ - 入金した' THEN 'paid'
		WHEN taoc.collectioin_result = '３．ເກັບເງີນໄດ້ສ່ວນໜື່ງ - 一部入金した' THEN 'paid'
		WHEN taoc.collectioin_result = '４．ບໍ່ຈ່າຍເງີນ - 入金しなかった' THEN 'not pay'
		WHEN taoc.collectioin_result = '5.   ນັດຈ່າຍ - 約束した' THEN 'promise to pay'
		ELSE ''
	END AS `pay_status`,
	(taoc.pay_amount 
		/
	CASE
		WHEN currency = 'USD' THEN 1
		WHEN currency = 'THB' THEN 33.80
		WHEN currency = 'LAK' THEN 21759.00
		ELSE 0
	END) AS `usd_pay_amount`,
	taoc.`make_mou`,
	DATE_FORMAT(taoc.paid_promise_date, '%Y-%m-%d') AS `paid_or_promise_date`,
	taoc.car_gps_url,
	taoc.additional_asset
FROM tabActivity_of_collection_3 taoc 
LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(taoc.collection_staff, ' -', 1) = sme.staff_no )
WHERE DATE_FORMAT(taoc.`date`, '%Y-%m-%d') = CURDATE()
	AND SUBSTRING_INDEX(taoc.who, ' /', 1) = 'Customer'
	AND sme.id IS NOT NULL 
;



-- 2. Export Collection activity by Sales to Guarantor
SELECT 
	taoc.contract_no, 
	DATE_FORMAT(taoc.`date`, '%Y-%m-%d') AS `date`,
	SUBSTRING_INDEX(taoc.collection_staff, ' -', 1) `from_staff`,
	SUBSTRING_INDEX(taoc.who, ' /', 1) AS `to_who`,
	CASE 
		WHEN taoc.collectioin_result = '１．ໂອນຈ່າຍແລ້ວ - 既に送金済' THEN 'paid'
		WHEN taoc.collectioin_result = '２．ຈ່າຍເງິນສົດແລ້ວ - 入金した' THEN 'paid'
		WHEN taoc.collectioin_result = '３．ເກັບເງີນໄດ້ສ່ວນໜື່ງ - 一部入金した' THEN 'paid'
		WHEN taoc.collectioin_result = '４．ບໍ່ຈ່າຍເງີນ - 入金しなかった' THEN 'not pay'
		WHEN taoc.collectioin_result = '5.   ນັດຈ່າຍ - 約束した' THEN 'promise to pay'
		ELSE ''
	END AS `pay_status`,
	(taoc.pay_amount 
		/
	CASE
		WHEN currency = 'USD' THEN 1
		WHEN currency = 'THB' THEN 33.80
		WHEN currency = 'LAK' THEN 21759.00
		ELSE 0
	END) AS `usd_pay_amount`,
	taoc.`make_mou`,
	DATE_FORMAT(taoc.paid_promise_date, '%Y-%m-%d') AS `paid_or_promise_date`,
	taoc.car_gps_url,
	taoc.additional_asset
FROM tabActivity_of_collection_3 taoc 
LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(taoc.collection_staff, ' -', 1) = sme.staff_no )
WHERE DATE_FORMAT(taoc.`date`, '%Y-%m-%d') = CURDATE()
	AND SUBSTRING_INDEX(taoc.who, ' /', 1) = 'Guarantor'
	AND sme.id IS NOT NULL 
;


-- Collection visit
SELECT 
	vr.contractno AS `contract_no`,
	vr.customer_visit,
	vr.customer_visit_date ,
	vr.guarantor_visit , 
	vr.guarantor_pay_date ,
	vr.meet_customer,
	vr.meet_guarantor ,
	vr.customer_will_pay ,
	vr.customer_made_memo ,
	vr.guarantor_will_pay,
	vr.guarantor_made_memo ,
	vr.found_car ,
	vr.car_accident ,
	vr.gps_work ,
	vr.car_sold ,
	vr.customer_has_asset ,
	vr.guarantor_has_asset ,
	vr.`result` ,
	vr.creation 
FROM tabvisit_report_01 vr
WHERE 
	target = 'This Month' -- ''This Month  Last Month
	-- AND creation >= CURDATE()
ORDER BY name DESC
;



select * FROM tabActivity_of_collection




select ac.contract_no, null `sales_dept`, null `sales_sec`, null `sales_unit`, null `collection_cc`, 
	null `collection_unit`, null `collection_team`, collection_staff `collection_name`, null `ccc_or_collection`,
	date(`date`) `date`, time(`date`) `time`, visited_place, who_you_met, collectioin_result, date(paid_promise_date) `payment_date`, 
	see_collateral, collateral_status, gps_status, visitor_comments, 
	exceptional, detail_of_exceptional, 
	null `full_name`, tel_no,
	call_result, inc_demand, will_inc_date, usd_inc_amount,
	(select count(*) from tabActivity_of_collection 
		where contract_no = ac.contract_no and `date` >= date_format(now(), '%Y-%m-01') 
		group by contract_no limit 1
	) as `number_of_visit`,
	ac.make_mou, ac.mou_comment ,
	ac.debt_notice , ac.debt_notice_comment ,
	ac.asset_survey , ac.asset_survey_comment ,
	ac.contract_amendment_notice , ac.contract_amendment_notice_comment ,
	ac.collection_type,
	ac.reason_cant_seized,
	ac.detail_cant_seized,
	ac.gps_repair ,
	ac.gps_repair_comments 
from tabActivity_of_collection_3 ac 
where date(date) >= date_format(now(), '%Y-%m-01')
order by ac.name desc;






-- 3. Update PRINAMRY KEY after import
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabActivity_of_collection);
    
    -- Step 2: Update the auto_increment value for tabActivity_of_collection
    SET @alter_query = CONCAT('ALTER TABLE tabActivity_of_collection AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into activity_of_collection_3_id_seq
	insert into activity_of_collection_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabActivity_of_collection), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from activity_of_collection_id_seq;









