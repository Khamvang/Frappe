

-- New_Business_List
SELECT
	CONCAT('http://13.250.153.252:8000/app/new_business_crm/', name) AS 'edit',
	modified as 'date_updated',
	approach_type as 'list',
	sales_incharge,
	company_name ,
	company_address ,
	company_tel, 
	business_type ,
	enterprise_type ,
	personal_name ,
	personal_position ,
	personal_address ,
	sales_called_date as 'called_date',
	CASE WHEN modified >= '2025-05-01' THEN 'called' ELSE 'x' END AS `is_call`,
	sales_call_status as 'called_status',
	sales_ranks as 'rank',
	sales_amount_usd as 'amount',
	sales_due_date as 'plan_date',
	sales_condition as 'condition',
	team_remark as 'coment_of_teamleader',
	manager_comment as 'comment_of_manager',
	sum_status as 'monitor_status',
	sum_due_done_date as 'schedule_date',
	sum_detail as 'summarize',
	sum_policy as 'policy',
	file_approahc ,
	file_from_who
FROM tabNew_Business_CRM
WHERE sales_ranks not in ('Block - ຕ້ອງການຕັດອອກຈາກລິສ')
-- WHERE approach_type in ('Coffee List')
ORDER BY sales_incharge ASC, approach_type ASC, name ASC


select * from tabNew_Business_CRM


