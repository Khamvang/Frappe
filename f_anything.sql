




select `name` 'id', date_format(creation, '%Y-%m-%d') 'date_created', date_format(modified, '%Y-%m-%d') 'date_updated',
	concat(staff_no, ' - ', staff_name) 'sales_person', broker_name , broker_tel , facebook , broker_workplace , business_type , `year` 
	address_province , address_district , address_village , ever_introduced , contract_no , `rank` , 
	date_will_contract , customer_name , customer_tel , currency , amount , collateral , remark 
from tabfive_relationships 


select * from tabfive_relationships order by name desc limit 10;
select * from five_relationships_id_seq;


-- add datetime
SELECT ADDTIME("10:54:21", "00:10:00") AS Updated_time ;
SELECT ADDTIME("2023-08-01 12:55:45.212689000", "02:00:00") AS Updated_time ;
-- deduct datetime
SELECT SUBTIME('06:14:03', '15:50:90') AS Result;
SELECT SUBTIME('2019-05-01 11:15:45', '20 04:02:01') AS Result; 

select date_format('2023-08-02', '%c'); -- Numeric month name (0 to 12) https://www.w3schools.com/sql/func_mysql_date_format.ASp
select date_format('2023-08-02', '%e'); -- Day of the month AS a numeric value (0 to 31) https://www.w3schools.com/sql/func_mysql_date_format.ASp

select * from tabSME_BO_and_Plan tsbap order by name desc; -- 51554
select * from tabSME_BO_and_Plan tsbap WHERE rank1 = '';
select * from tabUser tu ;
select * from sme_org so ;

update tabSME_BO_and_Plan set rank1 = rank_update WHERE rank1 = ''

select * from tabsme_Sales_partner WHERE owner_staff is null;


-- check and update the data for each rank
select name, rank1 , rank_update , rank_S_date , rank_A_date , rank_B_date , rank_C_date from tabSME_BO_and_Plan WHERE rank_update in ('S','A','B','C');


