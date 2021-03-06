#任何操作之前都先打开库
USE myemployees;
/*############################################进阶3：排序查询############################################*/
/*
语法：
SELECT 
	查询列表	----------------------------------> 顺序③
FROM
	表	------------------------------------------> 顺序①
【WHERE 筛选条件】	----------------------------------> 顺序②
ORDER BY
	排序列表 【asc(从小到大)||desc(从大到小)】	--> 顺序④

特点：  1. ASC代表的是升序，DESC代表的是降序，如果不写默认是升序。
	2. ORDER BY子句中可以支持单个字段、多个字段、表达式、函数、别名
	3. ORDER BY子句一般是放在查询语句的最后面。但LIMIT子句除外。
	
*/
/*
案例1.1：查询员工信息，要求按工资从高到低排序
*/
SELECT *
	FROM employees
	ORDER BY salary DESC;
/*
案例1.2：查询员工信息，要求按工资从低到高排序
*/
SELECT *
	FROM employees /*默认不写ASC也是从低到高排序。*/

	ORDER BY salary ASC;
/*
案例2：查询部门编号>= 90的员工信息，按入职时间的先后进行排序【添加筛选条件】。
*/
SELECT *
	FROM employees
	WHERE department_id >= 90
	ORDER BY hiredate ASC;
/*
案例3：按年薪的高低显示员工的信息和年薪【按表达式排序】
*/
SELECT *,
	   salary * 12 * (
		   1 + IFNULL(commission_pct,0)) 年薪
	FROM employees
	ORDER BY salary * 12 * (
		1 + IFNULL(commission_pct,0)) ASC;
/*
案例4：按年薪的高低显示员工的信息和年薪【按别名排序】
*/
SELECT *,
	   salary * 12 * (
		   1 + IFNULL(commission_pct,0)) 年薪
	FROM employees
	ORDER BY 年薪 ASC;
/*
案例5：按姓名的长度显示员工的姓名和工资【按函数排序】
*/
SELECT last_name,
	   salary,
	   LENGTH(last_name) 姓名长度
	FROM employees
	ORDER BY 姓名长度 ASC;
/*
案例6：查询员工信息，要求先按工资排序，再按员工编号排序【按多个字段排序】
*/
SELECT *
	FROM employees
	ORDER BY salary      ASC,
			 employee_id DESC;
