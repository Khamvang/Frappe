


-- 1. Prospect SABCFG 
-- https://docs.google.com/spreadsheets/d/1UJMbMCywiyb2Pq-nlN0DHIcdB5kmB4fr9X-aNt8yBl8/edit?gid=0#gid=0

select bp.name, bp.address_province_and_city , 
	bp.rank_update
from tabSME_BO_and_Plan bp 
where bp.rank_update in ('S','A','B','C','F','G')
	and bp.address_province_and_city != ''
	and bp.contract_status not in ('Contracted');





