/*
		任何操作之前都先打开库
*/
USE girls;

/*#############################################进阶7：子查询#############################################*/
/*
		含义：
			出现在其他语句中的SELECT语句，称为子查询或内查询
			外部的查询语句，称为主查询或外查询。

		分类：
			按子查询出现的位置：
				SELECT后面:
					仅支持标量子查询
				FROM后面：
					支持表子查询
				WHERE或HAVING后面：		✔✔
					标量子查询	(单行)	✔
					列子查询	(多行)	✔
					行子查询
				EXISTS后面(相关子查询)：
					标量子查询	(单行)
					列子查询	(多行)
					行子查询
					表子查询
					
			按结果集的行列数不同：
				标量子查询(结果集只有一行一列)
				列子查询(结果集只有一列多行)
				行子查询(结果集只有一行多列)
				表子查询(结果集一般为多行多列)
*/
/*
		1. WHERE 或 HAVING后面
		1.1. 标量子查询(单行子查询)
		1.2. 列子查询(多行子查询)
		1.3. 行子查询(多行多列)
		
		特点：
			① 子查询放在小括号()内
			② 子查询一般放在条件的右侧
			③ 标量子查询，一般搭配着单行操作符使用
				单行操作符：> < >= <= = <> <=>
			  列子查询，一般搭配着多行操作符使用
				多行操作符：IN ANY SOME ALL
			④ 子查询的执行优于主查询执行，主查询的条件用到了子查询的结果。
*/
/*
		1.1.1. 标量子查询
		案例1：谁的工资比 Abel 高？
*/
# ① 查询Abel的工资
SELECT salary
	FROM employees
	WHERE last_name = 'Abel';

# ② 查询员工的信息，满足 salary > ①的结果
SELECT *
	FROM employees
	WHERE salary >
		  (
		  SELECT salary
			  FROM employees
			  WHERE last_name = 'Abel');

/*
		1.1.1. 标量子查询
		案例2：返回job_id与141号员工相同，salary 比143 号员工多的员工姓名，job_id和工资
*/
# ① 查询141号员工的job_id
SELECT job_id
	FROM employees
	WHERE employee_id = 141;

# ② 查询143号员工的salary
SELECT salary
	FROM employees
	WHERE employee_id = 143;

# ③ 在①和②的结果上查询要求job_id = ① 并且 salary > ②
SELECT last_name,
	   job_id,
	   salary
	FROM employees
	WHERE job_id =
		  (
		  SELECT job_id
			  FROM employees
			  WHERE employee_id = 141)
	  AND salary >
		  (
		  SELECT salary
			  FROM employees
			  WHERE employee_id = 143);

/*
		1.1.1. 标量子查询
		案例3：返回公司工资最少的员工的last_name,job_id 和salary
*/
# ① 直接查询工资最小的值
SELECT MIN(salary)
	FROM employees;

# ② 查询员工的last_name,job_id 和salary 满足条件 salary = ①
SELECT last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary =
		  (
		  SELECT MIN(salary)
			  FROM employees);

/*
		1.1.1. 标量子查询
		案例4：查询最低工资大于50 号部门最低工资的 部门id
*/
# ① 查询50号部门的最低工资。
SELECT MIN(salary)
	FROM employees
	WHERE department_id = 50;

# ② 查询每个部门的最低工资
SELECT MIN(salary),
	   department_id
	FROM employees
	GROUP BY department_id;

# ③ 在②基础上筛选，满足MIN(salary) > ①
SELECT MIN(salary),
	   department_id
	FROM employees
	GROUP BY department_id
	HAVING MIN(salary) >
		   (
		   SELECT MIN(salary)
			   FROM employees
			   WHERE department_id = 50);

/*
		1.1.1.2 非法使用标量子查询
*/
SELECT MIN(salary),
	   department_id
	FROM employees
	GROUP BY department_id
	HAVING MIN(salary) > # 单行操作符
		   (
		   SELECT MIN(salary) # 标量子查询
			   FROM employees
			   WHERE department_id = 50 #筛选不为空
		   );

/*
		1.1.2. 列子查询(多行子查询)

		多行操作符			含义
		IN/NOT IN			等于/不等于 列表中的任意一个
		ANY | SOME			和子查询返回的某一个值比较
		ALL					和子查询返回的所有值比较
*/
/*
		1.1.2. 列子查询(多行子查询)
		案例1：返回location_id 是1400 或1700 的部门中的所有员工姓名
*/
# ① 查询location_id 是1400 或1700 的部门编号
SELECT DISTINCT
	   department_id
	FROM departments
	WHERE location_id IN (1400, 1700);

# ② 查询①中所有员工姓名
SELECT last_name
	FROM employees
	WHERE department_id <> ALL # IN 可以替换为 = ANY / NOT IN 可以替换为 <> ALL
		  (
		  SELECT DISTINCT
				 department_id
			  FROM departments
			  WHERE location_id IN (1400, 1700));

/*
		1.1.2. 列子查询(多行子查询)
		案例2：返回其它工种中比job_id 为‘IT_PROG’工种任一工资低的员工的员工号、姓名、job_id 以及salary
*/
# ① 查询job_id 为‘IT_PROG’ 部门的员工的工资
SELECT DISTINCT
	   salary
	FROM employees
	WHERE job_id = 'IT_PROG';