-- update rank, own_salesperson, customer_tel
update tabSME_BO_and_Plan 
	set rank_S_date = cASe when rank_update = 'S' then date_format(modified, '%Y-%m-%d') else rank_S_date end,
	rank_A_date = cASe when rank_update = 'A' then date_format(modified, '%Y-%m-%d') else rank_A_date end,
	rank_B_date = cASe when rank_update = 'B' then date_format(modified, '%Y-%m-%d') else rank_B_date end,
	rank_C_date = cASe when rank_update = 'C' then date_format(modified, '%Y-%m-%d') else rank_C_date end,
	rank_update = cASe when contract_status = 'Contracted' then 'S' else rank_update end,
	ringi_status = cASe when contract_status = 'Contracted' then 'Approved' else ringi_status end,
	visit_or_not = cASe when contract_status = 'Contracted' then 'Yes - ຢ້ຽມຢາມແລ້ວ' when visit_date > date(now()) and visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' then 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' else visit_or_not end,
	rank1 = cASe when date_format(creation, '%Y-%m-%d') = date_format(modified, '%Y-%m-%d') then rank_update else rank1 end,
	`own_salesperson` = cASe when `own_salesperson` is not null then `own_salesperson` when callcenter_of_sales is null or callcenter_of_sales = '' then staff_no else regexp_replace(callcenter_of_sales  , '[^[:digit:]]', '') end,
	customer_tel = 
	cASe when customer_tel = '' then ''
		when (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(customer_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(customer_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8))
	end
;

 
update tabsme_Sales_partner
	set broker_tel = 
	  cASe when broker_tel = '' then ''
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
	end,
	broker_type = cASe when refer_type = 'LMS_Broker' then 'SP - ນາຍໜ້າໃນອາດີດ' else broker_type end,
	refer_type = cASe when broker_type = '5way - 5ສາຍພົວພັນ' and refer_type is null then '5way' else refer_type end,
	owner_staff = cASe when owner_staff = '' or owner_staff is null then current_staff else owner_staff end
;






-- update backup data 
insert into tabSME_BO_and_Plan select * from tabSME_BO_and_Plan_bk WHERE name not in (select name from tabSME_BO_and_Plan);
replace into tabSME_BO_and_Plan_bk select * from tabSME_BO_and_Plan; -- Updated Rows	495867
-- replace into tabsme_Sales_partner_bk select * from tabsme_Sales_partner; -- Updated Rows	151647


-- BO https://docs.google.com/spreadsheets/d/1rKhGY4JN5N0EZs8WiUC8dVxFAiwGrxcMp8-K_Scwlg4/edit#gid=1793628529&fvid=551853106
replace into SME_BO_and_Plan_report 
select cASe when bpr.date_report is null then date(now()) else bpr.date_report end `date_report`, sme.staff_no, 1 `cASe`, cASe when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.normal_bullet, bp.usd_loan_amount, bp.cASe_no, bp.contract_no, -- bp.customer_name, 
	concat('=HYPERLINK("http://13.250.153.252:8000/app/sme_bo_and_plan/"&',bp.name,',', '"' , bp.customer_name, '"',')' ) `customer_name`,
	bp.rank_update,
	cASe when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date , 
	cASe when bpr.id is null and (bp.disbursement_date_pay_date is null or bp.disbursement_date_pay_date < date(now())) then null 
		when bp.disbursement_date_pay_date >= date(Now()) then 'ແຜນເພີ່ມ' when bpr.which is null then null
		when bpr.id is not null then 'ແຜນເພີ່ມ' else bpr.which
	end `which`, 
	bp.name `id`, cASe when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`
from tabSME_BO_and_Plan bp LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
LEFT JOIN SME_BO_and_Plan_report bpr on (bpr.id = bp.name)
WHERE ((bp.rank_update in ('S','A','B','C') /*or bp.list_type is not null*/ )
	and cASe when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2024-12-01' then 0 else 1 end != 0 -- if contracted before '2023-09-29' then not need
	-- and bp.disbursement_date_pay_date between date(now()) and '2024-07-31' -- and date_format(bp.modified, '%Y-%m-%d') >= date(now())
	-- and bp.ringi_status != 'Rejected' -- and bp.contract_status != 'Cancelled'
	) or bp.name in (select id from SME_BO_and_Plan_report)
order by sme.id ;

select * from SME_BO_and_Plan_report bpr -- WHERE date_report = '2024-06-21';



-- _________________ delete in the lASt month sales plan but can't execute _________________
-- delete from SME_BO_and_Plan_report WHERE now_result in ('Contracted', 'Cancelled') ;
-- delete from SME_BO_and_Plan_report WHERE disbursement_date_pay_date < '2024-07-01' or disbursement_date_pay_date is null;
-- delete from SME_BO_and_Plan_report WHERE id = 638551;

update SME_BO_and_Plan_report set which = null WHERE now_result != 'Contracted' and disbursement_date_pay_date is null

select bpr.* , cASe when bp.modified >= date(now()) then 'called' else 0 end `is_call_today`, sme.id 
from SME_BO_and_Plan_report bpr LEFT JOIN tabSME_BO_and_Plan bp on (bpr.id = bp.name)
LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
WHERE bpr.which = 'ແຜນເພີ່ມ' and bpr.staff_no is not null -- and bpr.now_result = 'Contracted' and bpr.disbursement_date_pay_date is null
order by sme.id ASc ;



-- auto sync to google sheet https://docs.google.com/spreadsheets/d/1Te5-HcXAG8p8nDBrHFiZyEcqPzP4Qqf4OBqA1YloRRg/edit?gid=1913257518#gid=1913257518
select sme.id, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.mini_unit, sme.staff_name,
	bpr.staff_no, bpr.cASe, bpr.`type`, bpr.usd_loan_amount, bpr.cASe_no, bpr.contract_no, bpr.customer_name, bpr.rank_update, bpr.now_result, 
	bpr.disbursement_date_pay_date, bpr.which, bpr.id, bpr.comments, 
	cASe when bp.modified >= date(now()) then 'called' else 0 end `is_call_today`,
	bpr.date_report, bp.customer_name,
	cASe when bpr.now_result = 'Contracted' and bpr.disbursement_date_pay_date = date(now()) then '' end 'Daily report' 
from SME_BO_and_Plan_report bpr LEFT JOIN tabSME_BO_and_Plan bp on (bpr.id = bp.name)
LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
WHERE bpr.which = 'ແຜນເພີ່ມ' and bpr.staff_no is not null -- and bpr.now_result = 'Contracted' and bpr.disbursement_date_pay_date is null
order by sme.id ASc ;


-- manual 
select bpr.* , cASe when bp.modified >= date(now()) then 'called' else 0 end `is_call_today`, sme.id 
from SME_BO_and_Plan_report bpr LEFT JOIN tabSME_BO_and_Plan bp on (bpr.id = bp.name)
LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
WHERE bpr.id in ()
order by field(bpr.id, )



-- for Fong
select bpr.date_report, sme.`g-dept`, sme.dept, sme.sec_branch , sme.unit_no, sme.unit, bpr.staff_no , sme.staff_name, bpr.`cASe`, bpr.`type` , bpr.usd_loan_amount, bpr.cASe_no, bpr.contract_no, bp.customer_name, bp.customer_tel, bpr.rank_update, bpr.now_result ,
	bpr.disbursement_date_pay_date, bpr.which , bpr.id, bpr.comments 
from SME_BO_and_Plan_report bpr LEFT JOIN tabSME_BO_and_Plan bp on (bpr.id = bp.name)
LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
-- WHERE (bpr.now_result not in ('Contracted', 'Cancelled') and bpr.date_report < '2024-04-01') or bpr.date_report >= '2024-04-01'
 WHERE bpr.disbursement_date_pay_date between '2024-06-10' and '2024-07-31' and bpr.usd_loan_amount >= 10000
-- WHERE bp.name in ()
order by sme.id ASc ;






select * from sme_pre_daily_report WHERE bp_name = 745253



select cASe when bpr.date_report is null then date(now()) else bpr.date_report end `date_report`, sme.staff_no, sme.staff_name, sme.sec_branch, 1 `cASe`, cASe when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.usd_loan_amount, bp.cASe_no, bp.contract_no, -- bp.customer_name, 
	concat('=HYPERLINK("http://13.250.153.252:8000/app/sme_bo_and_plan/"&',bp.name,',', '"' , bp.customer_name, '"',')' ) `customer_name`,
	bp.rank_update,
	cASe when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date , 
	cASe when bpr.id is null and (bp.disbursement_date_pay_date is null or bp.disbursement_date_pay_date < date(now())) then null 
		when bp.disbursement_date_pay_date >= date(Now()) then 'ແຜນເພີ່ມ' when bpr.which is null then null
		when bpr.id is not null then 'ແຜນເພີ່ມ' else bpr.which
	end `which`, 
	bp.name `id`, cASe when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`,
	bp.credit , bp.modified 
from tabSME_BO_and_Plan bp LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
LEFT JOIN SME_BO_and_Plan_report bpr on (bpr.id = bp.name)
WHERE bp.name in (665905,662605,660232,208570,666056,665983,665290,664082,662719,665884,665405,664818,664339,657189,656494,659531,665480,664765,661228,666060,665436,660531,661231,659691,657744,661782,651284,651138,645714,664800,662751,632156,662313,660710,665019,661100,666049,665903,664029,662860,662380,665899,664549,663619,665341,664573,656265,666043,666010,665433,663032,665227,665869,664736,662759,661646,612164,665904,663416,662815,665327,663420,659063,665555,655598,655895,662919,661392,664120,665786,663524,665410,660166,664855,658143,664715,656591,664709,665896,664109,663667,661851,657409,666047,665991,663920,655302,666005,665910,662277,660525,657684,666062,664153,660963,660199,662617,660178,662207,657729,661945,661353,660747,663904,666051,665445,664238,661233,664012,664688,665907,641846,663970,666000,665994,662339,660098,656579,655995,657338,663693,662374,662370,657750,666023,664853,662668,664757,661226,666044,664210,666006,654651,665879,665345,664886,662515,661061,665557,665406,664045,663487,653405,666053,665324,665388,663586,651912,664303,663647,663321,661787,658281,665715,664948,657219,663892,661580,665051,664100,663037,666095,665429,664103,660449,657083,660692,665876,666007,662729,664251,652025,665882,665874,665401,665384,661625,665870,665843,664250,665829,663690,665350,666016,665999,659707,648068,665351,662233,584252,664918,661869,661564,664028,660970,663643,663511,660206,665811,662681,664946,663030,662190,639455,664064,663496,659422,665872,654141,664579,624539,663484,665308,663477,665291,655218,664827,664148,665672,664044,665619,665868,664265,653011,665492,664875,661777,666065,659828,665706,654698,665688,653133,656820,655335,665758,665136,663576,665782,662074,665430,661559,664920,664164,663605,662915,664793,664296,661820,648619,666050,642494,665815,663898,662161,664152,665909,664866,665249,664221,663509,661579,664149,663314,661146,99787,660533,660147,665219,664601,663881,662928,661601,662930,660096,664127,663293,648157,666035,665339,664787,664781,664774,658209,657656,663290,659687,658125,654374,665895,664217,657767,665886,656999,663691,665446,656460,662737,665311,655913,661929,664718,661223,664691,659714,660620,663000,661765,660118,649786,665900,649014,664334,647790,663632,661767,660373,653909,646911,665455,661950,659806,655275,650359,665254,664857,664279,661481,661134,654660,664878,662996,662016,665989,662917,665736,665407,663467,661852,655254,665258,662288,655318,654610,642991,657581,665898,663694,661797,641844,662202,660998,663575,662282,662173,660995,665995,665875,665877,661960,663889,56709,666046,662245,659703,657197,666032,664944,664346,650643,657068,665992,657182,656057,653874,653197,652493,656646,657728,665356,655440,664352,653924,663389,661666,661234,663043,664344,664448,664363,662910,666045,661191,665906,665360,664797,660064,664342,605771,663622,662904,662298,665894,661622,665500,662347,661519,656072,662732,664340,662991,662137,660709,665403,660002,664956,665792,666057,665880,664310,662866,659926,659940,657773,664316,662865,662856,660004,665465,664320)
	and bp.credit = '4145 - FONG' and bp.modified >= '2024-07-01';




select * from tabSME_BO_and_Plan WHERE callcenter_of_sales like '4297%' and creation >= '2024-07-01'

-- xyz to import to tabsme_Sales_partner
insert into tabsme_Sales_partner (`current_staff`, `owner_staff`, `broker_type`, `broker_name`, `broker_tel`, `address_province_and_city`, `address_village`, `business_type`,
	`year`, `refer_id`, `refer_type`, `creation`, `modified`, `owner`)
select cASe when bp.callcenter_of_sales is not null then bp.callcenter_of_sales else bp.staff_no end `current_staff` , 
	bp.own_salesperson `owner_staff`, bp.is_sales_partner `broker_type`, bp.customer_name `broker_name`, bp.customer_tel `broker_tel`,
	bp.address_province_and_city, bp.address_village, bp.business_type, bp.`year`, bp.name `refer_id`, 'tabSME_BO_and_Plan' `refer_type`,
	bp.creation, bp.modified, bp.owner
from tabSME_BO_and_Plan bp LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
LEFT JOIN sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
WHERE bp.is_sales_partner in ('X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ')
	and bp.name not in (select refer_id from tabsme_Sales_partner WHERE refer_type = 'tabSME_BO_and_Plan');
	

-- 1st method: to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner; 
alter table tabsme_Sales_partner auto_increment= 568670 ; -- next id
insert into sme_sales_partner_id_seq 
select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_sales_partner_id_seq;

-- 2nd method: 
    -- Step 1: Get the next auto_increment value and set it
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabsme_Sales_partner);
    
    -- Step 2: Update the auto_increment value for tabsme_Sales_partner
    SET @alter_query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_not_cached_value);
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Step 3: Insert the new sequence into sme_sales_partner_id_seq
	insert into sme_sales_partner_id_seq 
	select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
	from sme_sales_partner_id_seq;




