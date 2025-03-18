


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











