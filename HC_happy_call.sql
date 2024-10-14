

-- __________________________________________ Prepare new Month __________________________________________
-- 1) check and delete the customer who doesnn't like LALCO
select * from tabSME_BO_and_Plan where reason_of_credit = '18 ບໍ່ມັກ LALCO';
delete from tabSME_BO_and_Plan where reason_of_credit = '18 ບໍ່ມັກ LALCO';
delete from tabSME_BO_and_Plan_bk where reason_of_credit = '18 ບໍ່ມັກ LALCO';


-- 2) SABC update the list for next month
delete from temp_sme_pbx_BO where type in ('S', 'A', 'B', 'C');


-- 3) insert and replace SABC rank from tabSME_BO_and_Plan to temp_sme_pbx_BO
replace into temp_sme_pbx_BO
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, bp.staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`
	-- case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted');


-- 4) F update the list for next month
delete from temp_sme_pbx_BO where type in ('F');


-- 5) insert and replace F rank from tabSME_BO_and_Plan to temp_sme_pbx_BO
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


-- 6) Export data to allocate the cases of resigned employees to current employees
select tb.* , bp.usd_loan_amount, 
	case when sme.dept is null then 'Resigned' when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`,
	sme.unit_no
from tabSME_BO_and_Plan bp 
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme.staff_no)
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
order by sme.id asc;












-- draft
select date_format(bp.creation, '%Y-%m-%d') as `Date created`, 
	bp.modified as `Timestamp`,
	bp.name as `id`, 
	sme.dept as `DEPT`, 
	sme.sec_branch as `SECT`, 
	sme.unit_no as `Unit_no`, 
	sme.unit as `Unit`, 
	sme.staff_no as `Staff No`, 
	sme.staff_name as `Staff Name`, 
	bp.`type`, 
	bp.usd_loan_amount, 
	bp.normal_bullet ,
	bp.customer_name ,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', bp.name) as `Edit`,
	bp.rank_update , 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	is_sales_partner as `SP_rank`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end as `rank1_SABC`,
	case when rank_update in ('S','A','B','C') then 1 else 0 end as `SABC`, 
	case when bp.modified >= '2024-10-01'  then 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	case when sme.dept is null then 'Resigned' when sme2.dept is null then 'Resigned'
		when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org sme2 on (case when locate(' ', bp.own_salesperson) = 0 then bp.own_salesperson else left(bp.own_salesperson, locate(' ', bp.own_salesperson)-1) end = sme2.staff_no)
-- left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)

