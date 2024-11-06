

-- Dormant list for Non-sales
select apl.creation,
	apl.staff_no,
	apl.customer_name ,
	apl.customer_tel ,
	apl.address_province_and_city ,
	apl.address_village ,
	apl.maker ,
	apl.model ,
	apl.year ,
	apl.approach_id ,
	apl.currency ,
	apl.usd_loan_amount_old ,
	apl.usd_now_amount ,
	sme.unit_no, sme.unit ,
	case 
		when sme.unit_no = 1 then '1003 - KHAM'
		when sme.unit_no = 2 then '623 - TOU'
		when sme.unit_no = 3 then '3197 - KOUNG'
		when sme.unit_no = 4 then '3306 - JING'
		when sme.unit_no = 5 then '317 - TA'
		when sme.unit_no = 6 then '317 - TA'
		when sme.unit_no = 7 then '4380 - BO'
		when sme.unit_no = 8 then '4380 - BO'
		when sme.unit_no = 9 then '1168 - THIP'
		when sme.unit_no = 10 then '303 - PHIK'
		when sme.unit_no = 11 then '303 - PHIK'
		when sme.unit_no = 12 then '3434 - NAMFON'
		when sme.unit_no = 13 then '2233 - PAENG'
		when sme.unit_no = 14 then '2904 - KOUNG'
		when sme.unit_no = 15 then '2904 - KOUNG'
		when sme.unit_no = 16 then '763 - MOS'
		when sme.unit_no = 17 then '4416 - DETH'
		when sme.unit_no = 18 then '4416 - DETH'
		when sme.unit_no = 19 then '3005 - LAY'
		when sme.unit_no = 20 then '4242 - NOP'
		when sme.unit_no = 21 then '4242 - NOP'
		when sme.unit_no = 22 then '2349 - PHET'
		when sme.unit_no = 23 then '2349 - PHET'
		when sme.unit_no = 24 then '4483 - NOY'
		when sme.unit_no = 25 then '2451 - PUPIEW'
		when sme.unit_no = 26 then '2451 - PUPIEW'
		when sme.unit_no = 27 then '361 - HONEY'
		when sme.unit_no = 28 then '361 - HONEY'
		when sme.unit_no = 29 then '3694 - JEN'
		when sme.unit_no = 30 then '1603 - NUN'
		when sme.unit_no = 31 then '3628 - MEE'
		when sme.unit_no = 32 then '3628 - MEE'
		when sme.unit_no = 33 then '1328 - PARN'
		when sme.unit_no = 34 then '1328 - PARN'
		when sme.unit_no = 35 then '3415 - NOUK'
		when sme.unit_no = 36 then '3415 - NOUK'
		when sme.unit_no = 37 then '3701 - AONG'
		when sme.unit_no = 38 then '3736 - AIRNOY'
		when sme.unit_no = 39 then '1289 - ALEX'
		when sme.unit_no = 40 then '1289 - ALEX'
		when sme.unit_no = 41 then '3305 - MAY'
		when sme.unit_no = 42 then '3305 - MAY'
		when sme.unit_no = 43 then '3099 - JIJY'
		when sme.unit_no = 44 then '3099 - JIJY'
		when sme.unit_no = 45 then '284 - AM'
		when sme.unit_no = 46 then '284 - AM'
		when sme.unit_no = 47 then '1152 - NOY'
		when sme.unit_no = 48 then '1563 - MON'
		when sme.unit_no = 49 then '1353 - NOUT'
		when sme.unit_no = 50 then '1465 - NOUK'
		when sme.unit_no = 51 then '1465 - NOUK'
		when sme.unit_no = 52 then '469 - SANG'
		when sme.unit_no = 53 then '469 - SANG'
		when sme.unit_no = 54 then '273 - PHONE'
		when sme.unit_no = 55 then '273 - PHONE'
		when sme.unit_no = 56 then '3444 - TANOY'
		when sme.unit_no = 57 then '3444 - TANOY'
		when sme.unit_no = 58 then '1065 - KAB'
		when sme.unit_no = 59 then '1072 - BO'
		when sme.unit_no = 60 then '1072 - BO'
		when sme.unit_no = 61 then '419 - KER'
		when sme.unit_no = 62 then '419 - KER'
		when sme.unit_no = 63 then '2053 - KOUNGKING'
		when sme.unit_no = 64 then '2053 - KOUNGKING'
		when sme.unit_no = 65 then '3932 - NAKHAO'
		when sme.unit_no = 66 then '3932 - NAKHAO'
		when sme.unit_no = 67 then '515 - MIENG'
		when sme.unit_no = 68 then '520 - MUA'
		when sme.unit_no = 69 then '1854 - AMUAY'
		when sme.unit_no = 70 then '4417 - MIT'
		when sme.unit_no = 71 then '3632 - ZAI'
		when sme.unit_no = 72 then '3662 - DEUAN'
		when sme.unit_no = 73 then '4458 - TAR'
		when sme.unit_no = 74 then '4457 - DY'
		when sme.unit_no = 75 then '3479 - KHARN'
		when sme.unit_no = 76 then '4463 - LAXAENG'
		when sme.unit_no = 77 then '4464 - MYNO'
		when sme.unit_no = 78 then '4100 - SANUN'
	end 'Non-sales',
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', apl.name) as `Edit`,
	apl.rank_update, 
	apl.rank_of_credit,
	apl.reason_of_credit ,
	apl.disbursement_date_pay_date 
from tabSME_Approach_list apl
left join tabsme_Employees emp on (apl.staff_no = emp.name)
left join sme_org sme on (emp.staff_no = sme.staff_no)
where apl.approach_type = 'Dormant'
;


