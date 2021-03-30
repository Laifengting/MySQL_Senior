----子查询
--【案例】谁的工资比 Abel 高?
--① 先查询Abel的工资是多少
SELECT salary
	FROM employees
	WHERE LOWER(last_name) = 'abel';

--② 再查询比①高的人
SELECT last_name
	FROM employees
	WHERE salary > (
				   SELECT salary
					   FROM employees
					   WHERE LOWER(last_name) = 'abel');
--()内的查询即是子查询(外查询)

--【案例】查询员工名为Chen的manager的信息
--① 先查询Chen的manager_id
SELECT manager_id
	FROM employees
	WHERE LOWER(last_name) = 'chen';

--② 再查询employee_id = ① 的人的信息
SELECT *
	FROM employees
	WHERE employee_id = (
						SELECT manager_id
							FROM employees
							WHERE LOWER(last_name) = 'chen');

--【案例】返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id 和工资
--① 先查询141号员工的job_id
SELECT job_id
	FROM employees
	WHERE employee_id = 141;

--② 查询出143号员工的工资
SELECT salary
	FROM employees
	WHERE employee_id = 143;

--在①②条件基础上，查询
SELECT last_name,
	   job_id,
	   salary
	FROM employees
	WHERE job_id IN (
					SELECT job_id
						FROM employees
						WHERE employee_id = 141)
	  AND salary > (
				   SELECT salary
					   FROM employees
					   WHERE employee_id = 143);

--【案例】返回公司工资最少的员工的last_name,job_id和salary
SELECT last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary = (
				   SELECT MIN(salary)
					   FROM employees);

--【案例】查询最低工资大于50号部门最低工资的部门id和其最低工资
--① 查询50号部门的最低工资。
SELECT MIN(salary)
	FROM employees
	WHERE department_id = 50;

--②查询满足①条件的最低工资和部门id
SELECT MIN(salary),
	   department_id
	FROM employees
	GROUP BY department_id
	HAVING MIN(salary) > (
						 SELECT MIN(salary)
							 FROM employees
							 WHERE department_id = 50);

--多行子查询
/*
IN：等于列表中的任意一个 和 =ANY一样作用
ANY：和子查询返回的某一个值比较
ALL：和子查询返回的所有值比较
*/
--返回其它部门中比job_id为‘IT_PROG’部门任一工资低的员工的员工号、姓名、job_id 以及salary
--① job_id为'IT_PROG'的部门是哪个
SELECT DISTINCT department_id
	FROM employees
	WHERE job_id = 'IT_PROG';

--② 返回①号部门中所有员工的工资。
SELECT salary
	FROM employees
	WHERE department_id = (
						  SELECT DISTINCT department_id
							  FROM employees
							  WHERE job_id = 'IT_PROG');

--③ 返回比②中任一工资低的员工
SELECT employee_id,
	   last_name,
	   job_id,
	   salary
	FROM employees
	WHERE department_id <> (
						   SELECT DISTINCT department_id
							   FROM employees
							   WHERE job_id = 'IT_PROG')
	  AND salary < ANY (
					   SELECT salary
						   FROM employees
						   WHERE department_id = (
												 SELECT DISTINCT department_id
													 FROM employees
													 WHERE job_id = 'IT_PROG'));

--总结
/*
通过本章学习，您已经学会: 
    如何使用子查询。
    在查询时基于未知的值时，应使用子查询。

SELECT select_list
FROM   TABLE
WHERE  expr operator (SELECT select_list
        FROM   TABLE);
*/

/*
41. 查询工资最低的员工信息: last_name, salary  
*/
--①查询最低工资
SELECT MIN(salary)
	FROM employees;

--②查询最低工资等于①的员工信息
SELECT last_name,
	   salary
	FROM employees
	WHERE salary = (
				   SELECT MIN(salary)
					   FROM employees);

/*
42. 查询平均工资最低的部门信息
*/
--①查询最低平均工资
SELECT MIN(AVG(salary))
	FROM employees
	GROUP BY department_id;

--②查询平均工资等于①的部门编号
SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) = (
						 SELECT MIN(AVG(salary))
							 FROM employees
							 GROUP BY department_id);
--③查询部门编号为②的部门信息
SELECT *
	FROM departments
	WHERE department_id = (
						  SELECT department_id
							  FROM employees
							  GROUP BY department_id
							  HAVING AVG(salary) = (
												   SELECT MIN(AVG(salary))
													   FROM employees
													   GROUP BY department_id));

/*
43*. 查询平均工资最低的部门信息和该部门的平均工资
*/
SELECT d.*,
	   (
	   SELECT AVG(salary)
		   FROM employees
		   WHERE department_id = d.department_id)
	FROM departments d
	WHERE department_id = (
						  SELECT department_id
							  FROM employees
							  GROUP BY department_id
							  HAVING AVG(salary) = (
												   SELECT MIN(AVG(salary))
													   FROM employees
													   GROUP BY department_id));

/*
44. 查询平均工资最高的 job 信息
*/
--①查询工种中最高的平均工资
SELECT MAX(AVG(salary))
	FROM employees
	GROUP BY job_id;

--②查询平均工资最高的job_id
SELECT job_id
	FROM employees
	GROUP BY job_id
	HAVING AVG(salary) = (
						 SELECT MAX(AVG(salary))
							 FROM employees
							 GROUP BY job_id);
