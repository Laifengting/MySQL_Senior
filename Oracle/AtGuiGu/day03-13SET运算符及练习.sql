--学习目标
/*
通过本章学习，您将可以:
描述 SET 操作符
将多个查询用 SET 操作符连接组成一个新的查询
    UNION/UNION ALL
    INTERSECT
    MINUS 
排序:ORDER BY
*/


--准备工作：创建两张表
CREATE TABLE employees01
AS
	SELECT *
		FROM employees
		WHERE department_id IN (70,
								80);

SELECT *
	FROM employees01;

CREATE TABLE employees02
AS
	SELECT *
		FROM employees
		WHERE department_id IN (80,
								90);

SELECT *
	FROM employees02;

--使用UNION(去重)
/*
UNION 操作符返回两个查询的结果集的并集
*/
SELECT *
	FROM employees01
UNION
SELECT *
	FROM employees02;

--起别名
SELECT employee_id id,
	   last_name name,
	   salary sal --起别名需要起在主表上。另外起在从表上没有作用。
	FROM employees01
UNION
SELECT employee_id,
	   last_name,
	   salary
	FROM employees02
ORDER BY id DESC;
--可以按别名排序

--连接两表的内容
SELECT employee_id id,
	   department_id,
	   to_char(NULL)
	FROM employees01
UNION
SELECT to_number(NULL),
	   department_id,
	   department_name
	FROM departments;

--使用UNION ALL
/*
UNION ALL 操作符返回两个查询的结果集的并集。对于两个结果集的重复部分，不去重。
*/
SELECT *
	FROM employees01
UNION ALL
SELECT *
	FROM employees02;

--INTERSECT 操作符
/*
INTERSECT 操作符返回两个结果集的交集
*/
SELECT *
	FROM employees01 intersect
SELECT *
	FROM employees02;

--MINUS 操作符
/*
MINUS操作符：返回两个结果集的差集
*/
SELECT *
	FROM employees01 minus
SELECT *
	FROM employees02;

--使用
SET 操作符注意事项
	/*
	在SELECT 列表中的列名和表达式在数量和数据类型上要相对应。
	括号可以改变执行的顺序。
	ORDER BY 子句:
		只能在语句的最后出现
		可以使用第一个查询中的列名, 别名或相对位置

	除 UNION ALL之外，系统会自动将重复的记录删除。
	系统将第一个查询的列名显示在输出中。
	除 UNION ALL之外，系统自动按照第一个查询中的第一个列的升序排列。

	*/

	- -使用相对位置排序举例 COLUMN a_dummy noprint
SELECT 'sing' "My dream",
	   3 a_dummy
	FROM dual
UNION
SELECT 'I`d like to teach',
	   1
	FROM dual
UNION
SELECT 'the world to',
	   2
	FROM dual
ORDER BY 2;

--总结
/*
通过本章学习,您已经可以:
    使用 UNION 操作符
    使用 UNION ALL 操作符
    使用 INTERSECT 操作符
    使用 MINUS操作符
    使用 ORDER BY 对结果集排序
*/

--练习：1.查询部门的部门号，其中不包括job_id是”ST_CLERK”的部门号
--方式一：
SELECT DISTINCT department_id
	FROM departments
	WHERE department_id <> (
						   SELECT DISTINCT department_id
							   FROM employees
							   WHERE job_id = 'ST_CLERK');

--方式二：
SELECT DISTINCT department_id
	FROM departments minus
SELECT DISTINCT department_id
	FROM employees
	WHERE job_id = 'ST_CLERK';


--练习：2.查询10，50，20号部门的job_id，department_id并且department_id按10，50，20的顺序排列
COLUMN a_dummy noprint;
--只在命令行窗口运行有效。
SELECT job_id,
	   department_id,
	   1 a_dummy
	FROM employees
	WHERE department_id = 10
UNION
SELECT job_id,
	   department_id,
	   3
	FROM employees
	WHERE department_id = 20
UNION
SELECT job_id,
	   department_id,
	   2
	FROM employees
	WHERE department_id = 50
ORDER BY 3 ASC;

--练习：3.查询所有员工的last_name ,department_id 和department_name
SELECT last_name,
	   department_id,
	   to_char(NULL) department_name
	FROM employees
UNION
SELECT to_char(NULL),
	   department_id,
	   department_name
	FROM departments;
