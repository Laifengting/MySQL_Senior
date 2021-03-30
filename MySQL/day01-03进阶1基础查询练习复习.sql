#任何操作之前都先打开库
USE myemployees;
#1.  下面的语句是否可以执行成功
SELECT last_name,
	   job_id,
	   salary sal
	   #起别名

	FROM employees;
#2.  下面的语句是否可以执行成功
SELECT *
	FROM employees;
#3.  找出下面语句中的错误

SELECT employee_id,
	   last_name，
		   #，应该是英文状态下的,
		   salary * 12 “annual salary”
#起别名时别名前面的AS可以省略。“”应该是英文状态下的""
	FROM employees;

#4.  显示表 departments 的结构，并查询其中的全部数据
DESC departments;
#显示表的结构
SELECT *
	FROM departments;
#查询表中的全部数据

#5.  显示出表 employees 中的全部 job_id（不能重复）
SELECT DISTINCT job_id
	FROM employees;
#DISTINCT去重

#6.  显示出表 employees 的全部列，各个列之间用逗号连接，列头显示成 OUT_PUT
SELECT CONCAT(#CONCAT()：连接函数
			   employee_id,
			   ',',
			   first_name,
			   ',',
			   last_name,
			   ',',
			   phone_number,
			   ',',
			   manager_id,
			   ',',
			   IFNULL(commission_pct,"null"),
		   #IFNULL(expr1,expr2)：如果expr1为null,则输出expr2；如果expr1不为null，则输出expr1。
			   ',',
			   hiredate
		   ) out_put
	FROM employees;
#7. 【补充】函数IFNULL(expr1,expr2)：如果expr1为null,则输出expr2；如果expr1不为null，则输出expr1。

#8. 【补充】函数ISNULL(expr)：如果expr为null,则返回1；如果expr不为null,则返回0。
SELECT ISNULL(commission_pct),
	   commission_pct
	FROM employees;
