

-- prepare list for new 13 branches
select name 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	case when contract_status = 'Contracted' then 'Contracted'
		when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 'SABC'
		when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 'F'
		when contract_status != 'Contracted' and rank_update in ('G') then 'G'
	end 'type', 
	maker, model, `year`, rank_update 'remark_1', null 'remark_2', null 'remark_3'
from tabSME_BO_and_Plan 
where contract_status != 'Contracted'
	and address_province_and_city in ('Attapeu - Saysetha','Borikhamxay - Khamkeut','Champasack - Paksong','Champasack - Phonthong','Luangprabang - Nam Bak','Savanakhet - Songkhone','Vientiane Capital - Hadxayfong','Vientiane Capital - Naxaythong','Vientiane Capital - Parkngum','Vientiane Capital - Xaythany','Vientiane Province - Vangvieng','Xayaboury - Parklai','Xiengkhuang - Kham'
)
order by address_province_and_city asc;



-- prepare list for current 18 branches
select name 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	case when contract_status = 'Contracted' then 'Contracted'
		when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 'SABC'
		when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 'F'
		when contract_status != 'Contracted' and rank_update in ('G') then 'G'
	end 'type', 
	maker, model, `year`, rank_update 'remark_1', usd_loan_amount 'remark_2', null 'remark_3'
from tabSME_BO_and_Plan 
where contract_status != 'Contracted'
	and address_province_and_city in ('Attapeu - Samakkhixay','Bokeo - Houay Xay','Borikhamxay - Paksane','Champasack - Pak Se','Huaphanh - Xam Neua','Khammuane - Thakhek','Luangnamtha - Namtha','Luangprabang - Luang Prabang','Oudomxay - Xay','Phongsaly - Boun Neua','Saravane - Saravanh','Savanakhet - Kaysone Phomvihane','Vientiane Capital - Sisattanak','Vientiane Province - phonhong','Xayaboury - Xaiyabuly','Xaysomboune - Anouvong','Sekong - La Mam','Xiengkhuang - Paek'
)
order by address_province_and_city asc;



-- prepare list for all each province and district
select name 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	case when contract_status = 'Contracted' then 'Contracted'
		when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 'SABC'
		when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 'F'
		when contract_status != 'Contracted' and rank_update in ('G') then 'G'
	end 'type', 
	maker, model, `year`, rank_update 'remark_1', usd_loan_amount 'remark_2', address_province_and_city 'remark_3'
from tabSME_BO_and_Plan 
where contract_status != 'Contracted' and address_province_and_city != ''
order by address_province_and_city asc;



-- prepare list of all XYZ of province and district
select name, broker_name, broker_tel, address_province_and_city, broker_type
from tabsme_Sales_partner
where refer_type = 'tabSME_BO_and_Plan' and address_province_and_city != '';