--③从jobs表中，查出job_id=②的所有信息。
SELECT *
	FROM jobs
	WHERE job_id = (
				   SELECT job_id
					   FROM employees
					   GROUP BY job_id
					   HAVING AVG(salary) = (
											SELECT MAX(AVG(salary))
												FROM employees
												GROUP BY job_id));

/*
45. 查询平均工资高于公司平均工资的部门有哪些?
*/
--①公司平均工资
SELECT AVG(salary)
	FROM employees;
--②部门平均工资
SELECT AVG(salary),
	   department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) > (
						 SELECT AVG(salary)
							 FROM employees);

/*
46. 查询出公司中所有 manager 的详细信息.
*/
SELECT *
	FROM employees
	WHERE employee_id IN (
						 SELECT manager_id
							 FROM employees);

/*
47. 各个部门中 最高工资中最低的那个部门的 最低工资是多少
*/
--① 查询最高工资最低的那个是多少？
SELECT MIN(MAX(salary))
	FROM employees
	GROUP BY department_id;

--② 查询哪个部门的最高工资=①
SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING MAX(salary) = (
						 SELECT MIN(MAX(salary))
							 FROM employees
							 GROUP BY department_id);

--③查询②号部门的最低工资。
SELECT MIN(salary)
	FROM employees
	WHERE department_id = (
						  SELECT department_id
							  FROM employees
							  GROUP BY department_id
							  HAVING MAX(salary) = (
												   SELECT MIN(MAX(salary))
													   FROM employees
													   GROUP BY department_id));

SELECT *
	FROM employees;

/*
48. 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
*/
--①查询出最高平均工资
SELECT MAX(AVG(salary))
	FROM employees
	GROUP BY department_id;

--②查询出平均工资最高的部门号
SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary) = (
						 SELECT MAX(AVG(salary))
							 FROM employees
							 GROUP BY department_id);

--③求出②部门的manager_id
SELECT DISTINCT manager_id
	FROM employees
	WHERE department_id = (
						  SELECT department_id
							  FROM employees
							  GROUP BY department_id
							  HAVING AVG(salary) = (
												   SELECT MAX(AVG(salary))
													   FROM employees
													   GROUP BY department_id));
--④查询出employee_id=③的员工信息。
SELECT last_name,
	   department_id,
	   email,
	   salary
	FROM employees
	WHERE employee_id IN
		  (
		  SELECT manager_id
			  FROM employees
			  WHERE department_id = (
									SELECT department_id
										FROM employees
										GROUP BY department_id
										HAVING AVG(salary) = (
															 SELECT MAX(AVG(salary))
																 FROM employees
																 GROUP BY department_id)));

/*
49. 查询 1999 年来公司的人所有员工的最高工资的那个员工的信息.
*/
--①查询出1999年来公司的最高工资为哪个
SELECT MAX(salary)
	FROM employees
	WHERE to_char(hire_date,
				  'yyyy') = '1999';

--查询99年来公司的且工资等于①
SELECT *
	FROM employees
	WHERE to_char(hire_date,
				  'yyyy') = '1999'
	  AND salary = (
				   SELECT MAX(salary)
					   FROM employees
					   WHERE to_char(hire_date,
									 'yyyy') = '1999');

/*
1.查询和Zlotkey相同部门的员工姓名和雇用日期
*/
SELECT last_name,
	   hire_date
	FROM employees
	WHERE department_id = (
						  SELECT department_id
							  FROM employees
							  WHERE LOWER(last_name) = 'zlotkey')
	  AND LOWER(last_name) <> 'zlotkey';

/*
2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
*/
SELECT employee_id,
	   last_name,
	   salary
	FROM employees
	WHERE salary > (
				   SELECT AVG(salary)
					   FROM employees);

/*
3.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资
*/

SELECT employee_id,
	   last_name,
	   salary
	FROM employees e1
	WHERE salary > (
				   SELECT AVG(salary)
					   FROM employees e2
					   WHERE e1.department_id = e2.department_id
					   GROUP BY e2.department_id);

/*
4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
*/
--①查询姓名中包含字母u的员工所有的部门编号
SELECT DISTINCT department_id
	FROM employees
	WHERE last_name LIKE '%u%';

--②查询department_id IN ①的所有员工号和姓名
SELECT employee_id,
	   last_name
	FROM employees
	WHERE department_id IN (
						   SELECT DISTINCT department_id
							   FROM employees
							   WHERE last_name LIKE '%u%')
	  AND last_name NOT LIKE '%u%';
/*
5. 查询在部门的location_id为1700的部门工作的员工的员工号
*/
--①查询location_id = 1700的部门号是多少？
SELECT department_id
	FROM departments
	WHERE location_id = 1700;

--②查询在①部门工作的员工的员工号
SELECT employee_id
	FROM employees
	WHERE department_id IN (
						   SELECT department_id
							   FROM departments
							   WHERE location_id = 1700);

/*
6.查询管理者是King的员工姓名和工资
*/
SELECT last_name,
	   salary
	FROM employees
	WHERE manager_id IN (
						SELECT employee_id
							FROM employees
							WHERE last_name = 'King');
