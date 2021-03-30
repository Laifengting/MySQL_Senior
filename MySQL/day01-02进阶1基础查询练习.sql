#任何操作之前都先打开库
USE myemployees;

#1. 下面的语句是否可以执行成功
SELECT last_name,
	   job_id,
	   salary sal
	FROM employees;

#2. 下面的语句是否可以执行成功
SELECT *
	FROM employees;

#3. 找出下面语句中的错误
SELECT employee_id,
	   last_name，#，应该是英文输入状态下的,
		   salary * 12 “annual salary”	# “”应该是英文输入状态下的""
	FROM employees;

#正确的写法为：
SELECT employee_id,
	   last_name,
	   salary * 12 "ANNUAL SALARY"
	FROM employees;

#4. 显示表 departments 的结构，并查询其中的全部数据
DESC departments;
SELECT *
	FROM departments;

#5. 显示出表 employees 中的全部 job_id（不能重复）
SELECT DISTINCT job_id
	FROM employees;

#6. 显示出表 employees 的全部列，各个列之间用逗号连接，列头显示成 OUT_PUT

#函数：IFNULL(expr1,expr2)：如果expr1是null,则返回expr2，否则返回expr1。
SELECT IFNULL(commission_pct,'null') 奖金率,
	   commission_pct
	FROM employees;
#----------------------------------------------------------------#
SELECT CONCAT(employee_id,',',first_name,',',last_name,',',email,',',IFNULL(commission_pct,'null')) out_put
	FROM employees;
