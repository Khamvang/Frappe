


SELECT creation 
	contract_no, contract_status, exeptional, customer_name, customer_tel,
	sales, collection_cc, collection ,
	last_target, payment_status, payment_grade ,
	delay_status , 
	S_at_5th, A_at_10th, B_at_20th, C_at_31st, F_after_1_month,
	old_payment_type, old_interest_rate, old_currency, 
	first_payment_date, old_last_payment_date, no_of_payment 
FROM tabsme_special_focus ;



SELECT * FROM tabsme_special_focus ;

CREATE INDEX idx_contract_no ON tabsme_special_focus(contract_no)

ALTER TABLE `_8abac9eed59bf169`.tabsme_special_focus CHANGE a A_at_10th varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL NULL;

ALTER TABLE `_8abac9eed59bf169`.tabsme_special_focus CHANGE b B_at_20th varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL NULL;

ALTER TABLE `_8abac9eed59bf169`.tabsme_special_focus CHANGE c C_at_31st varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL NULL;

ALTER TABLE `_8abac9eed59bf169`.tabsme_special_focus CHANGE f F_after_1_month varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL NULL;





-- Export the result 
SELECT 
        c.contract_no,
        CASE c.status 
                WHEN 0 THEN 'Pending'
                WHEN 1 THEN 'Pending Approval'
                WHEN 2 THEN 'Pending Disbursement'
                WHEN 3 THEN 'Disbursement Approval'
                WHEN 4 THEN 'Active'
                WHEN 5 THEN 'Cancelled'
                WHEN 6 THEN 'Refinance'
                WHEN 7 THEN 'Closed'
                ELSE NULL
        END AS `contract_status`,
    CASE 
                WHEN p.loan_amount = ps2.principal_amount THEN 'DDT'
                WHEN p.loan_amount <> ps2.principal_amount THEN 'Normal'
                WHEN p.payment_schedule_type = 1 THEN 'Normal'
                ELSE 'DDT+Installment'
        END AS `ddt_installment`,
        usc.monthly_interest_2nd,
        p.trading_currency AS `currency`
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN update_schedule usc ON usc.id = (
        SELECT id FROM update_schedule
        WHERE prospect_id = c.prospect_id AND status IN (4)
        ORDER BY date_updated DESC LIMIT 0, 1
)
LEFT JOIN tblpaymentschedule ps2 ON ps2.id = (
    SELECT id FROM tblpaymentschedule 
    WHERE prospect_id = c.prospect_id 
    ORDER BY payment_date DESC LIMIT 0, 1
)
WHERE c.status IN (4, 6, 7)
        AND c.contract_no IN ();











