SHOW EVENTS;
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;





-- ---------------------------------- update sales partner type ----------------------------------
select refer_type, broker_type, count(*) from tabsme_Sales_partner group by refer_type, broker_type ;
update tabsme_Sales_partner set refer_type = '5way', broker_type = '5way - 5ສາຍພົວພັນ' WHERE refer_type is null or refer_type = '5way';
update tabsme_Sales_partner set broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ' WHERE refer_type = 'tabSME_BO_and_Plan' and broker_type not in ('Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ'); 
select distinct refer_type, broker_type from tabsme_Sales_partner ;


select * from tabsme_Sales_partner WHERE send_wa = '' or send_wa is null;
update tabsme_Sales_partner set send_wa = 'No-ສົ່ງບໍໄດ້' WHERE send_wa = '' or send_wa is null;
update tabsme_Sales_partner set wa_date = date_format(modified, '%Y-%m-%d') WHERE send_wa != '' and modified >= '2024-08-01' ;



-- ---------------------------------- delete deplicate -----------------------------------
delete from tabsme_Sales_partner WHERE name in (

select refer_type, broker_type, count(*) from tabsme_Sales_partner WHERE name in (
select `name` from ( 
		select `name`, row_number() over (partition by `broker_tel` order by field(`refer_type`, "LMS_Broker", "tabSME_BO_and_Plan", "5way"), 
			field(`broker_type`, "SP - ນາຍໜ້າໃນອາດີດ", "Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "5way - 5ສາຍພົວພັນ"), `name` ASc) AS row_numbers  
		from tabsme_Sales_partner
	) AS t1
WHERE row_numbers > 1 
) group by refer_type, broker_type ;

delete from tabsme_Sales_partner WHERE name in (
select `name` from ( 
		select `name`, row_number() over (partition by `broker_tel` order by field(`refer_type`, "LMS_Broker", "tabSME_BO_and_Plan", "5way"), 
			field(`broker_type`, "SP - ນາຍໜ້າໃນອາດີດ", "Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "5way - 5ສາຍພົວພັນ"), `name` ASc) AS row_numbers  
		from tabsme_Sales_partner
	) AS t1
WHERE row_numbers > 1 
);



-- --------------------------------------------------------------------------------
select * from tabSME_BO_and_Plan tsbap order by name desc limit 10 -- name before import 219602

select name, customer_tel, custtbl_id from tabSME_BO_and_Plan tsbap WHERE name >= 219602 and custtbl_id is not null

-- to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabSME_BO_and_Plan;
alter table tabSME_BO_and_Plan auto_increment= 699110 ; -- next id
insert into sme_bo_and_plan_id_seq select (select max(name)+1 `next_not_cached_value` from tabSME_BO_and_Plan), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;


select * from tabsme_Sales_partner tsp WHERE name in ()

update tabsme_Sales_partner set current_staff = '1453 - AON'
WHERE name in ()

-- check
select bp.staff_no, tb.current_staff  from tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO_pre_HC tb on (tb.id = bp.name)
WHERE bp.staff_no != tb.current_staff;

-- update
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO_pre_HC tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff WHERE tb.`type` = 'F'; -- 369,654

update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO_pre_HC tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff WHERE tb.`type` in ('S','A','B','C'); -- 52,928

update tabSME_BO_and_Plan bp inner join tabSME_BO_and_Plan_bk bpk on (bp.name = bpk.name)
set bp.staff_no = bpk.staff_no WHERE bp.name in (select id from temp_sme_pbx_BO_pre_HC );

-- check
select * from temp_sme_pbx_SP ; -- 43,283

select sp.name, sp.current_staff, ts.current_staff from tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
WHERE sp.current_staff != ts.current_staff ;

-- update 
update tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
set sp.current_staff = ts.current_staff;

-- export to check pbx SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp LEFT JOIN sme_org sme on (cASe when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
-- LEFT JOIN temp_sme_pbx_SP ts on (ts.id = sp.name)
WHERE sp.refer_type = 'LMS_Broker' -- SP
	or (sp.refer_type = 'tabSME_BO_and_Plan' and sme.`unit_no` is not null -- if resigned staff no need --
      and sp.`rank` != 'Block - ຕ້ອງການໃຫ້ບຼ໋ອກ' and sp.`rank` != 'Not interest - ບໍ່ສົນໃຈ ເປັນນາຍໜ້າ' ) -- XYZ
	or (sp.refer_type = '5way' and sme.`unit_no` is not null) -- 5way
order by sme.id ;



select *, left(sp.current_staff, locate(' ', sp.current_staff)-1) from tabsme_Sales_partner sp
WHERE left(sp.current_staff, locate(' ', sp.current_staff)-1) in ('387', '')

select refer_id , business_type  from tabsme_Sales_partner sp WHERE sp.refer_type = 'LMS_Broker'



insert into temp_sme_2
select name, custtbl_id, row_numbers, now() `time` from ( 
		select name, custtbl_id, row_number() over (partition by custtbl_id order by name) AS row_numbers  
		from tabSME_BO_and_Plan 
		WHERE name >= 219602 and custtbl_id is not null
		) AS t1
	WHERE row_numbers > 1; -- done <= 1068


select * from tabSME_BO_and_Plan WHERE name in (select name from temp_sme_2 )

delete from tabSME_BO_and_Plan WHERE name in (select name from temp_sme_2 )

-- 


select * from tabsme_Sales_partner_bk WHERE name not in (select name from tabsme_Sales_partner);

select bp.name , bp.staff_no, te.staff_no, te.name from tabSME_BO_and_Plan bp LEFT JOIN tabsme_Employees te on (bp.staff_no = te.staff_no)
WHERE bp.staff_no <> te.name and bp.name <= 10000;

update tabSME_BO_and_Plan bp LEFT JOIN tabsme_Employees te on (bp.staff_no = te.staff_no)
set bp.staff_no = te.name WHERE bp.name in (72451, 72623, 75313, 77608) and bp.staff_no <> te.name ;


-- SABC export the current list 
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO_pre_HC tb on (tb.id = bp.name)
set tb.current_staff = bp.staff_no WHERE tb.`type` = 'F'

select * from temp_sme_pbx_BO_pre_HC tspb WHERE `type` = 'F' and month_type <= 6; -- 30,292

select count(*)
from tabSME_BO_and_Plan bp LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
-- LEFT JOIN sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
inner join temp_sme_pbx_BO_pre_HC tb on (tb.id = bp.name)
WHERE bp.name in (select id from temp_sme_pbx_BO_pre_HC WHERE `type` in ('F') and month_type <= 6)
order by sme.id ASc;

-- SABC Additional list for SABC less or 1 year
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, staff_no `current_staff`, 
	cASe when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	cASe when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	cASe when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
WHERE ( (bp.rank1 in ('S', 'A', 'B', 'C') and date_format(bp.creation, '%Y-%m-%d') between '2024-01-01' and '2024-01-31' and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted', 'Cancelled');











select staff_no, name from tabsme_Employees ;
select * from temp_sme_pbx_BO WHERE type in ('S', 'A', 'B', 'C');
delete from temp_sme_pbx_BO WHERE type in ('S', 'A', 'B', 'C');

-- update
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff;



select sp.name, sp.current_staff, sp.owner_staff , te.name , te.staff_no 
from tabsme_Sales_partner sp LEFT JOIN tabsme_Employees te on (sp.owner_staff = te.staff_no) 
WHERE sp.current_staff != te.name

update  tabsme_Sales_partner sp LEFT JOIN tabsme_Employees te on (sp.owner_staff = te.staff_no) 
set sp.owner_staff = te.name
WHERE sp.owner_staff != te.name


-- Yoshi request
select bp.name `id`, date_format(bp.creation, '%Y-%m-%d') `date create`, bp.customer_name, bp.customer_tel , 
	cASe when timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) =0 then 1 
	else timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `year_type`, -- 
	cASe when tspb.id is not null then tspb.month_type else timestampdiff(month, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `month_type`,
	bp.rank1, 
	cASe when bp.contract_status = 'Contracted' then 'Contracted' else bp.rank_update end `type`,
	cASe when bp.contract_status = 'Contracted' then 'x' else 'ok' end `without contracted`,
	cASe when sme.staff_no is not null then concat(sme.staff_no, ' - ', sme.staff_name)
		when smec.staff_no is not null then concat(smec.staff_no, ' - ', smec.staff_name)
		else null
	end 'current_staff'
from tabSME_BO_and_Plan bp LEFT JOIN temp_sme_pbx_BO tspb on (bp.name = tspb.id)
LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
LEFT JOIN sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
WHERE bp.rank1 in ('S', 'A', 'B', 'C', 'F') ;


select rank_update, COUNT(*) from tabSME_BO_and_Plan bp group by rank_update;

select address_province_and_city,
	count(cASe when contract_status = 'Contracted' then 1 end ) 'Contracted',
	count(cASe when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 1 end ) 'SABC',
	count(cASe when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 1 end ) 'F',
	count(cASe when contract_status != 'Contracted' and rank_update in ('G') then 1 end ) 'G'
from tabSME_BO_and_Plan bp group by address_province_and_city;

select address_province_and_city, contract_status, rank_update, count(*)
from tabSME_BO_and_Plan bp group by address_province_and_city, contract_status, rank_update;


-- prepare list for current 18 branches
select name 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	cASe when contract_status = 'Contracted' then 'Contracted'
		when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 'SABC'
		when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 'F'
		when contract_status != 'Contracted' and rank_update in ('G') then 'G'
	end 'type', 
	maker, model, `year`, rank_update 'remark_1', usd_loan_amount 'remark_2', null 'remark_3'
from tabSME_BO_and_Plan 
WHERE contract_status != 'Contracted'
	and address_province_and_city in ('Sekong - La Mam')
order by address_province_and_city ASc;





-- Users Email management  https://docs.google.com/spreadsheets/d/1y_aoS_10n_FAqgWbbaURD9D79WN--wgR5Ih3QwLWTag/edit#gid=659979462
select name, username, first_name, lASt_name , gender, birth_date, phone , mobile_no, enabled, time_zone from tabUser order by creation desc;


update tabUser set time_zone = 'ASia/Bangkok' WHERE name != 'maheshprabuddika@gmail.com';
update tabUser set enabled = 0 WHERE username in ('1186', '3851');

select * from tabUser WHERE name = 'test1@lalco.la';
select * from user

select staff_no, main_contact  from tabsme_Employees te 

-- export HR system
select ha.name, date_format(ha.creation, '%Y-%m-%d') `date created`, date_format(ha.modified, '%Y-%m-%d') `date updated`,
	ha.office, ha.branch, ha.department, ha.head_of_department, ha.staff_no, 
	ha.category, ha.first_leave_date, ha.end_leave_date, ha.number_of_leave_day, 
	ha.reASon, ha.detail_of_reASon, concat('http://13.250.153.252:8000', replace(replace(ha.evidence, '/private', '' ), ' ', '%20' )) `evidence`,
	ha.workflow_state,
	concat('http://13.250.153.252:8000/app/hr_absence/', name) `Edit`
from tabHR_Absence ha ;




select address_province_and_city, count(*)
from tabSME_BO_and_Plan
WHERE rank_update in ('G', 'G1', 'G2')
group by address_province_and_city 

select distinct address_province_and_city from tabSME_BO_and_Plan



-- select data to show in google sheet and looker studio
select cb.contract_no, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit, cb.sales_staff, cb.collection_staff, cb.collection_cc_staff,
	cb.customer_name, cb.debt_type, cb.collection_status, cb.now_amount_usd, ac.date, ac.collection_method, ac.call_result, ac.visited_result,
	ac.rank_of_cASe, ac.next_policy, ac.policy_due_date, ac.promise_date,
	concat('http://13.250.153.252:8000/app/activity_of_collection/', ac.name) `edit`,
	ac.priority,
	ac.collectioin_result, ac.is_order
from tabcontract_bASe cb 
LEFT JOIN sme_org sme on (cASe when locate(' ', cb.sales_staff) = 0 then cb.sales_staff else left(cb.sales_staff, locate(' ', cb.sales_staff)-1) end = sme.staff_no)
LEFT JOIN tabActivity_of_collection ac on ac.name = (select name from tabActivity_of_collection WHERE contract_no = cb.name order by name desc limit 1)
WHERE cb.debt_type != ''
order by sme.id ASc;





select name, contract_no, `date`, gps_status, exceptional, collection_method, call_result, visited_result, promise_date, priority, is_order 
from tabActivity_of_collection


select contract_no, target_date, debt_type, collection_status from tabcontract_bASe


update tabcontract_bASe cb
LEFT JOIN tabActivity_of_collection ac2 on ac2.name = (select name from tabActivity_of_collection WHERE contract_no = cb.name order by name desc limit 1)
set ac2.is_order = 1
WHERE ac2.contract_no in ()




select now();
SELECT @@global.time_zone, @@session.time_zone;
SET time_zone = '+07:00';



-- 2) insert collection order to collection and collection CC people
insert into tabActivity_of_collection (`creation`, `contract_no`, `collection_staff`, `date`, `collection_method`, `collectioin_result`, `priority`)
select now() `creation`, cb.contract_no, cb.collection_staff, 
	cASe when cb.collection_status = 'already paid' then null else date(now()) end `date`, 
	cASe when cb.collection_status = 'already paid' then '' else 'Visit / ລົງຢ້ຽມຢາມ' end `collection_method`, 
	cASe when cb.collection_status = 'already paid' then 'Paid / ຈ່າຍ' else null end `collectioin_result`,
	cASe when cb.collection_status = 'already paid' then ''
		when count(ac.exceptional) >=1 then 1 -- Exceptional cASe
		when ac2.gps_status = 'offline' or cb.gps_status = 'offline' then 2 -- GPS Offline
		when count(ifnull(ac.promise_date, 1)) >= 1 then 3 -- No payment promise
		when count(ac.promise_date) or ac2.promise_date > date(now()) then 4 -- Break payment primise
		else 5 -- Others
	end `priority` 
from tabcontract_bASe cb LEFT JOIN tabActivity_of_collection ac on (ac.contract_no = cb.name)
LEFT JOIN tabActivity_of_collection ac2 on ac2.name = (select name from tabActivity_of_collection WHERE contract_no = cb.name order by name desc limit 1)
 WHERE cb.debt_type != '' and cb.collection_status = '0'
group by cb.name ;


delete from tabSME_BO_and_Plan_bk WHERE name = 631221

select * from tabSME_BO_and_Plan bp WHERE date_format(bp.creation, '%Y-%m-%d') = '2024-04-12' 

select ac.`date`, cb.contract_no, ac.exceptional, cb.gps_status 'bASe_gps_status', ac.gps_status 'activity_gps_status',  ac.promise_date
from tabcontract_bASe cb LEFT JOIN tabActivity_of_collection ac on (ac.contract_no = cb.name)


select * from tabActivity_of_collection WHERE creation >= date(now()) -1  and contract_no in (2100087, 2106051)  ;

update tabActivity_of_collection set `date` = date(now()) WHERE modified >= date(now())


-- Yoshi orders to check cASe that have car and no car
select rank_update, 
	count(cASe when maker != '' or model != '' then 1 end) 'Have car',
	count(cASe when maker is null and model is null then 1 end) 'No car'
from tabSME_BO_and_Plan 
-- WHERE name <= 100
group by rank_update


select name, maker, model , cASe when maker != '' or model != '' then 'Have car' end `Car_check`, rank1 , rank_update 
from tabSME_BO_and_Plan WHERE rank_update = 'F';


update tabSME_BO_and_Plan set rank1 = 'F', rank_update = 'F' WHERE rank_update = ''


select *
from tabsme_Sales_partner sp
WHERE current_staff = '387 - LEY' and refer_type = '5way' and sp.owner_staff = sp.current_staff




select name, creation, rank1, contract_status, disbursement_date_pay_date ,
	timestampdiff(day, date_format(creation, '%Y-%m-%d'), disbursement_date_pay_date)
from tabSME_BO_and_Plan bp
WHERE rank1 in ('S', 'A', 'B', 'C')



select staff_no, main_contact  from tabsme_Employees ;





select null `No`,
	concat(first_name_en, ' ', lASt_name_en ) `Fullname`,
	job_title `Job function`,
	department `Department`,
	date_resigned `LASt working date`,
	concat(email, ' / ', staff_no) `Email/ Employee ID`
from tabsme_Employees
WHERE staff_status = 'Resigned' and date_resigned >= MAKEDATE(YEAR(CURDATE()), 1)
order by date_resigned ;




-- Collection 
select ac.contract_no, null `sales_dept`, null `sales_sec`, null `sales_unit`, null `collection_cc`, 
	null `collection_unit`, null `collection_team`, collection_staff `collection_name`,
	date(`date`) `date`, time(`date`) `time`, visited_place, who_you_met, collectioin_result, date(paid_promise_date) `payment_date`, 
	see_collateral, collateral_status, gps_status, visitor_comments, 
	exceptional, detail_of_exceptional, 
	inc_demand
from tabActivity_of_collection ac ;






select tb.*, bp.contract_status, bp.rank_update from temp_sme_pbx_BO tb
inner join tabSME_BO_and_Plan bp on (tb.id = bp.name)
WHERE tb.`type` = 'F' and tb.month_type between 13 and 30


select customer_name  from tabSME_Approach_list WHERE name = 299876

select date_format(curdate(), '%Y-%m-01')


select count(*)
from tabSME_BO_and_Plan bp LEFT JOIN sme_org sme on (cASe when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
-- LEFT JOIN sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
WHERE bp.name in (select id from temp_sme_pbx_BO WHERE `type` in ('F') and month_type > 12)
	and sme.unit_no is not null -- if resigned staff no need
order by sme.id ASc;





select sp.name `id`, sp.refer_id `lms_broker_id`,
	sme2.staff_no `lms_staff_no`, te2.name `lms_name`,
	sme.staff_no `current_staff_no`, te.name `current_name`,
	sme3.staff_no `modified_staff_no`, te3.name `modified_name`,
	cASe when sme2.staff_no is not null then te2.name 
		when sme.staff_no is not null then te.name
		when sme3.staff_no is not null then te3.name
		else sp.current_staff
	end `current_staff`
from tabsme_Sales_partner sp
LEFT JOIN sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
LEFT JOIN tabsme_Employees te on (te.staff_no = SUBSTRING_INDEX(sp.current_staff, ' -', 1) )
LEFT JOIN temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner WHERE refer_id = sp.refer_id order by creation desc limit 1 )
LEFT JOIN sme_org sme2 on (SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) = sme2.staff_no)
LEFT JOIN tabsme_Employees te2 on (te2.staff_no = SUBSTRING_INDEX(tmspd.owner_staff, ' -', 1) )
LEFT JOIN tabsme_Employees te3 on (te3.email = sp.modified_by)
LEFT JOIN sme_org sme3 on (sme3.staff_no = te3.staff_no)
WHERE sp.refer_type = 'LMS_Broker';



select * from tabsme_Sales_partner sp WHERE sp.modified_by = 'mek2539@lalco.la'

select * from tabsme_Employees te3 WHERE te3.email = 'mek2539@lalco.la' and te3.staff_no = '2539'

select * from sme_org sme3 WHERE sme3.staff_no = '2539'



select * from tabUser tu 



show index from tabsme_Employees

create index idx_modified_by on tabsme_Sales_partner(modified_by)


SELECT DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) AS first_date_of_lASt_3_months;

select date_add(date(now()), interval + 2 month) ;





select sp.current_staff, sme.staff_no 
from tabsme_Sales_partner sp 
LEFT JOIN sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
WHERE sp.refer_type = 'LMS_Broker';


select sme.id, sme.staff_no, sme.staff_name , te.name from sme_org sme
LEFT JOIN tabsme_Employees te on (te.staff_no = sme.staff_no)
WHERE sme.`rank` <= 49 and unit not in ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')



SELECT sp.name, sp.current_staff, ROW_NUMBER() OVER (ORDER BY sp.name) AS row_num
from tabsme_Sales_partner sp 
LEFT JOIN sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
WHERE sp.refer_type = 'LMS_Broker' and sme.id is null;


SELECT staff_no, ROW_NUMBER() OVER (ORDER BY id) AS row_num
FROM sme_org
WHERE `rank` <= 49 AND unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');



select * from tabsme_Employees te WHERE staff_no = 4718


select * from tabSME_Approach_list tsal WHERE approach_id = 2000044


select send_wa, wa_date,
	cASe when send_wa = 'Yes-ສົ່ງໄດ້' and wa_date >= date_format(curdate(), '%Y-%m-01') then 'sent' else 'x' end `wa_status`
from tabSME_BO_and_Plan tsbap 




SELECT name, approach_id, staff_no , SUBSTRING_INDEX(apl.staff_no, ' -', 1)
from tabSME_Approach_list apl
WHERE approach_type = 'Existing' and staff_no = '22 - DAA';


select * from sme_org so 

-- 5) Prepare table temp_sme_pbx_sp, run this query on server 13.250.153.252 then export to server locahost databASe lalco_pbx table temp_sme_pbx_sp (One time per month)
replace into temp_sme_pbx_SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff 
from tabsme_Sales_partner sp LEFT JOIN sme_org sme on (cASe when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
WHERE sme.`unit_no` is not null;



select name AS id, modified, customer_name, customer_tel, staff_no, own_salesperson from tabSME_BO_and_Plan 
WHERE customer_tel in ('902097777934', '902091967889', '902094347240', '90305198070', '902077964467', '902059913446', '902095092272', '902097777792', '902091967810', '902094347243', '90309710720', '902054179009', '902054041685', '902095092201'
);


select * from tabsme_Sales_partner WHERE current_staff = '4671 - POUNA'




-- SME_XYZ
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	cASe when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.credit, sp.rank_of_credit, sp.credit_remark, ts.pbx_status `LCC check`, 
	cASe when sp.modified < date(now()) then '-' else left(sp.`rank`, locate(' ',sp.`rank`)-1) end `rank of call today`,
	sp.business_type, 
	(cASe when sp.currency = 'USD' then 1 when sp.currency = 'THB' then 1/35.10 when sp.currency = 'LAK' then 1/23480.00 end) * sp.amount `USD_amount`,
	cASe when left(sp.`rank`, locate(' -', sp.`rank`)-1) in ('X') then 'Contracted'
	when left(sp.`rank`, locate(' -', sp.`rank`)-1) in ('S', 'A', 'B', 'C') then 'SABC' else 'no' 
end `introduce status`,
	sp.send_wa, sp.wa_date, 
	cASe when sp.send_wa != '' and sp.wa_date >= '2024-12-01' then 'Sent' else 'x' end `wa_send_status`,
	cASe when sp.modified >= '2024-12-01'  then 'called' else 'x' end `call_ status`,
	sp.refer_type ,  sme.`unit_no` ,
     sp.`rank` 
from tabsme_Sales_partner sp LEFT JOIN sme_org sme on (cASe when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
LEFT JOIN temp_sme_pbx_SP ts on (ts.id = sp.name)
WHERE sp.name in (615750, 685332, 685333, 685336, 686390, 686391, 692957, 692959, 692960, 695103, 701721, 705119, 705121, 707338, 708482, 708483, 713016, 714149, 715366, 715367, 717703
)
	and sp.refer_type = 'tabSME_BO_and_Plan'  
	and sme.`unit_no` is not null -- if resigned staff no need --
     and sp.`rank` not in ('Block - ຕ້ອງການໃຫ້ບຼ໋ອກ' , 'Not interest - ບໍ່ສົນໃຈ ເປັນນາຍໜ້າ')
order by sme.id ;


select * from tabsme_Sales_partner WHERE `rank` is null;

update tabsme_Sales_partner 
set rank = ''
WHERE rank is null


select * from tabSME_BO_and_Plan tsbap WHERE customer_tel in ('902098246555', '902093586635')

show



select apl.contract_no, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	apl.approach_type
from tabSME_Approach_list apl 
inner join temp_sme_calldata_Dor_Inc tsc on (apl.approach_id = tsc.contract_no)
LEFT JOIN sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
WHERE apl.approach_type = 'Dormant' and unit_no != ''
	and apl.contract_no in (2003397, 2006086, 2012145, 2019188, 2012781, 2012847, 2007960, 2010816, 2011214, 2012231, 2016362, 2017176, 2017490, 2019749, 2001116, 2008485, 2009082, 2009336, 2022412, 2024468, 2036074, 2037794, 2036072, 2048536, 2044543, 2057067, 2053498, 2064794, 2068354, 2067465, 2078645
)
order by sme.id ASc;


-- 
SELECT  sme.id, sme.unit_no, sme.unit, sme.staff_no, te.name 
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
WHERE sme.rank between 70 and 79 -- Who hAS title AS sales
  AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
;



-- 4. Distribute CASes:
WITH cASe_data AS (
    -- Row numbers for cASes
    SELECT contract_no, unit_no, unit, ROW_NUMBER() OVER (PARTITION BY unit_no ORDER BY contract_no) AS cASe_row
    FROM (
        SELECT apl.contract_no, sme.unit_no, sme.unit
        FROM tabSME_Approach_list apl 
        INNER JOIN temp_sme_calldata_Dor_Inc tsc ON (apl.approach_id = tsc.contract_no)
        LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no)
        WHERE apl.approach_type = 'Dormant' AND unit_no != ''
         -- AND apl.contract_no IN ()
    ) sub
),
staff_data AS (
    -- Row numbers for staff
    SELECT sme.unit_no, sme.unit, sme.staff_no, te.name, ROW_NUMBER() OVER (PARTITION BY sme.unit_no ORDER BY sme.staff_no) AS staff_row
    FROM sme_org sme
    LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
    WHERE sme.rank BETWEEN 70 AND 79
      AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
),
unit_staff_counts AS (
    -- Total staff per unit (replaces the missing `staff_count` table)
    SELECT sme.unit_no, COUNT(*) AS total_staff
    FROM sme_org sme
    LEFT JOIN tabsme_Employees te ON te.staff_no = sme.staff_no
    WHERE sme.rank BETWEEN 70 AND 79
      AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC')
    GROUP BY sme.unit_no
),
distribution AS (
    -- Map cASes to staff
    SELECT c.contract_no, c.unit_no, c.unit, s.staff_no, s.name AS ASsigned_staff
    FROM cASe_data c JOIN staff_data s ON c.unit_no = s.unit_no
     AND ((c.cASe_row - 1) % (
         SELECT usc.total_staff FROM unit_staff_counts usc WHERE usc.unit_no = c.unit_no
     )) + 1 = s.staff_row
)
SELECT *
FROM distribution;



select name, staff_no, main_contact, date_resigned, staff_status from tabsme_Employees te 




-- 5) Export the list to do allocation
SELECT sm.id, sm.bp_name, sm.current_staff, sm.management_type 
from temp_sme_pbx_BO_special_management sm
WHERE management_type = 'F created in 4-5-6 months ago';




-- 6) select the employee which want to ASsign the cASe to them
SELECT te.name, sme.*
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON (sme.staff_no = te.staff_no)
-- rank condition: Z5:Z<=19,"G-Dept", Z5:Z<=29,"Dept", Z5:Z<=39,"Sec", Z5:Z<=49,"UL", Z5:Z<=59,"Mini UL", Z5:Z<=69,"TL", Z5:Z<=79,"Sales", TRUE,"CC"
-- WHERE sme.`rank` BETWEEN 0 AND 49 -- for UL and above
 WHERE sme.`rank` BETWEEN 50 AND 59 -- for Mini
-- WHERE sme.`rank` BETWEEN 60 AND 69 -- for TL
-- WHERE sme.`rank` BETWEEN 70 AND 79 -- for Sales
-- WHERE sme.`rank` >= 80 -- for CC
	AND sme.retirement_date IS NULL AND te.name IS NOT NULL 
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');
ORDER BY sme.id ASC;


delete from temp_sme_pbx_BO_special_management
WHERE management_type = 'F created in 4-5-6 months ago'
	and bp_name in (select bp_name from temp_sme_pbx_BO_special_management
		WHERE management_type in ('SABC loan amount over 10,000', 'SABC created in 4-5-6 months ago & loan < 3000', 
									'SABC loan amount between 3000 to 4999', 'SABC loan amount between 5000 to 9999',
									'SABC loan amount over 10,000')
	) 
;


select * from temp_sme_pbx_BO_special_management
WHERE management_type = 'F created in 4-5-6 months ago'



select apl.send_wa 
from tabSME_Approach_list apl 
inner join temp_sme_calldata_Dor_Inc tsc on (apl.approach_id = tsc.contract_no)
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
left join temp_sme_dor_inc tsdi on (apl.approach_id = tsdi.contract_no)
where apl.approach_type = 'Existing'
order by sme.id asc;






show index from sme_pre_daily_report

create index idx_usd_loan_amount on sme_pre_daily_report (usd_loan_amount)


SELECT 
	sp.name , sp.current_staff , sp.owner_staff 
FROM tabsme_Sales_partner sp 
LEFT JOIN tabsme_Employees emp ON (emp.staff_no = sp.refer_id)
where sp.refer_type = 'staff' and emp.staff_status = 'Resigned'


SELECT spdr.*, bp.usd_loan_amount 
FROM sme_pre_daily_report spdr 
left join tabSME_BO_and_Plan bp on (spdr.bp_name = bp.name)
where spdr.date_report = '2025-01-23'
	AND bp.creation >= '2024-12-24'
	AND bp.rank1 in ('S', 'A', 'B', 'C')


SELECT * from tabSME_BO_and_Plan 

alter table sme_pre_daily_report add `usd_loan_amount` decimal(21,2) NOT NULL DEFAULT 0.00


-- 3)  Show Events
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;

-- 5) Drop the Existing Event
DROP EVENT IF EXISTS `refresh_sme_pre_daily_report`;



select ac.contract_no, null `sales_dept`, null `sales_sec`, null `sales_unit`, null `collection_cc`, 
	null `collection_unit`, null `collection_team`, collection_staff `collection_name`, null `ccc_or_collection`,
	date(`date`) `date`, time(`date`) `time`, visited_place, who_you_met, collectioin_result, date(paid_promise_date) `payment_date`, 
	see_collateral, collateral_status, gps_status, visitor_comments, 
	exceptional, detail_of_exceptional, 
	null `full_name`, tel_no,
	call_result, inc_demand, will_inc_date, usd_inc_amount,
	(select count(*) from tabActivity_of_collection 
		where contract_no = ac.contract_no and `date` >= date_format(now(), '%Y-%m-01') 
		group by contract_no 
	) as `number_of_visit`
from tabActivity_of_collection ac 
where date(date) >= date_format(now(), '%Y-%m-01')
order by ac.name desc;


SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;




select * from temp_sme_pbx_BO_special_management 
where management_type = 'all SAB' -- 2,488


select * from sme_pre_daily_report spdr 
where date_report = '2025-01-23'
	and bp_name in (
		select id from temp_sme_pbx_BO_special_management 
		where management_type = 'all SAB'
	)
	



-- 4) SABC pending whitout This month plan
select sme.id `#`, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	bp.`type`, bp.usd_loan_amount, bp.customer_name, bp.rank_update, 
	case when bp.contract_status = 'Contracted' then 'Have Ringi' when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	spdr.disbursement_date_pay_date as `old_disbursement_date`,
	bp.disbursement_date_pay_date as `new_disbursement_date`, 
	bp.name `id`, date_format(bp.modified, '%Y-%m-%d') `date_modified`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) `edit`,
	case when bp.modified >= DATE_FORMAT(NOW(), '%Y-%m-01') then 'Called' else 0 end `is_call_this_month`,
	case when bp.modified >= CURDATE() then 'Called' else 0 end `is_call_today`,
	date_format(bp.creation, '%Y-%m-%d') `creation_date`
