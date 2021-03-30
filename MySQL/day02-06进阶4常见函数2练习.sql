/*
		任何操作之前都先打开库

*/ --
USE myemployees;
/*
1.  查询公司员工工资的最大值，最小值，平均值，总和
*/
SELECT MAX(salary) max,
	   MIN(salary) min,
	   ROUND(AVG(salary),2) avg,
	   SUM(salary) sum
	FROM employees;
/*
2.  查询员工表中的最大入职时间和最小入职时间的相差天数 （DIFFRENCE）
*/
SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) diffrence
	FROM employees;
/*
3.  查询部门编号为 90 的员工个数
*/
SELECT COUNT(*)
	FROM employees
	WHERE department_id = 90;