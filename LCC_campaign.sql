

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
