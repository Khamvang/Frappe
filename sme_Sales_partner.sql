

-- ______________________________________________________ Satrt Do this every month ______________________________________________________

-- 1) create table temp_sme_Sales_partner
CREATE TABLE `temp_sme_Sales_partner` (
  `contract_no` int(140) NOT NULL AUTO_INCREMENT,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `current_staff` varchar(140) DEFAULT NULL,
  `owner_staff` varchar(140) DEFAULT NULL,
  `broker_type` varchar(140) DEFAULT NULL,
  `broker_name` varchar(140) DEFAULT NULL,
  `broker_tel` varchar(140) DEFAULT NULL,
  `address_province_and_city` varchar(140) DEFAULT NULL,
  `address_village` varchar(140) DEFAULT NULL,
  `broker_workplace` varchar(140) DEFAULT NULL,
  `business_type` varchar(140) DEFAULT NULL,
  `ever_introduced` varchar(140) DEFAULT NULL,
  `rank` varchar(140) DEFAULT NULL,
  `refer_id` int(11) NOT NULL DEFAULT 0,
  `refer_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`contract_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



-- 2) export from LMS to Frappe on table name temp_sme_Sales_partner 
select from_unixtime(c.disbursed_datetime, '%Y-%m-%d %H:%m:%s') `creation`, null `modified`, 'Administrator' `owner`, null `current_staff`, 
	upper(case when u2.nickname = 'Mee' then concat(u.staff_no, ' - ', u.nickname) 
		when u2.staff_no is not null then concat(u2.staff_no, ' - ', u2.nickname) else concat(u.staff_no, ' - ', u.nickname)
	end ) `owner_staff`, 
	'SP - ນາຍໜ້າໃນອາດີດ' `broker_type`, 
	convert(cast(convert(concat(b.first_name , " ",b.last_name) using latin1) as binary) using utf8) `broker_name`, 
	case when left (right (REPLACE ( b.contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( b.contact_no, ' ', '') ,8))
	    when length (REPLACE ( b.contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( b.contact_no, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( b.contact_no, ' ', '') , 8))
	end `broker_tel`,
	concat(left(pr.province_name, locate('-', pr.province_name)-2), ' - ', ci.city_name) `address_province_and_city`, 
	convert(cast(convert(vi.village_name_lao using latin1) as binary) using utf8) `address_village`, null `broker_workplace`, 
	convert(cast(convert(concat(bt.code , " - ",bt.type) using latin1) as binary) using utf8) `business_type`, 'Yes - ເຄີຍແນະນຳມາແລ້ວ' `ever_introduced`, c.contract_no, null `rank`, b.id `refer_id`, 'LMS_Broker' `refer_type`
from tblcontract c left join tblprospect p on (p.id = c.prospect_id)
left join tblbroker b on (b.id = p.broker_id)
left join tbluser u on (u.id = p.salesperson_id)
left join tbluser u2 on (u2.id = p.broker_acquire_salesperson_id)
left join tblbusinesstype bt on (bt.code = b.business_type)
left join tblprovince pr on (b.address_province = pr.id)
left join tblcity ci on (b.address_city = ci.id)
left join tblvillage vi on (b.address_village_id = vi.id)
where c.status in (4,6,7) and p.broker_id <> 0
order by c.contract_no desc;




-- 3) insert data to tabsme_Sales_partner from temp_sme_Sales_partner

insert into tabsme_Sales_partner 
	(contract_no, creation, modified, owner, current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, rank, refer_id, refer_type)
select * from temp_sme_Sales_partner;



-- 4) update the next key to make your form can add new record after you import data from tabSME_BO_and_Plan

select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner;

alter table tabsme_Sales_partner auto_increment= 581384 ; -- next id

insert into sme_sales_partner_id_seq select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;



-- 5) Remove duplicate on tabsme_Sales_partner

delete from tabsme_Sales_partner where name in (
select `name` from ( 
		select `name`, row_number() over (partition by `broker_tel` order by field(`refer_type`, "LMS_Broker", "tabSME_BO_and_Plan", "5way"), 
			field(`broker_type`, "SP - ນາຍໜ້າໃນອາດີດ", "Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ", "5way - 5ສາຍພົວພັນ"), `name` asc) as row_numbers  
		from tabsme_Sales_partner
	) as t1
where row_numbers > 1 
);


-- 6) Update the next id key
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
update tabsme_Sales_partner set wa_date = date_format(modified, '%Y-%m-%d') where send_wa != '' and modified >= '2024-07-01' ;



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




