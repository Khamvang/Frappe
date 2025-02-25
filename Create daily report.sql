-- Create daily report

-- 1 create table
create table `sme_pre_daily_report` (
  `id` int(11) not null auto_increment,
  `date_report` date not null,
  `bp_name` int(11) not null,
  `rank_update` varchar(255) default null,
  `now_result` varchar(255) default null,
  `rank_update_SABC` int(11) not null default 0,
  `visit_or_not` varchar(255) default null,
  `ringi_status` varchar(255) default null,
  `disbursement_date_pay_date` date default null,
  `datetime_update` datetime default current_timestamp on update current_timestamp,
  primary key (`id`)
) engine=innodb auto_increment=1 default charset=utf8mb3 collate=utf8mb3_general_ci;



-- 2 create EVENT to insert data to the table sme_pre_daily_report
-- Run this in command line  >> mysql -u mahesh -pmahesh@Secret1 -h 13.250.153.252 --port 3306


DELIMITER $$

CREATE EVENT refresh_sme_pre_daily_report
ON SCHEDULE EVERY 1 DAY
STARTS '2025-01-23 23:00:00'
DO
BEGIN
    -- Step 1: Delete old data for today's report
    DELETE FROM sme_pre_daily_report
    WHERE date_report = DATE(NOW());

    -- Step 2: Insert new data into the report table
    INSERT INTO `sme_pre_daily_report` (`date_report`, `bp_name`, `rank_update`, `now_result`, `rank_update_SABC`, `visit_or_not`, `ringi_status`, `disbursement_date_pay_date`, `usd_loan_amount`)
    SELECT
        DATE(NOW()) AS `date_report`,
        bp.name AS `bp_name`,
        bp.`rank_update`,
        CASE
            WHEN bp.contract_status = 'Contracted' THEN 'Contracted'
            WHEN bp.contract_status = 'Cancelled' THEN 'Cancelled'
            ELSE bp.rank_update
        END AS `now_result`,
        CASE
            WHEN rank_update IN ('S','A','B','C') THEN 1
            ELSE 0
        END AS `rank_update_SABC`,
        bp.`visit_or_not`,
        bp.`ringi_status`,
        bp.`disbursement_date_pay_date`,
	bp.usd_loan_amount
    FROM
        tabSME_BO_and_Plan bp
    LEFT JOIN
        sme_org sme ON (CASE
            WHEN LOCATE(' ', bp.staff_no) = 0 THEN bp.staff_no
            ELSE LEFT(bp.staff_no, LOCATE(' ', bp.staff_no) - 1)
        END = sme.staff_no)
    LEFT JOIN
        sme_org smec ON (REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no)
    WHERE
        rank_update IN ('S','A','B','C','F')
        AND bp.contract_status != 'Contracted'
        AND bp.contract_status != 'Cancelled'
        AND bp.`type` IN ('New', 'Dor', 'Inc')
	        AND CASE
	            WHEN bp.callcenter_of_sales IS NULL OR bp.callcenter_of_sales = ''
	            THEN sme.unit_no
	            ELSE smec.unit_no
        	END IS NOT NULL
    ORDER BY
        sme.id ASC;
END$$

DELIMITER ;




-- 3)  Show Events
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;

SELECT * FROM information_schema.EVENTS WHERE EVENT_NAME = 'refresh_sme_pre_daily_report';



-- 4) manually execute the event before its scheduled time by using the following SQL
EXECUTE EVENT `refresh_sme_pre_daily_report`;



-- 5) Drop the Existing Event
DROP EVENT IF EXISTS `refresh_sme_pre_daily_report`;



-- 6) Remvoe deplucate, if need
delete from sme_pre_daily_report where bp_name in (
select `bp_name` from ( 
		select `bp_name`, row_number() over (partition by `bp_name`, `date_report` order by field(`rank_update`, "S", "A", "B", "C", "F"), id ) as row_numbers  
		from sme_pre_daily_report
	) as t1
where row_numbers > 1 
);




-- __________________________________________________________ Export the report __________________________________________________________
https://docs.google.com/spreadsheets/d/1jHRs_TM-B9RHRYsp1tyRLRFpqGemyth4KPxnV9Pnr3U/edit?gid=915570516#gid=915570516

-- 1) Have plan in This month and Next month
select sme.id `#`, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	bp.`type`, bp.usd_loan_amount, bp.customer_name, bp.rank_update, 
	case when bp.contract_status = 'Contracted' then 'Have Ringi' when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date, 
	bp.name `id`, date_format(bp.modified, '%Y-%m-%d') `date_modified`
from sme_pre_daily_report spdr 
left join tabSME_BO_and_Plan bp on (spdr.bp_name = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where spdr.date_report = (select max(date_report) from sme_pre_daily_report)
	and spdr.disbursement_date_pay_date between CURDATE() and LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH)) -- Date betwwen Today and Next month end
;





-- 2) SABC pending whitout This month and Next month plan
select sme.id `#`, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	bp.`type`, bp.usd_loan_amount, bp.customer_name, bp.rank_update, 
	case when bp.contract_status = 'Contracted' then 'Have Ringi' when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date, 
	bp.name `id`, date_format(bp.modified, '%Y-%m-%d') `date_modified`,
	case when bp.modified >= DATE_FORMAT(NOW(), '%Y-%m-01') then 'Called' else 0 end `is_call_this_month`,
	case when bp.modified >= CURDATE() then 'Called' else 0 end `is_call_today`
from sme_pre_daily_report spdr 
left join tabSME_BO_and_Plan bp on (spdr.bp_name = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where spdr.date_report = (select max(date_report) from sme_pre_daily_report)
	and ( 
			spdr.disbursement_date_pay_date not between CURDATE() and LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
			or spdr.disbursement_date_pay_date is null 
		)
	and rank_update_SABC = 1
;


-- 3) F pending whitout This month and Next month plan
select sme.id `#`, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit_no, sme.unit, sme.staff_no, sme.staff_name,
	bp.`type`, bp.usd_loan_amount, bp.customer_name, bp.rank_update, 
	case when bp.contract_status = 'Contracted' then 'Have Ringi' when bp.contract_status = 'Cancelled' then 'No Ringi' 
		when bp.ringi_status = 'Approved' then 'Have Ringi' when bp.ringi_status = 'Pending approval' then 'Have Ringi' 
		when bp.ringi_status = 'Draft' then 'Have Ringi' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Ringi_status`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `now_result`, 
	bp.disbursement_date_pay_date, 
	bp.name `id`, date_format(bp.modified, '%Y-%m-%d') `date_modified`,
	case when bp.modified >= DATE_FORMAT(NOW(), '%Y-%m-01') then 'Called' else 0 end `is_call_this_month`,
	case when bp.modified >= CURDATE() then 'Called' else 0 end `is_call_today`
from sme_pre_daily_report spdr 
left join tabSME_BO_and_Plan bp on (spdr.bp_name = bp.name)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where spdr.date_report = (select max(date_report) from sme_pre_daily_report)
	and ( 
			spdr.disbursement_date_pay_date not between CURDATE() and LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
			or spdr.disbursement_date_pay_date is null 
		)
	and rank_update_SABC = 0
	and sme.id is not null
;







