

-- 1) create temp_sme_pbx_BO for import the data call on pbx to check did they call by IP Phone or not
create table `temp_sme_pbx_BO` (
  `id` int(11) not null auto_increment,
  `customer_tel` varchar(255) default null,
  `pbx_status` varchar(255) default null,
  `date` datetime default null,
  `current_staff` varchar(255) default null,
  `type` varchar(255) default null,
  `month_type` int(11) default null comment '3=3 months or less, 6=6months or less, 9=9months or less, 12=12months or less',
  primary key (`id`)
) engine=innodb auto_increment=1 default charset=utf8mb3 collate=utf8mb3_general_ci;


-- 2) create temp_sme_pbx_SP for import the data call on pbx to check did they call by IP Phone or not
create table `temp_sme_pbx_SP` (
	`id` int(11) not null auto_increment,
	`broker_tel` varchar(255) default null,
	`pbx_status` varchar(255) default null,
	`date` datetime default null,
	primary key (`id`)
)engine=InnoDB auto_increment=1 default CHARSET=utf8mb3 collate=utf8mb3_general_ci;



-- 3) Create table temp_sme_dor_inc
CREATE TABLE `temp_sme_dor_inc` (
	`contract_no` int(11) NOT NULL AUTO_INCREMENT,
	`customer_tel` varchar(255) DEFAULT NULL,
	`pbx_status` varchar(255) DEFAULT NULL,
	`date` datetime DEFAULT NULL,
	`current_staff` varchar(255) DEFAULT NULL,
	`approach_type` varchar(255) DEFAULT NULL,
	PRIMARY KEY (`contract_no`),
	KEY `idx_customer_tel` (`customer_tel`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;





-- ________________________________________________________________________ Update PBX data ________________________________________________________________________

-- 1) insert data to table Run on server Locahost i7
insert into pbx_unique  
select null id, callee_number 'contact_no',
	case when status = 'FAILED' or status = 'BUSY' or status = 'VOICEMAIL' then 'NO ANSWER' else status end status ,
	'pbx_cdr' `priority_type`,
	date_format(`time`, '%Y-%m-%d') date_created,
	date(now()) date_updated,
	0 lalcocustomer_id ,
	0 custtbl_id ,
	id `pbxcdr_id` ,
	0 `pbxcdr_called_time` ,
	0 `contract_id`,
	0 `lcc_id`,
	0 `BOP_id`
from lalco_pbx.pbx_cdr pc 
where -- status = 'ANSWERED' and communication_type = 'Outbound'
	   status in ('NO ANSWER', 'FAILED', 'BUSY', 'VOICEMAIL' ) and communication_type = 'Outbound'
 and date_format(`time`, '%Y-%m-%d') between '2024-11-01' and '2024-11-31' -- please chcek this date from table all_unique_analysis
 and CONCAT(LENGTH(callee_number), left( callee_number, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
group by callee_number ;


-- 2) update set contact_id
update pbx_unique set contact_id = case when left(contact_no,4) = '9020' then right(contact_no,8) when left(contact_no,4) = '9030' then right(contact_no,7) end ;


-- 3) delete duplicate
delete from pbx_unique where id in (
	select id from ( 
			select id , row_number() over (partition by contact_id order by FIELD(`status`,  "ANSWERED", "NO ANSWER"), date_created desc) as row_numbers  
			from pbx_unique  
			) as t1
		where row_numbers > 1
);



-- 4) Prepare table temp_sme_dor_inc, run this query on server 13.250.153.252 then export to server locahost database lalco_pbx table temp_sme_dor_inc (One time per month)
replace into temp_sme_dor_inc
select approach_id `contract_no`, customer_tel, null `pbx_status`, null `date`, staff_no `current_staff` 
from tabSME_Approach_list 
where approach_type in ('Dormant', 'Existing');


-- Export to server locahost database lalco_pbx table temp_sme_dor_inc
select * from temp_sme_dor_inc;


/* 
-- To remove duplicate, if have any duplicate contract_no
delete from tabSME_Approach_list where name in (
	select name from ( 
			select name , row_number() over (partition by approach_id order by FIELD(`approach_type`,  "Dormant", "Existing") ) as row_numbers  
			from tabSME_Approach_list where approach_type in ('Dormant', 'Existing')
			) as t1
		where row_numbers > 1
);
*/


-- 5) Prepare table temp_sme_pbx_sp, run this query on server 13.250.153.252 then export to server locahost database lalco_pbx table temp_sme_pbx_sp (One time per month)
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff 
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
where sme.`unit_no` is not null;



-- 6)  Prepare table temp_sme_pbx_BO, run this query on server 13.250.153.252 then export to server locahost database lalco_pbx table temp_sme_pbx_BO (One time per month)
-- Please correct temp_sme_pbx_BO based on this query https://github.com/Khamvang/Frappe/blob/main/HC_happy_call_SABCF.sql
	
select * from temp_sme_pbx_BO 


-- Past SABCF, run this query on server locahost database lalco_pbx
-- 7) update
update temp_sme_pbx_bo ts join pbx_unique pu on (ts.broker_tel = pu.contact_no)
set ts.pbx_status = pu.status, ts.`date` = pu.date_created 

-- 8) export to frappe 
select * from temp_sme_pbx_bo where date >= date_add(date(now()), interval - 2 day);



-- Sales partner, run this query on server locahost database lalco_pbx
-- 9) update
update temp_sme_pbx_sp ts join pbx_unique pu on (ts.broker_tel = pu.contact_no)
set ts.pbx_status = pu.status, ts.`date` = pu.date_created 


-- 10) export to frappe, run this query on server locahost database lalco_pbx
select * from temp_sme_pbx_sp where date >= date_add(date(now()), interval - 2 day);



-- Dormant and Existing, run this query on server locahost database lalco_pbx
-- 11) update Dor and Inc
update temp_sme_dor_inc set customer_tel = 
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



-- 12) update, run this query on server locahost database lalco_pbx
update temp_sme_dor_inc tdi join pbx_unique pu on (tdi.customer_tel = pu.contact_no)
set tdi.pbx_status = pu.status, tdi.`date` = pu.date_created 


-- 13) export back to Frappe, run this query on server locahost database lalco_pbx
select * from temp_sme_dor_inc where date >= date_add(date(now()), interval - 2 day);













