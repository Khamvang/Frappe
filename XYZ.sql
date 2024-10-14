
-- XYZ for Phoutsady
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.customer_name, bp.customer_tel,
	bp.is_sales_partner,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.is_sales_partner in ('X - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ')
order by sme.id asc;


-- xyz to import to tabsme_Sales_partner
insert into tabsme_Sales_partner (`current_staff`, `owner_staff`, `broker_type`, `broker_name`, `broker_tel`, `address_province_and_city`, `address_village`, `business_type`,
	`year`, `refer_id`, `refer_type`, `creation`, `modified`, `owner`)
select bp.staff_no `current_staff`, bp.own_salesperson `owner_staff`, bp.is_sales_partner `broker_type`, bp.customer_name `broker_name`, bp.customer_tel `broker_tel`,
	bp.address_province_and_city, bp.address_village, bp.business_type, bp.`year`, bp.name `refer_id`, 'tabSME_BO_and_Plan' `refer_type`,
	bp.creation, bp.modified, bp.owner
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.is_sales_partner in ('X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ')
	and bp.name not in (select refer_id from tabsme_Sales_partner where refer_type = 'tabSME_BO_and_Plan');

-- to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner;
alter table tabsme_Sales_partner auto_increment= () ; -- next id
insert into sme_sales_partner_id_seq select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;


update tabsme_Sales_partner sp inner join tabSME_BO_and_Plan bp on (bp.name = sp.refer_id and sp.refer_type = 'tabSME_BO_and_Plan')
set sp.creation = bp.creation, sp.modified = bp.modified, sp.owner = bp.owner



select * from tabsme_Sales_partner where refer_type = 'tabSME_BO_and_Plan'


alter table tabsme_Sales_partner add refer_type varchar(255) default null;

update tabSME_BO_and_Plan set is_sales_partner = 
	case when is_sales_partner = 'X-ລູກຄ້າປັດຈຸບັນສົນໃຈເປັນນາຍໜ້າ' then 'X - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
		when is_sales_partner = 'Y-ລູກຄ້າເກົ່າສົນໃຈເປັນນາຍໜ້າ' then 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
		when is_sales_partner = 'Z-ລູກຄ້າໃໝ່ສົນໃຈເປັນນາຍໜ້າ' then 'Z - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
		else null
	end;


-- check and update fix the definition of sales partner
select sp.name, sp.refer_id, bp.name , bp.`type` , bp.is_sales_partner, sp.broker_type  
from tabsme_Sales_partner sp inner join tabSME_BO_and_Plan bp on (sp.refer_id = bp.name and sp.refer_type = 'tabSME_BO_and_Plan')

update tabsme_Sales_partner sp inner join tabSME_BO_and_Plan bp on (sp.refer_id = bp.name and sp.refer_type = 'tabSME_BO_and_Plan')
set sp.broker_type = case when bp.`type` = 'New' then 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
		when bp.`type` = 'Dor' then 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
		when bp.`type` = 'Inc' then 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
		else sp.broker_type
		end


-- export to google sheet
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sp.current_staff `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel, sp.currency, sp.amount
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.refer_type = 'tabSME_BO_and_Plan' order by sme.id ;


-- export to check pbx
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
-- where sp.broker_type = 'SP - ນາຍໜ້າໃນອາດີດ' order by sme.id ;
where sp.refer_type = 'tabSME_BO_and_Plan' order by sme.id ;











