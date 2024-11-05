-- Create daily report

-- 1 create table
create table `sme_pre_daily_report` (
  `id` int(11) not null auto_increment,
  `date_report` date not null,
  `bp_name` int(11) not null,
  `rank_update` varchar(255) default null,
  `now_result` varchar(255) default null,
  `rank_update_SABC` int(11) not null default 0,
  `visit_or_not` varchar(255) default null,
  `ringi_status` varchar(255) default null,
  `disbursement_date_pay_date` date default null,
  `datetime_update` datetime default current_timestamp on update current_timestamp,
  primary key (`id`)
) engine=innodb auto_increment=1 default charset=utf8mb3 collate=utf8mb3_general_ci;



-- 2 create EVENT to insert data to the table sme_pre_daily_report

-- 2.1 delete old data, if exist today report before insert new data
CREATE EVENT IF NOT EXISTS `delete_sme_pre_daily_report`
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-23 20:00:00'
DO
	delete from sme_pre_daily_report where date_report = date(now());



-- 2.2 Insert new data to table before report
CREATE EVENT IF NOT EXISTS `insert_to_sme_pre_daily_report`
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-23 20:05:00'
DO
	insert into `sme_pre_daily_report` (`date_report`, `bp_name`, `rank_update`, `now_result`, `rank_update_SABC`, `visit_or_not`, `ringi_status`, `disbursement_date_pay_date`)
	select date(now()) `date_report`,
		bp.name `bp_name`, 
		bp.`rank_update` , 
		case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `now_result`,
		case when rank_update in ('S','A','B','C') then 1 else 0 end `rank_update_SABC`,
		bp.`visit_or_not` ,
		bp.`ringi_status` ,
		bp.`disbursement_date_pay_date` 
	from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
	left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
	where rank_update in ('S','A','B','C','F') 
		and bp.contract_status != 'Contracted' -- if contracted then not need
		and bp.contract_status != 'Cancelled' -- if cencalled then not need
		and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
		and case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end is not null -- if resigned staff no need
	order by sme.id asc;



-- 3) Indexing and Performance: If you're running this event daily, make sure that sme_org and tabSME_BO_and_Plan are indexed properly on columns like staff_no and contract_status for performance optimization.
-- Create index on staff_no in sme_org table
CREATE INDEX idx_sme_org_staff_no ON sme_org(staff_no);

-- Create index on staff_no in tabSME_BO_and_Plan table
CREATE INDEX idx_tabSME_BO_and_Plan_staff_no ON tabSME_BO_and_Plan(staff_no);

-- Create index on contract_status in tabSME_BO_and_Plan table
CREATE INDEX idx_tabSME_BO_and_Plan_contract_status ON tabSME_BO_and_Plan(contract_status);

-- Create index on callcenter_of_sales in tabSME_BO_and_Plan table
CREATE INDEX idx_tabSME_BO_and_Plan_callcenter_of_sales ON tabSME_BO_and_Plan(callcenter_of_sales);

-- Optional: Composite index on rank_update and contract_status (if frequently used together in WHERE clauses)
CREATE INDEX idx_tabSME_BO_and_Plan_rank_contract ON tabSME_BO_and_Plan(rank_update, contract_status);



-- 4) Show Events
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;


-- 5) Drop the Existing Event
DROP EVENT IF EXISTS `insert_to_sme_pre_daily_report`;



-- 6) Remvoe deplucate, if need
delete from sme_pre_daily_report where bp_name in (
select `bp_name` from ( 
		select `bp_name`, row_number() over (partition by `bp_name`, `date_report` order by field(`rank_update`, "S", "A", "B", "C", "F"), id ) as row_numbers  
		from sme_pre_daily_report
	) as t1
where row_numbers > 1 
);














