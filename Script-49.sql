




select `name` 'id', date_format(creation, '%Y-%m-%d') 'date_created', date_format(modified, '%Y-%m-%d') 'date_updated',
	concat(staff_no, ' - ', staff_name) 'sales_person', broker_name , broker_tel , facebook , broker_workplace , business_type , `year` 
	address_province , address_district , address_village , ever_introduced , contract_no , `rank` , 
	date_will_contract , customer_name , customer_tel , currency , amount , collateral , remark 
from tabfive_relationships 


select * from tabfive_relationships order by name desc limit 10;
select * from five_relationships_id_seq;


-- add datetime
SELECT ADDTIME("10:54:21", "00:10:00") as Updated_time ;
SELECT ADDTIME("2023-08-01 12:55:45.212689000", "02:00:00") as Updated_time ;
-- deduct datetime
SELECT SUBTIME('06:14:03', '15:50:90') AS Result;
SELECT SUBTIME('2019-05-01 11:15:45', '20 04:02:01') AS Result; 

select date_format('2023-08-02', '%c'); -- Numeric month name (0 to 12) https://www.w3schools.com/sql/func_mysql_date_format.asp
select date_format('2023-08-02', '%e'); -- Day of the month as a numeric value (0 to 31) https://www.w3schools.com/sql/func_mysql_date_format.asp

select * from tabSME_BO_and_Plan tsbap order by name desc; -- 51554
select * from tabSME_BO_and_Plan tsbap where staff_no = '577' ;
select * from tabUser tu ;
select * from sme_org so ;



select * from tabsme_Sales_partner where owner_staff is null;


-- check and update the data for each rank
select name, rank1 , rank_update , rank_S_date , rank_A_date , rank_B_date , rank_C_date from tabSME_BO_and_Plan where rank_update in ('S','A','B','C');


-- update rank, own_salesperson, customer_tel
update tabSME_BO_and_Plan 
	set rank_S_date = case when rank_update = 'S' then date_format(modified, '%Y-%m-%d') else rank_S_date end,
	rank_A_date = case when rank_update = 'A' then date_format(modified, '%Y-%m-%d') else rank_A_date end,
	rank_B_date = case when rank_update = 'B' then date_format(modified, '%Y-%m-%d') else rank_B_date end,
	rank_C_date = case when rank_update = 'C' then date_format(modified, '%Y-%m-%d') else rank_C_date end,
	rank_update = case when contract_status = 'Contracted' then 'S' else rank_update end,
	ringi_status = case when contract_status = 'Contracted' then 'Approved' else ringi_status end,
	visit_or_not = case when contract_status = 'Contracted' then 'Yes - ຢ້ຽມຢາມແລ້ວ' when visit_date > date(now()) and visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' then 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' else visit_or_not end,
	rank1 = case when date_format(creation, '%Y-%m-%d') = date_format(modified, '%Y-%m-%d') then rank_update else rank1 end,
	`own_salesperson` = case when `own_salesperson` is not null then `own_salesperson` when callcenter_of_sales is null or callcenter_of_sales = '' then staff_no else regexp_replace(callcenter_of_sales  , '[^[:digit:]]', '') end,
	customer_tel = 
	case when customer_tel = '' then ''
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
	  case when broker_tel = '' then ''
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
	broker_type = case when refer_type = 'LMS_Broker' then 'SP - ນາຍໜ້າໃນອາດີດ' else broker_type end,
	refer_type = case when broker_type = '5way - 5ສາຍພົວພັນ' and refer_type is null then '5way' else refer_type end
;




-- update backup data 
insert into tabSME_BO_and_Plan select * from tabSME_BO_and_Plan_bk where name not in (select name from tabSME_BO_and_Plan);
replace into tabSME_BO_and_Plan_bk select * from tabSME_BO_and_Plan; -- Updated Rows	495867
-- replace into tabsme_Sales_partner_bk select * from tabsme_Sales_partner; -- Updated Rows	151647




-- BO https://docs.google.com/spreadsheets/d/1rKhGY4JN5N0EZs8WiUC8dVxFAiwGrxcMp8-K_Scwlg4/edit#gid=1793628529&fvid=551853106
replace into SME_BO_and_Plan_report 
select case when bpr.date_report is null then date(now()) else bpr.date_report end `date_report`, sme.staff_no, 1 `case`, case when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.usd_loan_amount, bp.case_no, bp.contract_no, -- bp.customer_name, 
	concat('=HYPERLINK("http://13.250.153.252:8000/app/sme_bo_and_plan/"&',bp.name,',', '"' , bp.customer_name, '"',')' ) `customer_name`,
	bp.rank_update,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date , 
	case when bpr.id is null and (bp.disbursement_date_pay_date is null or bp.disbursement_date_pay_date < date(now())) then null 
		when bp.disbursement_date_pay_date >= date(Now()) then 'ແຜນເພີ່ມ' when bpr.which is null then null
		when bpr.id is not null then 'ແຜນເພີ່ມ' else bpr.which
	end `which`, 
	bp.name `id`, case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join SME_BO_and_Plan_report bpr on (bpr.id = bp.name)
