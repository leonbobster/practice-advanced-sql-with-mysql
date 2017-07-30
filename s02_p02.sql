CREATE OR REPLACE VIEW `sample_staff`.`v_user_login` AS
	SELECT 
		`user_login`.`id` AS `user_login_id`,
		`user_login`.`user_id`,
		`user`.`name` AS `user_name`,
		`user_login`.`ip_address` AS `ip_address_int`,
		INET_NTOA(`user_login`.`ip_address`) AS `ip_address`,
		`user_login`.`login_dt`
	FROM `sample_staff`.`user_login`
	
	LEFT JOIN `sample_staff`.`user` ON 1 = 1
		AND `user`.`id` = `user_login`.`user_id`
		
	WHERE 1 = 1
		AND `user_login`.`deleted_flag` = 0 
	
	ORDER BY 
		`user_login`.`id` DESC;