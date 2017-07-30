/*
Postgres ROW_NUMBER() in MySQL.

SELECT * 
FROM (
    SELECT
        product_name,
        price,
        group_name,
        ROW_NUMBER() OVER (PARTITION BY group_name ORDER BY price DESC)
    FROM
        products
    INNER JOIN product_groups USING (group_id)
) x
WHERE
    ROW_NUMBER < 3;
;

Select N records with max salary for employee.
*/

SET @row_number = 0;
SET @employee_id = 0;
SET @n = 4;

SELECT 
	`employee_id`,
	`salary_amount`,
	`from_date`,
	`to_date`,
	`@row_number`
FROM
(
	SELECT
		`id`,
		`employee_id`,
		`salary_amount`,
		`from_date`,
		`to_date`,
		@row_number := IF(`employee_id` != @employee_id, 1, @row_number + 1) AS `@row_number`,
		@employee_id := `employee_id` AS `@employee_id`
	FROM (
		SELECT
			`id`,
			`employee_id`,
			`salary_amount`,
			`from_date`,
			`to_date`
		FROM `salary_copy` FORCE INDEX(`idx_employee_id_salary_amount`)
		WHERE `employee_id` IN (10004, 10001)
		ORDER BY `employee_id`, `salary_amount` DESC
	) x
) x
WHERE `@row_number` < @n + 1
;