from sme_pre_daily_report spdr 
left join tabSME_BO_and_Plan bp on (spdr.bp_name = bp.name)
INNER JOIN temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = spdr.bp_name and tspbsm.management_type = 'all SAB')
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
WHERE 
    spdr.date_report = (SELECT MAX(date_report) FROM sme_pre_daily_report) 
    AND (
        DATE(spdr.disbursement_date_pay_date) NOT BETWEEN CURDATE() AND LAST_DAY(CURDATE())
        OR spdr.disbursement_date_pay_date IS NULL 
        OR spdr.disbursement_date_pay_date = ''
    )
ORDER BY sme.id ASC;



SELECT COUNT(*) FROM sme_pre_daily_report where date_report = '2025-01-27'


-- 9) Check the number of introduce
select sp.name `id`, sp.refer_id `lms_broker_id` , tmsp.no_of_introduces `all_introduces`, tmsp3.no_of_introduces `3months_introduces`,
	case when tmsp3.no_of_introduces >= 10 then 'Diamond'
		when tmsp3.no_of_introduces >= 6 then 'Gold'
		when tmsp3.no_of_introduces >= 3 then 'Silver'
		when tmsp3.no_of_introduces >= 0 then 'Normal'
		else 'Normal'
	end `intro_rankings_3months`,
	case when tmsp3.no_of_introduces >= 10 then '4%'
		when tmsp3.no_of_introduces >= 6 then '3.8%'
		when tmsp3.no_of_introduces >= 3 then '3.36%'
		when tmsp3.no_of_introduces >= 0 then '3.5%'
		else '3.5%'
	end `commission_rate_should_be`,
	sp.current_staff, sme.staff_no, sp.owner_staff `sp_owner_staff`, tmspd.owner_staff `tmspd_owner_staff`
