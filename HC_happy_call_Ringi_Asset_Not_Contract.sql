/*
HC Happy call to Ringi Not Contract & Asset Not Contract

*/

-- 1. Run this query on lalco LMS server then export to Frappe table [tabSME_Approach_list]
-- 1.1 Ringi not contract 
SELECT 
    NOW() AS creation,
    'Administrator' AS owner,
    NULL AS staff_no,
    concat(us.staff_no, ' - ', upper(us.nickname)) as `own_salesperson`,
    case when c.status = 4 then 'Inc' else 'New' end AS type,
    p.id AS contract_no,
    c.id AS 'contract_id',
    p.case_no AS case_no,
    CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
    CASE when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	END AS 'customer_tel',
    CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name) AS address_province_and_city,
    CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) AS address_village,
    car.car_make AS maker, 
    convert(cast(convert(car.car_model using latin1) as binary) using utf8) AS model, 
    av.collateral_year AS year,
    '' AS branch_name, 
    'Ringi_Not_Contract' AS approach_type,
    p.id AS approach_id,
    p.trading_currency AS currency,
    p.loan_amount /
            (case when p.trading_currency = 'USD' then 1 
                    when p.trading_currency = 'LAK' then cr.usd2lak 
                    when p.trading_currency = 'THB' then cr.usd2thb
            end)
     AS `usd_loan_amount`,
    '' AS usd_now_amount,
    convert(cast(convert(concat(bt.code, ' ', bt.type) using latin1) as binary) using utf8) 'business_type',
    av.min_buying_price AS 'car_buying_price'
FROM tblcontract c
RIGHT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON cu.id = p.customer_id
LEFT JOIN tblvillage v ON cu.address_village_id = v.id
LEFT JOIN tblcity ci ON ci.id = cu.address_city
LEFT JOIN tblprovince pv ON pv.id = cu.address_province
LEFT JOIN tblprospectasset pa ON pa.prospect_id = p.id
LEFT JOIN tblassetvaluation av ON av.id = pa.assetvaluation_id
LEFT JOIN tblcar car ON av.collateral_car_id = car.id
left join tblbusinesstype bt on (bt.code = cu.business_type)
left join tblcurrencyrate cr on (cr.date_for = date_format(now(), '%Y-%m-01'))
left join tbluser us on (us.id = p.salesperson_id)
WHERE 
	p.id IN (
		SELECT 
			p.id
		from tblprospect p
		left join tblcontract c on (c.prospect_id = p.id)
		LEFT JOIN tblcustomer cu on (cu.id = p.customer_id)
		where FROM_UNIXTIME(p.date_updated , '%Y-%m-%d') between '2024-01-01' and '2025-01-31'
			and cu.id not in (select p.customer_id from tblcontract c left join tblprospect p on (p.id = c.prospect_id) where c.status in (4,6,7) )
		group by cu.id
		order by FIELD(p.status, 3,2,1,0,4) , FIELD(c.status, 4,6,7,3,2,1,0,5) ,
			c.disbursed_datetime desc
);




-- 1.2 Asset not contract
SELECT 
    NOW() AS creation,
    'Administrator' AS owner,
    NULL AS staff_no,
    concat(us.staff_no, ' - ', upper(us.nickname)) as `own_salesperson`,
    case when c.status = 4 then 'Inc' else 'New' end AS type,
    p.id AS contract_no,
    c.id AS 'contract_id',
    p.case_no AS case_no,
    CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
    CASE when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	END AS 'customer_tel',
    CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name) AS address_province_and_city,
    CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) AS address_village,
    car.car_make AS maker, 
    convert(cast(convert(car.car_model using latin1) as binary) using utf8) AS model, 
    av.collateral_year AS year,
    '' AS branch_name, 
    'Asset_Not_Contract' AS approach_type,
    p.id AS approach_id,
    p.trading_currency AS currency,
    p.loan_amount /
            (case when p.trading_currency = 'USD' then 1 
                    when p.trading_currency = 'LAK' then cr.usd2lak 
                    when p.trading_currency = 'THB' then cr.usd2thb
            end)
     AS `usd_loan_amount`,
    '' AS usd_now_amount,
    convert(cast(convert(concat(bt.code, ' ', bt.type) using latin1) as binary) using utf8) 'business_type',
    av.min_buying_price AS 'car_buying_price'
