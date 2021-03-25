/*
		任何操作之前都先打开库
*/ USE girls;
/*############################################进阶6：连接查询############################################*/
/*

	含义：又称为多表查询，当查询的字段来自于多个表时，就会用到连接查询
	
	笛卡尔乘积现象：表1有m行，表2有n行，结果=m*n行
		发生原因：没有有效的连接条件
		如何避免：添加有效的连接条件。
	
	分类：
		按年代分类：
			SQL92标准：MySQL中仅仅支持内连接
			SQL99标准【推荐】：MySQL中支持内连接+外连接(左外和右外)+交叉连接
		
		按功能分类：
			内连接：
				等值连接
				非等值连接
				自连接
				
			外连接：
				左外连接
				右外连接
				全外连接
				
			交叉连接

	JOIN的优化
	解读：
		① INNER JOIN：MySQL会选择数据量比较小的表作为驱动表，大表作为被驱动表。
		② LEFT JOIN：左表是驱动表，右表是被驱动表。
		③ RIGHT JOIN：右表是驱动表，左表是被驱动表。
	优化原则：
		① 尽量使用 INNER JOIN ，避免 LEFT JOIN 和 RIGHT JOIN
		② 被驱动表的索引字段作为 ON 的限制字段
		③ 利用小表去驱动大表

		
*/
SELECT *
FROM beauty;
SELECT *
FROM boys;
SELECT `name`,
       boyName
FROM boys,
     beauty;
SELECT `name`,
       boyName
FROM boys,
     beauty
WHERE beauty.boyfriend_id = boys.id;
/*
		一、 SQL92标准
*/
/*
		1. 内连接——等值连接
		特点：	① 多表等值连接的结果为多表的交集部分
				② n表连接，至少需要n-1个连接条件
				③ 多表的顺序没有要求
				④ 一般需要为表起别名
				⑤ 可以搭配前面介绍的所有子句使用，比如：排序，分组，筛选。
		
		案例1.1.1：查询女神名和对应的男神名
		
*/
SELECT `name`,
       boyName
FROM boys,
     beauty
WHERE beauty.boyfriend_id = boys.id;
/*
		案例1.1.2：查询员工名和对应的部门名
*/
SELECT last_name,
       department_name
FROM departments,
     employees
WHERE employees.department_id = departments.department_id;
/*
		1.2. 为表起别名
		优点：① 提高语句的简洁度
			  ② 区分多个重名的字段
	    注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定
		案例1.2.1：查询员工名、工种号、工种名
*/
SELECT last_name,
       e.job_id,
       j.job_title
FROM employees AS e,
     jobs AS j
WHERE e.job_id = j.job_id;
/*
		1.3. 两个表的顺序可以调换
		案例：查询员工名、工种号、工种名
*/
SELECT last_name,
       e.job_id,
       j.job_title
FROM jobs AS j,
     employees AS e
WHERE e.job_id = j.job_id;
/*
		1.4. 可以加筛选
		案例1.4.1：查询有奖金的员工名，部门名。
*/
SELECT last_name,
       department_name,
       commission_pct
FROM employees AS e,
     departments AS d
WHERE e.department_id = d.department_id
  AND e.commission_pct IS NOT NULL;
/*
		案例1.4.2：查询城市名中第二个字符为o的部门名和城市名
*/
SELECT department_name,
       city
FROM departments AS d,
     locations AS l
WHERE d.location_id = l.location_id -- 先添加连接条件

  AND city LIKE '_o%';
-- 再添加筛选条件
/*
		1.5. 可以加分组
		案例1.5.1：查询每个城市的部门个数
*/
SELECT city,
       COUNT(*) AS 个数
FROM departments AS d,
     locations AS l
WHERE d.location_id = l.location_id
GROUP BY city;
/*
		案例1.5.2：查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
*/
SELECT department_name,
       d.manager_id,
       MIN(salary)
FROM departments AS d,
     employees AS e
WHERE d.department_id = e.department_id
  AND commission_pct IS NOT NULL
GROUP BY department_name,
         d.manager_id;
/*
		1.6. 可以加排序
		案例：查询每个工种的工种名和员工的个数，并且按员工个数降序
*/
SELECT job_title,
       COUNT(*)
FROM jobs AS j,
     employees AS e
WHERE j.job_id = e.job_id
GROUP BY job_title
ORDER BY COUNT(*) DESC;
/*
		1.7. 实现多表连接
		案例：查询员工名、部门名和所在的城市
*/
SELECT last_name,
       department_name,
       city
FROM employees e,
     departments d,
     locations l
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND city LIKE 's%'
ORDER BY department_name DESC;
/*
		2. 内连接——非等值连接
		案例：查询员工的工资和工资级别
*/
SELECT salary,
       grade_level
FROM employees e,
     job_grades j
WHERE salary BETWEEN j.lowest_sal
	AND j.highest_sal
  AND j.grade_level = 'A';
/*
		3. 内连接——自连接
		案例：查询员工名和上级的名称
*/
SELECT e1.employee_id,
       e1.last_name,
       e2.employee_id,
       e2.last_name
FROM employees e1,
     employees e2
WHERE e1.manager_id = e2.employee_id;

