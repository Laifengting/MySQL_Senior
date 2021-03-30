--学习目标
/*
通过本章学习，您将可以:
    书写多列子查询
    在 FROM 子句中使用子查询
    在SQL中使用单列子查询
    书写相关子查询
    使用 EXISTS 和 NOT EXISTS 操作符
    使用子查询更新和删除数据
    使用 WITH 子句
*/
--【案例】查询last_name为Chen的manager的信息
SELECT *
	FROM employees
	WHERE employee_id = (
						SELECT manager_id
							FROM employees
							WHERE last_name = 'Chen');

--一、多列子查询
/*
多列子查询中的比较分为两种:
    成对比较
    不成对比较
*/
--问题：查询与141号或174号员工的manager_id和department_id相同的其他员工的employee_id, manager_id, department_id
SELECT employee_id,
	   manager_id,
	   department_id
	FROM employees
	WHERE (manager_id, department_id) IN (
										 SELECT manager_id,
												department_id
											 FROM employees
											 WHERE employee_id IN (141,
																   174))
	  AND employee_id NOT IN (141,
							  174);

--二、在 FROM 子句中使用子查询
--问题：返回比本部门平均工资高的员工的last_name, department_id, salary及平均工资
--方式一：存在冗余
SELECT last_name,
	   department_id,
	   salary,
	   (
	   SELECT AVG(salary)
		   FROM employees e3
		   WHERE e1.department_id = e3.department_id
		   GROUP BY department_id)
	FROM employees e1
	WHERE salary > (
				   SELECT AVG(salary)
					   FROM employees e2
					   WHERE e2.department_id = e1.department_id
					   GROUP BY department_id);

--方式二：
SELECT last_name,
	   e1.department_id,
	   salary,
	   e2.avg_sal
	FROM employees                   e1,
		 (
		 SELECT AVG(salary) avg_sal,
				department_id
			 FROM employees
			 GROUP BY department_id) e2
	WHERE e1.department_id = e2.department_id
	  AND salary > e2.avg_sal;

--三、单列子查询表达式
/*
单列子查询表达式是在一行中只返回一列的子查询
Oracle8i 只在下列情况下可以使用, 例如:
    SELECT 语句 (FROM 和 WHERE 子句)
    INSERT 语句中的VALUES列表中

Oracle9i中单列子查询表达式可在下列情况下使用:
    DECODE  和 CASE
    SELECT 中除 GROUP BY 子句以外的所有子句中
*/
--问题：显式员工的employee_id,last_name和location。
--其中，若员工department_id与location_id为1800的department_id相同，则location为’Canada’,其余则为’USA’。
--在case中使用子查询
SELECT employee_id,
	   last_name,
	   (CASE department_id
			WHEN (
			SELECT department_id
				FROM departments
				WHERE location_id = 1800)
				THEN
				'Canada'
				ELSE
				'USA'
			END) location
	FROM employees;

--在ORDER BY中使用子查询。
--问题：查询员工的employee_id,last_name,要求按照员工的department_name排序
SELECT employee_id,
	   last_name,
	   department_id
	FROM employees e1
	ORDER BY (
			 SELECT department_name
				 FROM departments d
				 WHERE e1.department_id = d.department_id);

--四、相关子查询
/*
相关子查询按照一行接一行的顺序执行，主查询的每一行都执行一次子查询
*/
--问题：查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
SELECT last_name,
	   salary,
	   department_id
	FROM employees e1
	WHERE salary > (
				   SELECT AVG(salary)
					   FROM employees e2
					   WHERE e1.department_id = e2.department_id
					   GROUP BY department_id);

--问题：若employees表中employee_id与job_history表中employee_id相同的数目不小于2，
--输出这些相同id的员工的employee_id,last_name和其job_id
SELECT employee_id,
	   last_name,
	   job_id
	FROM employees e1
	WHERE (
		  SELECT COUNT(*)
			  FROM job_history
			  WHERE employee_id = e1.employee_id) >= 2;

--五、EXISTS 操作符
/*
EXISTS 操作符检查在子查询中是否存在满足条件的行

如果在子查询中存在满足条件的行:
    不在子查询中继续查找
    条件返回 TRUE
    
如果在子查询中不存在满足条件的行:
    条件返回 FALSE
    继续在子查询中查找
*/
--问题：查询公司管理者的employee_id,last_name,job_id,department_id信息
--方式一：
SELECT DISTINCT
	   e1.employee_id,
	   e1.last_name,
	   e1.job_id,
	   e1.department_id
	FROM employees e1,
		 employees e2
	WHERE e1.employee_id = e2.manager_id;

