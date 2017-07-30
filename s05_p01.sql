SET @focus_date = '2000-01-01';
SET @company_average_salary = (
	SELECT ROUND(AVG(`salary`.`salary_amount`), 2) 
	FROM `salary`
	WHERE 1=1
		AND @focus_date BETWEEN `salary`.`from_date` AND IFNULL(`salary`.`to_date`, '2002-08-01')
);

SELECT
	department_id,
	department_name,
	department_average_salary,
	@company_average_salary AS company_average_salary,
	CASE
		WHEN department_average_salary > @company_average_salary THEN 'higher'
		WHEN department_average_salary < @company_average_salary THEN 'lower'
		ELSE 'same'
	END AS department_vs_company
FROM
(
	SELECT 
		`department`.`id` AS department_id,
		`department`.`name` AS department_name,
		ROUND(AVG(`salary`.`salary_amount`), 2) AS department_average_salary
	FROM `salary` 
	INNER JOIN `department_employee_rel`
		ON 1=1
			AND `department_employee_rel`.`employee_id` = `salary`.`employee_id`
			AND @focus_date 
				BETWEEN `department_employee_rel`.`from_date` 
				AND IFNULL(`department_employee_rel`.`to_date`, '2002-08-01')
	INNER JOIN `department`
		ON `department`.`id` = `department_employee_rel`.`department_id`
	WHERE 1=1
		AND @focus_date BETWEEN `salary`.`from_date` AND IFNULL(`salary`.`to_date`, '2002-08-01')
	GROUP BY
		`department`.`id`
) xTMP
;