FROM tblcontract c
RIGHT JOIN tblprospect p ON p.id = c.prospect_id
LEFT JOIN tblcustomer cu ON cu.id = p.customer_id
LEFT JOIN tblvillage v ON cu.address_village_id = v.id
LEFT JOIN tblcity ci ON ci.id = cu.address_city
LEFT JOIN tblprovince pv ON pv.id = cu.address_province
LEFT JOIN tblprospectasset pa ON pa.prospect_id = p.id
LEFT JOIN tblassetvaluation av ON av.id = pa.assetvaluation_id
LEFT JOIN tblcar car ON av.collateral_car_id = car.id
left join tblbusinesstype bt on (bt.code = cu.business_type)
left join tblcurrencyrate cr on (cr.date_for = date_format(now(), '%Y-%m-01'))
left join tbluser us on (us.id = p.salesperson_id)
WHERE 
	p.id IN (
		select 
			p.id
		from tblassetvaluation av
		left join tblprospectasset pa on (pa.assetvaluation_id = av.id)
		left join tblprospect p on (p.id = pa.prospect_id)
		left join tblcontract c on (c.prospect_id = p.id)
		LEFT JOIN tblcustomer cu ON (p.customer_id = cu.id)
		LEFT JOIN tblcustomer cu2 ON (cu2.id = av.customer_id)
		where FROM_UNIXTIME(av.date_updated , '%Y-%m-%d') between '2023-08-01' and '2023-08-31'
			and CASE WHEN cu.id IS NULL THEN cu2.id  WHEN cu.id = 0 THEN cu2.id  ELSE cu.id  END not in (
			select p.customer_id from tblcontract c left join tblprospect p on (p.id = c.prospect_id) where c.status in (4,6,7) -- and from_unixtime(c.disbursed_datetime, '%Y-%m-%d') >= '2022-12-01'
			) group by cu.id
		order by FIELD(p.status, 3,2,1,0,4) , FIELD(c.status, 4,6,7,3,2,1,0,5), c.disbursed_datetime desc 
);



-- 2. Run below this on Frappe server
-- 2.1 Check after impop
SELECT name, staff_no, approach_id, approach_type
FROM tabSME_Approach_list 
WHERE approach_type IN ('Ringi_Not_Contract', 'Asset_Not_Contract');



-- 2.2 insert data to temp_sme_pbx_BO_special_management
insert into temp_sme_pbx_BO_special_management
select null as `id`, bp.name as `bp_name`, bp.customer_tel, null `pbx_status`, null `date`, bp.staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	bp.`usd_loan_amount`,
	approach_type as `management_type`
from tabSME_Approach_list bp 
where approach_type in ('Ringi_Not_Contract', 'Asset_Not_Contract');



-- 2.3 Export the list to assign the people in charge
SELECT * FROM temp_sme_pbx_BO_special_management
WHERE management_type in ('Ringi_Not_Contract', 'Asset_Not_Contract')


-- 2.4 Export to make sales follow up 
-- https://docs.google.com/spreadsheets/d/1o9phSJExFrKQZ20qD9co2WZYrABuofXIYoeXFbNfKhw/edit?gid=1344188878#gid=1344188878
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
	case when bp.modified >= date_format(curdate(), '%Y-%m-31')  then 'called' else 'x' end as `call_ status`,
	bp.visit_or_not ,
	bp.ringi_status ,
	bp.disbursement_date_pay_date ,
	bp.credit,
	bp.rank_of_credit,
	bp.reason_of_credit,
	case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end as `comments`,
	null as `is_own`,
	bp.own_salesperson
from tabSME_Approach_list bp 
inner join temp_sme_pbx_BO_special_management tspbsm on (tspbsm.bp_name = bp.name and tspbsm.management_type in ('Ringi_Not_Contract', 'Asset_Not_Contract') )
left join sme_org sme on (case when locate(' ', tspbsm.current_staff) = 0 then tspbsm.current_staff else left(tspbsm.current_staff, locate(' ', tspbsm.current_staff)-1) end = sme.staff_no)
order by sme.id asc;












