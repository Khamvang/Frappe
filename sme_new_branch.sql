

1) Create the form and table for 
http://13.250.153.252:8000/app/doctype/SME_Approach_list

2) 
create table `sme_new_branch`(
	`id` int(11) not null auto_increment,
	`contact_no` varchar(255) default null,
	`branch_name` varchar(255) default null,
	`approach_type` varchar(255) default null,
	`approach_id` int(11) default null,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



3) Insert data to table 
insert into tabSME_Approach_list
(`creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, `customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, `credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`, `priority`, `branch_name`, `approach_type`, `approach_id`
)
select `creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, 
	`is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, 
	`visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, 
	`normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, 
	`customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, 
	`usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, 
	`usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, 
	`credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, 
	`_comments`, `_assign`, `_liked_by`, null `priority`, nb.`branch_name`, nb.`approach_type`, nb.approach_id 
from tabSME_BO_and_Plan bp inner join sme_new_branch nb on (bp.name = nb.approach_id)












