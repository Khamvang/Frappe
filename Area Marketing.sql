

-- 1. Existing 
-- https://docs.google.com/spreadsheets/d/1v0T5Sdwi5uQZAPgE0AoQ1H5uqDdm0cwDinxiWQUyjXc/edit?gid=2091521456#gid=2091521456


-- 2. Dormant 
-- https://docs.google.com/spreadsheets/d/1v0T5Sdwi5uQZAPgE0AoQ1H5uqDdm0cwDinxiWQUyjXc/edit?gid=979378677#gid=979378677


-- 3. Prospect SABCFG 
-- https://docs.google.com/spreadsheets/d/1UJMbMCywiyb2Pq-nlN0DHIcdB5kmB4fr9X-aNt8yBl8/edit?gid=0#gid=0

select bp.name, bp.address_province_and_city , 
	bp.rank_update
from tabSME_BO_and_Plan bp 
where bp.rank_update in ('S','A','B','C','F','G')
	and bp.address_province_and_city != ''
	and bp.contract_status not in ('Contracted');

-- 4. Sales partner
-- https://docs.google.com/spreadsheets/d/17coswPI_uF-E3aEXbqMpQD_en1FDKUFX95zXluT3dhs/edit?gid=913072935#gid=913072935


-- 5. 5 relationship
-- https://docs.google.com/spreadsheets/d/15wAmhxB0gDAHDwa6WSmY-PqPvAm6eOoIP5YKp48wTi4/edit?gid=352982216#gid=352982216


-- 6. XYZ
-- https://docs.google.com/spreadsheets/d/19IsoiG6JyB1CNodTyDLvLeb7HUM3CYnqHOs7XhjNErE/edit?gid=2069357420#gid=2069357420






