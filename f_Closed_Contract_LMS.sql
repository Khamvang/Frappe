
-- Refer https://github.com/Khamvang/LALCO-LMS/blob/main/Closed%20Contract%20customer.sql


-- 1) Run this query on lalco server 
SELECT 
	NOW() AS creation,
	'Administrator' AS owner,
	NULL AS staff_no,
	concat(us.staff_no, ' - ', upper(us.nickname)) as `own_salesperson`,
	case when c.status = 4 then 'Inc' else 'Dor' end AS type,
	c.contract_no AS contract_no,
	c.id AS 'contract_id',
	p.case_no AS case_no,
	CONVERT(CAST(CONVERT(CONCAT(cu.customer_first_name_lo, ' ', cu.customer_last_name_lo) USING latin1) AS binary) USING utf8) AS customer_name,
	CONCAT('90', SUBSTRING(cu.main_contact_no, 2)) AS customer_tel,
	CONCAT(LEFT(pv.province_name, LOCATE('-', pv.province_name) - 2), ' - ', ci.city_name) AS address_province_and_city,
	CONVERT(CAST(CONVERT(v.village_name_lao USING latin1) AS binary) USING utf8) AS address_village,
	car.car_make AS maker, 
	convert(cast(convert(car.car_model using latin1) as binary) using utf8) AS model, 
	av.collateral_year AS year,
	case p.call_centre 
		when 1 then '100 - Head Office'
		when 2 then '200 - Savannakhet'
		when 3 then '300 - Pakse - Champasack'
		when 4 then '400 - Luangprabang'
		when 5 then '500 - Oudomxay'
		when 6 then '110 - Vientiane province'
		when 7 then '210 - Xeno - Savanakhet'
		when 8 then '310 - Soukumma - Champasack'
		when 9 then '600 - Xainyabuli'
		when 10 then '700 - Houaphan'
		when 11 then '900 - Xiengkhouang'
		when 12 then '800 - Paksan - Bolikhamxay'
		when 13 then '220 - Paksong - Savanakhet'
		when 14 then '230 - Thakek - Khammuane'
		when 15 then '320 - Salavan'
		when 16 then '330 - Attapeu'
		when 17 then '910 - Kham - Xiengkhuang'
		when 18 then '240 - Phin - Savanakhet'
		when 21 then '999 - Other'
		when 22 then '1000 - Luangnamtha'
		when 24 then '120 - Dongdok - Vientiane Capital'
		when 26 then '111 - Vangvieng - Vientiane province'
		when 27 then '1300 - Bokeo'
		when 28 then '1100 - Phongsaly'
		when 29 then '1200 - Sekong'
		when 30 then '1400 - Xaysomboun'
		when 31 then '1500 - Hadxayfong - Vientiane Capital'
		when 32 then '1600 - Naxaythong - Vientiane Capital'
		when 33 then '1700 - Parkngum - Vientiane Capital'
		when 34 then '1800 - Xaythany - Vientiane Capital'
		when 35 then '1900 - Saysetha - Attapeu'
		when 36 then '2000 - Khamkeut - Borikhamxay'
		when 37 then '2100 - Paksong - Champasack'
		when 38 then '2200 - Chongmeg - Champasack'
		when 39 then '2300 - Nam Bak - Luangprabang'
		when 40 then '2400 - Songkhone - Savanakhet'
		when 41 then '2500 - Parklai - Xayaboury'
		when 42 then '2600 - Sikhottabong - Vientiane Capital '
		when 43 then '2700 - Xanakharm(VTP) - Vientiane Province'
		when 44 then '2800 - Feuang(VTP) - Vientiane Province'
		when 45 then '2900 - Thoulakhom(VTP) - Vientiane Province'
		when 46 then '3000 - Khoune(XKH) - Xienkhuang'
		when 47 then '3100 - Pakkading(PKN) - Borikhamxay'
		when 48 then '3200 - Khong(PKS) - Champasack'
		when 50 then '3300 - Khongxedone(SLV) - Saravane'
		when 51 then '3400 - Atsaphangthong(SVK) - Savanakhet'
		when 52 then '3500 - Nhommalth(TKK) - Khammuane'
		when 53 then '3600 - Nane(LPB) - Luangprabang'
		when 54 then '3700 - Hoon(ODX) - Oudomxay'
		when 55 then '3800 - Hongsa(XYB) - Xayaboury'
		when 56 then '3900 - Tonpherng(BKO) - Bokeo'
	end 'Branch', 
	'Closed_Contract' AS approach_type,
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
	null as 'car_buying_price',
	-- p.last_payment_date, c.date_closed,
	CASE when p.last_payment_date > c.date_closed then 'late close'
		when p.last_payment_date < c.date_closed then 'ealry close'
		else 'normal close'
	END AS 'close_type'