where ((bp.rank_update in ('S','A','B','C') /*or bp.list_type is not null*/ )
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2024-07-01' then 0 else 1 end != 0 -- if contracted before '2023-09-29' then not need
	-- and bp.disbursement_date_pay_date between date(now()) and '2024-07-31' -- and date_format(bp.modified, '%Y-%m-%d') >= date(now())
	-- and bp.ringi_status != 'Rejected' -- and bp.contract_status != 'Cancelled'
	) or bp.name in (select id from SME_BO_and_Plan_report)
order by sme.id ;

select * from SME_BO_and_Plan_report bpr where date_report = '2024-06-21';


-- _________________ delete in the last month sales plan but can't execute _________________
-- delete from SME_BO_and_Plan_report where now_result in ('Contracted', 'Cancelled') ;
-- delete from SME_BO_and_Plan_report where disbursement_date_pay_date < '2024-07-01' or disbursement_date_pay_date is null;
-- delete from SME_BO_and_Plan_report where id = 638551;

update SME_BO_and_Plan_report set which = null where now_result != 'Contracted' and disbursement_date_pay_date is null

select bpr.* , case when bp.modified >= date(now()) then 'called' else 0 end `is_call_today`, sme.id 
from SME_BO_and_Plan_report bpr left join tabSME_BO_and_Plan bp on (bpr.id = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bpr.which = 'ແຜນເພີ່ມ' and bpr.staff_no is not null -- and bpr.now_result = 'Contracted' and bpr.disbursement_date_pay_date is null
order by sme.id asc ;


-- auto sync to google sheet https://docs.google.com/spreadsheets/d/1Te5-HcXAG8p8nDBrHFiZyEcqPzP4Qqf4OBqA1YloRRg/edit?gid=1913257518#gid=1913257518
select sme.id, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.mini_unit, sme.staff_name,
	bpr.staff_no, bpr.case, bpr.`type`, bpr.usd_loan_amount, bpr.case_no, bpr.contract_no, bpr.customer_name, bpr.rank_update, bpr.now_result, 
	bpr.disbursement_date_pay_date, bpr.which, bpr.id, bpr.comments, 
	case when bp.modified >= date(now()) then 'called' else 0 end `is_call_today`,
	bpr.date_report, bp.customer_name,
	case when bpr.now_result = 'Contracted' and bpr.disbursement_date_pay_date = date(now()) then 'Daily report' 
from SME_BO_and_Plan_report bpr left join tabSME_BO_and_Plan bp on (bpr.id = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bpr.which = 'ແຜນເພີ່ມ' and bpr.staff_no is not null -- and bpr.now_result = 'Contracted' and bpr.disbursement_date_pay_date is null
order by sme.id asc ;


-- manual 
select bpr.* , case when bp.modified >= date(now()) then 'called' else 0 end `is_call_today`, sme.id 
from SME_BO_and_Plan_report bpr left join tabSME_BO_and_Plan bp on (bpr.id = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bpr.id in (660232,676963,684816,667507,702421,669877,701652,668932,666109,700152,692623,673173,665290,698424,694563,702424,702422,699114,668975,702429,694012,701712,674619,700369,671750,694011,689330,668552,699055,683674,682453,702439,701637,689916,695074,695049,688314,701297,697970,695343,687880,695060,673237,698370,691294,669010,681626,612164,678026,670059,618451,682065,671592,699770,688361,699755,681211,694851,674269,701660,699990,673957,667192,660199,682020,671761,641846,684366,698560,667929,696719,676269,691446,668582,690287,670287,668663,701676,666498,701503,661061,697119,701685,685352,668692,666437,673047,701674,700791,700789,669728,667060,684350,660692,695027,700956,698977,702001,701663,696754,700176,670306,698300,696173,702048,702017,699953,696647,699703,699913,676612,700542,698538,671713,692850,696929,689005,702150,701770,584252,696414,700758,665351,701356,698898,674754,664918,690018,700043,654141,696285,624539,664579,694592,689379,668442,688140,700507,663496,685050,695644,702154,700952,679034,671639,695423,702425,667030,700927,665868,700608,702085,701887,701684,670818,700511,654698,694430,702105,665492,700217,667204,702147,692701,666951,684510,648619,670014,699426,642494,702097,701197,700250,692926,664164,683082,662074,690388,695602,702094,672574,680164,693196,702110,700284,691453,665909,678241,664866,691536,695484,691508,697005,676078,684185,701049,672889,696640,691501,695038,676270,677904,671440,685572,680962,691835,698194,700386,700382,702014,696179,700120,702006,701435,682510,698520,701020,668538,694150,702004,671327,701023,670293,691772,700158,666407,690384,697389,677818,695705,693807,668143,691745,701068,666863,687718,695694,698306,695779,701966,659687,700931,700969,700374,698590,702064,685914,667498,670324,696962,665446,694359,683454,702233,665311,694113,701080,661223,664691,689471,666262,671416,664217,666366,692349,686101,701723,699039,677401,695770,688432,646546,685872,628531,702420,694128,652742,668696,664334,698901,695685,653909,694146,701619,646714,685666,663632,668574,698913,683441,661767,697052,681563,692183,685024,700308,646911,671603,697849,687471,701396,698260,659806,666402,695007,668640,692745,698226,672905,687519,702052,702137,701199,698232,689423,701625,665407,692221,662288,670561,668010,642991,664343,688953,665966,692483,691765,663694,691400,661797,672644,691203,689147,680733,687830,682917,669820,700955,691878,693099,696620,694453,693602,702389,701667,668150,681692,13047,674455,685748,682361,693159,667488,695334,15747,688008,694768,702408,680876,701758,668572,697069,681493,668937,702415,702426,686450,700317,694264,669072,668677,674636,701710,666494,670608,656072,662732,686540,662991,662137,668096,694141,660002,677976,697406,675446,667516,665880,700465,668593,692168,663531,678227,667610,690385,662283,674388,687202,671704,686005,671531,668705,670165,667595,666980,674699,671764,668607,671545,690003,688363,678124,692189,664320)
order by field(bpr.id, 660232,676963,684816,667507,702421,669877,701652,668932,666109,700152,692623,673173,665290,698424,694563,702424,702422,699114,668975,702429,694012,701712,674619,700369,671750,694011,689330,668552,699055,683674,682453,702439,701637,689916,695074,695049,688314,701297,697970,695343,687880,695060,673237,698370,691294,669010,681626,612164,678026,670059,618451,682065,671592,699770,688361,699755,681211,694851,674269,701660,699990,673957,667192,660199,682020,671761,641846,684366,698560,667929,696719,676269,691446,668582,690287,670287,668663,701676,666498,701503,661061,697119,701685,685352,668692,666437,673047,701674,700791,700789,669728,667060,684350,660692,695027,700956,698977,702001,701663,696754,700176,670306,698300,696173,702048,702017,699953,696647,699703,699913,676612,700542,698538,671713,692850,696929,689005,702150,701770,584252,696414,700758,665351,701356,698898,674754,664918,690018,700043,654141,696285,624539,664579,694592,689379,668442,688140,700507,663496,685050,695644,702154,700952,679034,671639,695423,702425,667030,700927,665868,700608,702085,701887,701684,670818,700511,654698,694430,702105,665492,700217,667204,702147,692701,666951,684510,648619,670014,699426,642494,702097,701197,700250,692926,664164,683082,662074,690388,695602,702094,672574,680164,693196,702110,700284,691453,665909,678241,664866,691536,695484,691508,697005,676078,684185,701049,672889,696640,691501,695038,676270,677904,671440,685572,680962,691835,698194,700386,700382,702014,696179,700120,702006,701435,682510,698520,701020,668538,694150,702004,671327,701023,670293,691772,700158,666407,690384,697389,677818,695705,693807,668143,691745,701068,666863,687718,695694,698306,695779,701966,659687,700931,700969,700374,698590,702064,685914,667498,670324,696962,665446,694359,683454,702233,665311,694113,701080,661223,664691,689471,666262,671416,664217,666366,692349,686101,701723,699039,677401,695770,688432,646546,685872,628531,702420,694128,652742,668696,664334,698901,695685,653909,694146,701619,646714,685666,663632,668574,698913,683441,661767,697052,681563,692183,685024,700308,646911,671603,697849,687471,701396,698260,659806,666402,695007,668640,692745,698226,672905,687519,702052,702137,701199,698232,689423,701625,665407,692221,662288,670561,668010,642991,664343,688953,665966,692483,691765,663694,691400,661797,672644,691203,689147,680733,687830,682917,669820,700955,691878,693099,696620,694453,693602,702389,701667,668150,681692,13047,674455,685748,682361,693159,667488,695334,15747,688008,694768,702408,680876,701758,668572,697069,681493,668937,702415,702426,686450,700317,694264,669072,668677,674636,701710,666494,670608,656072,662732,686540,662991,662137,668096,694141,660002,677976,697406,675446,667516,665880,700465,668593,692168,663531,678227,667610,690385,662283,674388,687202,671704,686005,671531,668705,670165,667595,666980,674699,671764,668607,671545,690003,688363,678124,692189,664320)



-- for Fong
select bpr.date_report, sme.`g-dept`, sme.dept, sme.sec_branch , sme.unit_no, sme.unit, bpr.staff_no , sme.staff_name, bpr.`case`, bpr.`type` , bpr.usd_loan_amount, bpr.case_no, bpr.contract_no, bp.customer_name, bp.customer_tel, bpr.rank_update, bpr.now_result ,
	bpr.disbursement_date_pay_date, bpr.which , bpr.id, bpr.comments 
from SME_BO_and_Plan_report bpr left join tabSME_BO_and_Plan bp on (bpr.id = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
-- where (bpr.now_result not in ('Contracted', 'Cancelled') and bpr.date_report < '2024-04-01') or bpr.date_report >= '2024-04-01'
 where bpr.disbursement_date_pay_date between '2024-06-10' and '2024-07-31' and bpr.usd_loan_amount >= 10000
-- where bp.name in ()
order by sme.id asc ;


select case when bpr.date_report is null then date(now()) else bpr.date_report end `date_report`, sme.staff_no, sme.staff_name, sme.sec_branch, 1 `case`, case when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.usd_loan_amount, bp.case_no, bp.contract_no, -- bp.customer_name, 
	concat('=HYPERLINK("http://13.250.153.252:8000/app/sme_bo_and_plan/"&',bp.name,',', '"' , bp.customer_name, '"',')' ) `customer_name`,
	bp.rank_update,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date , 
	case when bpr.id is null and (bp.disbursement_date_pay_date is null or bp.disbursement_date_pay_date < date(now())) then null 
		when bp.disbursement_date_pay_date >= date(Now()) then 'ແຜນເພີ່ມ' when bpr.which is null then null
		when bpr.id is not null then 'ແຜນເພີ່ມ' else bpr.which
	end `which`, 
	bp.name `id`, case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`,
	bp.credit , bp.modified 
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join SME_BO_and_Plan_report bpr on (bpr.id = bp.name)
where bp.name in (665905,662605,660232,208570,666056,665983,665290,664082,662719,665884,665405,664818,664339,657189,656494,659531,665480,664765,661228,666060,665436,660531,661231,659691,657744,661782,651284,651138,645714,664800,662751,632156,662313,660710,665019,661100,666049,665903,664029,662860,662380,665899,664549,663619,665341,664573,656265,666043,666010,665433,663032,665227,665869,664736,662759,661646,612164,665904,663416,662815,665327,663420,659063,665555,655598,655895,662919,661392,664120,665786,663524,665410,660166,664855,658143,664715,656591,664709,665896,664109,663667,661851,657409,666047,665991,663920,655302,666005,665910,662277,660525,657684,666062,664153,660963,660199,662617,660178,662207,657729,661945,661353,660747,663904,666051,665445,664238,661233,664012,664688,665907,641846,663970,666000,665994,662339,660098,656579,655995,657338,663693,662374,662370,657750,666023,664853,662668,664757,661226,666044,664210,666006,654651,665879,665345,664886,662515,661061,665557,665406,664045,663487,653405,666053,665324,665388,663586,651912,664303,663647,663321,661787,658281,665715,664948,657219,663892,661580,665051,664100,663037,666095,665429,664103,660449,657083,660692,665876,666007,662729,664251,652025,665882,665874,665401,665384,661625,665870,665843,664250,665829,663690,665350,666016,665999,659707,648068,665351,662233,584252,664918,661869,661564,664028,660970,663643,663511,660206,665811,662681,664946,663030,662190,639455,664064,663496,659422,665872,654141,664579,624539,663484,665308,663477,665291,655218,664827,664148,665672,664044,665619,665868,664265,653011,665492,664875,661777,666065,659828,665706,654698,665688,653133,656820,655335,665758,665136,663576,665782,662074,665430,661559,664920,664164,663605,662915,664793,664296,661820,648619,666050,642494,665815,663898,662161,664152,665909,664866,665249,664221,663509,661579,664149,663314,661146,99787,660533,660147,665219,664601,663881,662928,661601,662930,660096,664127,663293,648157,666035,665339,664787,664781,664774,658209,657656,663290,659687,658125,654374,665895,664217,657767,665886,656999,663691,665446,656460,662737,665311,655913,661929,664718,661223,664691,659714,660620,663000,661765,660118,649786,665900,649014,664334,647790,663632,661767,660373,653909,646911,665455,661950,659806,655275,650359,665254,664857,664279,661481,661134,654660,664878,662996,662016,665989,662917,665736,665407,663467,661852,655254,665258,662288,655318,654610,642991,657581,665898,663694,661797,641844,662202,660998,663575,662282,662173,660995,665995,665875,665877,661960,663889,56709,666046,662245,659703,657197,666032,664944,664346,650643,657068,665992,657182,656057,653874,653197,652493,656646,657728,665356,655440,664352,653924,663389,661666,661234,663043,664344,664448,664363,662910,666045,661191,665906,665360,664797,660064,664342,605771,663622,662904,662298,665894,661622,665500,662347,661519,656072,662732,664340,662991,662137,660709,665403,660002,664956,665792,666057,665880,664310,662866,659926,659940,657773,664316,662865,662856,660004,665465,664320)
	and bp.credit = '4145 - FONG' and bp.modified >= '2024-07-01';



reset query cache;
flush query cache;
show processlist;
kill connection 70091;
kill connection 70121;
kill connection 70123;


CREATE INDEX tabSME_BO_and_Plan_rank1_IDX USING BTREE ON tabSME_BO_and_Plan (rank1);

select * from tabSME_BO_and_Plan where callcenter_of_sales like '4297%' and creation >= '2024-07-01'

-- xyz to import to tabsme_Sales_partner
insert into tabsme_Sales_partner (`current_staff`, `owner_staff`, `broker_type`, `broker_name`, `broker_tel`, `address_province_and_city`, `address_village`, `business_type`,
	`year`, `refer_id`, `refer_type`, `creation`, `modified`, `owner`)
select case when bp.callcenter_of_sales is not null then bp.callcenter_of_sales else bp.staff_no end `current_staff` , 
	bp.own_salesperson `owner_staff`, bp.is_sales_partner `broker_type`, bp.customer_name `broker_name`, bp.customer_tel `broker_tel`,
	bp.address_province_and_city, bp.address_village, bp.business_type, bp.`year`, bp.name `refer_id`, 'tabSME_BO_and_Plan' `refer_type`,
	bp.creation, bp.modified, bp.owner
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.is_sales_partner in ('X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ')
	and bp.name not in (select refer_id from tabsme_Sales_partner where refer_type = 'tabSME_BO_and_Plan');
	

-- 1st method: to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner;
alter table tabsme_Sales_partner auto_increment= 553306 ; -- next id
insert into sme_sales_partner_id_seq select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;

-- 2nd method: 
-- Step 1: Get the next AUTO_INCREMENT value
SET @next_id = (SELECT MAX(id) + 1 FROM tabsme_Sales_partner);

-- Step 2: Construct the ALTER TABLE query
SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);

-- Step 3: Prepare and execute the query
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;






-- ---------------------------------- update sales partner type ----------------------------------
select refer_type, broker_type, count(*) from tabsme_Sales_partner group by refer_type, broker_type ;
update tabsme_Sales_partner set refer_type = '5way', broker_type = '5way - 5ສາຍພົວພັນ' where refer_type is null or refer_type = '5way';
update tabsme_Sales_partner set broker_type = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ' where refer_type = 'tabSME_BO_and_Plan' and broker_type not in ('Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ'); 
select distinct refer_type, broker_type from tabsme_Sales_partner ;


select * from tabsme_Sales_partner where send_wa = '' or send_wa is null;
update tabsme_Sales_partner set send_wa = 'No-ສົ່ງບໍໄດ້' where send_wa = '' or send_wa is null;
update tabsme_Sales_partner set wa_date = date_format(modified, '%Y-%m-%d') where send_wa != '' and modified >= '2024-08-01' ;




-- ---------------------------------- delete deplicate -----------------------------------
delete from tabsme_Sales_partner where name in (

select refer_type, broker_type, count(*) from tabsme_Sales_partner where name in (
select `name` from ( 
		select `name`, row_number() over (partition by `broker_tel` order by field(`refer_type`, "LMS_Broker", "tabSME_BO_and_Plan", "5way"), 
			field(`broker_type`, "SP - ນາຍໜ້າໃນອາດີດ", "Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "5way - 5ສາຍພົວພັນ"), `name` asc) as row_numbers  
		from tabsme_Sales_partner
	) as t1
where row_numbers > 1 
) group by refer_type, broker_type ;

delete from tabsme_Sales_partner where name in (
select `name` from ( 
		select `name`, row_number() over (partition by `broker_tel` order by field(`refer_type`, "LMS_Broker", "tabSME_BO_and_Plan", "5way"), 
			field(`broker_type`, "SP - ນາຍໜ້າໃນອາດີດ", "Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "5way - 5ສາຍພົວພັນ"), `name` asc) as row_numbers  
		from tabsme_Sales_partner
	) as t1
where row_numbers > 1 
);



-- --------------------------------------------------------------------------------
select * from tabSME_BO_and_Plan tsbap order by name desc limit 10 -- name before import 219602

select name, customer_tel, custtbl_id from tabSME_BO_and_Plan tsbap where name >= 219602 and custtbl_id is not null

-- to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabSME_BO_and_Plan;
alter table tabSME_BO_and_Plan auto_increment= 699110 ; -- next id
insert into sme_bo_and_plan_id_seq select (select max(name)+1 `next_not_cached_value` from tabSME_BO_and_Plan), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;


select * from tabsme_Sales_partner tsp where name in (292,293,294,295,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,908,947,948,1018,2163,2679,2735,2931,3100,3443,3811,3921,4258,4511,4740,5072,5126,5229,5545,96971)

update tabsme_Sales_partner set current_staff = '1453 - AON'
where name in (292,293,294,295,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,908,947,948,1018,2163,2679,2735,2931,3100,3443,3811,3921,4258,4511,4740,5072,5126,5229,5545,96971)

-- check
select bp.staff_no, tb.current_staff  from tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
where bp.staff_no != tb.current_staff;

-- update
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff where tb.`type` = 'F'; -- 369,654

update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff where tb.`type` in ('S','A','B','C'); -- 52,928

update tabSME_BO_and_Plan bp inner join tabSME_BO_and_Plan_bk bpk on (bp.name = bpk.name)
set bp.staff_no = bpk.staff_no where bp.name in (select id from temp_sme_pbx_BO );

-- check
select * from temp_sme_pbx_SP ; -- 43,283

select sp.name, sp.current_staff, ts.current_staff from tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.current_staff != ts.current_staff ;

-- update 
update tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
set sp.current_staff = ts.current_staff;

-- export to check pbx SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'LMS_Broker' -- SP
	or (sp.refer_type = 'tabSME_BO_and_Plan' and sme.`unit_no` is not null) -- XYZ
	or (sp.refer_type = '5way' and sp.owner_staff = sp.current_staff and sme.`unit_no` is not null) -- 5way
order by sme.id ;



select *, left(sp.current_staff, locate(' ', sp.current_staff)-1) from tabsme_Sales_partner sp
where left(sp.current_staff, locate(' ', sp.current_staff)-1) in ('387', '')

select refer_id , business_type  from tabsme_Sales_partner sp where sp.refer_type = 'LMS_Broker'



insert into temp_sme_2
select name, custtbl_id, row_numbers, now() `time` from ( 
		select name, custtbl_id, row_number() over (partition by custtbl_id order by name) as row_numbers  
		from tabSME_BO_and_Plan 
		where name >= 219602 and custtbl_id is not null
		) as t1
	where row_numbers > 1; -- done <= 1068


select * from tabSME_BO_and_Plan where name in (select name from temp_sme_2 )

delete from tabSME_BO_and_Plan where name in (select name from temp_sme_2 )

-- 


select * from tabsme_Sales_partner_bk where name not in (select name from tabsme_Sales_partner);

select bp.name , bp.staff_no, te.staff_no, te.name from tabSME_BO_and_Plan bp left join tabsme_Employees te on (bp.staff_no = te.staff_no)
where bp.staff_no <> te.name and bp.name <= 10000;

update tabSME_BO_and_Plan bp left join tabsme_Employees te on (bp.staff_no = te.staff_no)
set bp.staff_no = te.name where bp.name in (72451, 72623, 75313, 77608) and bp.staff_no <> te.name ;


-- SABC export the current list 
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set tb.current_staff = bp.staff_no where tb.`type` = 'F'

select * from temp_sme_pbx_BO tspb where `type` = 'F' and month_type <= 6; -- 30,292

select count(*)
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
-- left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
where bp.name in (select id from temp_sme_pbx_BO where `type` in ('F') and month_type <= 6)
order by sme.id asc;

-- SABC Additional list for SABC less or 1 year
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and date_format(bp.creation, '%Y-%m-%d') between '2024-01-01' and '2024-01-31' and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted', 'Cancelled');



-- __________________________________________ Prepare new Month __________________________________________
-- check and delete the customer who doesnn't like LALCO
select * from tabSME_BO_and_Plan where reason_of_credit = '18 ບໍ່ມັກ LALCO';
delete from tabSME_BO_and_Plan where reason_of_credit = '18 ບໍ່ມັກ LALCO';


-- SABC update the list for next month
delete from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C');

replace into temp_sme_pbx_BO
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, bp.staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`
	-- case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted');


-- F update the list for next month
delete from temp_sme_pbx_BO where type in ('F');

insert into temp_sme_pbx_BO
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, bp.staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else 'F' end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`
	-- case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('F') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('F') )
	and bp.name not in (select id from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted');



-- SABC update
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else bp.callcenter_of_sales end `current_staff`,
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) = 0  then 1
		when timestampdiff(month, bp.creation, date(now())) > 36 then 36 
		else timestampdiff(month, bp.creation, date(now())) 
	end `month_type`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	bp.address_province_and_city
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where ( bp.rank1 in ('S', 'A', 'B', 'C') or bp.rank_update in ('S', 'A', 'B', 'C') 
		or bp.name in (select id from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C') ) )
	and case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end != 'Contracted'


select staff_no, name from tabsme_Employees ;
select * from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C');
delete from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C');

-- update
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff;



select sp.name, sp.current_staff, sp.owner_staff , te.name , te.staff_no 
from tabsme_Sales_partner sp left join tabsme_Employees te on (sp.owner_staff = te.staff_no) 
where sp.current_staff != te.name

update  tabsme_Sales_partner sp left join tabsme_Employees te on (sp.owner_staff = te.staff_no) 
set sp.owner_staff = te.name
where sp.owner_staff != te.name


-- Yoshi request
select bp.name `id`, date_format(bp.creation, '%Y-%m-%d') `date create`, bp.customer_name, bp.customer_tel , 
	case when timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) =0 then 1 
	else timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `year_type`, -- 
	case when tspb.id is not null then tspb.month_type else timestampdiff(month, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `month_type`,
	bp.rank1, 
	case when bp.contract_status = 'Contracted' then 'Contracted' else bp.rank_update end `type`,
	case when bp.contract_status = 'Contracted' then 'x' else 'ok' end `without contracted`,
	case when sme.staff_no is not null then concat(sme.staff_no, ' - ', sme.staff_name)
		when smec.staff_no is not null then concat(smec.staff_no, ' - ', smec.staff_name)
		else null
	end 'current_staff'
from tabSME_BO_and_Plan bp left join temp_sme_pbx_BO tspb on (bp.name = tspb.id)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.rank1 in ('S', 'A', 'B', 'C', 'F') ;


select rank_update, COUNT(*) from tabSME_BO_and_Plan bp group by rank_update;

select address_province_and_city,
	count(case when contract_status = 'Contracted' then 1 end ) 'Contracted',
	count(case when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 1 end ) 'SABC',
	count(case when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 1 end ) 'F',
	count(case when contract_status != 'Contracted' and rank_update in ('G') then 1 end ) 'G'
from tabSME_BO_and_Plan bp group by address_province_and_city;

select address_province_and_city, contract_status, rank_update, count(*)
from tabSME_BO_and_Plan bp group by address_province_and_city, contract_status, rank_update;


-- prepare list for current 18 branches
select name 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	case when contract_status = 'Contracted' then 'Contracted'
		when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 'SABC'
		when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 'F'
		when contract_status != 'Contracted' and rank_update in ('G') then 'G'
	end 'type', 
	maker, model, `year`, rank_update 'remark_1', usd_loan_amount 'remark_2', null 'remark_3'
from tabSME_BO_and_Plan 
where contract_status != 'Contracted'
	and address_province_and_city in ('Sekong - La Mam')
order by address_province_and_city asc;





-- Users Email management  https://docs.google.com/spreadsheets/d/1y_aoS_10n_FAqgWbbaURD9D79WN--wgR5Ih3QwLWTag/edit#gid=659979462
select name, username, first_name, last_name , gender, birth_date, phone , mobile_no, enabled, time_zone from tabUser order by creation desc;


update tabUser set time_zone = 'Asia/Bangkok' where name != 'maheshprabuddika@gmail.com';
update tabUser set enabled = 0 where username in ('1186', '3851');

select * from tabUser where name = 'test1@lalco.la';
select * from user

select staff_no, main_contact  from tabsme_Employees te 

-- export HR system
select ha.name, date_format(ha.creation, '%Y-%m-%d') `date created`, date_format(ha.modified, '%Y-%m-%d') `date updated`,
	ha.office, ha.branch, ha.department, ha.head_of_department, ha.staff_no, 
	ha.category, ha.first_leave_date, ha.end_leave_date, ha.number_of_leave_day, 
	ha.reason, ha.detail_of_reason, concat('http://13.250.153.252:8000', replace(replace(ha.evidence, '/private', '' ), ' ', '%20' )) `evidence`,
	ha.workflow_state,
	concat('http://13.250.153.252:8000/app/hr_absence/', name) `Edit`
from tabHR_Absence ha ;




select address_province_and_city, count(*)
from tabSME_BO_and_Plan
where rank_update in ('G', 'G1', 'G2')
group by address_province_and_city 

select distinct address_province_and_city from tabSME_BO_and_Plan



-- select data to show in google sheet and looker studio
select cb.contract_no, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit, cb.sales_staff, cb.collection_staff, cb.collection_cc_staff,
	cb.customer_name, cb.debt_type, cb.collection_status, cb.now_amount_usd, ac.date, ac.collection_method, ac.call_result, ac.visited_result,
	ac.rank_of_case, ac.next_policy, ac.policy_due_date, ac.promise_date,
	concat('http://13.250.153.252:8000/app/activity_of_collection/', ac.name) `edit`,
	ac.priority,
	ac.collectioin_result, ac.is_order
from tabcontract_base cb 
left join sme_org sme on (case when locate(' ', cb.sales_staff) = 0 then cb.sales_staff else left(cb.sales_staff, locate(' ', cb.sales_staff)-1) end = sme.staff_no)
left join tabActivity_of_collection ac on ac.name = (select name from tabActivity_of_collection where contract_no = cb.name order by name desc limit 1)
where cb.debt_type != ''
order by sme.id asc;





select name, contract_no, `date`, gps_status, exceptional, collection_method, call_result, visited_result, promise_date, priority, is_order 
from tabActivity_of_collection


select contract_no, target_date, debt_type, collection_status from tabcontract_base


update tabcontract_base cb
left join tabActivity_of_collection ac2 on ac2.name = (select name from tabActivity_of_collection where contract_no = cb.name order by name desc limit 1)
set ac2.is_order = 1
where ac2.contract_no in (2106211,2106295,2102480,2103919,2103920,2106506,2076519,2105650,2074803,2077708,2082132,2104711,2104851,2105022,2078175,2082117,2062738,2085295,2089329,2104239,2104515,2105053,2105443,2104740,2105811,2105930,2106037,2098723,2100356,2101761,2073107,2100128,2100423,2102013,2105963,2106492,2103224,2102906,2100211,2102560,2102059,2102555,2104504,2106080,2103975,2103135,2099536,2101538,2103272,2103459,2103415,2104955,2103647,2103832,2106344,2105210,2102851,2097356,2103527,2105965,2102412,2105101
)




select now();
SELECT @@global.time_zone, @@session.time_zone;
SET time_zone = '+07:00';



-- 2) insert collection order to collection and collection CC people
insert into tabActivity_of_collection (`creation`, `contract_no`, `collection_staff`, `date`, `collection_method`, `collectioin_result`, `priority`)
select now() `creation`, cb.contract_no, cb.collection_staff, 
	case when cb.collection_status = 'already paid' then null else date(now()) end `date`, 
	case when cb.collection_status = 'already paid' then '' else 'Visit / ລົງຢ້ຽມຢາມ' end `collection_method`, 
	case when cb.collection_status = 'already paid' then 'Paid / ຈ່າຍ' else null end `collectioin_result`,
	case when cb.collection_status = 'already paid' then ''
		when count(ac.exceptional) >=1 then 1 -- Exceptional case
		when ac2.gps_status = 'offline' or cb.gps_status = 'offline' then 2 -- GPS Offline
		when count(ifnull(ac.promise_date, 1)) >= 1 then 3 -- No payment promise
		when count(ac.promise_date) or ac2.promise_date > date(now()) then 4 -- Break payment primise
		else 5 -- Others
	end `priority` 
from tabcontract_base cb left join tabActivity_of_collection ac on (ac.contract_no = cb.name)
left join tabActivity_of_collection ac2 on ac2.name = (select name from tabActivity_of_collection where contract_no = cb.name order by name desc limit 1)
 where cb.debt_type != '' and cb.collection_status = '0'
group by cb.name ;


delete from tabSME_BO_and_Plan_bk where name = 631221

select * from tabSME_BO_and_Plan bp where date_format(bp.creation, '%Y-%m-%d') = '2024-04-12' 

select ac.`date`, cb.contract_no, ac.exceptional, cb.gps_status 'base_gps_status', ac.gps_status 'activity_gps_status',  ac.promise_date
from tabcontract_base cb left join tabActivity_of_collection ac on (ac.contract_no = cb.name)


select * from tabActivity_of_collection where creation >= date(now()) -1  and contract_no in (2100087, 2106051)  ;

update tabActivity_of_collection set `date` = date(now()) where modified >= date(now())


-- Yoshi orders to check case that have car and no car
select rank_update, 
	count(case when maker != '' or model != '' then 1 end) 'Have car',
	count(case when maker is null and model is null then 1 end) 'No car'
from tabSME_BO_and_Plan 
-- where name <= 100
group by rank_update


select name, maker, model , case when maker != '' or model != '' then 'Have car' end `Car_check`, rank1 , rank_update 
from tabSME_BO_and_Plan where rank_update = 'F';


update tabSME_BO_and_Plan set rank1 = 'F', rank_update = 'F' where rank_update = ''


select *
from tabsme_Sales_partner sp
where current_staff = '387 - LEY' and refer_type = '5way' and sp.owner_staff = sp.current_staff




select name, creation, rank1, contract_status, disbursement_date_pay_date ,
	timestampdiff(day, date_format(creation, '%Y-%m-%d'), disbursement_date_pay_date)
from tabSME_BO_and_Plan bp
where rank1 in ('S', 'A', 'B', 'C')



select * from tabsme_Employees ;

update tabsme_Employees
	set main_contact = 
	  case when main_contact = '' then ''
		when (length (regexp_replace(main_contact , '[^[:digit:]]', '')) = 11 and left (regexp_replace(main_contact , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(main_contact , '[^[:digit:]]', '')) = 10 and left (regexp_replace(main_contact , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(main_contact , '[^[:digit:]]', '')) = 8 and left (regexp_replace(main_contact , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('20',right(regexp_replace(main_contact , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(main_contact , '[^[:digit:]]', '')) = 10 and left (regexp_replace(main_contact , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(main_contact , '[^[:digit:]]', '')) = 9 and left (regexp_replace(main_contact , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(main_contact , '[^[:digit:]]', '')) = 7 and left (regexp_replace(main_contact , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('30',right(regexp_replace(main_contact , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(main_contact , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('30',right(regexp_replace(main_contact , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(main_contact , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('20',right(regexp_replace(main_contact , '[^[:digit:]]', ''),8))
		else concat('20',right(regexp_replace(main_contact , '[^[:digit:]]', ''),8))
	end
;


select staff_no, staff_name, main_contact 
from tabsme_Employees;


select * from tabsme_Sales_partner tsp 

select creation, modified, 'Administrator' owner, current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village,
	broker_workplace, business_type, ever_introduced, contract_no, `rank`, refer_id, refer_type
from tabsme_Sales_partner tsp 
where refer_type = 'LMS_Broker';


select * from tabsme_Sales_partner tsp 
-- where left(broker_tel, 4) = '9030' -- and send_wa is null
where broker_tel = '' and send_wa is null


update tabsme_Sales_partner set send_wa = 'No-ສົ່ງບໍໄດ້'
-- where left(broker_tel, 4) = '9030' and send_wa is null
where broker_tel = ''


select refer_id, broker_type, business_type, refer_type 
from tabsme_Sales_partner tsp where refer_type = 'LMS_Broker'





select * from tabSME_Approach_list 

alter table tabSME_Approach_list add 








