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