# ② 查询其他部门中比①小的任意一个员工的员工号、姓名、job_id 以及salary
SELECT employee_id,
	   last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary < ANY
		  (
		  SELECT DISTINCT
				 salary
			  FROM employees
			  WHERE job_id = 'IT_PROG')
	  AND job_id <> 'IT_PROG';

/*
	< ANY 可以用MAX代替
*/
SELECT employee_id,
	   last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary <
		  (
		  SELECT DISTINCT
				 MAX(salary)
			  FROM employees
			  WHERE job_id = 'IT_PROG')
	  AND job_id <> 'IT_PROG';

/*
		1.1.2. 列子查询(多行子查询)
		案例3：返回其它工种中比job_id为 为‘IT_PROG’工种所有工资都低的员工的员工号、姓名、job_id  以及salary
*/
SELECT employee_id,
	   last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary < ALL
		  (
		  SELECT DISTINCT
				 salary
			  FROM employees
			  WHERE job_id = 'IT_PROG')
	  AND job_id <> 'IT_PROG';

/*
	< ALL 可以用MIN代替
*/
SELECT employee_id,
	   last_name,
	   job_id,
	   salary
	FROM employees
	WHERE salary <
		  (
		  SELECT DISTINCT
				 MIN(salary)
			  FROM employees
			  WHERE job_id = 'IT_PROG')
	  AND job_id <> 'IT_PROG';

/*
		1.1.3. 行子查询(结果集一行多列或多行多列)
		案例3：查询员工编号最小并且工资最高的员工信息
*/
###原始方法
# ① 查询最小的员工编号
SELECT MIN(employee_id)
	FROM employees;

# ② 查询最高工资
SELECT MAX(salary)
	FROM employees;

# ③ 查询员工信息 满足 ① 和 ②
SELECT *
	FROM employees
	WHERE employee_id =
		  (
		  SELECT MIN(employee_id)
			  FROM employees)
	  AND salary =
		  (
		  SELECT MAX(salary)
			  FROM employees);

###使用行子查询的方法
SELECT *
	FROM employees
	WHERE (employee_id, salary) =
		  (
		  SELECT MIN(employee_id),
				 MAX(salary)
			  FROM employees);

/*
		1.2. SELECT后面
		
		说明：仅支持标量子查询
		
		案例1：查询每个部门的员工个数
*/
SELECT d.*,
	   (
	   SELECT COUNT(*)
		   FROM employees e
		   WHERE e.department_id = d.department_id) 员工个数
	FROM departments d;

/*
		1.2. SELECT后面
		案例2：查询员工号=102的部门名
*/
# 方式一：用连接查询
SELECT department_name
	FROM departments     d
	INNER JOIN employees e
			   ON d.department_id = e.department_id
	WHERE e.employee_id = 102;

# 方式二：用子查询
SELECT (
	   SELECT department_name
		   FROM departments     d
		   INNER JOIN employees e
					  ON d.department_id = e.department_id
		   WHERE e.employee_id = 102) 部门名;

/*
		1.3. FROM后面
		
		将子查询结果充当一张表要求必须起别名
		
		案例1：查询每个部门的平均工资的工资等级
*/
# ① 先查询每个部门的平均工资
SELECT ROUND(AVG(salary),2) 平均工资,
	   department_id 部门编号
	FROM employees
	GROUP BY department_id;

# ② 连接①的结果集和job_grades表，筛选条件平均工资between lowest_sal AND highest_sal
SELECT ag_dep.*,
	   grade_level
	FROM (
		 SELECT ROUND(AVG(salary),2) ag,
				department_id
			 FROM employees
			 GROUP BY department_id) AS ag_dep
	INNER JOIN job_grades            AS g
			   ON ag BETWEEN lowest_sal
				   AND highest_sal;

/*
		1.4. EXISTS后面(相关子查询)
		语法：EXISTS(完整的查询语句)
		
		含义：判断完整查询语句中是否有内容，有返回1 没有返回0
		
		结果：只用两个 1 或 0
		
		
		举例：SELECT EXISTS(SELECT employee_id FROM employees);
		
		案例1：查询有员工的部门名
*/
#方式一：使用IN
SELECT department_name
	FROM departments d
	WHERE d.department_id IN
		  (
		  SELECT department_id
			  FROM employees);

#方式二：使用EXISTS
SELECT department_name
	FROM departments d
	WHERE EXISTS
			  (SELECT *
				   FROM employees e
				   WHERE d.department_id = e.department_id);

/*
		1.4. EXISTS后面(相关子查询)		
		案例2：查询没有女朋友的男神信息
*/
#方式一：使用IN
SELECT bo.*
	FROM boys bo
	WHERE bo.id NOT IN
		  (
		  SELECT boyfriend_id
			  FROM beauty);

#方式二：使用EXISTS
USE girls;

SELECT bo.*
	FROM boys bo
	WHERE NOT EXISTS
		(SELECT *
			 FROM beauty b
			 WHERE b.boyfriend_id = bo.id);

