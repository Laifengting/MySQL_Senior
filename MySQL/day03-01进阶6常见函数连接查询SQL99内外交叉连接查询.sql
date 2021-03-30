/*
		任何操作之前都先打开库
*/
USE girls;

/*############################################进阶6：连接查询############################################*/
/*
		二、 SQL99标准
		
		语法：
			SELECT 查询列表
			FROM 表1 别名 
			【连接类型】JOIN 表2 别名
			ON 连接条件
			【WHERE 筛选条件】
			【GROUP BY 分组】
			【HAVING 筛选条件】
			【ORDER BY 排序列表】
		
		
	
		内连接☑：连接类型：INNER
			等值连接
			非等值连接
			自连接
			
		外连接：
			左外连接☑：连接类型：LEFT 【OUTER】
			右外连接☑：连接类型：RIGHT 【OUTER】
			全外连接：连接类型：FULL 【OUTER】
			
		交叉连接：连接类型：CROSS
*/
/*
		2.1 内连接
		
		语法：
			SELECT 查询列表
			FROM 表1 别名
			【INNER】 JOIN 表2 别名
			ON 连接条件
			【WHERE 筛选条件】
			【GROUP BY 分组】
			【HAVING 筛选条件】
			【ORDER BY 排序列表】
		
		分类：
			等值连接
			非等值连接
			自连接
			
		特点：
			① 添加排序、分组、筛选
			② INNER 可以省略
			③ 筛选条件放在WHERE后面，连接条件放在ON后面，提高分离性，便于阅读。
			④ INNER JOIN连接和SQL92语法中的等值连接效果是一样的，都是查询多表的交集。
*/
/*
		2.1.1. 等值连接
		案例2.1.1.1：查询员工名、部门名(可以调换位置)
*/
USE myemployees;

SELECT last_name,
	   department_name
	FROM employees         e
	INNER JOIN departments d
			   ON e.department_id = d.department_id;

/*
		案例2.1.1.2：查询名字中包含e的员工名和工种名(添加筛选)
*/
USE myemployees;

SELECT last_name,
	   job_title
	FROM employees  e
	INNER JOIN jobs j
			   ON e.job_id = j.job_id
	WHERE last_name LIKE '%e%';

/*
		案例2.1.1.3：查询部门个数>3的城市名和部门个数(添加分组+筛选)
		步骤：
			① 查询每具城市的部门个数
			② 在①结果上筛选满足条件的
*/
USE myemployees;

SELECT city,
	   COUNT(*) 部门个数
	FROM locations         l
	INNER JOIN departments d
			   ON l.location_id = d.location_id
	GROUP BY city
	HAVING COUNT(*) > 3;

/*
		案例2.1.1.4：查询哪个部门的部门员工个数>3的部门名和员工个数，并按个数降序(排序)
		步骤：
			① 查询每个部门的员工个数
			② 在①的结果之上筛选员工个数>3的记录，并排序。
*/
USE myemployees;

SELECT COUNT(*) 个数,
	   department_name
	FROM employees         e
	INNER JOIN departments d
			   ON e.department_id = d.department_id
	GROUP BY department_name
	HAVING COUNT(*) > 3
	ORDER BY COUNT(*) DESC;

/*
		案例2.1.1.5：查询员工名、部门名、工种名，并按部门名降序
*/
USE myemployees;

SELECT last_name,
	   department_name,
	   job_title
	FROM employees         e
	INNER JOIN departments d
			   ON e.department_id = d.department_id
	INNER JOIN jobs        j
			   ON j.job_id = e.job_id
	ORDER BY department_name DESC;

/*
		2.1.2. 非等值连接
		案例2.1.2.1 查询员工的工资级别
*/
USE myemployees;

SELECT salary,
	   grade_level
	FROM employees        e
	INNER JOIN job_grades j
			   ON salary BETWEEN lowest_sal
				   AND highest_sal;

/*
		案例2.1.2.2 查询每个工资级别的个数大于2的个数，并且按工资级别降序排序
*/
USE myemployees;

SELECT COUNT(*),
	   grade_level
	FROM employees        e
	INNER JOIN job_grades j
			   ON salary BETWEEN j.lowest_sal
				   AND j.highest_sal
	GROUP BY grade_level
	HAVING COUNT(*) > 20
	ORDER BY grade_level DESC;

/*
		2.1.3. 自连接
		案例2.1.3.1 查询姓名中包含字符k的员工的名字，上级的名字
*/
USE myemployees;

SELECT e.last_name,
	   m.last_name
	FROM employees       e
	INNER JOIN employees m
			   ON e.manager_id = m.employee_id
	WHERE e.last_name LIKE '%k%';

