--分组函数
/*
AVG 平均值：只能操作number数值类型
COUNT 求个数
MAX 最大值：number数值，字符，日期类型都可以
MIN 最小值：number数值，字符，日期类型都可以
STDDEV([ DISTINCT | ALL ] expr)[ OVER (analytic_clause) ]返回样本标准差
SUM 求和：只能操作number数值类型
*/
SELECT AVG(salary),
	   MAX(salary),
	   MIN(salary),
	   SUM(salary)
	FROM employees;

SELECT COUNT(employee_id),
	   COUNT(last_name),
	   COUNT(hire_date)
	FROM employees;

SELECT COUNT(1)
	FROM employees;

SELECT COUNT(*)
	FROM employees;

--分组数据
--【案例】查询每个部门的平均工资。
SELECT AVG(salary),
	   department_id
	FROM employees
	GROUP BY department_id;

--求哪几个部门的平均工资
SELECT AVG(salary),
	   department_id
	FROM employees
	WHERE department_id IN (30,
							40,
							50)
	GROUP BY department_id;

--求每个部门的每个工种的平均工资。
SELECT AVG(salary),
	   department_id,
	   job_id
	FROM employees
	GROUP BY department_id,
			 job_id;

--【注意】查询的字段，只要不是组函数列，就必须出现在GROUP BY中。出现在GROUP BY中的字段，可以不显示在查询中。

--【案例】查询各部门中平均工资大于6000的部门，以及其平均工资。
SELECT AVG(salary),
	   department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) > 6000
	ORDER BY department_id ASC;

--组函数的嵌套
SELECT MAX(AVG(salary))
	FROM employees
	GROUP BY department_id;

--总结
/*
通过本章学习，您已经学会: 
    使用组函数:avg(),sum(),max(),min(),count()
    在查询中使用 GROUP BY 子句。
    在查询中使用 HAVING 子句。 

语法
SELECT  column, group_function(column)
FROM        table
[WHERE  condition]
[GROUP BY group_by_expression]
[HAVING   group_condition]--可以在GROUP BY前，也可以在其后。
[ORDER BY column];
*/

--练习：33. 查询 employees 表中有多少个部门
SELECT COUNT(DISTINCT department_id)
	FROM employees;

--练习：34. 查询全公司奖金基数的平均值(没有奖金的人按 0 计算)
SELECT AVG(nvl(commission_pct,
			   0))
	FROM employees;

--练习：35. 查询各个部门的平均工资
SELECT AVG(salary),
	   department_id
	FROM employees
	GROUP BY department_id;

--练习：36. Toronto 这个城市的员工的平均工资
SELECT AVG(salary)
	FROM employees   e
	JOIN departments d
		 ON e.department_id = d.department_id
	JOIN locations   l
		 ON d.location_id = l.location_id
	WHERE LOWER(l.city) = 'toronto';

--练习：37. (有员工的城市)各个城市的平均工资
SELECT city,
	   AVG(salary)
	FROM employees   e
	JOIN departments d
		 ON e.department_id = d.department_id
	JOIN locations   l
		 ON d.location_id = l.location_id
	GROUP BY city;

--练习：38. 查询平均工资高于 8000 的部门 id 和它的平均工资.      
SELECT department_id,
	   AVG(salary)
FROM   employees
GROUP  BY department_id
HAVING AVG(salary) > 8000;

--练习：39. 查询平均工资高于 6000 的 job_title 有哪些
SELECT job_title,
	   AVG(salary)
	FROM jobs      j
	JOIN employees e
		 ON j.job_id = e.job_id
	GROUP BY job_title
	HAVING AVG(salary) > 6000;

--练习：4.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary),
	   MIN(salary),
	   AVG(salary),
	   SUM(salary)
	FROM employees;

--练习：5.查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary),
	   MIN(salary),
	   AVG(salary),
	   SUM(salary),
	   job_id
	FROM employees
	GROUP BY job_id;

--练习：6.选择具有各个job_id的员工人数
SELECT COUNT(1),
	   job_id
	FROM employees
	GROUP BY job_id;

--练习：7.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary),
	   MIN(salary),
	   MAX(salary) - MIN(salary) difference
	FROM employees;

--练习：8.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT MIN(salary),
	   manager_id
	FROM employees
	WHERE manager_id IS NOT NULL
	GROUP BY manager_id
	HAVING MIN(salary) >= 6000;

--【注：WHERE语句可以合并到HAVING中】
SELECT MIN(salary),
	   manager_id
	FROM employees
	GROUP BY manager_id
	HAVING MIN(salary) >= 6000 AND manager_id IS NOT NULL;

--练习：9.查询所有部门的名字，location_id，员工数量和工资平均值
SELECT department_name,
	   location_id,
	   COUNT(*),
	   AVG(salary)
	FROM employees         e
	RIGHT JOIN departments d
			   ON e.department_id = d.department_id
	GROUP BY department_name,
			 location_id;

--练习：10.查询公司在1995-1998年之间，每年雇用的人数，结果类似下面的格式
/*
total 1995  1996    1997    1998
20      3   4   6   7
*/
SELECT COUNT(*) total,
	   COUNT(CASE to_char(hire_date,
						  'yyyy')
				 WHEN '1995'
					 THEN
					 1
					 ELSE
					 NULL
				 END) "1995",
	   COUNT(CASE to_char(hire_date,
						  'yyyy')
				 WHEN '1996'
					 THEN
					 1
					 ELSE
					 NULL
				 END) "1996",
	   COUNT(CASE to_char(hire_date,
						  'yyyy')
				 WHEN '1997'
					 THEN
					 1
					 ELSE
					 NULL
				 END) "1997",
	   COUNT(CASE to_char(hire_date,
						  'yyyy')
				 WHEN '1998'
					 THEN
					 1
					 ELSE
					 NULL
				 END) "1998"
	FROM employees
	WHERE to_char(hire_date,
				  'yyyy') IN ('1995',
							  '1996',
							  '1997',
							  '1998');

