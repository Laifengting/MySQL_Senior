USE myemployees;
/*
测验1：查询没有奖金，且工资小于18000的salary,last_name
*/
SELECT
	salary,
	last_name,
	
FROM
	employees 
WHERE
	commission_pct IS NULL 
	AND salary < 18000;
/*
测验2：查询employees表中，job_id不为“IT”或者工资为12000的员工信息
*/
SELECT
	* 
FROM
	employees #where not job_id = 'IT_PROG'
	
WHERE
	job_id <> 'IT_PROG' 
	OR salary = 12000;
/*
测验3：查询部门departments表的结构，查询效果如下
*/
DESC departments;
/*
测验4：查询部门departments表中涉及到了哪些位置编号
*/
SELECT DISTINCT
	location_id 
FROM
	departments;
/*
测验5：经典面试题
*/
/*
试问：
 SELECT
    *
FROM
    employees;

和 
 SELECT
    *
FROM
    employees
WHERE commission_pct LIKE '%%'
    AND last_name LIKE '%%';
*/
/*
结果量否一样？并说明原因。

不一样。如果判断的字段有null值，第二种方法就会少
*/