--方式二：
SELECT employee_id,
	   last_name,
	   job_id,
	   department_id
	FROM employees e1
	WHERE e1.employee_id IN (
							SELECT manager_id
								FROM employees e2
								WHERE e1.employee_id = e2.manager_id);
--方式三：
SELECT employee_id,
	   last_name,
	   job_id,
	   department_id
	FROM employees e1
	WHERE EXISTS(SELECT 1
					 FROM employees e2
					 WHERE e1.employee_id = e2.manager_id);

--NOT EXISTS 操作符
--问题：查询departments表中，不存在于employees表中的部门的department_id和department_name
SELECT department_id,
	   department_name
	FROM departments d
	WHERE NOT EXISTS(SELECT 1
						 FROM employees
						 WHERE department_id = d.department_id);

--六、相关更新
/*
使用相关子查询依据一个表中的数据更新另一个表的数据
*/
--创建复制employees表
CREATE TABLE employees2
AS
	SELECT *
		FROM employees;
--添加列
ALTER TABLE employees2
	ADD (department_name VARCHAR2 (20));

ALTER TABLE employees2
	DROP COLUMN department_name;

--给新增的列添加数据。
UPDATE employees2
SET
	department_name =
		(
		SELECT department_name
			FROM departments
			WHERE department_id = employees2.department_id);

SELECT *
	FROM employees2;

SELECT department_name
	FROM departments;

--相关删除
/*
使用相关子查询依据一个表中的数据删除另一个表的数据
*/
--问题：删除表employees中，其与emp_history表皆有的数据
--准备两张表
CREATE TABLE employees3
AS
	SELECT *
		FROM employees
		WHERE department_id IN (80,
								90);

CREATE TABLE emp_history
AS
	SELECT *
		FROM employees
		WHERE department_id IN (70,
								80);

--删除employees3中与emp_history中都有的数据。
DELETE
	FROM employees3 e
	WHERE employee_id = (
						SELECT employee_id
							FROM emp_history
							WHERE e.employee_id = employee_id);

SELECT *
	FROM employees3;

--七、WITH 子句
/*
使用 WITH 子句, 可以避免在 SELECT 语句中重复书写相同的语句块。
WITH 子句将该子句中的语句块执行一次并存储到用户的临时表空间中。
使用 WITH 子句可以提高查询效率。
*/
--【案例】查询公司中工资比Abel高的员工的信息
--方式一：普通子查询方法
SELECT *
	FROM employees
	WHERE salary > (
				   SELECT salary
					   FROM employees
					   WHERE last_name = 'Abel');

--方式二：WITH子句
WITH abel_sal AS
 (SELECT salary
  FROM   employees
  WHERE  last_name = 'Abel')
SELECT *
	FROM employees
	WHERE salary > (
				   SELECT salary
					   FROM abel_sal);

--问题：查询公司中各部门的总工资大于公司中各部门的平均总工资的部门信息
WITH dept_costs AS --WITH子句一：各部门总工资
 (SELECT SUM(salary) AS dept_total,
		 department_name
  FROM   employees   e,
		 departments d
  WHERE  e.department_id = d.department_id
  GROUP  BY department_name),

avg_cost AS --WITH子句二：各部门的平均总工资
 (SELECT SUM(dept_total) / COUNT(*) AS dept_avg
  FROM   dept_costs)

SELECT *
	FROM dept_costs
	WHERE dept_total > (
					   SELECT dept_avg
						   FROM avg_cost)
	ORDER BY department_name;

--总结
/*
通过本章学习,您已经可以: 
    使用多列子查询
    多列子查询的成对和非成对比较
    单列子查询
    相关子查询
    EXISTS 和 NOT EXISTS操作符
    相关更新和相关删除
    WITH子句
*/

--练习：1.查询员工的last_name, department_id, salary。
--其中员工的salary,department_id与有奖金的任何一个员工的salary,department_id相同即可
--方式一：
SELECT last_name,
	   department_id,
	   salary
	FROM employees
	WHERE (salary, department_id) IN (
									 SELECT salary,
											department_id
										 FROM employees
										 WHERE commission_pct IS NOT NULL);

--方式二：
SELECT last_name,
	   department_id,
	   salary
	FROM employees
	WHERE commission_pct IS NOT NULL
	  AND department_id IS NOT NULL;

--练习：2.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary
SELECT last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary > ALL (
					   SELECT salary
						   FROM employees
						   WHERE job_id = 'SA_MAN');

--练习：3.选择所有没有管理者的员工的last_name
--方式一：
SELECT last_name
	FROM employees e1
	WHERE NOT EXISTS(SELECT 1
						 FROM employees
						 WHERE manager_id = e1.manager_id);

--方式二：
SELECT last_name
	FROM employees e1
	WHERE manager_id IS NULL;
