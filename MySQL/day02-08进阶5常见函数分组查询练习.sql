/*
		任何操作之前都先打开库
*/ --
USE myemployees;
/*
1.  查询各 job_id 的员工工资的最大值，最小值，平均值，总和，并按 job_id 升序
*/
SELECT
	MAX( salary ) AS MAX,
	MIN( salary ) AS MIN,
	ROUND( AVG( salary ), 2 ) AS AVG,
	SUM( salary ) AS SUM,
	job_id 
FROM
	employees 
GROUP BY
	job_id 
ORDER BY
	job_id ASC;
/*

2.  查询员工最高工资和最低工资的差距（DIFFERENCE）
*/
SELECT
	MAX( salary ) - MIN( salary ) AS DIFFERENCE 
FROM
	employees;
/*
3.  查询各个管理者手下员工的最低工资，其中最低工资不能低于 6000，没有管理者的员工不计算在内
*/
SELECT
	manager_id,
	MIN( salary ) 
FROM
	employees 
WHERE
	manager_id IS NOT NULL 
GROUP BY
	manager_id 
HAVING
	MIN( salary )> 6000;
/*
4.  查询所有部门的编号，员工数量和工资平均值,并按平均工资降序
*/
SELECT
	department_id,
	count(*),
	ROUND( AVG( salary ), 2 ) AS 平均工资 
FROM
	employees 
GROUP BY
	department_id 
ORDER BY
	AVG( salary ) DESC;
/*
5.  选择具有各个 job_id 的员工人数
*/
SELECT
	job_id,
	COUNT(*) 
FROM
	employees 
GROUP BY
	job_id;