from tabsme_Sales_partner sp
left join sme_org sme on (SUBSTRING_INDEX(sp.current_staff, ' -', 1) = sme.staff_no)
left join temp_sme_Sales_partner tmspd on tmspd.contract_no = (select contract_no  from temp_sme_Sales_partner where refer_id = sp.refer_id order by creation desc limit 1 )
left join (select refer_id, count(*) as `no_of_introduces` from temp_sme_Sales_partner group by refer_id) tmsp on sp.refer_id = tmsp.refer_id
left join (select refer_id, count(*) as `no_of_introduces` from temp_sme_Sales_partner where creation > DATE_ADD(LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)), INTERVAL 1 DAY) group by refer_id) tmsp3 on sp.refer_id = tmsp3.refer_id
where sp.refer_type = 'LMS_Broker';






select DISTINCT management_type from temp_sme_pbx_BO_special_management tspbsm 

select * from temp_sme_pbx_BO_special_management tspbsm 
where management_type = 'SABC Over 1-2 year'






SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;


SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'refresh_sme_pre_daily_report';



SELECT DISTINCT refer_type FROM tabsme_Sales_partner tsp 

SELECT COUNT(*) FROM tabsme_Sales_partner WHERE refer_type = '5way'


SELECT * FROM tabsme_Employees te 


