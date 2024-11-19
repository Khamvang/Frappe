

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

-- 2.1 update current sales
update temp_sme_pbx_SP ts inner join tabsme_Sales_partner sp on (ts.id = sp.name)
set ts.current_staff = sp.current_staff ;

-- 2.2 insert new record to temp_sme_pbx_SP
insert into temp_sme_pbx_SP 
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff from tabsme_Sales_partner sp inner join sme_org sme on (sp.current_staff = sme.staff_no)
where name not in (select id from temp_sme_pbx_SP);


-- SABC export the current list 
select * from temp_sme_pbx_BO tspb;

-- SABC Additional list for SABC less or 1 year
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and date_format(bp.creation, '%Y-%m-%d') between '2024-01-01' and '2024-01-31' and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted', 'Cancelled');

-- _________________________________________________________________ check and update staff no _________________________________________________________________
select * from temp_sme_pbx_BO tspb; -- 422,582

-- check
select bp.staff_no, tb.current_staff  from tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
where bp.staff_no != tb.current_staff;

-- update
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff where tb.`type` = 'F'; -- 369,654

update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set tb.current_staff = bp.staff_no where tb.`type` in ('S','A','B','C'); -- 52,928

update tabSME_BO_and_Plan bp inner join tabSME_BO_and_Plan_bk bpk on (bp.name = bpk.name)
set bp.staff_no = bpk.staff_no where bp.name in (select id from temp_sme_pbx_BO );

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



-- 4) Prepare table temp_dor_inc, run this query on server 13.250.153.252 then export to server locahost database lalco_pbx table temp_dor_inc (One time per month)
select approach_id `contract_no`, customer_tel, null `pbx_status`, null `date`, staff_no `current_staff` 
from tabSME_Approach_list 
where approach_type in ('Dormant', 'Existing');


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
select * from temp_sme_pbx_BO;


-- Past SABCF
-- 7) update
update temp_sme_pbx_bo ts join pbx_unique pu on (ts.broker_tel = pu.contact_no)
set ts.pbx_status = pu.status, ts.`date` = pu.date_created 

-- 8) export to frappe 
select * from temp_sme_pbx_bo;



-- Sales partner
-- 9) update
update temp_sme_pbx_sp ts join pbx_unique pu on (ts.broker_tel = pu.contact_no)
set ts.pbx_status = pu.status, ts.`date` = pu.date_created 


-- 10) export to frappe 
select * from temp_sme_pbx_sp;



-- Dormant and Existing
-- 11) update Dor and Inc
update temp_dor_inc set customer_tel = 
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



-- 12) update
update temp_dor_inc tdi join pbx_unique pu on (tdi.customer_tel = pu.contact_no)
set tdi.pbx_status = pu.status, tdi.`date` = pu.date_created 


-- 13) export to HC Dor and Inc > Sheet PBX
select * from temp_dor_inc tdi 