FROM tblcontract c
LEFT JOIN tblprospect p ON p.id = c.prospect_id
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
where  c.status = 7 and c.date_closed >= '2024-12-01' ;


-- 2) Assign the staff_no Col D on this like 
https://docs.google.com/spreadsheets/d/1nh7yngwn1x6G6Tl5p1-tffAOjhgAZ49SlguBVqg02mk/edit?gid=0#gid=0


-- 3) Delete from tabSME_Approach_list
SELECT * FROM tabSME_Approach_list WHERE approach_type = 'Closed_Contract';

DELETE FROM tabSME_Approach_list WHERE approach_type = 'Closed_Contract';


-- 4) Copy paste to CSV file and import to table [tabSME_Approach_list]


-- 5) URL for Sales -- 2. Closed Contract list - ລູກຄ້າປິດງວດເດືອນ 12/24 ແລະ ເດືອນ 1/25 ໃຫ້ຫົວໜ້າໜ່ວຍງານໄປໂທ
-- URL https://docs.google.com/spreadsheets/d/1rVbYYFqjynXZESPbc9N8P05NX4Lg6ySPWD8ZsDE8OK0/edit?gid=1148753746#gid=1148753746

select apl.contract_no, 
	sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	apl.approach_type,
	apl.usd_loan_amount_old, apl.usd_now_amount ,
	apl.customer_name, 
	apl.address_province_and_city, apl.address_village,
	-- concat('https://portal01.lalco.la:1901/salesresultreport_v3_dormant_view.php?contractid=', contract_id) `edit`,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', apl.name) as `edit`,
	-- customer
	/*tsc.customer_neg_updated, tsc.customer_visited, tsc.customer_rank, tsdi.pbx_status `customer_pbx`, null `customer_disburse_date`, tsc.customer_nego_by, */
	date_format(apl.modified, '%Y-%m-%d') as `customer_neg_updated`, left(apl.visit_or_not, locate('-', apl.visit_or_not)-2) as `customer_visited`, apl.rank_update as `customer_rank`, tsdi.pbx_status `customer_pbx`, apl.disbursement_date_pay_date as `customer_disburse_date`, apl.modified_by as customer_nego_by,
	-- gurantor
	tsc.guarantor_neg_updated, tsc.guarantor_visited, tsc.guarantor_rank, null as `guarantor_pbx`, null `guarantor_disburse_date`, tsc.guarantor_nego_by,
	-- agent contact
	tsc.agent_contact_neg_updated, tsc.agent_contact_visited, tsc.agent_contact_rank, null as `agent_contact_pbx`, null `agent_contact_disburse_date`, tsc.agent_contact_nego_by,
	contract_id, 
	apl.car_buying_price - apl.usd_now_amount as `usd_Inc_amount`,
	concat('http://13.250.153.252:8000/app/sme_approach_list/', apl.name) `Frappe_edit`,
	apl.car_type, concat(apl.maker, ' - ', apl.model) as `car`, apl.usd_loan_amount, 
	case when apl.is_sales_partner = 'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ' then 'Yes'
		when apl.is_sales_partner = 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ' then 'Yes'
		when apl.is_sales_partner = 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ' then 'Yes'
		else 'No'
	end as `is_sales_partner`
from tabSME_Approach_list apl 
left join temp_sme_calldata_Dor_Inc tsc on (apl.approach_id = tsc.contract_no)
left join sme_org sme on (SUBSTRING_INDEX(apl.staff_no, ' -', 1) = sme.staff_no )
left join temp_sme_dor_inc tsdi on (apl.approach_id = tsdi.contract_no)
where apl.approach_type = 'Closed_Contract'
order by sme.id asc;













