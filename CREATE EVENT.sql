
-- Create events
CREATE EVENT IF NOT EXISTS 'Event Name'
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:20'  -- 5 seconds after the previous event
DO
    'insert logic here';

-- Show events
-- To list all events in your database, you can run:
SHOW EVENTS;
-- To see detailed information about a specific event:
SHOW CREATE EVENT 'Event Name';


-- Modify an Event:
ALTER EVENT 'Event Name'
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-23 00:00:00';


-- Delete or Drop the events
DROP EVENT construct_query;



------------------------------------------------------------------------------------------------------------------------
-- 1) Event to Insert Data
CREATE EVENT IF NOT EXISTS xyz_insert_sales_partner
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:00:00'
DO
    insert into tabsme_Sales_partner (`current_staff`, `owner_staff`, `broker_type`, `broker_name`, `broker_tel`, `address_province_and_city`, `address_village`, `business_type`,
    	`year`, `refer_id`, `refer_type`, `creation`, `modified`, `owner`)
    select case when bp.callcenter_of_sales is not null then bp.callcenter_of_sales else bp.staff_no end `current_staff` , 
    	bp.own_salesperson `owner_staff`, bp.is_sales_partner `broker_type`, bp.customer_name `broker_name`, bp.customer_tel `broker_tel`,
    	bp.address_province_and_city, bp.address_village, bp.business_type, bp.`year`, bp.name `refer_id`, 'tabSME_BO_and_Plan' `refer_type`,
    	bp.creation, bp.modified, bp.owner
    from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
    left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
    where bp.is_sales_partner in ('X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ')
    	and bp.name not in (select refer_id from tabsme_Sales_partner where refer_type = 'tabSME_BO_and_Plan');



-- 2) Event to Set Next AUTO_INCREMENT Value
CREATE EVENT IF NOT EXISTS xyz_set_next_id
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:00'
DO
    SET @next_id = (SELECT MAX(id) + 1 FROM tabsme_Sales_partner);



-- 3) Event to Construct the ALTER TABLE Query
CREATE EVENT IF NOT EXISTS xyz_construct_query
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:05' 
DO
    SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);



-- 4) Event to Prepare the Statement
CREATE EVENT IF NOT EXISTS xyz_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:10'  
DO
    PREPARE stmt FROM @query;



-- 5) Event to Execute the Statement
CREATE EVENT IF NOT EXISTS xyz_execute_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:15'  -- 5 seconds after the previous event
DO
    EXECUTE stmt;



-- 6) Event to Deallocate the Statement
CREATE EVENT IF NOT EXISTS xyz_deallocate_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:20'  -- 5 seconds after the previous event
DO
    DEALLOCATE PREPARE stmt;


-- __________________________________________________________ If want to show and drop the events __________________________________________________________

SHOW EVENTS;

DROP EVENT IF EXISTS update_and_insert_sales_partner;
DROP EVENT IF EXISTS set_next_id;
DROP EVENT IF EXISTS construct_query;
DROP EVENT IF EXISTS prepare_stmt;
DROP EVENT IF EXISTS execute_stmt;
DROP EVENT IF EXISTS deallocate_prepare_stmt;



------- For checking tomorrow
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner; 

next_not_cached_value|
---------------------+
               556395|


select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;

(select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner)|minimum_value|maximum_value      |start_value|increment|cache_size|cycle_option|cycle_count|
----------------------------------------------------------------------+-------------+-------------------+-----------+---------+----------+------------+-----------+
                                                                556395|            1|9223372036854775806|          1|        1|         0|           0|          0|



-- ____________________________________________________________ 

https://chatgpt.com/c/c5d8667e-5834-4f4e-a171-9debc9cf27bd

-- Request:
        Please help me to modified, and each event, I want to set the time, from event name update_and_insert_sales_partner to event name set_next_id set 1 minute later then other remaining set 5 second later
        
        -- Modify an Event:
        ALTER EVENT 'Event Name'
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:00:00'; 
        
        For the even name below here
        
        update_and_insert_sales_partner
        set_next_id
        construct_query
        prepare_stmt
        execute_stmt
        deallocate_prepare_stmt


-- Result:
        -- Modify the event update_and_insert_sales_partner
        ALTER EVENT update_and_insert_sales_partner
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:00:00';
        
        -- Modify the event set_next_id (1 minute after update_and_insert_sales_partner)
        ALTER EVENT set_next_id
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:01:00';
        
        -- Modify the event construct_query (5 seconds after set_next_id)
        ALTER EVENT construct_query
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:01:05';
        
        -- Modify the event prepare_stmt (5 seconds after construct_query)
        ALTER EVENT prepare_stmt
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:01:10';
        
        -- Modify the event execute_stmt (5 seconds after prepare_stmt)
        ALTER EVENT execute_stmt
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:01:15';
        
        -- Modify the event deallocate_prepare_stmt (5 seconds after execute_stmt)
        ALTER EVENT deallocate_prepare_stmt
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-22 13:01:20';












