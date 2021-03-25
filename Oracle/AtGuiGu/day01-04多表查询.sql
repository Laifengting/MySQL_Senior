----多表查询
---内连接：等值连接 & 不等值连接
--等值连接SQL92语法
SELECT employee_id,
	   d.department_id,
	   department_name,
	   city
FROM   employees   e,
	   departments d,
	   locations   l
WHERE  e.department_id = d.department_id
AND    d.location_id = l.location_id;

--使用INNER JOIN【INNER关键字可以省略。默认为内连接】SQL99语法
SELECT employee_id,
	   d.department_id,
	   department_name,
	   city
FROM   employees e
JOIN   departments d
ON     e.department_id = d.department_id
INNER  JOIN locations l
ON     d.location_id = l.location_id;

--非等值连接SQL92语法
SELECT employee_id,
	   last_name,
	   salary,
	   grade_level
FROM   employees  e,
	   job_grades j
WHERE  e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT *
FROM   employees;

---外连接：左外连接 & 右外连接 & 全外连接
--左外连接(左外联接)
SELECT last_name,
	   d.department_id,
	   department_name
FROM   employees   e,
	   departments d
WHERE  d.department_id(+) = e.department_id; --右外连接
--WHERE  d.department_id = e.department_id(+);--左外连接

/*
SELECT  table1.column, table2.column
FROM    table1
[CROSS JOIN table2] |--和笛卡尔集相同
[NATURAL JOIN table2] |--将两个表中列名都相同的作为条件创建等值连接。
[JOIN table2 USING (column_name)] |
[JOIN table2 
  ON(table1.column_name = table2.column_name)] |
[LEFT|RIGHT|FULL OUTER JOIN table2 
  ON (table1.column_name = table2.column_name)];

*/

--自连接
--【案例】查询公司中员工‘Chen’的manager的信息
SELECT e.*,
	   m.*
FROM   employees e
JOIN   employees m
ON     e.manager_id = m.employee_id
WHERE  lower(e.last_name) = 'chen';

--练习
--1.显示所有员工的姓名，部门号和部门名称。
SELECT last_name,
	   e.department_id,
	   department_name
FROM   employees e
LEFT   JOIN departments d
ON     e.department_id = d.department_id;

--2.查询90号部门员工的job_id和90号部门的location_id
SELECT DISTINCT e.job_id,
				d.location_id
FROM   employees   e,
	   departments d
WHERE  e.department_id = d.department_id
AND    d.department_id = 90;

SELECT DISTINCT e.job_id,
				d.location_id
FROM   employees e
LEFT   OUTER JOIN departments d
ON     e.department_id = d.department_id
WHERE  d.department_id = 90;

--3.选择所有有奖金的员工的last_name , department_name , location_id , city
SELECT last_name,
	   department_name,
	   l.location_id,
	   city
FROM   employees e
JOIN   departments d
ON     e.department_id = d.department_id
JOIN   locations l
ON     d.location_id = l.location_id
WHERE  e.commission_pct IS NOT NULL;

--4.选择city在Toronto工作的员工的last_name , job_id , department_id , department_name 
SELECT last_name,
	   job_id,
	   d.department_id,
	   department_name
FROM   employees e
JOIN   departments d
ON     e.department_id = d.department_id
JOIN   locations l
ON     l.location_id = d.location_id
WHERE  lower(l.city) = 'toronto';

--5.选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
/*
employees   Emp#     manager    Mgr#
kochhar     101      king   100
*/
SELECT emp.last_name   "employees",
	   emp.employee_id "Emp#",
	   ma.last_name    "manager",
	   ma.employee_id  "Mgr#"
FROM   employees emp
LEFT   JOIN employees ma
ON     emp.manager_id = ma.employee_id;
