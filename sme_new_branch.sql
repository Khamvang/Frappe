

-- 1) Create the form and table for 
http://13.250.153.252:8000/app/doctype/SME_Approach_list

-- 2) 
create table `sme_new_branch`(
	`id` int(11) not null auto_increment,
	`contact_no` varchar(255) default null,
	`branch_name` varchar(255) default null,
	`approach_type` varchar(255) default null,
	`approach_id` int(11) default null,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



-- 3) Insert data to table in Frappe server
insert into tabSME_Approach_list
(`creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, `customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, `credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`, `priority`, `branch_name`, `approach_type`, `approach_id`
)
select `creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, bp.`type`, 
	`is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, 
	`visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, 
	`normal_bullet`, `contract_no`, `case_no`, `customer_name`, bp.`customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, 
	`customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, 
	`usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, 
	`usd_value_of_real_estate`, `have_or_not`, `from_whom`, bp.`date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, 
	`credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, 
	`_comments`, `_assign`, `_liked_by`, null `priority`, 
	case when bp.address_province_and_city = 'Vientiane Province - Vangvieng' then 'Vangvieng'
		when bp.address_province_and_city = 'Vientiane Capital - Parkngum' then 'Mayparkngum'
		when bp.address_province_and_city = 'Vientiane Capital - Xaythany' then 'Xaythany'
		when bp.address_province_and_city = 'Vientiane Capital - Hadxayfong' then 'Hadxaifong'
		when bp.address_province_and_city = 'Vientiane Capital - Naxaythong' then 'Naxaiythong'
		when substring_index(bp.address_province_and_city, ' ', 1) = 'Phongsaly' then 'Phongsary'
		when bp.address_province_and_city = 'Luangprabang - Nam Bak' then 'Nambak'
		when substring_index(bp.address_province_and_city, ' ', 1) = 'Xaysomboune' then 'Xaisomboun'
		when bp.address_province_and_city = 'Xiengkhuang - Kham' then 'Kham'
		when bp.address_province_and_city = 'Xayaboury - Parklai' then 'Parklai'
		when bp.address_province_and_city = 'Savanakhet - Songkhone' then 'Songkhone'
		when bp.address_province_and_city = 'Savanakhet - Phine' then 'Phine'
		when bp.address_province_and_city = 'Borikhamxay - Khamkeut' then 'Khamkeuth'
		when bp.address_province_and_city = 'Champasack - Phonthong' then 'Chongmeg'
		when bp.address_province_and_city = 'Champasack - Paksong' then 'Paksxong'
		when substring_index(bp.address_province_and_city, ' ', 1) = 'Sekong' then 'Sekong'
		else null
	end as `branch_name`, 
	case when tb.`type` in ('S', 'A', 'B', 'C') then 'SABC'
		when tb.`type` in ('F') then 'F'
		else null
	end as `approach_type`, 
	bp.name as `approach_id` 
from tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (bp.name = tb.id)
where bp.address_province_and_city in ('Vientiane Province - Vangvieng', 'Vientiane Capital - Parkngum', 'Vientiane Capital - Xaythany', 'Vientiane Capital - Hadxayfong', 'Vientiane Capital - Naxaythong', 'Luangprabang - Nam Bak', 'Xiengkhuang - Kham', 'Xayaboury - Parklai', 'Savanakhet - Songkhone', 'Savanakhet - Phine', 'Borikhamxay - Khamkeut', 'Champasack - Phonthong', 'Champasack - Paksong')
	or substring_index(bp.address_province_and_city, ' ', 1) in ('Phongsaly', 'Xaysomboune', 'Sekong')
;


-- 4) Export Approach list from i7 server
select now() `creation`, now() `modified`, 
	null `modified_by`, 'Administrator' `owner`, 
	null `staff_no`, 
	name `customer_name`, 
	contact_no `customer_tel`, 
	concat(province_eng, ' - ', district_eng ) `address_province_and_city`, 
	village `address_village`, 
	`maker`, `model`,
	case when branch_name = 'Vangvieng - Vientiane Province' then 'Vangvieng'
		when branch_name = 'Parkngum - Vientiane Capital' then 'Mayparkngum'
		when branch_name = 'Xaythany - Vientiane Capital' then 'Xaythany'
		when branch_name = 'Hadxayfong - Vientiane Capital' then 'Hadxaifong'
		when branch_name = 'Naxaythong - Vientiane Capital' then 'Naxaiythong'
		when branch_name = 'Phongsary' then 'Phongsary'
		when branch_name = 'Nam Bak - Luangprabang' then 'Nambak'
		when branch_name = 'Xaisomboun' then 'Xaisomboun'
		when branch_name = 'Kham - Xiengkhuang' then 'Kham'
		when branch_name = 'Parklai - Xayaboury' then 'Parklai'
		when branch_name = 'Songkhone - Savanakhet' then 'Songkhone'
		when branch_name = 'Phine - Savanakhet' then 'Phine'
		when branch_name = 'Khamkeut - Borikhamxay' then 'Khamkeuth'
		when branch_name = 'Phonthong - Champasack' then 'Chongmeg (Phonthong)'
		when branch_name = 'Paksong - Champasack' then 'Paksxong'
		when branch_name = 'Sekong' then 'Sekong'
		else null
	end as `branch_name`, 
	'Approachlist' `approach_type`, 
	id `approach_id`
from contact_for_202409_lcc
where branch_name like '%-%' or branch_name in ('Phongsary', 'Xaisomboun', 'Sekong')




-- 5) update salesperson in charge
update tabSME_Approach_list
	set staff_no = case 
		when branch_name = 'Vangvieng' then '3643 - NICK'
		when branch_name = 'Mayparkngum' then '1319 - FON'
		when branch_name = 'Xaythany' then '1459 - CAT'
		when branch_name = 'Hadxaifong' then '1955 - KONG'
		when branch_name = 'Naxaiythong' then '843 - NY'
		when branch_name = 'Phongsary' then '616 - TIP'
		when branch_name = 'Nambak' then '2290 - AUN'
		when branch_name = 'Xaisomboun' then '2081 - THA'
		when branch_name = 'Kham' then '1094 - CHANLA'
		when branch_name = 'Parklai' then '1136 - NOY'
		when branch_name = 'Songkhone' then '1454 - DAM'
		when branch_name = 'Phine' then '487 - OP'
		when branch_name = 'Khamkeuth' then '2315 - NOU'
		when branch_name = 'Chongmeg' then '3637 - POUY'
		when branch_name = 'Paksxong' then '3699 - LY'
		when branch_name = 'Sekong' then '1730 - BOUNLEUA'
		else null
	end,
	callcenter_of_sales = null
;




-- 6) Export SABCF
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
	case when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`
from tabSME_Approach_list bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bp.approach_type in ('SABC', 'F')
order by sme.id asc;



-- 7) Export Approachlist
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
	case when sme.dept in ('Collection CC', 'Sales promotion CC', 'Internal', 'LC') then 'Resigned'
		else 'Own' 
	end as `is_own`
from tabSME_Approach_list bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bp.approach_type = 'Approachlist'
order by sme.id asc;