SELECT contract_no, customer_tel, approach_type
FROM tabSME_Approach_list tsal
WHERE approach_type = 'Ringi_Not_Contract'




SELECT name, approach_id
from tabSME_Approach_list
where approach_type = 'Existing';

SELECT name, approach_id
from tabSME_Approach_list
where approach_type = 'Dormant';

show processlist;

kill connection 491332



SELECT * FROM temp_sme_pbx_BO_pre_HC ;
SELECT * FROM temp_sme_pbx_BO ;

SHOW INDEX FROM temp_sme_pbx_BO_pre_HC ;
SHOW INDEX FROM temp_sme_pbx_BO ;

SELECT * FROM tabSME_BO_and_Plan ;

ALTER TABLE temp_sme_pbx_BO_pre_HC ADD usd_loan_amount DECIMAL(20,2) NOT NULL DEFAULT 0;
ALTER TABLE temp_sme_pbx_BO ADD usd_loan_amount DECIMAL(20,2) NOT NULL DEFAULT 0;

ALTER TABLE temp_sme_pbx_BO_pre_HC ADD is_own VARCHAR(255) DEFAULT NULL;
ALTER TABLE temp_sme_pbx_BO ADD is_own VARCHAR(255) DEFAULT NULL;


CREATE INDEX idx_current_staff ON temp_sme_pbx_BO_pre_HC(current_staff);
CREATE INDEX idx_current_staff ON temp_sme_pbx_BO(current_staff);