/*
		2.2 外连接
		
		应用场景：用于查询一个表中有，另一个表中没有的记录
					
		特点：
			① 外连接的查询结果为主表中的所有记录
				如果从表中有和它匹配的，则显示匹配的值
				如果从表中没有和匹配的，则显示null
				外连接查询结果 = 内连接结果 + 主表中有而从表没有的记录
				
			② 左外连接：LEFT JOIN 左边的是主表
			  右外连接：RIGHT JOIN 右边的是主表
			  
			③ 左外和右外交换两个表的顺序，可以实现同样的效果。
			
			④ 全外连接 = 内连接的结果 + 表1中有但表2中没有的结果 + 表2中有但表1中没有的结果
*/
USE girls;

SELECT *
	FROM beauty;

SELECT *
	FROM boys;

/*	
		2.2.1. 左外连接
		案例2.2.1.1：查询男朋友不在男神表的女神名【左外连接】
*/
USE girls;

SELECT b.name
	FROM beauty          b
	LEFT OUTER JOIN boys bo
					ON bo.id = b.boyfriend_id
		/*
		一般筛选条件选择主键来筛选，因为主键不能为空。
*/
	WHERE bo.id IS NULL;

/*	
		2.2.2. 右外连接
		案例2.2.2.1：查询男朋友不在男神表的女神名【右外连接】
*/
USE girls;

SELECT b.name
	FROM boys               bo
	RIGHT OUTER JOIN beauty b
					 ON bo.id = b.boyfriend_id
		/*
		一般筛选条件选择主键来筛选，因为主键不能为空。
*/
	WHERE bo.id IS NULL;

/*	
		案例2.2.1.2：查询男朋友不在男神表的女神名【左外连接-主从表调换】
*/
USE girls;

SELECT b.*,
	   bo.*
	FROM boys              bo
	LEFT OUTER JOIN beauty b
					ON b.boyfriend_id = bo.id
		/*
		一般筛选条件选择主键来筛选，因为主键不能为空。
*/
	WHERE b.id IS NULL;

/*	
		案例2.2.1.3：查询哪个部门没有员工【左外连接】
*/
USE myemployees;

SELECT d.*,
	   e.employee_id
	FROM departments          d
	LEFT OUTER JOIN employees e
					ON d.department_id = e.department_id
	WHERE e.employee_id IS NULL;

/*	
		案例2.2.2.2：查询哪个部门没有员工【右外连接】
*/
USE myemployees;

SELECT d.*,
	   e.employee_id
	FROM employees               e
	RIGHT OUTER JOIN departments d
					 ON d.department_id = e.department_id
	WHERE e.employee_id IS NULL;

/*	
		2.2.3. 全外连接
		语法：
			SELECT 查询列表
			FROM 表1 别名
			FULL JOIN 表2 别名
			ON 连接条件------------->[表1.key is null OR 表2.key is null]
			【WHERE 筛选条件】
			【GROUP BY 分组】
			【HAVING 筛选条件】
			【ORDER BY 排序列表】	
		MySQL不支持全外连接，但我们可以使用UNION来变通
			UNION 操作符用于合并两个或多个 SELECT 语句的结果集。
			注释：默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。

			故实现全外连接可以使用：
			SELECT 查询列表
			FROM 表1 别名
			LEFT JOIN 表2 别名
			ON 连接条件
			
			UNION
			
			SELECT 查询列表
			FROM 表1 别名
			RIGHT JOIN 表2 别名
			ON 连接条件
*/
USE girls;

SELECT b.*,
	   bo.*
	FROM beauty b FULL
    OUTER JOIN boys bo
ON b.`boyfriend_id` = bo.id
/*
全外连接通过UNION实现
*/
USE girls;

SELECT b.*,
	   bo.*
	FROM beauty          b
	LEFT OUTER JOIN boys bo
					ON b.boyfriend_id = bo.id
UNION
SELECT b.*,
	   bo.*
	FROM beauty           b
	RIGHT OUTER JOIN boys bo
					 ON b.boyfriend_id = bo.id;

/*
		2.3 交叉连接
		语法：
			SELECT 查询列表
			FROM 表1 别名
			CROSS JOIN 表2 别名
			ON 连接条件
			【WHERE 筛选条件】
			【GROUP BY 分组】
			【HAVING 筛选条件】
			【ORDER BY 排序列表】	
			
		功能：使用SQL99语法标准，对表1和表2实现笛卡尔乘积
*/
SELECT *
	FROM beauty;

SELECT *
	FROM boys;

USE girls;

SELECT b.*,
	   bo.*
	FROM beauty     b
	CROSS JOIN boys bo;

/*
		SQL92 和 SQL99 对比
		功能：SQL99支持的语法更多
		可读性：SQL99实现连接条件和筛选条件的分离，可以读性较高
*/
