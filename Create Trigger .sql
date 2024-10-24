
-- delete Trigger
DROP TRIGGER IF EXISTS update_main_contact_on_tabsme_employees;

-- Table tabsme_employees 
CREATE TRIGGER update_main_contact_on_tabsme_employees
BEFORE UPDATE ON tabsme_Employees
FOR EACH ROW
SET NEW.main_contact = 
  CASE 
    WHEN NEW.main_contact = '' THEN ''
    WHEN (LENGTH(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', '')) = 11 
          AND LEFT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 3) = '020')
      OR (LENGTH(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', '')) = 10 
          AND LEFT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 2) = '20')
      OR (LENGTH(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', '')) = 8 
          AND LEFT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 1) IN ('2', '5', '7', '8', '9'))
    THEN CONCAT('20', RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 8))
    WHEN (LENGTH(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', '')) = 10 
          AND LEFT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 3) = '030')
      OR (LENGTH(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', '')) = 9 
          AND LEFT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 2) = '30')
      OR (LENGTH(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', '')) = 7 
          AND LEFT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 1) IN ('2', '4', '5', '7', '9'))
    THEN CONCAT('30', RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 7))
    WHEN LEFT(RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 8), 1) IN ('0', '1', '') 
    THEN CONCAT('30', RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 7))
    WHEN LEFT(RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 8), 1) IN ('2', '5', '7', '8', '9') 
    THEN CONCAT('20', RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 8))
    ELSE CONCAT('20', RIGHT(REGEXP_REPLACE(NEW.main_contact, '[^[:digit:]]', ''), 8))
  END;



