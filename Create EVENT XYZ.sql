

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
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;


-- 4) Modify an Event:
ALTER EVENT 'Event Name'
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:00:00';


-- 5) Delete or Drop the events
DROP EVENT construct_query;



-- ------------------------------------------------------------ XYZ events ------------------------------------------------------------
-- 1) Event to Insert Data
CREATE EVENT IF NOT EXISTS xyz_insert_sales_partner
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:00:00'
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
STARTS '2024-10-07 00:01:00'
DO
    SET @next_not_cached_value = (SELECT max(name)+1 FROM tabsme_Sales_partner);


-- 3) Store the value in a user-defined variable
CREATE EVENT IF NOT EXISTS xyz_update_next_id
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:01:10' -- 10 seconds after the previous event
DO
    SET @alter_query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_not_cached_value);



-- 4) Event to Prepare the Statement
CREATE EVENT IF NOT EXISTS xyz_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:01:14'  -- 4 seconds after the previous event
DO
    PREPARE stmt FROM @alter_query;



-- 5) Event to Execute the Statement
CREATE EVENT IF NOT EXISTS xyz_execute_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:01:16'  -- 2 seconds after the previous event
DO
    EXECUTE stmt;



-- 6) Event to Deallocate the Statement
CREATE EVENT IF NOT EXISTS xyz_deallocate_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:01:18'  -- 2 seconds after the previous event
DO
    DEALLOCATE PREPARE stmt;



-- 7) Event to Deallocate the Statement
CREATE EVENT IF NOT EXISTS xyz_insert_new_sequence
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 00:01:20'  -- 2 seconds after the previous event
DO
    insert into sme_sales_partner_id_seq 
    select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
    from sme_bo_and_plan_id_seq;




-- ------------------------------------------------------------ If want to show and drop the events ------------------------------------------------------------

SHOW EVENTS;
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = '_8abac9eed59bf169' order by STARTS ;

DROP EVENT IF EXISTS xyz_insert_sales_partner;
DROP EVENT IF EXISTS xyz_set_next_id;
DROP EVENT IF EXISTS xyz_update_next_id;
DROP EVENT IF EXISTS xyz_prepare_stmt;
DROP EVENT IF EXISTS xyz_execute_stmt;
DROP EVENT IF EXISTS xyz_deallocate_prepare_stmt;
DROP EVENT IF EXISTS xyz_insert_new_sequence;














