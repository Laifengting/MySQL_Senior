/*
		任何操作之前都先打开库
*/
USE myemployees;
/*
		一、显示员工表的最大工资，工资平均值
*/
SELECT MAX(salary),
	   AVG(salary)
	FROM employees;
/*
		二、查询员工表的employee_id,job_id,last_name，按department_id降序，salary升序
*/
SELECT employee_id,
	   job_id,
	   salary,
	   last_name,
	   department_id
	FROM employees
	ORDER BY department_id DESC,
			 salary        ASC;
/*
		三、查询员工表的job_id中包含a和e的，并且a在e前面
*/
SELECT job_id
	FROM employees
	WHERE job_id LIKE '%a%e%';

/*
		四、已知表student,里面有id(学号)，name，gradeId(年级编号)
			已知表grade,里面有id(年级编号)，name(年级名)
			已知表result,里面有id(学号)，score，studentNo(学号)
			要求查询，姓名，年级名，成绩
*/
SELECT s.name,
	   g.name,
	   score
	FROM student s,
		 grade   g,
		 result  r
	WHERE s.gradeid = g.id
	  AND s.id = r.studentno;

/*
		五、显示当前日期，以及去前后空格，截取子字符串的函数
*/
SELECT NOW();
SELECT TRIM([remstr FROM] str);
SELECT SUBSTR(str FROM pos);
SELECT SUBSTR(str FROM pos FOR len);