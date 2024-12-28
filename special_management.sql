
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











