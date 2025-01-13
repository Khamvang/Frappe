-- --------------- collection ------ 
-- 1. create table sme_project_list for save all data

CREATE TABLE sme_project_list (
    id INT AUTO_INCREMENT,
    debt_type VARCHAR(255) NOT NULL,
    target_month DATE NOT NULL,
    first_payment_date DATE,
    last_payment_date DATE,
    contract_no VARCHAR(255) ,
    customer_name VARCHAR(255) NOT NULL,
    customer_tel VARCHAR(20),
    sale_staff VARCHAR(20),
    collection_staff VARCHAR(20),
    collection_cc_staff VARCHAR(20),
    now_amount_usd DECIMAL(15, 2),
    last_payment_rank varchar(50),
    call_to_whom VARCHAR(255),
    call_status VARCHAR(255),
    number_of_promised INT DEFAULT NULL,
    promised_date DATE DEFAULT NULL,
    -- visit_date datetime(6) DEFAULT NULL,
    gps_status VARCHAR(50) DEFAULT NULL,
    exceptional VARCHAR(255) DEFAULT NULL,
    seized_car VARCHAR(255) DEFAULT NULL,
    payment_status VARCHAR(255),
    payment_method VARCHAR(255),
    collected_date Date default null,
    `datetime_update` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 1 update sme_project list in spreadsheet Example: https://docs.google.com/spreadsheets/d/1iZIPNZDR4q5xnQMlXx8dc6W2nL2f9FMT5B2IikEZt_s/edit?gid=1031641098#gid=1031641098

-- sheet [For_Frappe]
-- then save csv file to table: sme_project_list
-- then run sql to update target: 


-- table target
CREATE TABLE sme_projectlist_target (
    id INT(11) NOT NULL AUTO_INCREMENT, -- Unique identifier for each row
    contract_no VARCHAR(50) NOT NULL,   -- Contract number, max length of 50 characters
    target_month DATE NOT NULL,         -- Target month stored as a date
    now_amount_usd DECIMAL(15, 2),      -- Amount in USD, with precision up to 2 decimal places
    PRIMARY KEY (id)                    -- Primary key defined correctly here
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- sql for update target
SELECT null as 'id',spl.contract_no as 'contract_no',spl.target_month as 'target_month',spl.now_amount_usd as 'now_amount_usd' 
FROM sme_project_list spl
WHERE target_month = '2024-12-05'

-- for check target month
SELECT target_month, COUNT(contract_no) from sme_projectlist_target spt
group by target_month 

-- for table collected
CREATE TABLE sme_projectlist_collected (
    cread_date datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() ,
    target_id INT NOT NULL,
    contract_no VARCHAR(50),
    affiliation VARCHAR(100),
    sales_gdept VARCHAR(100),
    sales_dept VARCHAR(100),
    sales_sec_branch VARCHAR(100),
    sales_unit VARCHAR(100),
    sales_staff VARCHAR(100),
    collection_staff VARCHAR(100),
    collection_cc_staff VARCHAR(100),
    seized_car VARCHAR(100),
    payment_status VARCHAR(50),
    payment_method VARCHAR(50),
    collected_date DATE,
    payment_rank VARCHAR(50)       
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- for collected
SELECT 
NULL as 'cread_date',
pjt.id as 'target_id',
pjt.contract_no as 'contract_no',
sorg.affiliation as 'affiliation',
sorg.`g-dept` as 'sales_gdept',
sorg.dept as 'sales_dept',
sorg.sec_branch as 'sales_sec_branch',
sorg.unit as 'sales_unit',
CONCAT(sorg.staff_no ," - ",sorg.staff_name) as 'sales_staff',
ep_c.name as 'collection_staff',
ep_cc.name as collection_cc_staff,
spl.seized_car  as 'seized_car',
spl.payment_status  as 'payment_status',
spl.payment_method as 'payment_method',
-- spl.target_month ,
spl.collected_date as 'collected_date',
    CASE 
        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') < DATE_FORMAT(spl.target_month,'2024-01-01') THEN '-'
	    WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-05') THEN 'S'
        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-10') THEN 'A'
        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-20') THEN 'B'
        WHEN DATE_FORMAT(spl.collected_date, '%Y-%m-%d') <= DATE_FORMAT(spl.target_month,'%Y-%m-31') THEN 'C'
        ELSE 'F'
    END AS 'payment_rank'
FROM sme_projectlist_target pjt
left join sme_project_list spl on (spl.contract_no = pjt.contract_no and spl.target_month = pjt.target_month)
left join sme_org sorg on (spl.sale_staff = sorg.staff_no)
LEFT JOIN tabsme_Employees ep_c on (ep_c.staff_no = spl.collection_staff)
LEFT JOIN tabsme_Employees ep_cc on (ep_cc.staff_no = spl.collection_cc_staff)
-- where spl.payment_status = 'already paid'
 where spl.payment_status not in ('already paid') and spl.seized_car  = 'Got car'
-- and spl.target_month = '2024-10-05'

 
 
SELECT * FROM sme_project_list spl ;
SELECT * FROM sme_projectlist_target spt ;
SELECT * FROM sme_projectlist_collected spc ;

 -- export file















-- == Ways 2
-- 2. export project list from LMS live project list by month
-- 3. then adjust like this, 1) insert col A for null. 2) insert now 2row then copy header from this link to check: https://docs.google.com/spreadsheets/d/1oD0r2ozGnW8-ejCaU8Bcm36x8DcvphfRf8UjYDCv0lo/edit?gid=1330890754#gid=1330890754
		-- 3) update date format 4 collumn and delete old header and the data type row. 4) save csv file
-- 4. truncate table: sme_collection_wa_msg by this sql

TRUNCATE TABLE sme_collection_wa_msg;

-- 5. import csv file to table: sme_collection_wa_msg
-- 6. run sql to export to table: sme_project_list
-- >> then start from 2 to 6 again about another month >> need to import 2month delay first then last month and this month

SELECT null as 'id',
 'month'
-- 'OA'
-- 'S'
-- 'No1 auto'
 as 'debt_type',
 '2024-12-05'
-- '2024-11-05'
 as 'target_month',
 null 'first_payment_date',
 null 'last_payment_date',
 scwm.contract_no as 'contract_no',
 scwm.customer_name as 'customer_name',
 scwm.customer_tel_1 as 'customer_tel',
 scwm.sales_no as 'sale_staff',
 scwm.collection_no as 'collection_staff',
 scwm.ccc_no as 'collection_cc_staff',
 scwm.now_amount_usd as 'now_amount_usd',
 scwm.`rank` as 'last_payment_rank',
 scwm.call_whom as 'call_to_whom',
 null as 'call_status',
 scwm.number_of_promise as 'number_of_promised',
 scwm.promise_date as 'promised_date',
 -- taoc.`date` as 'visit_date',
 scwm.gps_status as 'gps_status',
 scwm.exceptional as 'exceptional',
 scwm.seized_car as 'seized_car',
 scwm.paid_or_not as 'payment_status',
 scwm.payment_method as 'payment_method',
 scwm.date_of_pay as 'collected_date',
 CURRENT_DATE() as `datetime_update`
FROM sme_collection_wa_msg scwm 
left join tabActivity_of_collection taoc on taoc.name = (select name from tabActivity_of_collection where contract_no = scwm.contract_no and `date` >= DATE_FORMAT(NOW(),'%Y-%m-01') order by creation desc limit 1)
where scwm.target = 1;
