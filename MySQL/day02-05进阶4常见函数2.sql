/*
		任何操作之前都先打开库

*/ --
USE myemployees;
/*###########################################进阶4：常见函数2###########################################*/
/*
		二、分组函数

功能：用作统计使用，又称为：聚合函数、统计函数 或 组函数

分类：	SUM 求和
		AVG 平均值
		MAX 最大值
		MIN 最小值
		COUNT计算个数

特点：
	1. 	SUM、AVG一般用于处理数值型
		MAX、MIN、COUNT可以处理任何类型
		
	2. 以上分组函数都忽略null值
	
	3. 可以和DISTINCT搭配实现去重的运算。
	
	4. COUNT函数的单独介绍
		一般使用COUNT(*)用作统计行数

	5. 和分组函数一同查询的字段要求是GROUP BY后的字段

*/
/*
		1. 简单的使用
*/
SELECT SUM(salary)
	FROM employees;
SELECT AVG(salary)
	FROM employees;
SELECT MAX(salary)
	FROM employees;
SELECT MIN(salary)
	FROM employees;
SELECT COUNT(salary)
	FROM employees;
SELECT SUM(salary) 和,
	   AVG(salary) 平均,
	   MAX(salary) 最高,
	   MIN(salary) 最低,
	   COUNT(salary) 个数
	FROM employees;
SELECT SUM(salary) 和,
	   ROUND(AVG(salary),2) 平均,
	   MAX(salary) 最高,
	   MIN(salary) 最低,
	   COUNT(salary) 个数
	FROM employees;
/*
		2. 参数支持哪些类型
*/
SELECT SUM(last_name),
	   AVG(last_name)
	FROM employees;
SELECT MAX(last_name),
	   MIN(last_name),
	   COUNT(last_name)
	FROM employees;
SELECT MAX(hiredate),
	   MIN(hiredate)
	FROM employees;
SELECT COUNT(commission_pct)
	FROM employees;
SELECT COUNT(last_name)
	FROM employees;
/*
		3. 是否忽略null值
		SUM、AVG、MAX、MIN、COUNT忽略null值
*/
SELECT SUM(commission_pct),
	   AVG(commission_pct),
	   SUM(commission_pct) / 35,
	   SUM(commission_pct) / 107
	FROM employees;
SELECT MAX(commission_pct),
	   MIN(commission_pct)
	FROM employees;
SELECT COUNT(commission_pct)
	FROM employees;
/*
		4. 和DISTINCT搭配使用
*/
SELECT SUM(DISTINCT salary),
	   SUM(salary),
	   AVG(DISTINCT salary),
	   AVG(salary),
	   MAX(DISTINCT salary),
	   MAX(salary),
	   MIN(DISTINCT salary),
	   MIN(salary)
	FROM employees;
SELECT COUNT(DISTINCT salary),
	   COUNT(salary)
	FROM employees;
/*
		5. COUNT函数的详细介绍
*/
SELECT COUNT(salary)
	FROM employees;
/*
		统计行数COUNT(*)
*/
SELECT COUNT(*)
	FROM employees;
/*
		统计行数COUNT(常量值)
*/
SELECT COUNT(1)
	FROM employees;
/*
		效率：
		MYISAM存储引擎下,COUNT(*)的效率高
		INNODB存储引擎下，COUNT(*)和COUNT(1)的效率差不多，比COUNT(字段)要高一些。
*/
/*
		6. 和分组函数一同查询的字段有限制
*/-- 一般不这样写
-- SELECT AVG(salary),employee_id FROM	employees;
/*
		【补充】DATEDIFF(expr1,expr2)：返回expr1 跟 expr2之间的天数
*/