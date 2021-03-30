----视图
--创建视图
CREATE VIEW empview
AS
	SELECT employee_id,
		   last_name,
		   salary
		FROM employees
		WHERE department_id = 80;

--创建视图 起别名
CREATE VIEW empview1
AS
	SELECT employee_id id,
		   last_name name,
		   salary
		FROM employees
		WHERE department_id = 80;

--查看视图
SELECT *
	FROM empview1;

--查看原表
SELECT *
	FROM employees
	WHERE department_id = 80;

--修改视图数据
UPDATE empview1
SET
	salary = 20000
	WHERE id = 179;
--【注】修改视图后，原表的内容也会被修改。

--删除视图数据
DELETE
	FROM empview1
	WHERE id = 176;
--【因为原表中这一数据有外键约束】

--创建多张表的视图
CREATE VIEW empview2
AS
	SELECT employee_id id,
		   last_name name,
		   salary,
		   department_name
		FROM employees   e,
			 departments d
		WHERE e.department_id = d.department_id;

--查看视图
SELECT *
	FROM empview2;

--修改视图
CREATE OR REPLACE VIEW empview2
AS
	SELECT employee_id id,
		   last_name name,
		   salary,
		   department_name
		FROM employees   e,
			 departments d
		WHERE e.department_id = d.department_id;

--创建复杂视图
CREATE OR REPLACE VIEW empview4
AS
	SELECT department_name dept_name,
		   AVG(salary) avg_sal
		FROM employees   e,
			 departments d
		WHERE e.department_id = d.department_id
		GROUP BY department_name;

SELECT *
	FROM empview4;

--视图中使用DML的规定
/*
可以在简单视图中执行 DML 操作

当视图定义中包含以下元素之一时不能使insert:
    组函数
    GROUP BY 子句
    DISTINCT 关键字
    ROWNUM 伪列
    列的定义为表达式
    表中非空的列在视图定义中未包括

当视图定义中包含以下元素之一时不能使用delete:
    组函数
    GROUP BY 子句
    DISTINCT 关键字
    ROWNUM 伪列

当视图定义中包含以下元素之一时不能使用update:
    组函数
    GROUP BY子句
    DISTINCT 关键字
    ROWNUM 伪列
    列的定义为表达式
*/

--屏蔽 DML 操作/*
可以使用
	WITH READ ONLY 选项屏蔽对视图的dml 操作 任何 dml 操作都会返回一个oracle server 错误 CREATE OR REPLACE view empview3 AS
	SELECT employee_id     id,
		   last_name       NAME,
		   salary,
		   department_name
	FROM   employees   e,
		   departments d
	WHERE  e.department_id = d.department_id WITH READ ONLY;
* /

--查看视图
	SELECT *
	FROM   empview3;

--修改视图，由于视图中使用了WITH READ ONLY，视图就不能修改。
UPDATE empview3
SET    NAME = 'ABC'
WHERE  id = 206;

--删除视图
/*
删除视图只是删除视图的定义，并不会删除基表的数据
*/
DROP VIEW empview2;

--TOP-N分析
/*
查询最大的几个值的 Top-N 分析: 

SELECT [column_list], ROWNUM  
FROM   (SELECT [column_list] 
        FROM table
        ORDER  BY Top-N_column)
WHERE  ROWNUM <=  N;

注意: 
对 ROWNUM 只能使用 < 或 <=, 而用 =, >, >= 都将不能返回任何数据。
*/
--【案例】查询员工表中，工资前10名的员工信息。
SELECT rownum,
	   employee_id,
	   last_name,
	   salary
	FROM (
		 SELECT employee_id,
				last_name,
				salary
			 FROM employees
			 ORDER BY salary DESC)
	WHERE rownum <= 10;

--【案例】查询员工表中，工资排名在10-20之间的员工信息。

SELECT rn,
	   employee_id,
	   last_name,
	   salary
	FROM (
		 SELECT rownum rn,
				employee_id,
				last_name,
				salary
			 FROM (
				  SELECT employee_id,
						 last_name,
						 salary
					  FROM employees
					  ORDER BY salary DESC))
	WHERE rn >= 10
	  AND rn <= 20;

--总结
/*
通过本章学习，您已经了解视图的优点和基本应用:
    控制数据访问
    简化查询
    数据独立性
    删除时不删除数据
    Top-N 分析  
*/

--练习：1.使用表employees创建视图employee_vu，其中包括姓名（LAST_NAME），员工号（EMPLOYEE_ID），部门号(DEPARTMENT_ID).
CREATE OR
REPLACE view employee_vu AS
SELECT last_name,
	   employee_id,
	   department_id
	FROM employees;

--练习：2.显示视图的结构
DESC employee_vu;

--练习：3.查询视图中的全部内容
SELECT *
	FROM employee_vu;

--练习：4.将视图中的数据限定在部门号是80的范围内
CREATE OR REPLACE VIEW employee_vu
AS
	SELECT last_name,
		   employee_id,
		   department_id
		FROM employees
		WHERE department_id = 80;

--练习：5.将视图改变成只读视图
CREATE OR REPLACE VIEW employee_vu
AS
	SELECT last_name,
		   employee_id,
		   department_id
		FROM employees
		WHERE department_id = 80
WITH READ ONLY;

--练习：62. 查询员工表中 salary 前 10 的员工信息.
SELECT rownum,
	   emp.*
FROM   (SELECT *
		FROM   employees
		ORDER  BY salary DESC) emp
WHERE  rownum <= 10;

--注意: **对 ROWNUM 只能使用 < 或 <=, 而不能用 =, >, >= 都将不能返回任何数据.   

--练习：63. 查询员工表中 salary 10 - 20 的员工信息.    

SELECT *
FROM   (SELECT rownum rn,
			   emp.*
		FROM   (SELECT *
				FROM   employees
				ORDER  BY salary DESC) emp)
WHERE  rn >= 10
AND    rn <= 20;

--练习：64. 对 oralce 数据库中记录进行分页: 每页显示 pageSize 条记录, 查询第 pageNo 页的数据 
--注意: **对 oracle 分页必须使用 rownum "伪列"
SELECT *
	FROM (
		 SELECT rownum rn,
				e.*
			 FROM employees e) e2

	WHERE e2.rn > pagesize * (pageno - 1)
	  AND e2.rn <= pagesize * pageno;

--以上为未排序的。

--排序后的查询每页pagesize条记录，显示第pageno页的数据

SELECT *
	FROM (
		 SELECT rownum rn,
				alias_name.*
			 FROM (
				  SELECT *
					  FROM table_name
					  ORDER BY column_name DESC) alias_name)
	WHERE rn > pagesize * (pageno - 1)
	  AND rn <= pagesize * pageno;
