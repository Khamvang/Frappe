
-- Show events
SHOW EVENTS;

-- delete events
DROP EVENT construct_query;



-- 1) Event to Insert Data
CREATE EVENT IF NOT EXISTS update_and_insert_sales_partner
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:00:00'
DO
    INSERT INTO tabsme_Sales_partner (
        `current_staff`, `owner_staff`, `broker_type`, `broker_name`, `broker_tel`,
        `address_province_and_city`, `address_village`, `business_type`, `year`, `refer_id`,
        `refer_type`, `creation`, `modified`, `owner`
    )
    SELECT 
        CASE WHEN bp.callcenter_of_sales IS NOT NULL THEN bp.callcenter_of_sales ELSE bp.staff_no END AS `current_staff`,
        bp.own_salesperson AS `owner_staff`,
        bp.is_sales_partner AS `broker_type`,
        bp.customer_name AS `broker_name`,
        bp.customer_tel AS `broker_tel`,
        bp.address_province_and_city,
        bp.address_village,
        bp.business_type,
        bp.`year`,
        bp.name AS `refer_id`,
        'tabSME_BO_and_Plan' AS `refer_type`,
        bp.creation,
        bp.modified,
        bp.owner
    FROM tabSME_BO_and_Plan bp
    LEFT JOIN sme_org sme ON (
        CASE 
            WHEN LOCATE(' ', bp.staff_no) = 0 THEN bp.staff_no 
            ELSE LEFT(bp.staff_no, LOCATE(' ', bp.staff_no) - 1) 
        END = sme.staff_no
    )
    LEFT JOIN sme_org smec ON (
        REGEXP_REPLACE(bp.callcenter_of_sales, '[^[:digit:]]', '') = smec.staff_no
    )
    WHERE bp.is_sales_partner IN (
        'X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 
        'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 
        'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ'
    )
    AND bp.name NOT IN (
        SELECT refer_id FROM tabsme_Sales_partner WHERE refer_type = 'tabSME_BO_and_Plan'
    );



-- 2) Event to Set Next AUTO_INCREMENT Value
CREATE EVENT IF NOT EXISTS set_next_id
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:00'
DO
    SET @next_id = (SELECT MAX(id) + 1 FROM tabsme_Sales_partner);


-- 3) Event to Construct the ALTER TABLE Query
CREATE EVENT IF NOT EXISTS construct_query
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:05' 
DO
    SET @query = CONCAT('ALTER TABLE tabsme_Sales_partner AUTO_INCREMENT=', @next_id);



-- 4) Event to Prepare the Statement
CREATE EVENT IF NOT EXISTS prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:10'  
DO
    PREPARE stmt FROM @query;



-- 5) Event to Execute the Statement
CREATE EVENT IF NOT EXISTS execute_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:15'  -- 5 seconds after the previous event
DO
    EXECUTE stmt;



-- 6) Event to Deallocate the Statement
CREATE EVENT IF NOT EXISTS deallocate_prepare_stmt
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-22 01:02:20'  -- 5 seconds after the previous event
DO
    DEALLOCATE PREPARE stmt;


-- __________________________________________________________ If want to show and drop the events __________________________________________________________

SHOW EVENTS;

DROP EVENT IF EXISTS construct_query;
DROP EVENT IF EXISTS deallocate_prepare_stmt;
DROP EVENT IF EXISTS execute_stmt;
DROP EVENT IF EXISTS prepare_stmt;
DROP EVENT IF EXISTS set_next_id;
DROP EVENT IF EXISTS update_and_insert_sales_partner;



------- For checking tomorrow
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner; 

next_not_cached_value|
---------------------+
               556136|


select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;

(select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner)|minimum_value|maximum_value      |start_value|increment|cache_size|cycle_option|cycle_count|
----------------------------------------------------------------------+-------------+-------------------+-----------+---------+----------+------------+-----------+
                                                                556136|            1|9223372036854775806|          1|        1|         0|           0|          0|

