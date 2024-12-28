
-- 1) create table
CREATE TABLE `temp_sme_pbx_BO_special_management` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bp_name` int(11) NOT NULL,
  `customer_tel` varchar(255) DEFAULT NULL,
  `pbx_status` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `current_staff` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `month_type` int(11) DEFAULT NULL COMMENT '3=3 months or less, 6=6months or less, 9=9months or less, 12=12months or less',
  `usd_loan_amount` decimal(21,2) not null default 0,
  `management_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


-- 2) create INDEX
show index from temp_sme_pbx_BO_special_management;
create index idx_bp_name on temp_sme_pbx_BO_special_management(bp_name);
create index idx_management_type on temp_sme_pbx_BO_special_management(management_type);


-- 3) SABC created in 3 months ago
insert into temp_sme_pbx_BO_special_management
select null as `id`, bp.name as `bp_name`, bp.customer_tel, null `pbx_status`, null `date`, bp.staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	bp.`usd_loan_amount`,
	'SABC created in 3 months ago' as `management_type`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted', 'Cancelled')
	and timestampdiff(month, bp.creation, date(now())) <=3 
	and bp.usd_loan_amount >= 5000;


-- 4) SABC created in 3 months ago
insert into temp_sme_pbx_BO_special_management
select null as `id`, bp.name as `bp_name`, bp.customer_tel, null `pbx_status`, null `date`, bp.staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	bp.`usd_loan_amount`,
	'SABC Cancelled in 3 months ago' as `management_type`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status in ('Cancelled')
	and timestampdiff(month, bp.modified, date(now())) <=3 
	and bp.usd_loan_amount >= 5000;



-- 5) Export the list to do allocation
SELECT sm.id, sm.bp_name, sm.current_staff, sm.management_type 
from temp_sme_pbx_BO_special_management sm
-- WHERE management_type = 'SABC created in 3 months ago';
WHERE management_type = 'SABC Cancelled in 3 months ago';



-- 6) select the employee which want to assign the case to them
SELECT te.name, sme.*
FROM sme_org sme
LEFT JOIN tabsme_Employees te ON (sme.staff_no = te.staff_no)
-- WHERE sme.`rank` <= 59 -- Z5:Z<=19,"G-Dept", Z5:Z<=29,"Dept", Z5:Z<=39,"Sec", Z5:Z<=49,"UL", Z5:Z<=59,"Mini UL", Z5:Z<=69,"TL", Z5:Z<=79,"Sales", TRUE,"CC"
WHERE sme.`rank` <= 69
	AND sme.unit NOT IN ('Collection CC', 'Sales Promotion CC', 'Management', 'Internal', 'LC');
ORDER BY sme.id ASC;




-- 7) Export for Sales 
select bp.modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	sme.dept `DEPT`, 
	sme.sec_branch `SECT`, 
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	sme.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	1 `point`, bp.`type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name , bp.customer_tel ,
	bp.ringi_status , bp.ringi_comment , bp.disbursement_date_pay_date , bp.contract_status , bp.contract_comment , bp.customer_card , bp.rank1 , bp.approch_list , bp.rank_update , 
	bp.visit_date , bp.visit_or_not ,
	case when contract_status = 'Cancelled' then 'Cancelled' else null end `Cancelled Result`, 
	case when rank_update in ('S','A','B','C') then 1 else 0 end `SABC`, 
	case when rank_update in ('C') then 1 else 0 end `C`, 
	sme.sales_cc `sales_cc`, bp.name `id`,
	concat(bp.staff_no,'-', date_format(bp.visit_date, '%c'),'-',date_format(bp.visit_date, '%e'),'-', case when bp.priority_to_visit = '' then 1 else bp.priority_to_visit end ) `Visit plan M-D-P`,
	regexp_replace(bp.sp_cc , '[^[:digit:]]', '') `Sales promotion CC`,
	bp.rank_update_sp_cc ,
	case when left(bp.double_count, locate('-', bp.double_count)-2) = '' then bp.double_count else left(bp.double_count, locate('-', bp.double_count)-2) end `Double count person`,
	regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') `CC`,
	date_format(bp.creation, '%Y-%m-%d') `Date created`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end `rank1_SABC`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when bp.contract_status = 'Contracted' then date_format(bp.modified, '%Y-%m-%d') else null end `rank_X_date`,
	rank_S_date, rank_A_date, rank_B_date, rank_C_date,
	case when bp.contract_status = 'Cancelled' then date_format(bp.modified, '%Y-%m-%d') else null end `Cancelled_date`,
	concat(bp.maker, ' - ', bp.model) `collateral`, bp.`year`,
	null `visit_order`,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village,
	is_sales_partner `SP_rank`,
	bp.credit, bp.rank_of_credit, case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`,
	case when bp.modified >= '2024-12-28' then 'called' else 'x' end `call_status`,
	bp.reason_of_credit
from tabSME_BO_and_Plan bp 
inner join temp_sme_pbx_BO_special_management sm on (sm.bp_name = bp.name)
left join sme_org sme on (case when locate(' ', sm.current_staff) = 0 then sm.current_staff else left(sm.current_staff, locate(' ', sm.current_staff)-1) end = sme.staff_no)
where sm.management_type = 'SABC created in 3 months ago'
-- where sm.management_type = 'SABC Cancelled in 3 months ago'
order by sme.id asc;