-- ______________________________________________________ End Do this every month ______________________________________________________










-- form for import data from csv to frappe 
select current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, contract_no, `rank`, refer_id  
from tabsme_Sales_partner 

-- add column
alter table tabsme_Sales_partner add column refer_id int(11) not null default 0;


-- to make your form can add new record after you import data by cvs
alter table tabsme_Sales_partner auto_increment=94768; -- next id
insert into sme_sales_partner_id_seq select 94768, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_sales_partner_id_seq;

update tabsme_Sales_partner set modified = date(now()); -- creation = date(now()),


-- export to google sheet
select sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no, sme.staff_name, sp.broker_type, sp.broker_name, sp.`rank`, sp.date_for_introduction, sp.customer_name,
	sp.modified `date_update`, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`, sp.name `id`
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = 'SP -  ນາຍໜ້າໃນອາດີດ';


-- temp update current_staff
create table temp_sme_sales_partner (
	id int(11) not null auto_increment,
	current_staff varchar(255) ,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;



-- update contact_no
update tabsme_Sales_partner set broker_tel = 
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
	end
;


-- SP export to google sheet https://docs.google.com/spreadsheets/d/17coswPI_uF-E3aEXbqMpQD_en1FDKUFX95zXluT3dhs/edit#gid=564749378
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.credit, sp.rank_of_credit, sp.credit_remark, ts.pbx_status `LCC check`, 
	case when sp.modified < date(now()) then '-' else left(sp.`rank`, locate(' ',sp.`rank`)-1) end `rank of call today`,
	sp.business_type
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'LMS_Broker' order by sme.id ;


-- XYZ export to google sheet https://docs.google.com/spreadsheets/d/19IsoiG6JyB1CNodTyDLvLeb7HUM3CYnqHOs7XhjNErE/edit#gid=990597291
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.currency, sp.amount,
	ts.pbx_status `LCC check`
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'tabSME_BO_and_Plan' and sme.`unit_no` is not null -- if resigned staff no need
order by sme.id ;


-- 5way export to google sheet https://docs.google.com/spreadsheets/d/15wAmhxB0gDAHDwa6WSmY-PqPvAm6eOoIP5YKp48wTi4/edit#gid=722440269
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.currency, sp.amount,
	ts.pbx_status `LCC check`,
	sp.business_type
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.broker_type = '5way - 5ສາຍພົວພັນ' and sp.owner_staff = sp.current_staff and sme.`unit_no` is not null -- if resigned staff no need
order by sme.id ;


-- export to check pbx
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp inner join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = '5way - 5ສາຍພົວພັນ' and sp.owner_staff = sp.current_staff 
	and sp.name not in (select refer_id from tabsme_Sales_partner where refer_type = '5way - 5ສາຍພົວພັນ')
order by sme.id ;

-- _____________________________________________________________ update current staff for tabsme_Sales_partner _____________________________________________________________
-- export current data
select name `id`, current_staff , refer_id 
from tabsme_Sales_partner where broker_type = 'SP - ນາຍໜ້າໃນອາດີດ';

-- update 
update tabsme_Sales_partner sp inner join temp_sme_pbx_SP tsp on (sp.name = tsp.id)
set sp.current_staff = tsp.current_staff where  sp.broker_type = 'SP - ນາຍໜ້າໃນອາດີດ';


-- _____________________________________________________________ update Sales partner _____________________________________________________________
-- SP
update tabsme_Sales_partner set broker_type = 'SP - ນາຍໜ້າໃນອາດີດ', refer_type = 'LMS_Broker' where name between 1 and 5677;

-- 5way
update tabsme_Sales_partner set broker_type = '5way - 5ສາຍພົວພັນ', refer_type = '5way' where name between 5678 and 94767;



-- check
select * from temp_sme_pbx_SP ; -- 43,283

select sp.name, sp.current_staff, ts.current_staff from tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.current_staff != ts.current_staff ;

-- update 
update tabsme_Sales_partner sp inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
set ts.current_staff = sp.current_staff;

-- export to check pbx SP
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'LMS_Broker' -- SP
	or (sp.refer_type = 'tabSME_BO_and_Plan' and sme.`unit_no` is not null) -- XYZ
	or (sp.refer_type = '5way' and sp.owner_staff = sp.current_staff and sme.`unit_no` is not null) -- 5way
order by sme.id ;










