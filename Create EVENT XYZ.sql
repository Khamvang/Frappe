

-- ------------------------------------------------------------ Keyword for events ------------------------------------------------------------
-- 1) Create events
CREATE EVENT IF NOT EXISTS 'Event Name'
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:20'  -- 5 seconds after the previous event
DO
    'insert logic here';

-- 2) Show events
-- 2.1) To list all events in your database, you can run:
SHOW EVENTS;

-- 2.2) To see detailed information about a specific event:
SHOW CREATE EVENT 'Event Name';

-- 2.3) To list the last datetime that execute your events, Replace 'your_database_name' with the actual schema name
SELECT EVENT_NAME, STATUS, LAST_EXECUTED FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169';  


-- 4) Modify an Event:
ALTER EVENT 'Event Name'
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:00:00';


-- 5) Delete or Drop the events
DROP EVENT construct_query;



-- ------------------------------------------------------------ XYZ events ------------------------------------------------------------
-- 1) Event to Insert Data
CREATE EVENT IF NOT EXISTS xyz_insert_sales_partner
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:00:00'
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
STARTS '2024-08-25 00:01:00'
DO
    SET @next_id = (SELECT MAX(id) + 1 FROM tabsme_Sales_partner);


-- 3) Store the value in a user-defined variable
CREATE EVENT IF NOT EXISTS xyz_store_next_id
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:01:10' -- 10 seconds after the previous event
DO
    SET @next_id_user_var = @next_id;


-- 4) Event to Construct the ALTER TABLE Query
CREATE EVENT IF NOT EXISTS xyz_construct_query
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:01:12' -- 2 seconds after the previous event
DO
    SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);



-- 5) Event to Prepare the Statement
CREATE EVENT IF NOT EXISTS xyz_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:01:14'  -- 2 seconds after the previous event
DO
    PREPARE stmt FROM @query;



-- 6) Event to Execute the Statement
CREATE EVENT IF NOT EXISTS xyz_execute_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:01:16'  -- 2 seconds after the previous event
DO
    EXECUTE stmt;



-- 7) Event to Deallocate the Statement
CREATE EVENT IF NOT EXISTS xyz_deallocate_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-25 00:01:18'  -- 2 seconds after the previous event
DO
    DEALLOCATE PREPARE stmt;


-- ------------------------------------------------------------ If want to show and drop the events ------------------------------------------------------------

SHOW EVENTS;

DROP EVENT IF EXISTS xyz_insert_sales_partner;
DROP EVENT IF EXISTS xyz_set_next_id;
DROP EVENT IF EXISTS xyz_store_next_id;
DROP EVENT IF EXISTS xyz_construct_query;
DROP EVENT IF EXISTS xyz_prepare_stmt;
DROP EVENT IF EXISTS xyz_execute_stmt;
DROP EVENT IF EXISTS xyz_deallocate_prepare_stmt;



-- ------------------------------------------------------------ Request to ChatGPT for make the query to modify the schdule ------------------------------------------------------------

https://chatgpt.com/c/c5d8667e-5834-4f4e-a171-9debc9cf27bd

-- Request:
        Please help me to modified, and each event, I want to set the time, from event name update_and_insert_sales_partner to event name set_next_id set 1 minute later then other remaining set 5 second later
        
        -- Modify an Event:
        ALTER EVENT 'Event Name'
        ON SCHEDULE EVERY 1 DAY
        STARTS '2024-08-25 00:00:00'; 
        
        For the even name below here
        
    xyz_insert_sales_partner
    xyz_set_next_id
    xyz_construct_query
    xyz_prepare_stmt
    xyz_execute_stmt
    xyz_deallocate_prepare_stmt


-- Result:
    -- Modify the event xyz_insert_sales_partner
    ALTER EVENT xyz_insert_sales_partner
    ON SCHEDULE EVERY 1 DAY
    STARTS '2024-08-25 00:00:00';
    
    -- Modify the event xyz_set_next_id (1 minute after xyz_insert_sales_partner)
    ALTER EVENT xyz_set_next_id
    ON SCHEDULE EVERY 1 DAY
    STARTS '2024-08-25 00:01:00';
    
    -- Modify the event xyz_construct_query (5 seconds after xyz_set_next_id)
    ALTER EVENT xyz_construct_query
    ON SCHEDULE EVERY 1 DAY
    STARTS '2024-08-25 00:01:05';
    
    -- Modify the event xyz_prepare_stmt (5 seconds after xyz_construct_query)
    ALTER EVENT xyz_prepare_stmt
    ON SCHEDULE EVERY 1 DAY
    STARTS '2024-08-25 00:01:10';
    
    -- Modify the event xyz_execute_stmt (5 seconds after xyz_prepare_stmt)
    ALTER EVENT xyz_execute_stmt
    ON SCHEDULE EVERY 1 DAY
    STARTS '2024-08-25 00:01:15';
    
    -- Modify the event xyz_deallocate_prepare_stmt (5 seconds after xyz_execute_stmt)
    ALTER EVENT xyz_deallocate_prepare_stmt
    ON SCHEDULE EVERY 1 DAY
    STARTS '2024-08-25 00:01:20';












