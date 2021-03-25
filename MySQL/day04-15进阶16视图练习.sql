USE myemployees;
/*
		1、创建视图 emp_v1,要求查询电话号码以‘011’开头的员工姓名和工资、邮箱
*/
CREATE OR REPLACE VIEW emp_v1
AS
SELECT last_name, salary, email
FROM employees
WHERE phone_number LIKE '011%';


/*
		2、要求将视图 emp_v1 修改为查询电话号码以‘011’开头的并且邮箱中包含 e 字符的员工姓名和邮箱、电话号码
*/
CREATE OR REPLACE VIEW emp_v1 AS
SELECT last_name, email, phone_number
FROM employees
WHERE phone_number LIKE '011%'
  AND email LIKE '%e%';
/*
		3、向 emp_v1 插入一条记录，是否可以？
*/
# 可以
/*
		4、修改刚才记录中的电话号码为‘0119’
*/
CREATE OR REPLACE VIEW emp_v1 AS
SELECT last_name, email, phone_number
FROM employees
WHERE phone_number LIKE '0119%'
  AND email LIKE '%e%';
/*
		5、删除刚才记录
 */
DROP VIEW myemployees.emp_v1;
/*
		6、创建视图 emp_v2，要求查询部门的最高工资高于 12000 的部门信息
*/
CREATE OR REPLACE VIEW emp_v2
AS
SELECT max(salary) mx_dep, department_id
FROM employees e
GROUP BY department_id
HAVING mx_dep > 12000;

SELECT d.*, m.mx_dep
FROM departments d
	     INNER JOIN emp_v2 m ON d.department_id = m.department_id;

/*
		7、向 emp_v2 中插入一条记录，是否可以？
*/
# 可以
/*
		8、删除刚才的 emp_v2 和 emp_v1
*/
DROP VIEW emp_v1,emp_v2;