CREATE INDEX idx_usd_loan_amount ON temp_sme_pbx_BO_pre_HC(usd_loan_amount);
CREATE INDEX idx_usd_loan_amount ON temp_sme_pbx_BO(usd_loan_amount);

CREATE INDEX idx_is_own ON temp_sme_pbx_BO_pre_HC(is_own);
CREATE INDEX idx_is_own ON temp_sme_pbx_BO(is_own);

-- 9) Update the current staff to tabSME_BO_and_Plan
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff ;





SELECT creation ,
	name, 
	customer_name ,
	customer_tel ,
	`type` ,
	usd_loan_amount ,
	normal_bullet ,
	disbursement_date_pay_date ,
	address_province_and_city ,
	village ,
	maker ,
	model ,
	rank1,
	rank_update,
	ringi_comment 
FROM tabSME_BO_and_Plan 
-- WHERE name < 1000000
ORDER BY name DESC;


SELECT *
FROM tabSME_BO_and_Plan 
WHERE name >= 1000000
ORDER BY name DESC;


SELECT *
FROM tabSME_BO_and_Plan 
WHERE name < 1000000
ORDER BY name DESC;





- modified_by = email
- owner = email
- approch_list = '⑤ ຈາກການໂທ 200-3-3-1 ຂອງ CC ພາຍໃຕ້ຕົນເອງ'
- `type` = 'New'
- visit_or_not = 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ'
- rank1 = rank_update
- customer_card = 'No - ຍັງບໍ່ມີບັດ'



-- DELETE FROM tabSME_BO_and_Plan WHERE name >= 1000000


show processlist

kill connection 1171008;
kill connection 946010;
kill connection 946011;
kill connection 946012;
kill connection 946013;
kill connection 144443;

SELECT * FROM tabsme_Sales_partner
WHERE collateral IS NOT NULL



SELECT * FROM tabHR_SME_Address thsa 



SELECT distinct rank_update FROM tabSME_BO_and_Plan









-- 1. Fresh beer strategy
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
	bp.customer_tel,
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
	bp.reason_of_credit AS `reason_of_Credit`
FROM tabSME_BO_and_Plan bp
LEFT JOIN sme_org sme ON (SUBSTRING_INDEX(bp.staff_no, ' ', 1) = sme.staff_no)
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
		bp.creation >= '2025-09-09'
		-- only SABCF rank
		AND bp.rank1 IN ('S', 'A', 'B', 'C')
ORDER BY sme.id ASC,
	bp.name ASC 
;

















