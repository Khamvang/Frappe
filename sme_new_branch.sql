

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
from tabSME_BO_and_Plan bp left join sme_new_branch nb on (bp.name = nb.approach_id)
where bp.name in (select approach_id from sme_new_branch );



TRUNCATE table tabSME_Approach_list


insert into tabSME_Approach_list
(`creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, `customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, `credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`, `priority`, `branch_name`, `approach_type`, `approach_id`
)
select 
`creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, `customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, `credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`, `priority`, `branch_name`, `approach_type`, `approach_id`
from tabSME_Approach_list_2


insert into tabSME_Approach_list_2
(`creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, `customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, `credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`, `priority`, `branch_name`, `approach_type`, `approach_id`
)
select `creation`, `modified`, `modified_by`, `owner`, `docstatus`, `idx`, `staff_no`, `callcenter_of_sales`, `double_count`, `type`, `is_sales_partner`, `approch_list`, `visit_or_not`, `reason_of_visit`, `visit_date`, `details_of_visit_reason`, `priority_to_visit`, `visit_location_url`, `visit_time`, `evidence`, `disbursement_date_pay_date`, `usd_loan_amount`, `usd_fee_amount`, `monthly_interest_rate`, `normal_bullet`, `contract_no`, `case_no`, `customer_name`, `customer_tel`, `address_province_and_city`, `address_village`, `rank1`, `rank_update`, `customer_card`, `attach_customer_card`, `ringi_status`, `ringi_comment`, `contract_status`, `contract_comment`, `maker`, `model`, `year`, `usd_value`, `estate_types`, `land_area`, `real_estate_province_and_city`, `village`, `owner_first_name`, `owner_last_name`, `who_is_it`, `usd_value_of_real_estate`, `have_or_not`, `from_whom`, `date`, `usd_value_of_receivable`, `remark`, `sp_cc`, `rank_update_sp_cc`, `sp_cc_remark`, `credit`, `rank_of_credit`, `reason_of_credit`, `credit_remark`, `visit_checker`, `actual_visit_or_not`, `comment_by_visit_checker`, `_user_tags`, `_comments`, `_assign`, `_liked_by`, `priority`, `branch_name`, 'Approach list' `approach_type`, `name` `approach_id`
from tabSME_Approach_list



alter table tabSME_Approach_list add column `approach_id` int(11) default null

CREATE TABLE `tabSME_Approach_list_2` (
  `name` bigint(20) NOT NULL AUTO_INCREMENT,
  `creation` datetime(6) DEFAULT NULL,
  `modified` datetime(6) DEFAULT NULL,
  `modified_by` varchar(140) DEFAULT NULL,
  `owner` varchar(140) DEFAULT NULL,
  `docstatus` int(1) NOT NULL DEFAULT 0,
  `idx` int(8) NOT NULL DEFAULT 0,
  `staff_no` varchar(140) DEFAULT NULL,
  `callcenter_of_sales` varchar(140) DEFAULT NULL,
  `double_count` varchar(140) DEFAULT NULL,
  `type` varchar(140) DEFAULT NULL,
  `is_sales_partner` varchar(140) DEFAULT NULL,
  `approch_list` varchar(140) DEFAULT NULL,
  `visit_or_not` varchar(140) DEFAULT NULL,
  `reason_of_visit` varchar(140) DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `details_of_visit_reason` varchar(140) DEFAULT NULL,
  `priority_to_visit` varchar(140) DEFAULT NULL,
  `visit_location_url` varchar(140) DEFAULT NULL,
  `visit_time` time(6) DEFAULT NULL,
  `evidence` text DEFAULT NULL,
  `disbursement_date_pay_date` date DEFAULT NULL,
  `usd_loan_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `usd_fee_amount` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `monthly_interest_rate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `normal_bullet` varchar(140) DEFAULT NULL,
  `contract_no` int(11) NOT NULL DEFAULT 0,
  `case_no` varchar(140) DEFAULT NULL,
  `customer_name` varchar(140) DEFAULT NULL,
  `customer_tel` varchar(140) DEFAULT NULL,
  `address_province_and_city` varchar(140) DEFAULT NULL,
  `address_village` varchar(140) DEFAULT NULL,
  `rank1` varchar(140) DEFAULT NULL,
  `rank_update` varchar(140) DEFAULT NULL,
  `customer_card` varchar(140) DEFAULT NULL,
  `attach_customer_card` text DEFAULT NULL,
  `ringi_status` varchar(140) DEFAULT NULL,
  `ringi_comment` varchar(140) DEFAULT NULL,
  `contract_status` varchar(140) DEFAULT NULL,
  `contract_comment` varchar(140) DEFAULT NULL,
  `maker` varchar(140) DEFAULT NULL,
  `model` varchar(140) DEFAULT NULL,
  `year` varchar(140) DEFAULT NULL,
  `usd_value` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `estate_types` varchar(140) DEFAULT NULL,
  `land_area` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `real_estate_province_and_city` varchar(140) DEFAULT NULL,
  `village` varchar(140) DEFAULT NULL,
  `owner_first_name` varchar(140) DEFAULT NULL,
  `owner_last_name` varchar(140) DEFAULT NULL,
  `who_is_it` varchar(140) DEFAULT NULL,
  `usd_value_of_real_estate` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `have_or_not` varchar(140) DEFAULT NULL,
  `from_whom` varchar(140) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `usd_value_of_receivable` decimal(21,9) NOT NULL DEFAULT 0.000000000,
  `remark` varchar(140) DEFAULT NULL,
  `sp_cc` varchar(140) DEFAULT NULL,
  `rank_update_sp_cc` varchar(140) DEFAULT NULL,
  `sp_cc_remark` varchar(140) DEFAULT NULL,
  `credit` varchar(140) DEFAULT NULL,
  `rank_of_credit` varchar(140) DEFAULT NULL,
  `reason_of_credit` varchar(140) DEFAULT NULL,
  `credit_remark` varchar(140) DEFAULT NULL,
  `visit_checker` varchar(140) DEFAULT NULL,
  `actual_visit_or_not` varchar(140) DEFAULT NULL,
  `comment_by_visit_checker` varchar(140) DEFAULT NULL,
  `_user_tags` text DEFAULT NULL,
  `_comments` text DEFAULT NULL,
  `_assign` text DEFAULT NULL,
  `_liked_by` text DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `modified` (`modified`)
) ENGINE=InnoDB AUTO_INCREMENT=50984531 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;









