/*
		任何操作之前都先打开库
*/ USE myemployees;
/*############################################进阶5：分组查询############################################*/
/*
	语法：
		SELECT 分组函数，列(要求出现在GROUP BY的后面)
		FROM 表
		[WHERE 筛选条件]
		GROUP BY 分组的列表
		[HAVING 筛选条件]
		[ORDER BY 子句]
	
	注意：
		查询列表必须特殊，要求是分组函数和GROUP BY后出现的字段
	
	特点：
		1. 分组查询中的筛选条件分为两类
							数据源				位置					关键字
			分组前筛选		原始表				GROUP BY子句的前面		WHERE
			分组后筛选		分组后的结果集		GROUP BY子句的后面		HAVING
			
		【注意】	① 分组函数做条件肯定是放在HAVING子句中。
					② 能用分组前筛选的，就优先考虑使用分组前筛选
					
		2. GROUP BY子句支持单个字段分组，多个字段分组(多个字段之间用逗号隔开没有顺序要求)，表达式或函数(用得较少)
		
		3. 也可以添加排序(排序放在整个分组查询的最后)
		
*/
/*
		引入：查询每个部门的平均工资
*/
SELECT
	AVG( salary ) 
FROM
	employees;
/*		
		1. 简单的分组查询
		案例1：查询每个工程的最高工资
*/
SELECT
	MAX( salary ),
	job_id 
FROM
	employees 
GROUP BY
	job_id;
/*
		案例2：查询每个位置上的部门个数
*/
SELECT
	COUNT( * ),
	location_id 
FROM
	departments 
GROUP BY
	location_id;
/*
		2. 添加筛选条件
		案例1：查询邮箱中包含a字符的，每个部门的平均工资
*/
SELECT
	ROUND( AVG( salary ), 2 ),
	department_id 
FROM
	employees 
WHERE
	email LIKE '%a%' 
GROUP BY
	department_id;
/*
		3. 添加分组前的筛选条件
		案例2：查询有奖金的每个领导手下员工的最高工资
*/
SELECT
	MAX( salary ),
	manager_id 
FROM
	employees 
WHERE
	commission_pct IS NOT NULL 
GROUP BY
	manager_id 
ORDER BY
	manager_id ASC;
/*
		4. 添加分组后的筛选条件
		案例1：查询哪个部门的员工个数>2
			① 查询每个部门的员工个数
				SELECT COUNT(*),department_id
				FROM employees
				GROUP BY department_id;
			② 根据①的结果进行筛选，查询哪个部门的员工个数>2
				SELECT COUNT(*),department_id
				FROM employees
				GROUP BY department_id
				HAVING COUNT(*) > 2;
*/
SELECT
	COUNT(*) AS 员工数,
	department_id 
FROM
	employees 
GROUP BY
	department_id 
HAVING
	COUNT(*) > 2;
/*
		5. 添加分组后的筛选条件
		案例2：查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
			① 查询每个工种有奖金的员工的最高工资
				SELECT MAX( salary ),job_id 
				FROM employees 
				WHERE commission_pct IS NOT NULL
				GROUP BY job_id;
			② 根据①结果继续筛选，最高工资>12000
				SELECT MAX( salary ),job_id 
				FROM employees 
				WHERE commission_pct IS NOT NULL
				GROUP BY job_id
				HAVING MAX( salary ) > 12000;
*/
SELECT
	MAX( salary ),
	job_id 
FROM
	employees 
WHERE
	commission_pct IS NOT NULL 
GROUP BY
	job_id 
HAVING
	MAX( salary ) > 12000;
/*
		6. 添加分组后的筛选条件
		案例3：查询领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个，以及其最低工资。
			① 查询每个领导手下的员工最低工资。
				SELECT	MIN( salary ),	manager_id 
				FROM employees
				GROUP BY manager_id;
			② 添加筛选条件：领导编号>102
				SELECT MIN( salary ), manager_id 
				FROM employees
				WHERE manager_id > 102 
				GROUP BY manager_id;
			③ 添加筛选条件：最低工资>5000
				SELECT MIN( salary ), manager_id 
				FROM employees
				WHERE manager_id > 102 
				GROUP BY manager_id
				HAVING MIN( salary )> 5000;
*/
SELECT
	MIN( salary ),
	manager_id 
FROM
	employees 
WHERE
	manager_id > 102 
GROUP BY
	manager_id 
HAVING
	MIN( salary )> 5000;
/*
		7. 按表达式或函数分组
		案例：按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些
		分析：	① 查询每个长度的员工个数
					SELECT LENGTH( last_name ),COUNT(*)
					FROM employees 
					GROUP BY LENGTH( last_name );
				② 添加筛选条件
					SELECT LENGTH( last_name ),COUNT(*)
					FROM employees 
					GROUP BY LENGTH( last_name )
					HAVING COUNT(*) > 5;
*/
SELECT
	LENGTH( last_name ) AS len_name,
	COUNT(*) 
FROM
	employees 
GROUP BY
	LENGTH( last_name ) 
HAVING
	COUNT(*) > 5;

/*
		8. 按多个字段分组
		案例：查询每个部门每个工种的员工的平均工资
*/
SELECT
	ROUND( AVG( salary ), 2 ) AS AVG_SALARY,
	department_id,
	job_id 
FROM
	employees 
GROUP BY
	department_id,
	job_id;


/*
		9. 按多个字段分组添加排序
		案例：查询每个部门每个工种的员工的平均工资，并且按平均工资的高低显示
*/
SELECT
	ROUND( AVG( salary ), 2 ) AS AVG_SALARY,
	department_id,
	job_id 
FROM
	employees 
WHERE	#-- WHERE中不能使用别名
	department_id IS NOT NULL 
GROUP BY	#-- GROUP BY中可以使用别名
	department_id,
	job_id 
HAVING	#-- HAVING中可以使用别名
	AVG( salary ) > 10000 
ORDER BY	#-- ORDER BY中可以使用别名
	AVG( salary ) ASC;









