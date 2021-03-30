/*
		任何操作之前都先打开库
*/
USE girls;

/*#############################################进阶9：联合查询#############################################*/
/*
		UNION：联合，合并，将多条查询语句的结果合并成一个结果。
		
		语法：
			查询语句1
			UNION
			查询语句2
			UNION
			...
		
		应用场景：要查询的结果来自于多个表，且多个表没有直接的连接关系，但查询的信息一致时，就可以
		
		特点：	
			① 要求多条查询语句的查询列数是一致的。
			② 要求多条查询语句的查询的每一列的类型和顺序最好一致
			③ UNION关键字默认去重，如果使用UNION ALL可以包含重复项。
		
			
		引入案例:查询部门编号>90或邮箱中包含a的员工信息
*/
SELECT *
	FROM employees
	WHERE email LIKE '%a%' OR department_id > 90;

###转换成UNION

SELECT *
	FROM employees
	WHERE email LIKE '%a%'
UNION
SELECT *
	FROM employees
	WHERE department_id > 90;

/*
		案例：查询中国男性用户的信息以及外国男性用户的信息
*/
SELECT *
	FROM student
	WHERE sex = '男'
UNION ALL
SELECT *
	FROM student
	WHERE sex = '女'















